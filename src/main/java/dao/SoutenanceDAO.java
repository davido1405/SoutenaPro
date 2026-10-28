package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import connection.ConnexionBD;
import models.Jury;
import models.Soutenance;
import utils.BusinessException;
import utils.SqlUtils;
import utils.Validators;

/**
 * Accès aux soutenances, à leur jury et aux statistiques du tableau de bord.
 *
 * Règles métier appliquées ici :
 *  - un étudiant ne peut avoir qu'une soutenance ;
 *  - le jury compte au minimum 2 membres distincts ;
 *  - un enseignant ne peut pas être dans deux soutenances qui se chevauchent ;
 *  - une salle ne peut pas accueillir deux soutenances qui se chevauchent.
 */
public class SoutenanceDAO {

    private SoutenanceDAO() {
    }

    private static final String BASE_SELECT =
        "SELECT s.id_soutenance, s.matricule_etu, et.matricule_encadrant, s.date_heure, s.duree_minutes, s.salle, s.statut, s.note_finale,"
      + " u.nom AS nom_etu, u.prenom AS prenom_etu, f.lib_filiere, n.lib_niveau, et.sujet,"
      + " (SELECT COUNT(*) FROM jury j WHERE j.id_soutenance = s.id_soutenance) AS nb_jury,"
      + " (SELECT COUNT(*) FROM jury j JOIN evaluation ev ON ev.id_jury = j.id_jury"
      + "   WHERE j.id_soutenance = s.id_soutenance AND ev.note IS NOT NULL) AS nb_notes"
      + " FROM soutenance s"
      + " JOIN etudiant et ON et.matricule_etu = s.matricule_etu"
      + " JOIN utilisateur u ON u.id_utilisateur = et.id_utilisateur"
      + " LEFT JOIN filiere f ON f.id_filiere = et.id_filiere"
      + " LEFT JOIN niveau n ON n.id_niveau = et.id_niveau";

    // ---------------------------------------------------------------- Lecture

    /**
     * Liste filtrée : recherche texte, date (jour), enseignant (jury ou
     * encadrant) et statut. Tous les filtres sont optionnels.
     */
    public static List<Soutenance> findAll(String recherche, String date, String matriculeEns, String statut)
            throws SQLException {
        List<Soutenance> liste = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (!Validators.isBlank(recherche)) {
            sql.append(" AND (u.nom LIKE ? OR u.prenom LIKE ? OR s.matricule_etu LIKE ?"
                     + " OR et.sujet LIKE ? OR s.salle LIKE ? OR f.lib_filiere LIKE ?)");
            String like = "%" + recherche.trim() + "%";
            for (int i = 0; i < 6; i++) params.add(like);
        }
        if (!Validators.isBlank(date)) {
            sql.append(" AND DATE(s.date_heure) = ?");
            params.add(date.trim());
        }
        if (!Validators.isBlank(matriculeEns)) {
            sql.append(" AND (et.matricule_encadrant = ? OR EXISTS (SELECT 1 FROM jury j"
                     + " WHERE j.id_soutenance = s.id_soutenance AND j.matricule_ens = ?))");
            params.add(matriculeEns.trim());
            params.add(matriculeEns.trim());
        }
        if (!Validators.isBlank(statut) && !"TOUTES".equalsIgnoreCase(statut)) {
            sql.append(" AND s.statut = ?");
            params.add(statut.trim().toUpperCase());
        }
        sql.append(" ORDER BY s.date_heure DESC");

        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) p.setObject(i + 1, params.get(i));
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) liste.add(mapper(rs));
            }
        }
        return liste;
    }

    public static Soutenance findById(int id) throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(BASE_SELECT + " WHERE s.id_soutenance = ?")) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? mapper(rs) : null;
            }
        }
    }

    public static Soutenance findByEtudiant(String matricule) throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(BASE_SELECT + " WHERE s.matricule_etu = ?")) {
            p.setString(1, matricule);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? mapper(rs) : null;
            }
        }
    }

    /** Soutenances à venir d'un enseignant (jury ou encadrant). */
    public static List<Soutenance> findAVenirParEnseignant(String matricule) throws SQLException {
        List<Soutenance> liste = new ArrayList<>();
        String sql = BASE_SELECT
                + " WHERE s.date_heure >= NOW() AND s.statut <> 'ANNULEE'"
                + " AND (et.matricule_encadrant = ? OR EXISTS (SELECT 1 FROM jury j"
                + "   WHERE j.id_soutenance = s.id_soutenance AND j.matricule_ens = ?))"
                + " ORDER BY s.date_heure ASC";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, matricule);
            p.setString(2, matricule);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) liste.add(mapper(rs));
            }
        }
        return liste;
    }

    /** Prochaines soutenances planifiées, pour le tableau de bord administrateur. */
    public static List<Soutenance> findProchaines(int limite) throws SQLException {
        List<Soutenance> liste = new ArrayList<>();
        String sql = BASE_SELECT + " WHERE s.statut = 'PLANIFIEE' AND s.date_heure >= NOW()"
                + " ORDER BY s.date_heure ASC LIMIT ?";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, limite);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) liste.add(mapper(rs));
            }
        }
        return liste;
    }

    /** Membres du jury d'une soutenance, avec leur évaluation éventuelle. */
    public static List<Jury> findJury(int idSoutenance) throws SQLException {
        List<Jury> liste = new ArrayList<>();
        String sql = "SELECT j.id_jury, j.id_soutenance, j.matricule_ens, j.qualite,"
                   + " CONCAT(u.prenom, ' ', u.nom) AS enseignant_nom, sp.lib_specialite, ens.grade,"
                   + " ev.note, ev.avis"
                   + " FROM jury j"
                   + " JOIN enseignant ens ON ens.matricule_ens = j.matricule_ens"
                   + " JOIN utilisateur u ON u.id_utilisateur = ens.id_utilisateur"
                   + " LEFT JOIN specialite sp ON sp.id_specialite = ens.id_specialite"
                   + " LEFT JOIN evaluation ev ON ev.id_jury = j.id_jury"
                   + " WHERE j.id_soutenance = ?"
                   + " ORDER BY FIELD(j.qualite, 'PRESIDENT', 'RAPPORTEUR', 'EXAMINATEUR'), u.nom";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, idSoutenance);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    Jury j = new Jury();
                    j.setIdJury(rs.getInt("id_jury"));
                    j.setIdSoutenance(rs.getInt("id_soutenance"));
                    j.setMatriculeEnseignant(rs.getString("matricule_ens"));
                    j.setQualite(rs.getString("qualite"));
                    j.setEnseignantNom(rs.getString("enseignant_nom"));
                    j.setSpecialite(rs.getString("lib_specialite"));
                    j.setGrade(rs.getString("grade"));
                    double note = rs.getDouble("note");
                    j.setNote(rs.wasNull() ? null : note);
                    j.setAvis(rs.getString("avis"));
                    liste.add(j);
                }
            }
        }
        return liste;
    }

    /** Jury de plusieurs soutenances en une requête (évite le N+1 dans les listes). */
    public static Map<Integer, List<Jury>> findJurys(List<Soutenance> soutenances) throws SQLException {
        Map<Integer, List<Jury>> map = new LinkedHashMap<>();
        if (soutenances == null || soutenances.isEmpty()) return map;
        StringBuilder in = new StringBuilder();
        for (int i = 0; i < soutenances.size(); i++) {
            if (i > 0) in.append(',');
            in.append('?');
            map.put(soutenances.get(i).getIdSoutenance(), new ArrayList<>());
        }
        String sql = "SELECT j.id_jury, j.id_soutenance, j.matricule_ens, j.qualite,"
                   + " CONCAT(u.prenom, ' ', u.nom) AS enseignant_nom, ev.note, ev.avis"
                   + " FROM jury j"
                   + " JOIN enseignant ens ON ens.matricule_ens = j.matricule_ens"
                   + " JOIN utilisateur u ON u.id_utilisateur = ens.id_utilisateur"
                   + " LEFT JOIN evaluation ev ON ev.id_jury = j.id_jury"
                   + " WHERE j.id_soutenance IN (" + in + ")"
                   + " ORDER BY FIELD(j.qualite, 'PRESIDENT', 'RAPPORTEUR', 'EXAMINATEUR'), u.nom";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            for (int i = 0; i < soutenances.size(); i++) p.setInt(i + 1, soutenances.get(i).getIdSoutenance());
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    Jury j = new Jury();
                    j.setIdJury(rs.getInt("id_jury"));
                    j.setIdSoutenance(rs.getInt("id_soutenance"));
                    j.setMatriculeEnseignant(rs.getString("matricule_ens"));
                    j.setQualite(rs.getString("qualite"));
                    j.setEnseignantNom(rs.getString("enseignant_nom"));
                    double note = rs.getDouble("note");
                    j.setNote(rs.wasNull() ? null : note);
                    j.setAvis(rs.getString("avis"));
                    map.computeIfAbsent(j.getIdSoutenance(), k -> new ArrayList<>()).add(j);
                }
            }
        }
        return map;
    }

    /** Étudiants sans soutenance (pour le formulaire de planification). */
    public static List<Object[]> findEtudiantsNonPlanifies() throws SQLException {
        List<Object[]> liste = new ArrayList<>();
        String sql = "SELECT et.matricule_etu, CONCAT(u.prenom, ' ', u.nom) AS nom_complet,"
                   + " et.sujet, et.matricule_encadrant, CONCAT(eu.prenom, ' ', eu.nom) AS encadrant_nom"
                   + " FROM etudiant et"
                   + " JOIN utilisateur u ON u.id_utilisateur = et.id_utilisateur"
                   + " LEFT JOIN enseignant ens ON ens.matricule_ens = et.matricule_encadrant"
                   + " LEFT JOIN utilisateur eu ON eu.id_utilisateur = ens.id_utilisateur"
                   + " LEFT JOIN soutenance s ON s.matricule_etu = et.matricule_etu"
                   + " WHERE s.id_soutenance IS NULL"
                   + " ORDER BY u.nom, u.prenom";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                liste.add(new Object[]{
                    rs.getString("matricule_etu"),
                    rs.getString("nom_complet"),
                    rs.getString("sujet"),
                    rs.getString("matricule_encadrant"),
                    rs.getString("encadrant_nom")
                });
            }
        }
        return liste;
    }

    // ---------------------------------------------------------------- Écriture

    public static int insert(Soutenance s, List<Jury> jury) throws SQLException, BusinessException {
        valider(s, jury);

        try (Connection c = ConnexionBD.getConnection()) {
            c.setAutoCommit(false);
            try {
                verifierConflits(c, s, jury, 0);

                String sql = "INSERT INTO soutenance (matricule_etu, date_heure, duree_minutes, salle, statut)"
                           + " VALUES (?, ?, ?, ?, 'PLANIFIEE')";
                int id;
                try (PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    p.setString(1, s.getMatriculeEtudiant());
                    p.setTimestamp(2, s.getDateHeure());
                    p.setInt(3, s.getDureeMinutes());
                    p.setString(4, s.getSalle().trim());
                    p.executeUpdate();
                    try (ResultSet keys = p.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("Identifiant de soutenance non généré.");
                        id = keys.getInt(1);
                    }
                }
                insererJury(c, id, jury);
                c.commit();
                return id;
            } catch (SQLException | BusinessException ex) {
                c.rollback();
                if (ex instanceof SQLException sqlEx && SqlUtils.estViolationUnicite(sqlEx)) {
                    throw new BusinessException("Cet étudiant possède déjà une soutenance.");
                }
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public static void update(Soutenance s, List<Jury> jury) throws SQLException, BusinessException {
        valider(s, jury);
        if (s.getIdSoutenance() <= 0) throw new BusinessException("Soutenance introuvable.");

        try (Connection c = ConnexionBD.getConnection()) {
            try (PreparedStatement p = c.prepareStatement("SELECT statut FROM soutenance WHERE id_soutenance=?")) {
                p.setInt(1, s.getIdSoutenance());
                try (ResultSet rs = p.executeQuery()) {
                    if (!rs.next()) throw new BusinessException("Soutenance introuvable.");
                    if ("EVALUEE".equals(rs.getString(1))) {
                        throw new BusinessException("Une soutenance déjà évaluée ne peut plus être modifiée.");
                    }
                }
            }
            c.setAutoCommit(false);
            try {
                verifierConflits(c, s, jury, s.getIdSoutenance());

                String sql = "UPDATE soutenance SET matricule_etu=?, date_heure=?, duree_minutes=?, salle=?"
                           + " WHERE id_soutenance=?";
                try (PreparedStatement p = c.prepareStatement(sql)) {
                    p.setString(1, s.getMatriculeEtudiant());
                    p.setTimestamp(2, s.getDateHeure());
                    p.setInt(3, s.getDureeMinutes());
                    p.setString(4, s.getSalle().trim());
                    p.setInt(5, s.getIdSoutenance());
                    p.executeUpdate();
                }
                try (PreparedStatement p = c.prepareStatement("DELETE FROM jury WHERE id_soutenance=?")) {
                    p.setInt(1, s.getIdSoutenance());
                    p.executeUpdate();
                }
                insererJury(c, s.getIdSoutenance(), jury);
                c.commit();
            } catch (SQLException | BusinessException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    /** Annule sans supprimer : l'historique et les évaluations restent consultables. */
    public static void changerStatut(int id, String statut) throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("UPDATE soutenance SET statut=? WHERE id_soutenance=?")) {
            p.setString(1, statut);
            p.setInt(2, id);
            p.executeUpdate();
        }
    }

    public static boolean delete(int id) throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("DELETE FROM soutenance WHERE id_soutenance=?")) {
            p.setInt(1, id);
            return p.executeUpdate() > 0;
        }
    }

    // ------------------------------------------------------------- Statistiques

    public static int count() throws SQLException {
        return countWhere(null);
    }

    public static int countStatut(String statut) throws SQLException {
        return countWhere(statut);
    }

    private static int countWhere(String statut) throws SQLException {
        String sql = statut == null ? "SELECT COUNT(*) FROM soutenance" : "SELECT COUNT(*) FROM soutenance WHERE statut=?";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            if (statut != null) p.setString(1, statut);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Soutenances planifiées cette semaine. */
    public static int countCetteSemaine() throws SQLException {
        String sql = "SELECT COUNT(*) FROM soutenance WHERE statut = 'PLANIFIEE'"
                   + " AND YEARWEEK(date_heure, 1) = YEARWEEK(CURDATE(), 1)";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public static Double moyenneGenerale() throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(
                     "SELECT AVG(note_finale) FROM soutenance WHERE statut='EVALUEE' AND note_finale IS NOT NULL");
             ResultSet rs = p.executeQuery()) {
            if (!rs.next()) return null;
            double v = rs.getDouble(1);
            return rs.wasNull() ? null : Math.round(v * 100.0) / 100.0;
        }
    }

    /** Répartition par statut : {statut, effectif}. */
    public static List<Object[]> repartitionParStatut() throws SQLException {
        List<Object[]> liste = new ArrayList<>();
        String sql = "SELECT statut, COUNT(*) FROM soutenance GROUP BY statut";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) liste.add(new Object[]{rs.getString(1), rs.getInt(2)});
        }
        return liste;
    }

    /** Nombre de soutenances à venir dans les 7 prochains jours. */
    public static int countProchainsJours(int jours) throws SQLException {
        String sql = "SELECT COUNT(*) FROM soutenance WHERE statut='PLANIFIEE'"
                   + " AND date_heure BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY)";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, jours);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Nombre de soutenances où l'enseignant doit encore saisir une note. */
    public static int countAEvaluerParEnseignant(String matricule) throws SQLException {
        String sql = "SELECT COUNT(*) FROM jury j JOIN soutenance s ON s.id_soutenance = j.id_soutenance"
                   + " LEFT JOIN evaluation ev ON ev.id_jury = j.id_jury"
                   + " WHERE j.matricule_ens=? AND s.statut='PLANIFIEE' AND ev.note IS NULL";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, matricule);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ------------------------------------------------------------------ Interne

    private static void valider(Soutenance s, List<Jury> jury) throws BusinessException {
        if (s == null || Validators.isBlank(s.getMatriculeEtudiant())) {
            throw new BusinessException("Veuillez sélectionner un étudiant.");
        }
        if (s.getDateHeure() == null) {
            throw new BusinessException("La date et l'heure de la soutenance sont obligatoires.");
        }
        if (Validators.isBlank(s.getSalle())) {
            throw new BusinessException("La salle est obligatoire.");
        }
        if (s.getDureeMinutes() < 15 || s.getDureeMinutes() > 240) {
            throw new BusinessException("La durée doit être comprise entre 15 et 240 minutes.");
        }
        if (jury == null || jury.size() < 2) {
            throw new BusinessException("Le jury doit comporter au moins 2 membres.");
        }
        if (jury.size() > 5) {
            throw new BusinessException("Le jury ne peut pas comporter plus de 5 membres.");
        }
        List<String> vus = new ArrayList<>();
        boolean president = false;
        for (Jury membre : jury) {
            if (Validators.isBlank(membre.getMatriculeEnseignant())) {
                throw new BusinessException("Chaque membre du jury doit être identifié.");
            }
            if (vus.contains(membre.getMatriculeEnseignant())) {
                throw new BusinessException("Un enseignant ne peut pas figurer deux fois dans le même jury.");
            }
            vus.add(membre.getMatriculeEnseignant());
            if ("PRESIDENT".equals(membre.getQualite())) president = true;
        }
        if (!president) {
            throw new BusinessException("Le jury doit désigner un président.");
        }
    }

    private static void verifierConflits(Connection c, Soutenance s, List<Jury> jury, int idExclu)
            throws SQLException, BusinessException {
        Timestamp debut = s.getDateHeure();
        Timestamp fin = new Timestamp(debut.getTime() + s.getDureeMinutes() * 60_000L);

        // Salle déjà occupée sur le même créneau.
        String sqlSalle = "SELECT COUNT(*) FROM soutenance WHERE statut <> 'ANNULEE'"
                        + " AND id_soutenance <> ? AND LOWER(salle) = LOWER(?)"
                        + " AND date_heure < ?"
                        + " AND DATE_ADD(date_heure, INTERVAL duree_minutes MINUTE) > ?";
        try (PreparedStatement p = c.prepareStatement(sqlSalle)) {
            p.setInt(1, idExclu);
            p.setString(2, s.getSalle().trim());
            p.setTimestamp(3, fin);
            p.setTimestamp(4, debut);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new BusinessException("La salle « " + s.getSalle().trim()
                            + " » est déjà réservée sur ce créneau.");
                }
            }
        }

        // Enseignant déjà mobilisé sur un créneau qui se chevauche.
        String sqlEns = "SELECT COUNT(*) FROM jury j JOIN soutenance s2 ON s2.id_soutenance = j.id_soutenance"
                      + " WHERE j.matricule_ens = ? AND s2.id_soutenance <> ? AND s2.statut <> 'ANNULEE'"
                      + " AND s2.date_heure < ?"
                      + " AND DATE_ADD(s2.date_heure, INTERVAL s2.duree_minutes MINUTE) > ?";
        try (PreparedStatement p = c.prepareStatement(sqlEns)) {
            for (Jury membre : jury) {
                p.setString(1, membre.getMatriculeEnseignant());
                p.setInt(2, idExclu);
                p.setTimestamp(3, fin);
                p.setTimestamp(4, debut);
                try (ResultSet rs = p.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new BusinessException("L'enseignant " + membre.getMatriculeEnseignant()
                                + " participe déjà à une soutenance sur ce créneau.");
                    }
                }
            }
        }
    }

    private static void insererJury(Connection c, int idSoutenance, List<Jury> jury) throws SQLException {
        String sqlJury = "INSERT INTO jury (id_soutenance, matricule_ens, qualite) VALUES (?, ?, ?)";
        String sqlEval = "INSERT INTO evaluation (id_jury) VALUES (?)";
        try (PreparedStatement pj = c.prepareStatement(sqlJury, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement pe = c.prepareStatement(sqlEval)) {
            for (Jury membre : jury) {
                pj.setInt(1, idSoutenance);
                pj.setString(2, membre.getMatriculeEnseignant());
                pj.setString(3, Validators.isBlank(membre.getQualite()) ? "EXAMINATEUR" : membre.getQualite());
                pj.executeUpdate();
                try (ResultSet keys = pj.getGeneratedKeys()) {
                    if (keys.next()) {
                        pe.setInt(1, keys.getInt(1));
                        pe.executeUpdate();
                    }
                }
            }
        }
    }

    private static Soutenance mapper(ResultSet rs) throws SQLException {
        Soutenance s = new Soutenance();
        s.setIdSoutenance(rs.getInt("id_soutenance"));
        s.setMatriculeEtudiant(rs.getString("matricule_etu"));
        s.setMatriculeEncadrant(rs.getString("matricule_encadrant"));
        s.setDateHeure(rs.getTimestamp("date_heure"));
        s.setDureeMinutes(rs.getInt("duree_minutes"));
        s.setSalle(rs.getString("salle"));
        s.setStatut(rs.getString("statut"));
        double note = rs.getDouble("note_finale");
        s.setNoteFinale(rs.wasNull() ? null : note);
        s.setNomEtudiant(rs.getString("nom_etu"));
        s.setPrenomEtudiant(rs.getString("prenom_etu"));
        s.setFiliereLibelle(rs.getString("lib_filiere"));
        s.setNiveauLibelle(rs.getString("lib_niveau"));
        s.setSujet(rs.getString("sujet"));
        s.setNbJury(rs.getInt("nb_jury"));
        s.setNbNotes(rs.getInt("nb_notes"));
        return s;
    }
}


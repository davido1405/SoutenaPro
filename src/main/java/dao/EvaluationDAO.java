package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import connection.ConnexionBD;
import models.Evaluation;
import utils.BusinessException;

/**
 * Saisie et consultation des évaluations.
 *
 * Une évaluation est créée en même temps que le membre du jury. Elle reste
 * vide jusqu'à la saisie de la note. Dès que tous les membres ont noté, la
 * soutenance passe automatiquement au statut EVALUEE et la note finale est
 * la moyenne des notes du jury.
 */
public class EvaluationDAO {

    private EvaluationDAO() {
    }

    private static final String BASE_SELECT =
        "SELECT ev.id_evaluation, ev.note, ev.avis,"
      + " j.id_soutenance, j.matricule_ens, j.qualite,"
      + " CONCAT(ue.prenom, ' ', ue.nom) AS enseignant_nom,"
      + " s.statut AS statut_soutenance, s.date_heure,"
      + " CONCAT(u.prenom, ' ', u.nom) AS nom_etu, u.nom, u.prenom, et.sujet"
      + " FROM evaluation ev"
      + " JOIN jury j ON j.id_jury = ev.id_jury"
      + " JOIN soutenance s ON s.id_soutenance = j.id_soutenance"
      + " JOIN etudiant et ON et.matricule_etu = s.matricule_etu"
      + " JOIN utilisateur u ON u.id_utilisateur = et.id_utilisateur"
      + " JOIN enseignant ens ON ens.matricule_ens = j.matricule_ens"
      + " JOIN utilisateur ue ON ue.id_utilisateur = ens.id_utilisateur";

    public static List<Evaluation> findBySoutenance(int idSoutenance) throws SQLException {
        List<Evaluation> liste = new ArrayList<>();
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(BASE_SELECT + " WHERE j.id_soutenance = ?"
                     + " ORDER BY FIELD(j.qualite, 'PRESIDENT', 'RAPPORTEUR', 'EXAMINATEUR'), ue.nom")) {
            p.setInt(1, idSoutenance);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) liste.add(mapper(rs));
            }
        }
        return liste;
    }

    /** Toutes les évaluations d'un enseignant, les non saisies en premier. */
    public static List<Evaluation> findByEnseignant(String matricule) throws SQLException {
        List<Evaluation> liste = new ArrayList<>();
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(BASE_SELECT
                     + " WHERE j.matricule_ens = ?"
                     + " ORDER BY (ev.note IS NULL) DESC, s.date_heure DESC")) {
            p.setString(1, matricule);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) liste.add(mapper(rs));
            }
        }
        return liste;
    }

    public static Evaluation findById(int idEvaluation) throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(BASE_SELECT + " WHERE ev.id_evaluation = ?")) {
            p.setInt(1, idEvaluation);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? mapper(rs) : null;
            }
        }
    }

    /**
     * Enregistre la note et l'avis d'un membre du jury.
     *
     * @param idEvaluation identifiant de l'évaluation
     * @param matriculeEns matricule de l'enseignant connecté (contrôle d'accès)
     */
    public static void saisir(int idEvaluation, String matriculeEns, double note, String avis)
            throws SQLException, BusinessException {
        if (note < 0 || note > 20) {
            throw new BusinessException("La note doit être comprise entre 0 et 20.");
        }
        try (Connection c = ConnexionBD.getConnection()) {
            try (PreparedStatement p = c.prepareStatement(
                    "SELECT s.statut FROM evaluation ev"
                  + " JOIN jury j ON j.id_jury = ev.id_jury"
                  + " JOIN soutenance s ON s.id_soutenance = j.id_soutenance"
                  + " WHERE ev.id_evaluation = ? AND j.matricule_ens = ?")) {
                p.setInt(1, idEvaluation);
                p.setString(2, matriculeEns);
                try (ResultSet rs = p.executeQuery()) {
                    if (!rs.next()) {
                        throw new BusinessException("Vous ne faites pas partie du jury de cette soutenance.");
                    }
                    if ("ANNULEE".equals(rs.getString(1))) {
                        throw new BusinessException("Cette soutenance est annulée : la saisie des notes est désactivée.");
                    }
                }
            }
            c.setAutoCommit(false);
            try {
                String sql = "UPDATE evaluation ev JOIN jury j ON j.id_jury = ev.id_jury"
                           + " SET ev.note = ?, ev.avis = ?, ev.evalue_le = NOW()"
                           + " WHERE ev.id_evaluation = ? AND j.matricule_ens = ?";
                int lignes;
                try (PreparedStatement p = c.prepareStatement(sql)) {
                    p.setDouble(1, Math.round(note * 100.0) / 100.0);
                    p.setString(2, avis == null || avis.isBlank() ? null : avis.trim());
                    p.setInt(3, idEvaluation);
                    p.setString(4, matriculeEns);
                    lignes = p.executeUpdate();
                }
                if (lignes == 0) {
                    throw new BusinessException("Vous ne faites pas partie du jury de cette soutenance.");
                }

                int idSoutenance;
                try (PreparedStatement p = c.prepareStatement(
                        "SELECT j.id_soutenance FROM jury j JOIN evaluation ev ON ev.id_jury = j.id_jury"
                      + " WHERE ev.id_evaluation = ?")) {
                    p.setInt(1, idEvaluation);
                    try (ResultSet rs = p.executeQuery()) {
                        if (!rs.next()) throw new BusinessException("Évaluation introuvable.");
                        idSoutenance = rs.getInt(1);
                    }
                }

                mettreAJourStatut(c, idSoutenance);
                c.commit();
            } catch (SQLException | BusinessException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    /**
     * Recalcule le statut d'une soutenance : EVALUEE si toutes les notes sont
     * présentes, sinon PLANIFIEE ; la note finale est la moyenne du jury.
     */
    private static void mettreAJourStatut(Connection c, int idSoutenance) throws SQLException {
        String sql = "SELECT COUNT(*) AS total, SUM(CASE WHEN ev.note IS NOT NULL THEN 1 ELSE 0 END) AS notees,"
                   + " AVG(ev.note) AS moyenne"
                   + " FROM jury j LEFT JOIN evaluation ev ON ev.id_jury = j.id_jury"
                   + " WHERE j.id_soutenance = ?";
        int total;
        int notees;
        double moyenne;
        try (PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, idSoutenance);
            try (ResultSet rs = p.executeQuery()) {
                if (!rs.next()) return;
                total = rs.getInt("total");
                notees = rs.getInt("notees");
                moyenne = rs.getDouble("moyenne");
            }
        }

        if (total > 0 && notees == total) {
            try (PreparedStatement p = c.prepareStatement(
                    "UPDATE soutenance SET statut='EVALUEE', note_finale=? WHERE id_soutenance=?")) {
                p.setDouble(1, Math.round(moyenne * 100.0) / 100.0);
                p.setInt(2, idSoutenance);
                p.executeUpdate();
            }
        } else {
            try (PreparedStatement p = c.prepareStatement(
                    "UPDATE soutenance SET statut='PLANIFIEE', note_finale=NULL WHERE id_soutenance=?")) {
                p.setInt(1, idSoutenance);
                p.executeUpdate();
            }
        }
    }

    public static Double moyenneGenerale() throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT AVG(note) FROM evaluation WHERE note IS NOT NULL");
             ResultSet rs = p.executeQuery()) {
            if (!rs.next()) return null;
            double v = rs.getDouble(1);
            return rs.wasNull() ? null : Math.round(v * 100.0) / 100.0;
        }
    }

    public static int countEnAttenteParEnseignant(String matricule) throws SQLException {
        String sql = "SELECT COUNT(*) FROM jury j JOIN soutenance s ON s.id_soutenance = j.id_soutenance"
                   + " LEFT JOIN evaluation ev ON ev.id_jury = j.id_jury"
                   + " WHERE j.matricule_ens = ? AND s.statut = 'PLANIFIEE' AND ev.note IS NULL";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, matricule);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private static Evaluation mapper(ResultSet rs) throws SQLException {
        Evaluation e = new Evaluation();
        e.setIdEvaluation(rs.getInt("id_evaluation"));
        e.setIdSoutenance(rs.getInt("id_soutenance"));
        e.setMatriculeEnseignant(rs.getString("matricule_ens"));
        e.setEnseignantNom(rs.getString("enseignant_nom"));
        e.setQualite(rs.getString("qualite"));
        double note = rs.getDouble("note");
        e.setNote(rs.wasNull() ? null : note);
        e.setAvis(rs.getString("avis"));
        e.setNomEtudiant(rs.getString("nom"));
        e.setPrenomEtudiant(rs.getString("prenom"));
        e.setSujet(rs.getString("sujet"));
        e.setStatutSoutenance(rs.getString("statut_soutenance"));
        java.sql.Timestamp ts = rs.getTimestamp("date_heure");
        e.setDateSoutenance(ts == null ? null
                : new java.text.SimpleDateFormat("dd/MM/yyyy 'à' HH:mm", java.util.Locale.FRENCH).format(ts));
        return e;
    }
}

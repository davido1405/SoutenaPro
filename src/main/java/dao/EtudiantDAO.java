package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import connection.ConnexionBD;
import models.Etudiant;
import utils.BusinessException;
import utils.HashUtils;
import utils.SqlUtils;
import utils.Validators;

public class EtudiantDAO {

    private EtudiantDAO() {
    }

    private static final String BASE_SELECT =
        "SELECT et.matricule_etu, et.id_filiere, f.lib_filiere, et.id_niveau, n.lib_niveau,"
      + " et.matricule_encadrant, CONCAT(eu.prenom, ' ', eu.nom) AS encadrant_nom, et.sujet,"
      + " u.id_utilisateur, u.login, u.nom, u.prenom, u.email, u.telephone, u.adresse,"
      + " s.statut AS statut_soutenance, s.date_heure AS date_soutenance"
      + " FROM etudiant et"
      + " JOIN utilisateur u ON u.id_utilisateur = et.id_utilisateur"
      + " LEFT JOIN filiere f ON f.id_filiere = et.id_filiere"
      + " LEFT JOIN niveau n ON n.id_niveau = et.id_niveau"
      + " LEFT JOIN enseignant ens ON ens.matricule_ens = et.matricule_encadrant"
      + " LEFT JOIN utilisateur eu ON eu.id_utilisateur = ens.id_utilisateur"
      + " LEFT JOIN soutenance s ON s.matricule_etu = et.matricule_etu";

    public static List<Etudiant> findAll(String recherche) throws SQLException {
        List<Etudiant> liste = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT);
        List<String> params = new ArrayList<>();

        if (!Validators.isBlank(recherche)) {
            sql.append(" WHERE (u.nom LIKE ? OR u.prenom LIKE ? OR et.matricule_etu LIKE ?"
                     + " OR et.sujet LIKE ? OR f.lib_filiere LIKE ?)");
            String like = "%" + recherche.trim() + "%";
            for (int i = 0; i < 5; i++) params.add(like);
        }
        sql.append(" ORDER BY u.nom, u.prenom");

        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) p.setString(i + 1, params.get(i));
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) liste.add(mapper(rs));
            }
        }
        return liste;
    }

    public static Etudiant findByMatricule(String matricule) throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(BASE_SELECT + " WHERE et.matricule_etu = ?")) {
            p.setString(1, matricule);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? mapper(rs) : null;
            }
        }
    }

    /** Étudiants encadrés par un enseignant donné. */
    public static List<Etudiant> findByEncadrant(String matriculeEns) throws SQLException {
        List<Etudiant> liste = new ArrayList<>();
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(
                     BASE_SELECT + " WHERE et.matricule_encadrant = ? ORDER BY u.nom, u.prenom")) {
            p.setString(1, matriculeEns);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) liste.add(mapper(rs));
            }
        }
        return liste;
    }

    public static int count() throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT COUNT(*) FROM etudiant");
             ResultSet rs = p.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public static void insert(Etudiant e) throws SQLException, BusinessException {
        if (Validators.isBlank(e.getMatricule()) || Validators.isBlank(e.getNom()) || Validators.isBlank(e.getPrenom())) {
            throw new BusinessException("Le matricule, le nom et le prénom sont obligatoires.");
        }
        String login = e.getMatricule().trim().toLowerCase();

        try (Connection c = ConnexionBD.getConnection()) {
            c.setAutoCommit(false);
            try {
                String sqlUser = "INSERT INTO utilisateur (login, mdp, id_role, nom, prenom, email, telephone, adresse)"
                               + " VALUES (?, ?, 3, ?, ?, ?, ?, ?)";
                try (PreparedStatement p = c.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                    p.setString(1, login);
                    p.setString(2, HashUtils.sha256("123456"));
                    p.setString(3, e.getNom().trim());
                    p.setString(4, e.getPrenom().trim());
                    p.setString(5, Validators.nullIfBlank(e.getEmail()));
                    p.setString(6, Validators.nullIfBlank(e.getTelephone()));
                    p.setString(7, Validators.nullIfBlank(e.getAdresse()));
                    p.executeUpdate();
                    try (ResultSet keys = p.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("Identifiant utilisateur non généré.");
                        e.setIdUtilisateur(keys.getInt(1));
                    }
                }

                String sqlEtu = "INSERT INTO etudiant (matricule_etu, id_filiere, id_niveau, matricule_encadrant, sujet, id_utilisateur)"
                              + " VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement p = c.prepareStatement(sqlEtu)) {
                    p.setString(1, e.getMatricule().trim());
                    p.setInt(2, e.getFiliere());
                    p.setInt(3, e.getNiveau());
                    p.setString(4, Validators.nullIfBlank(e.getMatriculeEncadrant()));
                    p.setString(5, Validators.nullIfBlank(e.getSujet()));
                    p.setInt(6, e.getIdUtilisateur());
                    p.executeUpdate();
                }

                c.commit();
            } catch (SQLException ex) {
                c.rollback();
                if (SqlUtils.estViolationUnicite(ex)) {
                    throw new BusinessException("Ce matricule ou cet email est déjà utilisé. "
                            + "Vérifiez que cet étudiant n'a pas déjà été créé.");
                }
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public static void update(Etudiant e) throws SQLException, BusinessException {
        try (Connection c = ConnexionBD.getConnection()) {
            c.setAutoCommit(false);
            try {
                String sqlUser = "UPDATE utilisateur SET nom=?, prenom=?, email=?, telephone=?, adresse=? WHERE id_utilisateur=?";
                try (PreparedStatement p = c.prepareStatement(sqlUser)) {
                    p.setString(1, e.getNom().trim());
                    p.setString(2, e.getPrenom().trim());
                    p.setString(3, Validators.nullIfBlank(e.getEmail()));
                    p.setString(4, Validators.nullIfBlank(e.getTelephone()));
                    p.setString(5, Validators.nullIfBlank(e.getAdresse()));
                    p.setInt(6, e.getIdUtilisateur());
                    p.executeUpdate();
                }

                String sqlEtu = "UPDATE etudiant SET id_filiere=?, id_niveau=?, matricule_encadrant=?, sujet=?"
                              + " WHERE matricule_etu=?";
                try (PreparedStatement p = c.prepareStatement(sqlEtu)) {
                    p.setInt(1, e.getFiliere());
                    p.setInt(2, e.getNiveau());
                    p.setString(3, Validators.nullIfBlank(e.getMatriculeEncadrant()));
                    p.setString(4, Validators.nullIfBlank(e.getSujet()));
                    p.setString(5, e.getMatricule());
                    p.executeUpdate();
                }

                c.commit();
            } catch (SQLException ex) {
                c.rollback();
                if (SqlUtils.estViolationUnicite(ex)) {
                    throw new BusinessException("Cet email est déjà utilisé par un autre compte.");
                }
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    /** Supprime l'étudiant ; la soutenance et ses évaluations suivent par cascade SQL. */
    public static boolean delete(String matricule) throws SQLException {
        try (Connection c = ConnexionBD.getConnection()) {
            c.setAutoCommit(false);
            try {
                Integer idUtilisateur = null;
                try (PreparedStatement p = c.prepareStatement("SELECT id_utilisateur FROM etudiant WHERE matricule_etu=?")) {
                    p.setString(1, matricule);
                    try (ResultSet rs = p.executeQuery()) {
                        if (!rs.next()) {
                            c.rollback();
                            return false;
                        }
                        idUtilisateur = rs.getInt(1);
                    }
                }

                try (PreparedStatement p = c.prepareStatement("DELETE FROM etudiant WHERE matricule_etu=?")) {
                    p.setString(1, matricule);
                    p.executeUpdate();
                }
                if (idUtilisateur != null) {
                    try (PreparedStatement p = c.prepareStatement("DELETE FROM utilisateur WHERE id_utilisateur=?")) {
                        p.setInt(1, idUtilisateur);
                        p.executeUpdate();
                    }
                }
                c.commit();
                return true;
            } catch (SQLException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public static List<String[]> getFilieres() throws SQLException {
        List<String[]> liste = new ArrayList<>();
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT id_filiere, lib_filiere FROM filiere ORDER BY lib_filiere");
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) liste.add(new String[]{rs.getString(1), rs.getString(2)});
        }
        return liste;
    }

    public static List<String[]> getNiveaux() throws SQLException {
        List<String[]> liste = new ArrayList<>();
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT id_niveau, lib_niveau FROM niveau ORDER BY ordre");
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) liste.add(new String[]{rs.getString(1), rs.getString(2)});
        }
        return liste;
    }

    /** Répartition des étudiants par filière : {libellé, effectif}. */
    public static List<Object[]> repartitionParFiliere() throws SQLException {
        List<Object[]> liste = new ArrayList<>();
        String sql = "SELECT f.lib_filiere, COUNT(e.matricule_etu) AS total"
                   + " FROM filiere f LEFT JOIN etudiant e ON e.id_filiere = f.id_filiere"
                   + " GROUP BY f.id_filiere, f.lib_filiere ORDER BY total DESC, f.lib_filiere";
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) liste.add(new Object[]{rs.getString(1), rs.getInt(2)});
        }
        return liste;
    }

    private static Etudiant mapper(ResultSet rs) throws SQLException {
        Etudiant e = new Etudiant();
        e.setMatricule(rs.getString("matricule_etu"));
        e.setIdUtilisateur(rs.getInt("id_utilisateur"));
        e.setLogin(rs.getString("login"));
        e.setNom(rs.getString("nom"));
        e.setPrenom(rs.getString("prenom"));
        e.setEmail(rs.getString("email"));
        e.setTelephone(rs.getString("telephone"));
        e.setAdresse(rs.getString("adresse"));
        e.setFiliere(rs.getInt("id_filiere"));
        e.setFiliereLibelle(rs.getString("lib_filiere"));
        e.setNiveau(rs.getInt("id_niveau"));
        e.setNiveauLibelle(rs.getString("lib_niveau"));
        e.setMatriculeEncadrant(rs.getString("matricule_encadrant"));
        e.setEncadrantNom(rs.getString("encadrant_nom"));
        e.setSujet(rs.getString("sujet"));
        e.setStatutSoutenance(rs.getString("statut_soutenance"));
        e.setDateSoutenance(rs.getString("date_soutenance"));
        return e;
    }
}

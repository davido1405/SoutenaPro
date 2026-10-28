package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import connection.ConnexionBD;
import models.Enseignant;
import utils.BusinessException;
import utils.HashUtils;
import utils.SqlUtils;
import utils.Validators;

public class EnseignantDAO {

    private EnseignantDAO() {
    }

    private static final String BASE_SELECT =
        "SELECT ens.matricule_ens, ens.id_specialite, sp.lib_specialite, ens.grade,"
      + " u.id_utilisateur, u.login, u.nom, u.prenom, u.email, u.telephone, u.adresse,"
      + " (SELECT COUNT(*) FROM etudiant e WHERE e.matricule_encadrant = ens.matricule_ens) AS nb_encadres"
      + " FROM enseignant ens"
      + " JOIN utilisateur u ON u.id_utilisateur = ens.id_utilisateur"
      + " LEFT JOIN specialite sp ON sp.id_specialite = ens.id_specialite";

    public static List<Enseignant> findAll(String recherche) throws SQLException {
        List<Enseignant> liste = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT);
        List<String> params = new ArrayList<>();

        if (!Validators.isBlank(recherche)) {
            sql.append(" WHERE (u.nom LIKE ? OR u.prenom LIKE ? OR ens.matricule_ens LIKE ?"
                     + " OR sp.lib_specialite LIKE ? OR ens.grade LIKE ?)");
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

    public static Enseignant findByMatricule(String matricule) throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(BASE_SELECT + " WHERE ens.matricule_ens = ?")) {
            p.setString(1, matricule);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? mapper(rs) : null;
            }
        }
    }

    public static int count() throws SQLException {
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT COUNT(*) FROM enseignant");
             ResultSet rs = p.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public static void insert(Enseignant e) throws SQLException, BusinessException {
        if (Validators.isBlank(e.getMatricule()) || Validators.isBlank(e.getNom()) || Validators.isBlank(e.getPrenom())) {
            throw new BusinessException("Le matricule, le nom et le prénom sont obligatoires.");
        }

        try (Connection c = ConnexionBD.getConnection()) {
            c.setAutoCommit(false);
            try {
                String sqlUser = "INSERT INTO utilisateur (login, mdp, id_role, nom, prenom, email, telephone, adresse)"
                               + " VALUES (?, ?, 2, ?, ?, ?, ?, ?)";
                try (PreparedStatement p = c.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                    p.setString(1, e.getMatricule().trim().toLowerCase());
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

                String sqlEns = "INSERT INTO enseignant (matricule_ens, id_specialite, grade, id_utilisateur)"
                              + " VALUES (?, ?, ?, ?)";
                try (PreparedStatement p = c.prepareStatement(sqlEns)) {
                    p.setString(1, e.getMatricule().trim());
                    p.setInt(2, e.getSpecialite());
                    p.setString(3, Validators.nullIfBlank(e.getGrade()));
                    p.setInt(4, e.getIdUtilisateur());
                    p.executeUpdate();
                }

                c.commit();
            } catch (SQLException ex) {
                c.rollback();
                if (SqlUtils.estViolationUnicite(ex)) {
                    throw new BusinessException("Ce matricule ou cet email est déjà utilisé. "
                            + "Vérifiez que cet enseignant n'a pas déjà été créé.");
                }
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public static void update(Enseignant e) throws SQLException, BusinessException {
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

                String sqlEns = "UPDATE enseignant SET id_specialite=?, grade=? WHERE matricule_ens=?";
                try (PreparedStatement p = c.prepareStatement(sqlEns)) {
                    p.setInt(1, e.getSpecialite());
                    p.setString(2, Validators.nullIfBlank(e.getGrade()));
                    p.setString(3, e.getMatricule());
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

    /**
     * Un enseignant référencé comme encadrant ou membre d'un jury ne peut pas être
     * supprimé : cela détruirait l'historique des évaluations.
     */
    public static boolean delete(String matricule) throws SQLException, BusinessException {
        int encadres;
        int jurys;
        try (Connection c = ConnexionBD.getConnection()) {
            try (PreparedStatement p = c.prepareStatement("SELECT COUNT(*) FROM etudiant WHERE matricule_encadrant=?")) {
                p.setString(1, matricule);
                try (ResultSet rs = p.executeQuery()) { rs.next(); encadres = rs.getInt(1); }
            }
            try (PreparedStatement p = c.prepareStatement(
                    "SELECT COUNT(*) FROM evaluation ev JOIN jury j ON j.id_jury = ev.id_jury"
                  + " WHERE j.matricule_ens=?")) {
                p.setString(1, matricule);
                try (ResultSet rs = p.executeQuery()) { rs.next(); jurys = rs.getInt(1); }
            }
        }

        if (encadres > 0 || jurys > 0) {
            throw new BusinessException("Suppression impossible : cet enseignant encadre " + encadres
                    + " étudiant(s) et participe à " + jurys + " évaluation(s).");
        }

        try (Connection c = ConnexionBD.getConnection()) {
            c.setAutoCommit(false);
            try {
                int idUtilisateur;
                try (PreparedStatement p = c.prepareStatement("SELECT id_utilisateur FROM enseignant WHERE matricule_ens=?")) {
                    p.setString(1, matricule);
                    try (ResultSet rs = p.executeQuery()) {
                        if (!rs.next()) {
                            c.rollback();
                            return false;
                        }
                        idUtilisateur = rs.getInt(1);
                    }
                }
                try (PreparedStatement p = c.prepareStatement("DELETE FROM enseignant WHERE matricule_ens=?")) {
                    p.setString(1, matricule);
                    p.executeUpdate();
                }
                try (PreparedStatement p = c.prepareStatement("DELETE FROM utilisateur WHERE id_utilisateur=?")) {
                    p.setInt(1, idUtilisateur);
                    p.executeUpdate();
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

    public static List<String[]> getSpecialites() throws SQLException {
        List<String[]> liste = new ArrayList<>();
        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement("SELECT id_specialite, lib_specialite FROM specialite ORDER BY lib_specialite");
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) liste.add(new String[]{rs.getString(1), rs.getString(2)});
        }
        return liste;
    }

    private static Enseignant mapper(ResultSet rs) throws SQLException {
        Enseignant e = new Enseignant();
        e.setMatricule(rs.getString("matricule_ens"));
        e.setIdUtilisateur(rs.getInt("id_utilisateur"));
        e.setLogin(rs.getString("login"));
        e.setNom(rs.getString("nom"));
        e.setPrenom(rs.getString("prenom"));
        e.setEmail(rs.getString("email"));
        e.setTelephone(rs.getString("telephone"));
        e.setAdresse(rs.getString("adresse"));
        e.setSpecialite(rs.getInt("id_specialite"));
        e.setSpecialiteLibelle(rs.getString("lib_specialite"));
        e.setGrade(rs.getString("grade"));
        e.setNbEncadres(rs.getInt("nb_encadres"));
        return e;
    }
}

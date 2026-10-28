package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import connection.ConnexionBD;
import models.Administrateur;
import models.Enseignant;
import models.Etudiant;
import models.Utilisateur;
import utils.HashUtils;

public class UtilisateurDAO {

    private static final String REQUETE_CONNEXION =
        "SELECT u.id_utilisateur, u.login, u.mdp, u.id_role, r.lib_role, u.nom, u.prenom, u.email, u.telephone, u.adresse,"
      + " a.id_admin,"
      + " ens.matricule_ens, ens.id_specialite, sp.lib_specialite, ens.grade,"
      + " (SELECT COUNT(*) FROM etudiant e2 WHERE e2.matricule_encadrant = ens.matricule_ens) AS nb_encadres,"
      + " et.matricule_etu, et.id_filiere, f.lib_filiere, et.id_niveau, n.lib_niveau,"
      + " et.matricule_encadrant, et.sujet,"
      + " s.statut AS statut_soutenance, s.date_heure AS date_soutenance"
      + " FROM utilisateur u"
      + " JOIN role r ON r.id_role = u.id_role"
      + " LEFT JOIN administrateur a ON a.id_utilisateur = u.id_utilisateur"
      + " LEFT JOIN enseignant ens ON ens.id_utilisateur = u.id_utilisateur"
      + " LEFT JOIN specialite sp ON sp.id_specialite = ens.id_specialite"
      + " LEFT JOIN etudiant et ON et.id_utilisateur = u.id_utilisateur"
      + " LEFT JOIN filiere f ON f.id_filiere = et.id_filiere"
      + " LEFT JOIN niveau n ON n.id_niveau = et.id_niveau"
      + " LEFT JOIN soutenance s ON s.matricule_etu = et.matricule_etu"
      + " WHERE u.login = ?";

    private UtilisateurDAO() {
    }

    /**
     * Authentifie un utilisateur et retourne le bon sous-type (Administrateur,
     * Enseignant ou Etudiant), ou null si les identifiants sont invalides.
     */
    public static Utilisateur connexion(String login, String motDePasse) throws SQLException {
        if (login == null || motDePasse == null) return null;

        try (Connection c = ConnexionBD.getConnection();
             PreparedStatement p = c.prepareStatement(REQUETE_CONNEXION)) {
            p.setString(1, login.trim());
            try (ResultSet rs = p.executeQuery()) {
                if (!rs.next()) return null;
                if (!rs.getString("mdp").equals(HashUtils.sha256(motDePasse))) return null;

                int role = rs.getInt("id_role");
                Utilisateur user;
                if (role == 1) {
                    Administrateur admin = new Administrateur();
                    admin.setIdAdmin(rs.getInt("id_admin"));
                    user = admin;
                } else if (role == 2) {
                    Enseignant ens = new Enseignant();
                    ens.setMatricule(rs.getString("matricule_ens"));
                    ens.setSpecialite(rs.getInt("id_specialite"));
                    ens.setSpecialiteLibelle(rs.getString("lib_specialite"));
                    ens.setGrade(rs.getString("grade"));
                    ens.setNbEncadres(rs.getInt("nb_encadres"));
                    user = ens;
                } else {
                    Etudiant etu = new Etudiant();
                    etu.setMatricule(rs.getString("matricule_etu"));
                    etu.setFiliere(rs.getInt("id_filiere"));
                    etu.setFiliereLibelle(rs.getString("lib_filiere"));
                    etu.setNiveau(rs.getInt("id_niveau"));
                    etu.setNiveauLibelle(rs.getString("lib_niveau"));
                    etu.setMatriculeEncadrant(rs.getString("matricule_encadrant"));
                    etu.setSujet(rs.getString("sujet"));
                    etu.setStatutSoutenance(rs.getString("statut_soutenance"));
                    etu.setDateSoutenance(rs.getString("date_soutenance"));
                    user = etu;
                }

                user.setIdUtilisateur(rs.getInt("id_utilisateur"));
                user.setLogin(rs.getString("login"));
                user.setMotDePasse(rs.getString("mdp"));
                user.setRole(role);
                user.setRoleLibelle(rs.getString("lib_role"));
                user.setNom(rs.getString("nom"));
                user.setPrenom(rs.getString("prenom"));
                user.setEmail(rs.getString("email"));
                user.setTelephone(rs.getString("telephone"));
                user.setAdresse(rs.getString("adresse"));
                return user;
            }
        }
    }
}

package models;

/**
 * Compte utilisateur commun aux trois espaces (admin, enseignant, étudiant).
 */
public class Utilisateur {

    private int idUtilisateur;
    private String login;
    private String motDePasse;
    private int role;
    private String roleLibelle;
    private String nom;
    private String prenom;
    private String email;
    private String telephone;
    private String adresse;

    public int getIdUtilisateur() { return idUtilisateur; }
    public void setIdUtilisateur(int idUtilisateur) { this.idUtilisateur = idUtilisateur; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }

    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }

    public String getRoleLibelle() { return roleLibelle; }
    public void setRoleLibelle(String roleLibelle) { this.roleLibelle = roleLibelle; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getNomComplet() {
        return (prenom == null ? "" : prenom) + " " + (nom == null ? "" : nom);
    }

    public String getInitiales() {
        String p = (prenom == null || prenom.isEmpty()) ? "" : prenom.substring(0, 1);
        String n = (nom == null || nom.isEmpty()) ? "" : nom.substring(0, 1);
        return (p + n).toUpperCase();
    }
}

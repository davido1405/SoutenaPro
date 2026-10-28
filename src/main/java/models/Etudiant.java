package models;

public class Etudiant extends Utilisateur {

    private String matricule;
    private int filiere;
    private String filiereLibelle;
    private int niveau;
    private String niveauLibelle;
    private String matriculeEncadrant;
    private String encadrantNom;
    private String sujet;
    private String statutSoutenance;
    private String dateSoutenance;

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public int getFiliere() { return filiere; }
    public void setFiliere(int filiere) { this.filiere = filiere; }

    public String getFiliereLibelle() { return filiereLibelle; }
    public void setFiliereLibelle(String filiereLibelle) { this.filiereLibelle = filiereLibelle; }

    public int getNiveau() { return niveau; }
    public void setNiveau(int niveau) { this.niveau = niveau; }

    public String getNiveauLibelle() { return niveauLibelle; }
    public void setNiveauLibelle(String niveauLibelle) { this.niveauLibelle = niveauLibelle; }

    public String getMatriculeEncadrant() { return matriculeEncadrant; }
    public void setMatriculeEncadrant(String matriculeEncadrant) { this.matriculeEncadrant = matriculeEncadrant; }

    public String getEncadrantNom() { return encadrantNom; }
    public void setEncadrantNom(String encadrantNom) { this.encadrantNom = encadrantNom; }

    public String getSujet() { return sujet; }
    public void setSujet(String sujet) { this.sujet = sujet; }

    public String getStatutSoutenance() { return statutSoutenance; }
    public void setStatutSoutenance(String statutSoutenance) { this.statutSoutenance = statutSoutenance; }

    public String getDateSoutenance() { return dateSoutenance; }
    public void setDateSoutenance(String dateSoutenance) { this.dateSoutenance = dateSoutenance; }
}

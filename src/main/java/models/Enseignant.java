package models;

public class Enseignant extends Utilisateur {

    private String matricule;
    private int specialite;
    private String specialiteLibelle;
    private String grade;
    private int nbEncadres;

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public int getSpecialite() { return specialite; }
    public void setSpecialite(int specialite) { this.specialite = specialite; }

    public String getSpecialiteLibelle() { return specialiteLibelle; }
    public void setSpecialiteLibelle(String specialiteLibelle) { this.specialiteLibelle = specialiteLibelle; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public int getNbEncadres() { return nbEncadres; }
    public void setNbEncadres(int nbEncadres) { this.nbEncadres = nbEncadres; }
}

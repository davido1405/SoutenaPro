package models;

/**
 * Membre du jury d'une soutenance. La note et l'avis sont portés par
 * l'évaluation associée (une ligne d'évaluation par membre du jury).
 */
public class Jury {

    private int idJury;
    private int idSoutenance;
    private String matriculeEnseignant;
    private String enseignantNom;
    private String specialite;
    private String grade;
    private String qualite;
    private Double note;
    private String avis;

    public int getIdJury() { return idJury; }
    public void setIdJury(int idJury) { this.idJury = idJury; }

    public int getIdSoutenance() { return idSoutenance; }
    public void setIdSoutenance(int idSoutenance) { this.idSoutenance = idSoutenance; }

    public String getMatriculeEnseignant() { return matriculeEnseignant; }
    public void setMatriculeEnseignant(String matriculeEnseignant) { this.matriculeEnseignant = matriculeEnseignant; }

    public String getEnseignantNom() { return enseignantNom; }
    public void setEnseignantNom(String enseignantNom) { this.enseignantNom = enseignantNom; }

    public String getSpecialite() { return specialite; }
    public void setSpecialite(String specialite) { this.specialite = specialite; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getQualite() { return qualite; }
    public void setQualite(String qualite) { this.qualite = qualite; }

    public Double getNote() { return note; }
    public void setNote(Double note) { this.note = note; }

    public String getAvis() { return avis; }
    public void setAvis(String avis) { this.avis = avis; }

    public boolean isNoteSaisie() { return note != null; }

    public String getQualiteLibelle() {
        if ("PRESIDENT".equals(qualite)) return "Président";
        if ("RAPPORTEUR".equals(qualite)) return "Rapporteur";
        return "Examinateur";
    }

    public String getInitiales() {
        if (enseignantNom == null || enseignantNom.isBlank()) return "?";
        String[] parts = enseignantNom.trim().split("\\s+");
        if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
        return (parts[0].charAt(0) + "" + parts[parts.length - 1].charAt(0)).toUpperCase();
    }
}

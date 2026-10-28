package models;

public class Evaluation {

    private int idEvaluation;
    private int idSoutenance;
    private String matriculeEnseignant;
    private String enseignantNom;
    private String qualite;
    private Double note;
    private String avis;
    private String nomEtudiant;
    private String prenomEtudiant;
    private String sujet;
    private String statutSoutenance;
    private String dateSoutenance;

    public int getIdEvaluation() { return idEvaluation; }
    public void setIdEvaluation(int idEvaluation) { this.idEvaluation = idEvaluation; }

    public int getIdSoutenance() { return idSoutenance; }
    public void setIdSoutenance(int idSoutenance) { this.idSoutenance = idSoutenance; }

    public String getMatriculeEnseignant() { return matriculeEnseignant; }
    public void setMatriculeEnseignant(String matriculeEnseignant) { this.matriculeEnseignant = matriculeEnseignant; }

    public String getEnseignantNom() { return enseignantNom; }
    public void setEnseignantNom(String enseignantNom) { this.enseignantNom = enseignantNom; }

    public String getQualite() { return qualite; }
    public void setQualite(String qualite) { this.qualite = qualite; }

    public Double getNote() { return note; }
    public void setNote(Double note) { this.note = note; }

    public String getAvis() { return avis; }
    public void setAvis(String avis) { this.avis = avis; }

    public String getNomEtudiant() { return nomEtudiant; }
    public void setNomEtudiant(String nomEtudiant) { this.nomEtudiant = nomEtudiant; }

    public String getPrenomEtudiant() { return prenomEtudiant; }
    public void setPrenomEtudiant(String prenomEtudiant) { this.prenomEtudiant = prenomEtudiant; }

    public String getSujet() { return sujet; }
    public void setSujet(String sujet) { this.sujet = sujet; }

    public String getStatutSoutenance() { return statutSoutenance; }
    public void setStatutSoutenance(String statutSoutenance) { this.statutSoutenance = statutSoutenance; }

    public String getDateSoutenance() { return dateSoutenance; }
    public void setDateSoutenance(String dateSoutenance) { this.dateSoutenance = dateSoutenance; }

    public String getQualiteLibelle() {
        if ("PRESIDENT".equals(qualite)) return "Président du jury";
        if ("RAPPORTEUR".equals(qualite)) return "Rapporteur";
        return "Examinateur";
    }

    public String getInitialesEtudiant() {
        String p = (prenomEtudiant == null || prenomEtudiant.isEmpty()) ? "" : prenomEtudiant.substring(0, 1);
        String n = (nomEtudiant == null || nomEtudiant.isEmpty()) ? "" : nomEtudiant.substring(0, 1);
        return (p + n).toUpperCase();
    }
}

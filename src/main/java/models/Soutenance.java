package models;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Locale;

public class Soutenance {

    private int idSoutenance;
    private String matriculeEtudiant;
    private String matriculeEncadrant;
    private String nomEtudiant;
    private String prenomEtudiant;
    private String filiereLibelle;
    private String niveauLibelle;
    private String sujet;
    private Timestamp dateHeure;
    private int dureeMinutes;
    private String salle;
    private String statut;
    private Double noteFinale;
    private int nbJury;
    private int nbNotes;
    private String qualiteMembre;
    private Double noteMembre;
    private String avisMembre;

    public int getIdSoutenance() { return idSoutenance; }
    public void setIdSoutenance(int idSoutenance) { this.idSoutenance = idSoutenance; }

    public String getMatriculeEtudiant() { return matriculeEtudiant; }
    public void setMatriculeEtudiant(String matriculeEtudiant) { this.matriculeEtudiant = matriculeEtudiant; }

    public String getMatriculeEncadrant() { return matriculeEncadrant; }
    public void setMatriculeEncadrant(String matriculeEncadrant) { this.matriculeEncadrant = matriculeEncadrant; }

    public String getNomEtudiant() { return nomEtudiant; }
    public void setNomEtudiant(String nomEtudiant) { this.nomEtudiant = nomEtudiant; }

    public String getPrenomEtudiant() { return prenomEtudiant; }
    public void setPrenomEtudiant(String prenomEtudiant) { this.prenomEtudiant = prenomEtudiant; }

    public String getFiliereLibelle() { return filiereLibelle; }
    public void setFiliereLibelle(String filiereLibelle) { this.filiereLibelle = filiereLibelle; }

    public String getNiveauLibelle() { return niveauLibelle; }
    public void setNiveauLibelle(String niveauLibelle) { this.niveauLibelle = niveauLibelle; }

    public String getSujet() { return sujet; }
    public void setSujet(String sujet) { this.sujet = sujet; }

    public Timestamp getDateHeure() { return dateHeure; }
    public void setDateHeure(Timestamp dateHeure) { this.dateHeure = dateHeure; }

    public int getDureeMinutes() { return dureeMinutes; }
    public void setDureeMinutes(int dureeMinutes) { this.dureeMinutes = dureeMinutes; }

    public String getSalle() { return salle; }
    public void setSalle(String salle) { this.salle = salle; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Double getNoteFinale() { return noteFinale; }
    public void setNoteFinale(Double noteFinale) { this.noteFinale = noteFinale; }

    public int getNbJury() { return nbJury; }
    public void setNbJury(int nbJury) { this.nbJury = nbJury; }

    public int getNbNotes() { return nbNotes; }
    public void setNbNotes(int nbNotes) { this.nbNotes = nbNotes; }

    public String getQualiteMembre() { return qualiteMembre; }
    public void setQualiteMembre(String qualiteMembre) { this.qualiteMembre = qualiteMembre; }

    public Double getNoteMembre() { return noteMembre; }
    public void setNoteMembre(Double noteMembre) { this.noteMembre = noteMembre; }

    public String getAvisMembre() { return avisMembre; }
    public void setAvisMembre(String avisMembre) { this.avisMembre = avisMembre; }

    public String getDateJour() {
        return dateHeure == null ? "—" : new SimpleDateFormat("dd/MM/yyyy", Locale.FRENCH).format(dateHeure);
    }

    /** Jour du mois sur deux chiffres, pour les pastilles de calendrier. */
    public String getJourNumero() {
        return dateHeure == null ? "—" : new SimpleDateFormat("dd", Locale.FRENCH).format(dateHeure);
    }

    /** Mois abrégé en majuscules (ex. « OCT »). */
    public String getMoisCourt() {
        if (dateHeure == null) return "";
        return new SimpleDateFormat("MMM", Locale.FRENCH).format(dateHeure)
                .replace(".", "").toUpperCase(Locale.FRENCH);
    }

    public String getHeure() {
        return dateHeure == null ? "—" : new SimpleDateFormat("HH:mm", Locale.FRENCH).format(dateHeure);
    }

    public String getDateHeureLocal() {
        return dateHeure == null ? "" : new SimpleDateFormat("yyyy-MM-dd'T'HH:mm", Locale.FRENCH).format(dateHeure);
    }

    public String getFin() {
        if (dateHeure == null) return "—";
        return new SimpleDateFormat("HH:mm", Locale.FRENCH).format(new Timestamp(dateHeure.getTime() + dureeMinutes * 60_000L));
    }

    public String getStatutLibelle() {
        if ("EVALUEE".equalsIgnoreCase(statut)) return "Évaluée";
        if ("ANNULEE".equalsIgnoreCase(statut)) return "Annulée";
        return "Planifiée";
    }

    public String getInitiales() {
        String p = (prenomEtudiant == null || prenomEtudiant.isEmpty()) ? "" : prenomEtudiant.substring(0, 1);
        String n = (nomEtudiant == null || nomEtudiant.isEmpty()) ? "" : nomEtudiant.substring(0, 1);
        return (p + n).toUpperCase();
    }
}

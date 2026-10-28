package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import dao.EnseignantDAO;
import dao.EtudiantDAO;
import dao.EvaluationDAO;
import dao.SoutenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Enseignant;
import models.Etudiant;
import models.Evaluation;
import models.Jury;
import models.Soutenance;
import models.Utilisateur;
import utils.BusinessException;
import utils.Flash;
import utils.Validators;

/**
 * Espace administrateur : tableau de bord, gestion des étudiants, des
 * enseignants, du planning des soutenances, des résultats et export CSV.
 */
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ------------------------------------------------------------------- GET

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo() == null ? "/" : request.getPathInfo();
        try {
            switch (path) {
                case "/etudiants" -> afficherEtudiants(request, response);
                case "/etudiants/detail" -> afficherDetailEtudiant(request, response);
                case "/etudiants/nouveau" -> afficherFormulaireEtudiant(request, response, null);
                case "/etudiants/modifier" -> {
                    String matricule = Validators.trim(request.getParameter("matricule"));
                    if (Validators.isBlank(matricule)) {
                        response.sendRedirect(request.getContextPath() + "/admin/etudiants/nouveau");
                    } else {
                        afficherFormulaireEtudiant(request, response, matricule);
                    }
                }
                case "/enseignants" -> afficherEnseignants(request, response);
                case "/enseignants/detail" -> afficherDetailEnseignant(request, response);
                case "/enseignants/nouveau" -> afficherFormulaireEnseignant(request, response, null);
                case "/enseignants/modifier" -> {
                    String matricule = Validators.trim(request.getParameter("matricule"));
                    if (Validators.isBlank(matricule)) {
                        response.sendRedirect(request.getContextPath() + "/admin/enseignants/nouveau");
                    } else {
                        afficherFormulaireEnseignant(request, response, matricule);
                    }
                }
                case "/soutenances" -> afficherSoutenances(request, response);
                case "/soutenances/detail" -> afficherDetailSoutenance(request, response, false);
                case "/soutenances/nouvelle" -> afficherFormulaireSoutenance(request, response, 0);
                case "/soutenances/modifier" -> {
                    int id = Validators.parseInt(request.getParameter("id"), 0);
                    if (id <= 0) {
                        response.sendRedirect(request.getContextPath() + "/admin/soutenances/nouvelle");
                    } else {
                        afficherFormulaireSoutenance(request, response, id);
                    }
                }
                case "/soutenances/convocation" -> afficherConvocation(request, response);
                case "/resultats" -> afficherResultats(request, response);
                case "/resultats/detail" -> afficherDetailSoutenance(request, response, true);
                case "/export" -> exporter(request, response);
                default -> afficherDashboard(request, response);
            }
        } catch (Exception e) {
            gererErreur(request, response, e);
        }
    }

    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("nbEtudiants", EtudiantDAO.count());
        request.setAttribute("nbEnseignants", EnseignantDAO.count());
        request.setAttribute("nbSoutenances", SoutenanceDAO.count());
        request.setAttribute("nbPlanifiees", SoutenanceDAO.countStatut("PLANIFIEE"));
        request.setAttribute("nbEvaluees", SoutenanceDAO.countStatut("EVALUEE"));
        request.setAttribute("nbAnnulees", SoutenanceDAO.countStatut("ANNULEE"));
        request.setAttribute("cetteSemaine", SoutenanceDAO.countCetteSemaine());
        request.setAttribute("prochainsJours", SoutenanceDAO.countProchainsJours(7));
        request.setAttribute("moyenneGenerale", SoutenanceDAO.moyenneGenerale());
        request.setAttribute("repartitionFilieres", EtudiantDAO.repartitionParFiliere());
        request.setAttribute("repartitionStatuts", SoutenanceDAO.repartitionParStatut());
        request.setAttribute("prochaines", SoutenanceDAO.findProchaines(5));
        request.setAttribute("jurys", SoutenanceDAO.findJurys(SoutenanceDAO.findProchaines(5)));
        preparerPage(request, "Tableau de bord", "Vue d'ensemble de la plateforme", "dashboard");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherEtudiants(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String q = request.getParameter("q");
        request.setAttribute("q", q);
        request.setAttribute("liste", EtudiantDAO.findAll(q));
        preparerPage(request, "Étudiants", "Créer, modifier et suivre les étudiants", "etudiants");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherEnseignants(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String q = request.getParameter("q");
        request.setAttribute("q", q);
        request.setAttribute("liste", EnseignantDAO.findAll(q));
        preparerPage(request, "Enseignants", "Gérer les membres du corps enseignant", "enseignants");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherSoutenances(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String q = request.getParameter("q");
        String date = request.getParameter("date");
        String statut = request.getParameter("statut");
        List<Soutenance> liste = SoutenanceDAO.findAll(q, date, null, statut);

        request.setAttribute("q", q);
        request.setAttribute("date", date);
        request.setAttribute("statut", statut);
        request.setAttribute("liste", liste);
        request.setAttribute("jurys", SoutenanceDAO.findJurys(liste));
        preparerPage(request, "Soutenances", "Planifier les passages et composer les jurys", "soutenances");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherResultats(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Soutenance> liste = SoutenanceDAO.findAll(null, null, null, "EVALUEE");
        request.setAttribute("liste", liste);
        request.setAttribute("jurys", SoutenanceDAO.findJurys(liste));
        request.setAttribute("moyenneGenerale", SoutenanceDAO.moyenneGenerale());
        request.setAttribute("moyenneJury", EvaluationDAO.moyenneGenerale());
        preparerPage(request, "Résultats", "Notes finales et délibérations", "resultats");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    // ------------------------------------------------------- Pages de détail

    private void afficherDetailEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException, BusinessException {
        String matricule = Validators.trim(request.getParameter("matricule"));
        Etudiant etudiant = EtudiantDAO.findByMatricule(matricule);
        if (etudiant == null) throw new BusinessException("Étudiant introuvable.");

        Soutenance soutenance = SoutenanceDAO.findByEtudiant(matricule);
        List<Jury> jury = soutenance == null ? List.of() : SoutenanceDAO.findJury(soutenance.getIdSoutenance());
        List<Evaluation> evaluations = soutenance == null ? List.of()
                : EvaluationDAO.findBySoutenance(soutenance.getIdSoutenance());

        request.setAttribute("etudiant", etudiant);
        request.setAttribute("soutenance", soutenance);
        request.setAttribute("jury", jury);
        request.setAttribute("evaluations", evaluations);
        preparerPage(request, "Fiche étudiant",
                etudiant.getPrenom() + " " + etudiant.getNom() + " · " + etudiant.getMatricule(),
                "etudiants", "etudiantDetail.jsp");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherDetailEnseignant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException, BusinessException {
        String matricule = Validators.trim(request.getParameter("matricule"));
        Enseignant enseignant = EnseignantDAO.findByMatricule(matricule);
        if (enseignant == null) throw new BusinessException("Enseignant introuvable.");

        List<Etudiant> encadres = EtudiantDAO.findByEncadrant(matricule);
        List<Soutenance> soutenances = SoutenanceDAO.findAll(null, null, matricule, null);
        List<Evaluation> evaluations = EvaluationDAO.findByEnseignant(matricule);
        int notesSaisies = 0;
        for (Evaluation evaluation : evaluations) {
            if (evaluation.getNote() != null) notesSaisies++;
        }

        request.setAttribute("enseignant", enseignant);
        request.setAttribute("encadres", encadres);
        request.setAttribute("soutenances", soutenances);
        request.setAttribute("jurys", SoutenanceDAO.findJurys(soutenances));
        request.setAttribute("evaluations", evaluations);
        request.setAttribute("notesSaisies", notesSaisies);
        preparerPage(request, "Fiche enseignant",
                enseignant.getPrenom() + " " + enseignant.getNom() + " · " + enseignant.getMatricule(),
                "enseignants", "enseignantDetail.jsp");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherDetailSoutenance(HttpServletRequest request, HttpServletResponse response,
            boolean modeResultat) throws SQLException, ServletException, IOException, BusinessException {
        int id = Validators.parseInt(request.getParameter("id"), 0);
        Soutenance soutenance = SoutenanceDAO.findById(id);
        if (soutenance == null) throw new BusinessException("Soutenance introuvable.");

        Etudiant etudiant = EtudiantDAO.findByMatricule(soutenance.getMatriculeEtudiant());
        Enseignant encadrant = Validators.isBlank(soutenance.getMatriculeEncadrant()) ? null
                : EnseignantDAO.findByMatricule(soutenance.getMatriculeEncadrant());

        request.setAttribute("soutenance", soutenance);
        request.setAttribute("etudiant", etudiant);
        request.setAttribute("encadrant", encadrant);
        request.setAttribute("jury", SoutenanceDAO.findJury(id));
        request.setAttribute("evaluations", EvaluationDAO.findBySoutenance(id));
        request.setAttribute("modeResultat", modeResultat);
        if (modeResultat) {
            preparerPage(request, "Détail du résultat",
                    "Délibération et notes du jury", "resultats", "soutenanceDetail.jsp");
        } else {
            preparerPage(request, "Détail de la soutenance",
                    "Planning, jury et délibération", "soutenances", "soutenanceDetail.jsp");
        }
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherConvocation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException, BusinessException {
        int id = Validators.parseInt(request.getParameter("id"), 0);
        Soutenance soutenance = SoutenanceDAO.findById(id);
        if (soutenance == null) throw new BusinessException("Soutenance introuvable.");

        request.setAttribute("soutenance", soutenance);
        request.setAttribute("etudiant", EtudiantDAO.findByMatricule(soutenance.getMatriculeEtudiant()));
        request.setAttribute("jury", SoutenanceDAO.findJury(id));
        request.getRequestDispatcher("/WEB-INF/pages/admin/convocation.jsp").forward(request, response);
    }

    // ----------------------------------------------------- Pages de formulaire

    private void afficherFormulaireEtudiant(HttpServletRequest request, HttpServletResponse response,
            String matricule) throws SQLException, ServletException, IOException, BusinessException {
        Etudiant edit = null;
        if (!Validators.isBlank(matricule)) {
            edit = EtudiantDAO.findByMatricule(matricule);
            if (edit == null) throw new BusinessException("Étudiant introuvable.");
        }
        request.setAttribute("editEtudiant", edit);
        request.setAttribute("filieres", EtudiantDAO.getFilieres());
        request.setAttribute("niveaux", EtudiantDAO.getNiveaux());
        request.setAttribute("enseignants", EnseignantDAO.findAll(null));
        preparerPage(request, edit == null ? "Nouvel étudiant" : "Modifier l'étudiant",
                edit == null ? "Créer un compte étudiant et rattacher un encadrant" : "Mettre à jour la fiche étudiante",
                "etudiants", "etudiantForm.jsp");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherFormulaireEnseignant(HttpServletRequest request, HttpServletResponse response,
            String matricule) throws SQLException, ServletException, IOException, BusinessException {
        Enseignant edit = null;
        if (!Validators.isBlank(matricule)) {
            edit = EnseignantDAO.findByMatricule(matricule);
            if (edit == null) throw new BusinessException("Enseignant introuvable.");
        }
        request.setAttribute("editEnseignant", edit);
        request.setAttribute("specialites", EnseignantDAO.getSpecialites());
        preparerPage(request, edit == null ? "Nouvel enseignant" : "Modifier l'enseignant",
                edit == null ? "Créer un compte enseignant" : "Mettre à jour la fiche enseignant",
                "enseignants", "enseignantForm.jsp");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherFormulaireSoutenance(HttpServletRequest request, HttpServletResponse response, int id)
            throws SQLException, ServletException, IOException, BusinessException {
        Soutenance edit = null;
        if (id > 0) {
            edit = SoutenanceDAO.findById(id);
            if (edit == null) throw new BusinessException("Soutenance introuvable.");
            if ("EVALUEE".equals(edit.getStatut())) {
                Flash.error(request.getSession(),
                        "Cette soutenance est évaluée : sa modification est verrouillée.");
                response.sendRedirect(request.getContextPath()
                        + "/admin/soutenances/detail?id=" + id);
                return;
            }
            List<Jury> membres = SoutenanceDAO.findJury(id);
            request.setAttribute("editJury", membres);
            for (Jury membre : membres) {
                if ("PRESIDENT".equals(membre.getQualite())) {
                    request.setAttribute("juryPresident", membre.getMatriculeEnseignant());
                } else if ("RAPPORTEUR".equals(membre.getQualite())) {
                    request.setAttribute("juryRapporteur", membre.getMatriculeEnseignant());
                } else {
                    request.setAttribute("juryExaminateur", membre.getMatriculeEnseignant());
                }
            }
        }
        request.setAttribute("editSoutenance", edit);
        request.setAttribute("etudiantsNonPlanifies", SoutenanceDAO.findEtudiantsNonPlanifies());
        request.setAttribute("enseignants", EnseignantDAO.findAll(null));
        preparerPage(request, edit == null ? "Planifier une soutenance" : "Modifier la soutenance",
                edit == null ? "Choisir un étudiant, un créneau, une salle et un jury"
                        : "Mettre à jour le créneau, la salle ou le jury",
                "soutenances", "soutenanceForm.jsp");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    // ------------------------------------------------------------------ POST

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo() == null ? "/" : request.getPathInfo();
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            switch (path) {
                case "/etudiants" -> {
                    String cible = "/admin/etudiants";
                    if ("delete".equals(action)) {
                        supprimerEtudiant(request, session);
                    } else {
                        String matricule = enregistrerEtudiant(request, session);
                        cible = "/admin/etudiants/detail?matricule=" + matricule;
                    }
                    response.sendRedirect(request.getContextPath() + cible);
                }
                case "/enseignants" -> {
                    String cible = "/admin/enseignants";
                    if ("delete".equals(action)) {
                        supprimerEnseignant(request, session);
                    } else {
                        String matricule = enregistrerEnseignant(request, session);
                        cible = "/admin/enseignants/detail?matricule=" + matricule;
                    }
                    response.sendRedirect(request.getContextPath() + cible);
                }
                case "/soutenances" -> {
                    String cible = "/admin/soutenances";
                    if ("delete".equals(action)) {
                        supprimerSoutenance(request, session);
                    } else if ("statut".equals(action)) {
                        int id = changerStatut(request, session);
                        if ("detail".equals(request.getParameter("retour"))) {
                            cible = "/admin/soutenances/detail?id=" + id;
                        }
                    } else {
                        cible = "/admin/soutenances/detail?id=" + enregistrerSoutenance(request, session);
                    }
                    response.sendRedirect(request.getContextPath() + cible);
                }
                default -> response.sendRedirect(request.getContextPath() + "/admin");
            }
        } catch (Exception e) {
            Flash.error(session, messageErreur(e));
            String cible = switch (path) {
                case "/etudiants" -> "/admin/etudiants";
                case "/enseignants" -> "/admin/enseignants";
                case "/soutenances" -> "/admin/soutenances";
                default -> "/admin";
            };
            response.sendRedirect(request.getContextPath() + cible);
        }
    }

    private String enregistrerEtudiant(HttpServletRequest request, HttpSession session)
            throws SQLException, BusinessException {
        String matriculeOriginal = Validators.trim(request.getParameter("matriculeOriginal"));
        Etudiant e = new Etudiant();
        e.setMatricule(Validators.trim(request.getParameter("matricule")));
        e.setNom(Validators.trim(request.getParameter("nom")));
        e.setPrenom(Validators.trim(request.getParameter("prenom")));
        e.setEmail(Validators.trim(request.getParameter("email")));
        e.setTelephone(Validators.trim(request.getParameter("telephone")));
        e.setAdresse(Validators.trim(request.getParameter("adresse")));
        e.setFiliere(Validators.parseInt(request.getParameter("filiere"), 1));
        e.setNiveau(Validators.parseInt(request.getParameter("niveau"), 1));
        e.setMatriculeEncadrant(Validators.trim(request.getParameter("matriculeEncadrant")));
        e.setSujet(Validators.trim(request.getParameter("sujet")));

        if (Validators.isBlank(matriculeOriginal)) {
            EtudiantDAO.insert(e);
            Flash.success(session, "Étudiant « " + e.getPrenom() + " " + e.getNom()
                    + " » créé. Identifiant : " + e.getMatricule().toLowerCase() + ", mot de passe : 123456.");
            return e.getMatricule();
        } else {
            Etudiant existant = EtudiantDAO.findByMatricule(matriculeOriginal);
            if (existant == null) throw new BusinessException("Étudiant introuvable.");
            e.setMatricule(matriculeOriginal);
            e.setIdUtilisateur(existant.getIdUtilisateur());
            EtudiantDAO.update(e);
            Flash.success(session, "Fiche de " + e.getPrenom() + " " + e.getNom() + " mise à jour.");
            return matriculeOriginal;
        }
    }

    private void supprimerEtudiant(HttpServletRequest request, HttpSession session) throws SQLException, BusinessException {
        String matricule = request.getParameter("matricule");
        if (EtudiantDAO.delete(matricule)) {
            Flash.success(session, "Étudiant supprimé, ainsi que sa soutenance et ses évaluations.");
        } else {
            throw new BusinessException("Étudiant introuvable.");
        }
    }

    private String enregistrerEnseignant(HttpServletRequest request, HttpSession session)
            throws SQLException, BusinessException {
        String matriculeOriginal = Validators.trim(request.getParameter("matriculeOriginal"));
        Enseignant e = new Enseignant();
        e.setMatricule(Validators.trim(request.getParameter("matricule")));
        e.setNom(Validators.trim(request.getParameter("nom")));
        e.setPrenom(Validators.trim(request.getParameter("prenom")));
        e.setEmail(Validators.trim(request.getParameter("email")));
        e.setTelephone(Validators.trim(request.getParameter("telephone")));
        e.setAdresse(Validators.trim(request.getParameter("adresse")));
        e.setSpecialite(Validators.parseInt(request.getParameter("specialite"), 1));
        e.setGrade(Validators.trim(request.getParameter("grade")));

        if (Validators.isBlank(matriculeOriginal)) {
            EnseignantDAO.insert(e);
            Flash.success(session, "Enseignant « " + e.getPrenom() + " " + e.getNom()
                    + " » créé. Identifiant : " + e.getMatricule().toLowerCase() + ", mot de passe : 123456.");
            return e.getMatricule();
        } else {
            Enseignant existant = EnseignantDAO.findByMatricule(matriculeOriginal);
            if (existant == null) throw new BusinessException("Enseignant introuvable.");
            e.setMatricule(matriculeOriginal);
            e.setIdUtilisateur(existant.getIdUtilisateur());
            EnseignantDAO.update(e);
            Flash.success(session, "Fiche de " + e.getPrenom() + " " + e.getNom() + " mise à jour.");
            return matriculeOriginal;
        }
    }

    private void supprimerEnseignant(HttpServletRequest request, HttpSession session)
            throws SQLException, BusinessException {
        String matricule = request.getParameter("matricule");
        if (EnseignantDAO.delete(matricule)) {
            Flash.success(session, "Enseignant supprimé.");
        } else {
            throw new BusinessException("Enseignant introuvable.");
        }
    }

    private int enregistrerSoutenance(HttpServletRequest request, HttpSession session)
            throws SQLException, BusinessException {
        Soutenance s = new Soutenance();
        s.setIdSoutenance(Validators.parseInt(request.getParameter("id"), 0));
        s.setMatriculeEtudiant(Validators.trim(request.getParameter("matriculeEtudiant")));
        s.setDureeMinutes(Validators.parseInt(request.getParameter("dureeMinutes"), 60));
        s.setSalle(Validators.trim(request.getParameter("salle")));
        s.setDateHeure(parseDate(request.getParameter("dateHeure")));

        List<Jury> jury = new ArrayList<>();
        ajouterMembre(jury, request.getParameter("president"), "PRESIDENT");
        ajouterMembre(jury, request.getParameter("rapporteur"), "RAPPORTEUR");
        ajouterMembre(jury, request.getParameter("examinateur"), "EXAMINATEUR");

        if (s.getIdSoutenance() > 0) {
            SoutenanceDAO.update(s, jury);
            Flash.success(session, "Soutenance mise à jour.");
            return s.getIdSoutenance();
        } else {
            int id = SoutenanceDAO.insert(s, jury);
            Flash.success(session, "Soutenance planifiée avec succès.");
            return id;
        }
    }

    private void ajouterMembre(List<Jury> jury, String matricule, String qualite) {
        if (!Validators.isBlank(matricule)) {
            Jury j = new Jury();
            j.setMatriculeEnseignant(matricule.trim());
            j.setQualite(qualite);
            jury.add(j);
        }
    }

    private void supprimerSoutenance(HttpServletRequest request, HttpSession session) throws SQLException {
        int id = Validators.parseInt(request.getParameter("id"), 0);
        if (SoutenanceDAO.delete(id)) {
            Flash.success(session, "Soutenance supprimée.");
        } else {
            Flash.error(session, "Soutenance introuvable.");
        }
    }

    private int changerStatut(HttpServletRequest request, HttpSession session) throws SQLException {
        int id = Validators.parseInt(request.getParameter("id"), 0);
        String statut = request.getParameter("statut");
        if (!"ANNULEE".equals(statut) && !"PLANIFIEE".equals(statut)) {
            Flash.error(session, "Statut inconnu.");
            return id;
        }
        SoutenanceDAO.changerStatut(id, statut);
        Flash.success(session, "ANNULEE".equals(statut) ? "Soutenance annulée." : "Soutenance replanifiée.");
        return id;
    }

    // ------------------------------------------------------------------ CSV

    private void exporter(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String type = request.getParameter("type");
        response.setContentType("text/csv; charset=UTF-8");
        String nom = "soutenances".equals(type) ? "soutenances" : "etudiants".equals(type) ? "etudiants" : "enseignants";
        response.setHeader("Content-Disposition", "attachment; filename=\"soutenapro-" + nom + ".csv\"");

        try (PrintWriter out = response.getWriter()) {
            out.write('\uFEFF'); // BOM UTF-8 pour Excel
            if ("etudiants".equals(type)) {
                out.println("Matricule;Nom;Prenom;Email;Filiere;Niveau;Encadrant;Sujet;Statut soutenance");
                for (Etudiant e : EtudiantDAO.findAll(null)) {
                    out.println(String.join(";", csv(e.getMatricule()), csv(e.getNom()), csv(e.getPrenom()),
                            csv(e.getEmail()), csv(e.getFiliereLibelle()), csv(e.getNiveauLibelle()),
                            csv(e.getEncadrantNom()), csv(e.getSujet()), csv(e.getStatutSoutenance())));
                }
            } else if ("enseignants".equals(type)) {
                out.println("Matricule;Nom;Prenom;Email;Specialite;Grade;Etudiants encadres");
                for (Enseignant e : EnseignantDAO.findAll(null)) {
                    out.println(String.join(";", csv(e.getMatricule()), csv(e.getNom()), csv(e.getPrenom()),
                            csv(e.getEmail()), csv(e.getSpecialiteLibelle()), csv(e.getGrade()),
                            String.valueOf(e.getNbEncadres())));
                }
            } else {
                out.println("Date;Heure;Etudiant;Filiere;Niveau;Sujet;Salle;Duree (min);Statut;Note finale;Jury");
                for (Soutenance s : SoutenanceDAO.findAll(null, null, null, null)) {
                    List<Jury> jury = SoutenanceDAO.findJury(s.getIdSoutenance());
                    StringBuilder membres = new StringBuilder();
                    for (Jury j : jury) {
                        if (membres.length() > 0) membres.append(" / ");
                        membres.append(j.getEnseignantNom()).append(" (").append(j.getQualiteLibelle()).append(")");
                    }
                    out.println(String.join(";", csv(s.getDateJour()), csv(s.getHeure()),
                            csv(s.getPrenomEtudiant() + " " + s.getNomEtudiant()), csv(s.getFiliereLibelle()),
                            csv(s.getNiveauLibelle()), csv(s.getSujet()), csv(s.getSalle()),
                            String.valueOf(s.getDureeMinutes()), csv(s.getStatutLibelle()),
                            s.getNoteFinale() == null ? "" : String.format(java.util.Locale.US, "%.2f", s.getNoteFinale()),
                            csv(membres.toString())));
                }
            }
        }
    }

    private String csv(String valeur) {
        if (valeur == null) return "";
        String propre = valeur.replace('\n', ' ').replace('\r', ' ').replace(";", ",");
        return propre;
    }

    // -------------------------------------------------------------- Utilitaires

    private Timestamp parseDate(String valeur) throws BusinessException {
        if (Validators.isBlank(valeur)) return null;
        try {
            String normalisee = valeur.trim().replace('T', ' ');
            if (normalisee.length() == 16) normalisee += ":00";
            return Timestamp.valueOf(normalisee);
        } catch (IllegalArgumentException e) {
            throw new BusinessException("Format de date invalide.");
        }
    }

    private void preparerPage(HttpServletRequest request, String titre, String sousTitre, String actif) {
        preparerPage(request, titre, sousTitre, actif, actif + ".jsp");
    }

    private void preparerPage(HttpServletRequest request, String titre, String sousTitre, String actif,
            String fichier) {
        request.setAttribute("pageTitle", titre);
        request.setAttribute("pageSubtitle", sousTitre);
        request.setAttribute("pageActive", actif);
        request.setAttribute("contenu", "/WEB-INF/pages/admin/" + fichier);
    }

    private void gererErreur(HttpServletRequest request, HttpServletResponse response, Exception e)
            throws ServletException, IOException {
        request.setAttribute("erreurTitre", "Une erreur est survenue");
        request.setAttribute("erreurMessage", messageErreur(e));
        request.setAttribute("erreurDetail", e.getClass().getSimpleName());
        request.getRequestDispatcher("/WEB-INF/pages/error.jsp").forward(request, response);
    }

    private String messageErreur(Exception e) {
        if (e instanceof BusinessException) return e.getMessage();
        if (e instanceof SQLException) {
            return "Erreur base de données : " + e.getMessage();
        }
        return "Erreur inattendue : " + e.getMessage();
    }
}

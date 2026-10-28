package controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.EvaluationDAO;
import dao.SoutenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Enseignant;
import models.Evaluation;
import models.Jury;
import models.Soutenance;
import utils.BusinessException;
import utils.Flash;
import utils.Validators;

/**
 * Espace enseignant : suivi de ses soutenances et saisie des notes du jury.
 */
public class EnseignantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Enseignant user = (Enseignant) request.getSession().getAttribute("ConnectedUser");
        String path = request.getPathInfo() == null ? "/" : request.getPathInfo();
        try {
            switch (path) {
                case "/soutenances" -> afficherSoutenances(request, response, user);
                case "/soutenances/detail" -> afficherDetailSoutenance(request, response, user);
                case "/evaluations" -> afficherEvaluations(request, response, user);
                default -> afficherDashboard(request, response, user);
            }
        } catch (Exception e) {
            request.setAttribute("erreurTitre", "Une erreur est survenue");
            request.setAttribute("erreurMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/error.jsp").forward(request, response);
        }
    }

    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, Enseignant user)
            throws SQLException, ServletException, IOException {
        List<Soutenance> toutes = SoutenanceDAO.findAll(null, null, user.getMatricule(), null);
        List<Evaluation> evaluations = EvaluationDAO.findByEnseignant(user.getMatricule());

        int enAttente = 0;
        int saisies = 0;
        for (Evaluation e : evaluations) {
            if (e.getNote() == null) {
                if (!"ANNULEE".equals(e.getStatutSoutenance())) enAttente++;
            } else {
                saisies++;
            }
        }

        request.setAttribute("toutesSoutenances", toutes);
        request.setAttribute("evaluations", evaluations);
        request.setAttribute("enAttente", enAttente);
        request.setAttribute("saisies", saisies);
        request.setAttribute("nbEncadres", user.getNbEncadres());
        request.setAttribute("avenir", SoutenanceDAO.findAVenirParEnseignant(user.getMatricule()));
        request.setAttribute("jurys", SoutenanceDAO.findJurys(toutes));
        preparerPage(request, "Tableau de bord", "Bonjour " + user.getPrenom() + ", voici votre activité", "dashboard");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherSoutenances(HttpServletRequest request, HttpServletResponse response, Enseignant user)
            throws SQLException, ServletException, IOException {
        String q = request.getParameter("q");
        String date = request.getParameter("date");
        String statut = request.getParameter("statut");
        List<Soutenance> liste = SoutenanceDAO.findAll(q, date, user.getMatricule(), statut);

        request.setAttribute("q", q);
        request.setAttribute("date", date);
        request.setAttribute("statut", statut);
        request.setAttribute("liste", liste);
        request.setAttribute("jurys", SoutenanceDAO.findJurys(liste));
        preparerPage(request, "Mes soutenances", "Soutenances où vous êtes encadrant ou membre du jury", "soutenances");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherDetailSoutenance(HttpServletRequest request, HttpServletResponse response, Enseignant user)
            throws SQLException, ServletException, IOException, BusinessException {
        int id = Validators.parseInt(request.getParameter("id"), 0);
        Soutenance soutenance = SoutenanceDAO.findById(id);
        if (soutenance == null) throw new BusinessException("Soutenance introuvable.");

        List<Jury> jury = SoutenanceDAO.findJury(id);
        boolean encadrant = user.getMatricule().equals(soutenance.getMatriculeEncadrant());
        Evaluation maNote = null;
        for (Evaluation e : EvaluationDAO.findBySoutenance(id)) {
            if (user.getMatricule().equals(e.getMatriculeEnseignant())) maNote = e;
        }
        if (!encadrant && maNote == null) {
            throw new BusinessException("Vous n'êtes ni encadrant ni membre du jury de cette soutenance.");
        }

        request.setAttribute("soutenance", soutenance);
        request.setAttribute("jury", jury);
        request.setAttribute("maNote", maNote);
        request.setAttribute("estEncadrant", encadrant);
        preparerPage(request, "Détail de la soutenance",
                "Étudiant, jury et évaluation", "soutenances", "soutenanceDetail.jsp");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    private void afficherEvaluations(HttpServletRequest request, HttpServletResponse response, Enseignant user)
            throws SQLException, ServletException, IOException {
        List<Evaluation> liste = EvaluationDAO.findByEnseignant(user.getMatricule());
        int enAttente = 0;
        int saisies = 0;
        for (Evaluation e : liste) {
            if (e.getNote() == null) {
                if (!"ANNULEE".equals(e.getStatutSoutenance())) enAttente++;
            } else {
                saisies++;
            }
        }
        request.setAttribute("liste", liste);
        request.setAttribute("enAttente", enAttente);
        request.setAttribute("saisies", saisies);
        preparerPage(request, "Mes évaluations", "Saisir et consulter vos notes de jury", "evaluations");
        request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Enseignant user = (Enseignant) request.getSession().getAttribute("ConnectedUser");
        HttpSession session = request.getSession();
        String path = request.getPathInfo() == null ? "/" : request.getPathInfo();

        if (!"/evaluations".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/enseignant");
            return;
        }

        try {
            int idEvaluation = Validators.parseInt(request.getParameter("idEvaluation"), 0);
            double note = Double.parseDouble(request.getParameter("note").replace(',', '.'));
            String avis = request.getParameter("avis");
            EvaluationDAO.saisir(idEvaluation, user.getMatricule(), note, avis);
            Flash.success(session, "Note enregistrée. Merci pour votre évaluation.");
        } catch (NumberFormatException e) {
            Flash.error(session, "Veuillez saisir une note valide entre 0 et 20.");
        } catch (Exception e) {
            Flash.error(session, e.getMessage());
        }
        String cible = "/enseignant/evaluations";
        if ("detail".equals(request.getParameter("retour"))) {
            int idSoutenance = Validators.parseInt(request.getParameter("idSoutenance"), 0);
            if (idSoutenance > 0) cible = "/enseignant/soutenances/detail?id=" + idSoutenance;
        }
        response.sendRedirect(request.getContextPath() + cible);
    }

    private void preparerPage(HttpServletRequest request, String titre, String sousTitre, String actif) {
        preparerPage(request, titre, sousTitre, actif, actif + ".jsp");
    }

    private void preparerPage(HttpServletRequest request, String titre, String sousTitre, String actif,
            String fichier) {
        request.setAttribute("pageTitle", titre);
        request.setAttribute("pageSubtitle", sousTitre);
        request.setAttribute("pageActive", actif);
        request.setAttribute("contenu", "/WEB-INF/pages/enseignant/" + fichier);
    }
}

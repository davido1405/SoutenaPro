package controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.EnseignantDAO;
import dao.EvaluationDAO;
import dao.SoutenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Enseignant;
import models.Etudiant;
import models.Evaluation;
import models.Jury;
import models.Soutenance;
import utils.DateUtils;
import utils.Validators;

/**
 * Espace étudiant : consultation de sa soutenance et de son résultat.
 */
public class EtudiantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Etudiant user = (Etudiant) request.getSession().getAttribute("ConnectedUser");
        String path = request.getPathInfo() == null ? "/" : request.getPathInfo();
        try {
            Soutenance soutenance = SoutenanceDAO.findByEtudiant(user.getMatricule());
            List<Jury> jury = soutenance == null ? List.of() : SoutenanceDAO.findJury(soutenance.getIdSoutenance());
            List<Evaluation> evaluations = soutenance == null ? List.of()
                    : EvaluationDAO.findBySoutenance(soutenance.getIdSoutenance());

            /* encadrant */
            request.setAttribute("soutenance", soutenance);
            request.setAttribute("jury", jury);
            request.setAttribute("evaluations", evaluations);
            request.setAttribute("joursRestants", soutenance == null ? null
                    : DateUtils.joursRestants(soutenance.getDateHeure()));
            if (soutenance != null && user.getMatriculeEncadrant() != null) {
                request.setAttribute("encadrant", EnseignantDAO.findByMatricule(user.getMatriculeEncadrant()));
            }

            if ("/resultat".equals(path)) {
                preparerPage(request, "Mon résultat", "Notes et délibération du jury", "resultat");
            } else if ("/soutenance".equals(path)) {
                preparerPage(request, "Ma soutenance", "Détail du dossier et du jury", "soutenance");
            } else {
                preparerPage(request, "Tableau de bord", "Bonjour " + user.getPrenom()
                        + ", retrouvez votre soutenance", "dashboard");
            }
            request.getRequestDispatcher("/WEB-INF/pages/layout.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("erreurTitre", "Une erreur est survenue");
            request.setAttribute("erreurMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/error.jsp").forward(request, response);
        }
    }

    private void preparerPage(HttpServletRequest request, String titre, String sousTitre, String actif) {
        request.setAttribute("pageTitle", titre);
        request.setAttribute("pageSubtitle", sousTitre);
        request.setAttribute("pageActive", actif);
        request.setAttribute("contenu", "/WEB-INF/pages/etudiant/" + actif + ".jsp");
    }
}

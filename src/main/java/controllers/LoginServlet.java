package controllers;

import java.io.IOException;

import dao.UtilisateurDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Utilisateur;
import utils.Validators;

/**
 * Authentification commune aux trois espaces.
 */
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("ConnectedUser") != null) {
            Utilisateur user = (Utilisateur) session.getAttribute("ConnectedUser");
            response.sendRedirect(request.getContextPath() + espace(user.getRole()));
            return;
        }
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String login = Validators.trim(request.getParameter("login"));
        String motDePasse = request.getParameter("motDePasse");

        if (Validators.isBlank(login) || Validators.isBlank(motDePasse)) {
            request.setAttribute("erreur", "Veuillez renseigner votre identifiant et votre mot de passe.");
            request.setAttribute("login", login);
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
            return;
        }

        try {
            Utilisateur user = UtilisateurDAO.connexion(login, motDePasse);
            if (user == null) {
                request.setAttribute("erreur", "Identifiant ou mot de passe incorrect.");
                request.setAttribute("login", login);
                request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("ConnectedUser", user);
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + espace(user.getRole()));
        } catch (Exception e) {
            request.setAttribute("erreur", "Connexion à la base impossible. Vérifiez que le serveur MySQL est démarré.");
            request.setAttribute("login", login);
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }

    private String espace(int role) {
        if (role == 1) return "/admin";
        if (role == 2) return "/enseignant";
        return "/etudiant";
    }
}

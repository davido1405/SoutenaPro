package filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import models.Utilisateur;

/**
 * Contrôle d'accès centralisé : chaque espace n'est accessible qu'au rôle attendu.
 */
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        Utilisateur user = session == null ? null : (Utilisateur) session.getAttribute("ConnectedUser");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String chemin = req.getServletPath();
        int attendu = chemin.startsWith("/admin") ? 1 : chemin.startsWith("/enseignant") ? 2 : 3;

        if (user.getRole() != attendu) {
            resp.sendRedirect(req.getContextPath() + espace(user.getRole()));
            return;
        }

        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        chain.doFilter(request, response);
    }

    private String espace(int role) {
        if (role == 1) return "/admin";
        if (role == 2) return "/enseignant";
        return "/etudiant";
    }
}

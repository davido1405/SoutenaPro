package utils;

import jakarta.servlet.http.HttpSession;

/**
 * Messages flash (POST → redirect → GET) pour éviter les doublons
 * lors d'un rafraîchissement de page.
 */
public final class Flash {

    private Flash() {
    }

    /** Un seul message à la fois : évite d'afficher un succès et une erreur ensemble. */
    private static void reinitialiser(HttpSession session) {
        session.removeAttribute("flashSuccess");
        session.removeAttribute("flashError");
        session.removeAttribute("flashInfo");
    }

    public static void success(HttpSession session, String message) {
        reinitialiser(session);
        session.setAttribute("flashSuccess", message);
    }

    public static void error(HttpSession session, String message) {
        reinitialiser(session);
        session.setAttribute("flashError", message);
    }

    public static void info(HttpSession session, String message) {
        reinitialiser(session);
        session.setAttribute("flashInfo", message);
    }
}

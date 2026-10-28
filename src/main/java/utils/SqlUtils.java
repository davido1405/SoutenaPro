package utils;

import java.sql.SQLException;
import java.util.Locale;

/**
 * Petites aides JDBC partagées par les DAO.
 */
public final class SqlUtils {

    private SqlUtils() {
    }

    /**
     * Détecte une violation de contrainte d'unicité (matricule, login ou email).
     * Le message de MySQL est localisé (« Duplicata… » en français), d'où le
     * contrôle du SQLState et du code d'erreur en plus du texte.
     */
    public static boolean estViolationUnicite(SQLException ex) {
        if (ex == null) {
            return false;
        }
        if ("23000".equals(ex.getSQLState()) || ex.getErrorCode() == 1062) {
            return true;
        }
        String message = ex.getMessage();
        if (message == null) {
            return false;
        }
        String texte = message.toLowerCase(Locale.ROOT);
        return texte.contains("duplicate")
                || texte.contains("duplicata")
                || texte.contains("unique constraint")
                || texte.contains("uk_login");
    }
}

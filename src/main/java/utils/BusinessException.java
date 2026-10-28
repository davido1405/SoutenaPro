package utils;

/**
 * Erreur métier dont le message est directement affichable à l'utilisateur.
 */
public class BusinessException extends Exception {

    private static final long serialVersionUID = 1L;

    public BusinessException(String message) {
        super(message);
    }
}

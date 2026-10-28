package utils;

public final class Validators {

    private Validators() {
    }

    public static boolean isBlank(String valeur) {
        return valeur == null || valeur.trim().isEmpty();
    }

    public static String trim(String valeur) {
        return valeur == null ? null : valeur.trim();
    }

    public static String nullIfBlank(String valeur) {
        return isBlank(valeur) ? null : valeur.trim();
    }

    public static boolean isEmail(String email) {
        return email != null && email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");
    }

    public static int parseInt(String valeur, int defaut) {
        try {
            return Integer.parseInt(valeur);
        } catch (NumberFormatException e) {
            return defaut;
        }
    }

    /** Retourne null si la note est vide, lève une IllegalArgumentException si hors [0,20]. */
    public static Double parseNote(String valeur) {
        if (isBlank(valeur)) return null;
        double note = Double.parseDouble(valeur.replace(',', '.'));
        if (note < 0 || note > 20) {
            throw new IllegalArgumentException("La note doit être comprise entre 0 et 20.");
        }
        return Math.round(note * 100.0) / 100.0;
    }

    public static String tronquer(String valeur, int max) {
        if (valeur == null) return null;
        return valeur.length() <= max ? valeur : valeur.substring(0, max - 1) + "…";
    }
}

package utils;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public final class DateUtils {

    private DateUtils() {
    }

    /** Ex. « Mercredi 28 octobre 2026 ». */
    public static String aujourdHui() {
        return capitaliser(new SimpleDateFormat("EEEE d MMMM yyyy", Locale.FRENCH).format(new Date()));
    }

    public static String format(Timestamp timestamp) {
        if (timestamp == null) return "—";
        return new SimpleDateFormat("dd/MM/yyyy à HH:mm", Locale.FRENCH).format(timestamp);
    }

    public static String formatDate(Timestamp timestamp) {
        if (timestamp == null) return "—";
        return new SimpleDateFormat("dd MMMM yyyy", Locale.FRENCH).format(timestamp);
    }

    public static long joursRestants(Timestamp timestamp) {
        if (timestamp == null) return Long.MAX_VALUE;
        Calendar aujourdHui = Calendar.getInstance();
        aujourdHui.set(Calendar.HOUR_OF_DAY, 0);
        aujourdHui.set(Calendar.MINUTE, 0);
        aujourdHui.set(Calendar.SECOND, 0);
        aujourdHui.set(Calendar.MILLISECOND, 0);
        Calendar cible = Calendar.getInstance();
        cible.setTimeInMillis(timestamp.getTime());
        cible.set(Calendar.HOUR_OF_DAY, 0);
        cible.set(Calendar.MINUTE, 0);
        cible.set(Calendar.SECOND, 0);
        cible.set(Calendar.MILLISECOND, 0);
        long diff = cible.getTimeInMillis() - aujourdHui.getTimeInMillis();
        return Math.round(diff / 86_400_000.0);
    }

    private static String capitaliser(String texte) {
        if (texte == null || texte.isEmpty()) return texte;
        return Character.toUpperCase(texte.charAt(0)) + texte.substring(1);
    }
}

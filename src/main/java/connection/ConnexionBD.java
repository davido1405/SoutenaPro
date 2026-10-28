package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Connexion JDBC à la base SoutenaPro.
 * Les paramètres peuvent être surchargés par variables d'environnement,
 * ce qui évite de recompiler en cas de changement de serveur.
 */
public class ConnexionBD {

    private static final String URL = env("SOUTENAPRO_DB_URL",
            "jdbc:mysql://127.0.0.1:3306/soutena_pro?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8");
    private static final String UTILISATEUR = env("SOUTENAPRO_DB_USER", "root");
    private static final String MOT_DE_PASSE = env("SOUTENAPRO_DB_PASSWORD", "");

    private ConnexionBD() {
    }

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        return (value == null || value.isBlank()) ? fallback : value;
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
    }
}

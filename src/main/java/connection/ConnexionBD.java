package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Connexion JDBC à la base SoutenaPro.
 *
 * Même logique de connexion que le projet ProjetSoutenance : constantes
 * simples, mêmes identifiants MySQL, seule la base change (soutena_pro).
 */
public class ConnexionBD {

    private static final String URL = "jdbc:mysql://127.0.0.1:3306/soutena_pro?useSSL=false&serverTimezone=UTC";
    private static final String UTILISATEUR = "root";
    private static final String MOT_DE_PASSE = "";

    private ConnexionBD() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
    }
}

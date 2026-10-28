import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Petit utilitaire d'installation de la base SoutenaPro.
 * Il lit un script SQL et exécute chaque instruction via JDBC, ce qui évite
 * d'avoir le client MySQL en ligne de commande.
 *
 * Compilation :
 *   javac -encoding UTF-8 -cp mysql-connector-j-9.1.0.jar -d build/tools database/InstallerBD.java
 *
 * Exécution :
 *   java -cp "build/tools;mysql-connector-j-9.1.0.jar" InstallerBD database/install.sql root "motdepasse"
 */
public class InstallerBD {

    public static void main(String[] args) throws Exception {
        String fichier = args.length > 0 ? args[0] : "database/install.sql";
        String utilisateur = args.length > 1 ? args[1] : "root";
        String motDePasse = args.length > 2 ? args[2] : "";

        String serveur = System.getenv("SOUTENAPRO_DB_SERVER");
        if (serveur == null || serveur.isBlank()) {
            serveur = "jdbc:mysql://127.0.0.1:3306/?useSSL=false&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=UTC&characterEncoding=UTF-8";
        }

        Path chemin = Path.of(fichier);
        if (!Files.exists(chemin)) {
            System.err.println("Fichier SQL introuvable : " + chemin.toAbsolutePath());
            System.exit(1);
        }

        String script = Files.readString(chemin, StandardCharsets.UTF_8);
        List<String> instructions = decouper(script);
        System.out.println("Connexion à " + serveur + " ...");

        try (Connection connexion = DriverManager.getConnection(serveur, utilisateur, motDePasse);
             Statement statement = connexion.createStatement()) {
            int ok = 0;
            for (String instruction : instructions) {
                try {
                    statement.execute(instruction);
                    ok++;
                } catch (Exception e) {
                    System.err.println("Échec sur : " + instruction.substring(0, Math.min(120, instruction.length())));
                    throw e;
                }
            }
            System.out.println("Installation terminée : " + ok + " instruction(s) exécutée(s).");
            System.out.println("Base 'soutena_pro' prête. Comptes : admin1/admin123, ens1/ens123, etu1/etu123.");
        }
    }

    /** Découpe le script sur les points-virgules hors chaînes et retire les commentaires. */
    private static List<String> decouper(String script) {
        List<String> instructions = new ArrayList<>();
        StringBuilder courante = new StringBuilder();
        boolean dansChaine = false;
        boolean dansCommentaireLigne = false;
        boolean dansCommentaireBloc = false;

        for (int i = 0; i < script.length(); i++) {
            char c = script.charAt(i);
            char suivant = i + 1 < script.length() ? script.charAt(i + 1) : '\0';

            if (dansCommentaireLigne) {
                if (c == '\n') dansCommentaireLigne = false;
                continue;
            }
            if (dansCommentaireBloc) {
                if (c == '*' && suivant == '/') {
                    dansCommentaireBloc = false;
                    i++;
                }
                continue;
            }
            if (!dansChaine && c == '-' && suivant == '-') {
                dansCommentaireLigne = true;
                i++;
                continue;
            }
            if (!dansChaine && c == '/' && suivant == '*') {
                dansCommentaireBloc = true;
                i++;
                continue;
            }
            if (c == '\'') {
                dansChaine = !dansChaine;
            }
            if (c == ';' && !dansChaine) {
                String instruction = courante.toString().trim();
                if (!instruction.isEmpty()) instructions.add(instruction);
                courante.setLength(0);
            } else {
                courante.append(c);
            }
        }
        String reste = courante.toString().trim();
        if (!reste.isEmpty()) instructions.add(reste);
        return instructions;
    }
}

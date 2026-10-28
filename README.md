# SoutenaPro — Plateforme de gestion des soutenances

Application web Jakarta EE 10 complète pour organiser les soutenances de fin d'études :
planification, composition des jurys, saisie des notes, publication des résultats et
tableaux de bord par rôle.

Projet indépendant, créé dans `Projets JEE/SoutenaPro`, sans aucune modification du projet
`ProjetSoutenance`.

---

## 1. Stack technique

| Élément | Choix |
|---|---|
| Serveur d'application | WildFly 37 (Jakarta EE 10) |
| Java | 17 (`--release 17`) |
| Vues | JSP + JSTL 3.0 (tags `jakarta.tags.*`) |
| Front | Tailwind CSS (CDN), police Inter, composants maison |
| Base de données | MySQL 8 (`soutena_pro`) |
| Accès données | JDBC + DAO, requêtes préparées |
| Sécurité | SHA-256 pour les mots de passe, filtre d'authentification par rôle, en-têtes anti-cache |

---

## 2. Fonctionnalités

### Administrateur

- **Tableau de bord** : effectifs, soutenances planifiées / évaluées / annulées, moyenne
  générale, soutenances de la semaine et des 7 prochains jours, répartition par filière
  et par statut, prochains passages avec jury.
- **Étudiants** : recherche multi-critères, création et modification sur page dédiée,
  fiche détaillée (parcours, encadrant, soutenance, jury, résultat), suppression en cascade,
  affectation d'un encadrant et d'un sujet, statut de soutenance.
- **Enseignants** : recherche, création et modification sur page dédiée, fiche détaillée
  (encadrements, soutenances, notes déposées), suppression protégée (refusée si
  l'enseignant encadre des étudiants ou siège dans un jury).
- **Soutenances** : filtres (recherche, date, statut), planification avec jury de 2 à 5
  membres, président obligatoire, détection des conflits de salle et de jury, fiche détaillée,
  annulation / réactivation, convocation imprimable, verrouillage de la modification après
  évaluation.
- **Résultats** : notes finales, détail des notes par membre du jury, moyennes, page de
  délibération dédiée.
- **Exports CSV** (UTF-8 avec BOM, séparateur `;`) : étudiants, enseignants, planning.

### Enseignant

- Tableau de bord personnel : soutenances à venir, nombre d'encadrements, notes en attente.
- Liste de ses soutenances (encadrant ou membre du jury) avec filtres.
- Fiche détaillée d'une soutenance (accès contrôlé) avec jury, avancement et formulaire de note.
- Saisie et modification des notes (0 à 20) et avis, uniquement pour les soutenances dont
  il est membre du jury.

### Étudiant

- Tableau de bord : sujet, date, heure, salle, compte à rebours, jury, suivi du dossier.
- Page « Ma soutenance » : dossier complet, jury, consignes du jour J.
- Résultat détaillé après délibération : note finale, mention, notes et avis du jury,
  relevé imprimable.

### Transverse

- Connexion unique avec redirection automatique vers l'espace du rôle.
- Messages flash après redirection (PRG) : pas de doublon au rafraîchissement.
- Pages d'erreur soignées, design responsive, navigation latérale active.
- Mots de passe hachés en SHA-256, sessions de 30 minutes, cookies `HttpOnly`.

---

## 3. Comptes de démonstration

| Rôle | Identifiant | Mot de passe |
|---|---|---|
| Administrateur | `admin1` | `admin123` |
| Administrateur | `admin2` | `admin123` |
| Enseignant | `ens1` … `ens6` | `ens123` |
| Étudiant | `etu1` … `etu10` | `etu123` |

Les comptes créés depuis l'interface reçoivent le mot de passe `123456` et un identifiant
égal au matricule en minuscules.

---

## 4. Installation

### Prérequis

- JDK 17
- MySQL 8 démarré sur `127.0.0.1:3306`
- WildFly 37 (ou tout serveur Jakarta EE 10)

### 4.1 Base de données

Deux méthodes au choix.

**Avec le client MySQL :**

```bash
mysql -u root -p < database/install.sql
```

**Sans client MySQL (utilitaire JDBC fourni) :**

```powershell
cd database
.\install-db.ps1 -User root -Password "votre_mot_de_passe"
```

Le script `install.sql` crée la base `soutena_pro`, le schéma, les index, les contraintes
et un jeu de données réaliste (10 étudiants, 6 enseignants, 10 soutenances dont 3 évaluées).

### 4.2 Compilation et déploiement

```powershell
# Compile et génère dist\SoutenaPro.war
.\build.ps1

# Compile et copie directement le WAR dans WildFly
.\build.ps1 -Deploy

# WildFly installé ailleurs
.\build.ps1 -Deploy -WildFly "D:\serveurs\wildfly-37.0.1.Final"
```

Application disponible sur **http://localhost:8080/SoutenaPro/**.

Le script détecte automatiquement le JDK 17 et l'API Servlet de WildFly ; aucune
dépendance Maven n'est nécessaire. `-Deploy` copie le WAR, dépose le marqueur
`.dodeploy` puis relance le scanner de déploiement via `jboss-cli` s'il tourne.
Le déploiement reste ainsi piloté par le scanner et n'ajoute aucune entrée
persistante dans `standalone.xml`, ce qui évite le doublon
`WFLYCTL0212: Duplicate resource` au démarrage suivant.

### 4.3 Vérification des pages

Un script en lecture seule parcourt les trois espaces (administrateur, 6 enseignants,
10 étudiants), suit tous les liens internes et contrôle les accès protégés :

```powershell
.\tools\verifier-pages.ps1
```

Il vérifie au total 189 requêtes (pages, fiches, formulaires, convocations, exports,
filtres) et signale toute page manquante (404), erreur serveur ou exception. Il refuse
aussi tout lien interne sans le chemin de contexte `/SoutenaPro`, afin que la
vérification corresponde aux URL réellement rendues. Le code de sortie vaut `0` si
tout est correct, `1` sinon.

### 4.4 Paramètres de connexion

Valeurs par défaut : `root` sans mot de passe sur `127.0.0.1:3306`, base `soutena_pro`.
Elles peuvent être surchargées sans recompiler :

| Variable | Défaut |
|---|---|
| `SOUTENAPRO_DB_URL` | `jdbc:mysql://127.0.0.1:3306/soutena_pro?...` |
| `SOUTENAPRO_DB_USER` | `root` |
| `SOUTENAPRO_DB_PASSWORD` | *(vide)* |
| `SOUTENAPRO_DB_SERVER` | serveur sans base, utilisé par l'installateur |

Exemple sous Windows :

```powershell
$env:SOUTENAPRO_DB_PASSWORD = "secret"
```

---

## 5. Architecture

```
SoutenaPro/
├── build.ps1                  Compilation + packaging + déploiement
├── database/
│   ├── install.sql            Schéma + données de démonstration
│   ├── InstallerBD.java       Exécuteur SQL via JDBC
│   └── install-db.ps1         Script d'installation de la base
├── src/main/java/
│   ├── connection/            Connexion JDBC paramétrable
│   ├── models/                Utilisateur, Étudiant, Enseignant, Soutenance, Jury, Évaluation
│   ├── dao/                   UtilisateurDAO, ÉtudiantDAO, EnseignantDAO,
│   │                          SoutenanceDAO, EvaluationDAO
│   ├── filters/               Encodage + contrôle d'accès par rôle
│   ├── controllers/           Login, Logout, Admin, Enseignant, Étudiant
│   └── utils/                 Hash, flash, dates, validation, exceptions métier
└── src/main/webapp/
    ├── index.jsp              Redirection vers /login
    └── WEB-INF/
        ├── web.xml            Filtres, servlets, sessions, pages d'erreur
        ├── lib/               JSTL + connecteur MySQL
        └── pages/
            ├── layout.jsp     Coquille commune (navigation, en-tête, flash)
            ├── login.jsp      Connexion (écran scindé)
            ├── error.jsp
            ├── admin/         dashboard, listes, fiches détaillées, formulaires, convocation, résultats
            ├── enseignant/    dashboard, soutenances, fiche soutenance, évaluations
            └── etudiant/      dashboard, ma soutenance, résultat
```

### Modèle de données

`utilisateur` porte l'identité et les identifiants ; `administrateur`, `enseignant` et
`etudiant` étendent ce compte. Une soutenance est liée à un étudiant (unique), un jury
(`jury`) et une évaluation par membre (`evaluation`). Les notes sont agrégées dans
`soutenance.note_finale`.

### Règles métier

1. Un étudiant ne peut avoir qu'une seule soutenance.
2. Le jury compte entre 2 et 5 membres distincts et désigne un président.
3. Une salle ou un enseignant ne peut pas être mobilisé sur deux créneaux qui se chevauchent.
4. Tous les membres du jury doivent avoir noté pour que la soutenance passe en `EVALUEE`.
5. La note finale est la moyenne des notes du jury, calculée automatiquement.
6. Un enseignant référencé (encadrement ou jury) ne peut pas être supprimé.
7. Une soutenance évaluée ne peut plus être modifiée ; elle peut être supprimée avec confirmation.
8. Une soutenance annulée n'accepte aucune note : la saisie est désactivée côté interface et refusée côté serveur.

---

## 6. Améliorations par rapport au projet initial

- Schéma normalisé (référentiels, jury séparé des évaluations, contraintes SQL).
- Couche DAO systématique, requêtes préparées et transactions pour les opérations multi-tables.
- Détection des conflits de salle et de jury à la planification.
- Statut `EVALUEE` et note finale calculés automatiquement.
- Suppression protégée des enseignants référencés.
- Messages flash et redirections POST/GET sans doublon.
- Recherche et filtres sur toutes les listes, exports CSV.
- Tableaux de bord dynamiques par rôle et design responsive épuré.
- Pages d'action complètes : fiches détaillées étudiants / enseignants / soutenances,
  formulaires dédiés (plus de modales), convocation imprimable, délibération et dossier étudiant.
- Pages d'erreur, en-têtes de sécurité et paramètres de base surchargeables.

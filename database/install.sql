-- ============================================================================
-- SoutenaPro — script d'installation de la base de données
-- MySQL 8.x / MariaDB récent
--
-- Exécution :  mysql -u root -p < database/install.sql
-- ou via l'utilitaire JDBC fourni (voir README).
--
-- Comptes de démonstration (mot de passe en clair, stocké en SHA-256) :
--   admin1 / admin123
--   ens1 … ens6 / ens123
--   etu1 … etu10 / etu123
-- ============================================================================

SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS soutena_pro
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE soutena_pro;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS evaluation;
DROP TABLE IF EXISTS jury;
DROP TABLE IF EXISTS soutenance;
DROP TABLE IF EXISTS etudiant;
DROP TABLE IF EXISTS enseignant;
DROP TABLE IF EXISTS administrateur;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS niveau;
DROP TABLE IF EXISTS filiere;
DROP TABLE IF EXISTS specialite;
DROP TABLE IF EXISTS role;
SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------- Référentiels ---------------------------------
CREATE TABLE role (
    id_role     INT          NOT NULL,
    lib_role    VARCHAR(30)  NOT NULL,
    PRIMARY KEY (id_role)
) ENGINE=InnoDB;

CREATE TABLE specialite (
    id_specialite   INT          NOT NULL AUTO_INCREMENT,
    lib_specialite  VARCHAR(80)  NOT NULL,
    PRIMARY KEY (id_specialite),
    UNIQUE KEY uk_specialite (lib_specialite)
) ENGINE=InnoDB;

CREATE TABLE filiere (
    id_filiere   INT          NOT NULL AUTO_INCREMENT,
    lib_filiere  VARCHAR(80)  NOT NULL,
    PRIMARY KEY (id_filiere),
    UNIQUE KEY uk_filiere (lib_filiere)
) ENGINE=InnoDB;

CREATE TABLE niveau (
    id_niveau   INT          NOT NULL AUTO_INCREMENT,
    lib_niveau  VARCHAR(30)  NOT NULL,
    ordre       INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (id_niveau)
) ENGINE=InnoDB;

-- ------------------------------ Utilisateurs ---------------------------------
CREATE TABLE utilisateur (
    id_utilisateur  INT           NOT NULL AUTO_INCREMENT,
    login           VARCHAR(60)   NOT NULL,
    mdp             CHAR(64)      NOT NULL,
    id_role         INT           NOT NULL,
    nom             VARCHAR(60)   NOT NULL,
    prenom          VARCHAR(60)   NOT NULL,
    email           VARCHAR(120)  NULL,
    telephone       VARCHAR(30)   NULL,
    adresse         VARCHAR(150)  NULL,
    cree_le         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_utilisateur),
    UNIQUE KEY uk_login (login),
    UNIQUE KEY uk_email (email),
    KEY idx_utilisateur_role (id_role),
    CONSTRAINT fk_utilisateur_role FOREIGN KEY (id_role) REFERENCES role (id_role)
) ENGINE=InnoDB;

CREATE TABLE administrateur (
    id_admin        INT NOT NULL AUTO_INCREMENT,
    id_utilisateur  INT NOT NULL,
    PRIMARY KEY (id_admin),
    UNIQUE KEY uk_admin_utilisateur (id_utilisateur),
    CONSTRAINT fk_admin_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE enseignant (
    matricule_ens   VARCHAR(20)  NOT NULL,
    id_specialite   INT          NULL,
    grade           VARCHAR(60)  NULL,
    id_utilisateur  INT          NOT NULL,
    PRIMARY KEY (matricule_ens),
    UNIQUE KEY uk_enseignant_utilisateur (id_utilisateur),
    KEY idx_enseignant_specialite (id_specialite),
    CONSTRAINT fk_enseignant_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_enseignant_specialite FOREIGN KEY (id_specialite)
        REFERENCES specialite (id_specialite) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE etudiant (
    matricule_etu         VARCHAR(20)  NOT NULL,
    id_filiere            INT          NULL,
    id_niveau             INT          NULL,
    matricule_encadrant   VARCHAR(20)  NULL,
    sujet                 VARCHAR(255) NULL,
    id_utilisateur        INT          NOT NULL,
    PRIMARY KEY (matricule_etu),
    UNIQUE KEY uk_etudiant_utilisateur (id_utilisateur),
    KEY idx_etudiant_filiere (id_filiere),
    KEY idx_etudiant_niveau (id_niveau),
    KEY idx_etudiant_encadrant (matricule_encadrant),
    CONSTRAINT fk_etudiant_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_etudiant_filiere FOREIGN KEY (id_filiere)
        REFERENCES filiere (id_filiere) ON DELETE SET NULL,
    CONSTRAINT fk_etudiant_niveau FOREIGN KEY (id_niveau)
        REFERENCES niveau (id_niveau) ON DELETE SET NULL,
    CONSTRAINT fk_etudiant_encadrant FOREIGN KEY (matricule_encadrant)
        REFERENCES enseignant (matricule_ens) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ------------------------------- Soutenances ----------------------------------
CREATE TABLE soutenance (
    id_soutenance   INT           NOT NULL AUTO_INCREMENT,
    matricule_etu   VARCHAR(20)   NOT NULL,
    date_heure      DATETIME      NOT NULL,
    duree_minutes   INT           NOT NULL DEFAULT 60,
    salle           VARCHAR(40)   NOT NULL,
    statut          VARCHAR(20)   NOT NULL DEFAULT 'PLANIFIEE',
    note_finale     DECIMAL(4,2)  NULL,
    cree_le         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_soutenance),
    UNIQUE KEY uk_soutenance_etudiant (matricule_etu),
    KEY idx_soutenance_date (date_heure),
    KEY idx_soutenance_salle (salle),
    KEY idx_soutenance_statut (statut),
    CONSTRAINT fk_soutenance_etudiant FOREIGN KEY (matricule_etu)
        REFERENCES etudiant (matricule_etu) ON DELETE CASCADE,
    CONSTRAINT ck_soutenance_statut CHECK (statut IN ('PLANIFIEE', 'EVALUEE', 'ANNULEE')),
    CONSTRAINT ck_soutenance_note CHECK (note_finale IS NULL OR (note_finale >= 0 AND note_finale <= 20))
) ENGINE=InnoDB;

CREATE TABLE jury (
    id_jury         INT          NOT NULL AUTO_INCREMENT,
    id_soutenance   INT          NOT NULL,
    matricule_ens   VARCHAR(20)  NOT NULL,
    qualite         VARCHAR(20)  NOT NULL DEFAULT 'EXAMINATEUR',
    PRIMARY KEY (id_jury),
    UNIQUE KEY uk_jury_membre (id_soutenance, matricule_ens),
    KEY idx_jury_enseignant (matricule_ens),
    CONSTRAINT fk_jury_soutenance FOREIGN KEY (id_soutenance)
        REFERENCES soutenance (id_soutenance) ON DELETE CASCADE,
    CONSTRAINT fk_jury_enseignant FOREIGN KEY (matricule_ens)
        REFERENCES enseignant (matricule_ens) ON DELETE RESTRICT,
    CONSTRAINT ck_jury_qualite CHECK (qualite IN ('PRESIDENT', 'RAPPORTEUR', 'EXAMINATEUR'))
) ENGINE=InnoDB;

CREATE TABLE evaluation (
    id_evaluation  INT           NOT NULL AUTO_INCREMENT,
    id_jury        INT           NOT NULL,
    note           DECIMAL(4,2)  NULL,
    avis           VARCHAR(255)  NULL,
    evalue_le      TIMESTAMP     NULL,
    PRIMARY KEY (id_evaluation),
    UNIQUE KEY uk_evaluation_jury (id_jury),
    CONSTRAINT fk_evaluation_jury FOREIGN KEY (id_jury)
        REFERENCES jury (id_jury) ON DELETE CASCADE,
    CONSTRAINT ck_evaluation_note CHECK (note IS NULL OR (note >= 0 AND note <= 20))
) ENGINE=InnoDB;

-- ================================ DONNÉES ====================================

INSERT INTO role (id_role, lib_role) VALUES
    (1, 'Administrateur'),
    (2, 'Enseignant'),
    (3, 'Étudiant');

INSERT INTO specialite (id_specialite, lib_specialite) VALUES
    (1, 'Génie logiciel'),
    (2, 'Intelligence artificielle'),
    (3, 'Réseaux et sécurité'),
    (4, 'Data science'),
    (5, 'Systèmes d''information');

INSERT INTO filiere (id_filiere, lib_filiere) VALUES
    (1, 'Génie Logiciel'),
    (2, 'Intelligence Artificielle'),
    (3, 'Réseaux et Télécoms'),
    (4, 'Systèmes d''Information');

INSERT INTO niveau (id_niveau, lib_niveau, ordre) VALUES
    (1, 'Licence 3', 1),
    (2, 'Master 1', 2),
    (3, 'Master 2', 3);

-- Mot de passe admin123
INSERT INTO utilisateur (id_utilisateur, login, mdp, id_role, nom, prenom, email, telephone, adresse) VALUES
    (1, 'admin1', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 1,
     'TIZIE', 'Grace David', 'admin@univ.cm', '+237 690 00 00 01', 'Yaoundé'),
    (2, 'admin2', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 1,
     'ATANGANA', 'Paul', 'scolarite@univ.cm', '+237 690 00 00 02', 'Yaoundé');

INSERT INTO administrateur (id_admin, id_utilisateur) VALUES (1, 1), (2, 2);

-- Enseignants — mot de passe ens123
INSERT INTO utilisateur (id_utilisateur, login, mdp, id_role, nom, prenom, email, telephone, adresse) VALUES
    (3, 'ens1', 'de0dde51fbc0b30467e0e41d4ba32582e506b464e4315d1e01b6c03af9650ea7', 2,
     'MBALLA', 'Serge', 'serge.mballa@univ.cm', '+237 699 00 00 01', 'Yaoundé'),
    (4, 'ens2', 'de0dde51fbc0b30467e0e41d4ba32582e506b464e4315d1e01b6c03af9650ea7', 2,
     'NKOUMOU', 'Alice', 'alice.nkoumou@univ.cm', '+237 699 00 00 02', 'Douala'),
    (5, 'ens3', 'de0dde51fbc0b30467e0e41d4ba32582e506b464e4315d1e01b6c03af9650ea7', 2,
     'FOTSO', 'Bernard', 'bernard.fotso@univ.cm', '+237 699 00 00 03', 'Yaoundé'),
    (6, 'ens4', 'de0dde51fbc0b30467e0e41d4ba32582e506b464e4315d1e01b6c03af9650ea7', 2,
     'ABENA', 'Clarisse', 'clarisse.abena@univ.cm', '+237 699 00 00 04', 'Bafoussam'),
    (7, 'ens5', 'de0dde51fbc0b30467e0e41d4ba32582e506b464e4315d1e01b6c03af9650ea7', 2,
     'TCHOUA', 'Émile', 'emile.tchoua@univ.cm', '+237 699 00 00 05', 'Yaoundé'),
    (8, 'ens6', 'de0dde51fbc0b30467e0e41d4ba32582e506b464e4315d1e01b6c03af9650ea7', 2,
     'NGONO', 'Béatrice', 'beatrice.ngono@univ.cm', '+237 699 00 00 06', 'Douala');

INSERT INTO enseignant (matricule_ens, id_specialite, grade, id_utilisateur) VALUES
    ('ENS001', 1, 'Maître de conférences', 3),
    ('ENS002', 2, 'Professeur', 4),
    ('ENS003', 3, 'Chargé de cours', 5),
    ('ENS004', 4, 'Maître de conférences', 6),
    ('ENS005', 5, 'Chargé de cours', 7),
    ('ENS006', 1, 'Professeur', 8);

-- Étudiants — mot de passe etu123
INSERT INTO utilisateur (id_utilisateur, login, mdp, id_role, nom, prenom, email, telephone, adresse) VALUES
    (9,  'etu1',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'NKOMO', 'Ariane', 'ariane.nkomo@univ.cm', '+237 691 00 00 01', 'Yaoundé'),
    (10, 'etu2',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'TABI', 'Junior', 'junior.tabi@univ.cm', '+237 691 00 00 02', 'Douala'),
    (11, 'etu3',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'FOUDA', 'Mireille', 'mireille.fouda@univ.cm', '+237 691 00 00 03', 'Yaoundé'),
    (12, 'etu4',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'OYONO', 'Pierre', 'pierre.oyono@univ.cm', '+237 691 00 00 04', 'Ebolowa'),
    (13, 'etu5',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'BIKOUE', 'Laura', 'laura.bikoue@univ.cm', '+237 691 00 00 05', 'Yaoundé'),
    (14, 'etu6',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'ESSOMBA', 'Marc', 'marc.essomba@univ.cm', '+237 691 00 00 06', 'Douala'),
    (15, 'etu7',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'MBOM', 'Sandrine', 'sandrine.mbom@univ.cm', '+237 691 00 00 07', 'Buea'),
    (16, 'etu8',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'NDOUMBE', 'Yann', 'yann.ndoumbe@univ.cm', '+237 691 00 00 08', 'Yaoundé'),
    (17, 'etu9',  '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'KAMGA', 'Estelle', 'estelle.kamga@univ.cm', '+237 691 00 00 09', 'Bertoua'),
    (18, 'etu10', '612b65360845261803ad809086cff726f5c4dff0e12fc9b157569879f0ab3953', 3, 'DJOMO', 'Franck', 'franck.djomo@univ.cm', '+237 691 00 00 10', 'Yaoundé');

INSERT INTO etudiant (matricule_etu, id_filiere, id_niveau, matricule_encadrant, sujet, id_utilisateur) VALUES
    ('ETU001', 1, 3, 'ENS001', 'Conception d''une plateforme de télémédecine pour les zones rurales', 9),
    ('ETU002', 2, 3, 'ENS002', 'Détection de fraudes bancaires par apprentissage automatique', 10),
    ('ETU003', 3, 3, 'ENS003', 'Sécurisation des infrastructures SDN par approche zero-trust', 11),
    ('ETU004', 4, 3, 'ENS004', 'Mise en place d''un ERP pour une PME camerounaise', 12),
    ('ETU005', 1, 2, 'ENS005', 'Application mobile de gestion des emplois du temps universitaires', 13),
    ('ETU006', 2, 3, 'ENS006', 'Prédiction de la consommation énergétique par réseaux de neurones', 14),
    ('ETU007', 1, 3, 'ENS001', 'Architecture microservices pour une plateforme e-commerce', 15),
    ('ETU008', 3, 3, 'ENS002', 'Supervision d''un réseau IoT industriel', 16),
    ('ETU009', 4, 2, 'ENS003', 'Digitalisation du processus d''inscription administrative', 17),
    ('ETU010', 2, 2, 'ENS004', 'Analyse de sentiments des avis clients en langue française', 18);

-- Soutenances (3 évaluées, 6 planifiées, 1 annulée)
INSERT INTO soutenance (id_soutenance, matricule_etu, date_heure, duree_minutes, salle, statut, note_finale) VALUES
    (1,  'ETU001', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '09:00:00'), 60, 'Amphi A',  'EVALUEE',  17.00),
    (2,  'ETU002', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7 DAY),  '10:00:00'), 60, 'Salle 204', 'EVALUEE',  14.00),
    (3,  'ETU003', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 3 DAY),  '14:00:00'), 45, 'Amphi B',  'EVALUEE',  12.00),
    (4,  'ETU004', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY),  '09:00:00'), 60, 'Amphi A',  'PLANIFIEE', NULL),
    (5,  'ETU005', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY),  '11:00:00'), 45, 'Salle 101', 'PLANIFIEE', NULL),
    (6,  'ETU006', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 5 DAY),  '14:00:00'), 60, 'Salle 204', 'PLANIFIEE', NULL),
    (7,  'ETU007', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 7 DAY),  '10:00:00'), 60, 'Amphi B',  'PLANIFIEE', NULL),
    (8,  'ETU008', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 10 DAY), '09:30:00'), 45, 'Salle 101', 'PLANIFIEE', NULL),
    (9,  'ETU009', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 12 DAY), '15:00:00'), 45, 'Salle 204', 'ANNULEE',  NULL),
    (10, 'ETU010', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 14 DAY), '08:30:00'), 60, 'Amphi A',  'PLANIFIEE', NULL);

-- Jurys (3 membres par soutenance, l'encadrant préside)
INSERT INTO jury (id_jury, id_soutenance, matricule_ens, qualite) VALUES
    (1, 1, 'ENS001', 'PRESIDENT'), (2, 1, 'ENS002', 'RAPPORTEUR'), (3, 1, 'ENS003', 'EXAMINATEUR'),
    (4, 2, 'ENS002', 'PRESIDENT'), (5, 2, 'ENS004', 'RAPPORTEUR'), (6, 2, 'ENS005', 'EXAMINATEUR'),
    (7, 3, 'ENS003', 'PRESIDENT'), (8, 3, 'ENS001', 'RAPPORTEUR'), (9, 3, 'ENS006', 'EXAMINATEUR'),
    (10, 4, 'ENS004', 'PRESIDENT'), (11, 4, 'ENS002', 'RAPPORTEUR'), (12, 4, 'ENS005', 'EXAMINATEUR'),
    (13, 5, 'ENS005', 'PRESIDENT'), (14, 5, 'ENS003', 'RAPPORTEUR'), (15, 5, 'ENS001', 'EXAMINATEUR'),
    (16, 6, 'ENS006', 'PRESIDENT'), (17, 6, 'ENS004', 'RAPPORTEUR'), (18, 6, 'ENS002', 'EXAMINATEUR'),
    (19, 7, 'ENS001', 'PRESIDENT'), (20, 7, 'ENS005', 'RAPPORTEUR'), (21, 7, 'ENS003', 'EXAMINATEUR'),
    (22, 8, 'ENS002', 'PRESIDENT'), (23, 8, 'ENS006', 'RAPPORTEUR'), (24, 8, 'ENS004', 'EXAMINATEUR'),
    (25, 9, 'ENS003', 'PRESIDENT'), (26, 9, 'ENS001', 'RAPPORTEUR'), (27, 9, 'ENS006', 'EXAMINATEUR'),
    (28, 10, 'ENS004', 'PRESIDENT'), (29, 10, 'ENS002', 'RAPPORTEUR'), (30, 10, 'ENS005', 'EXAMINATEUR');

-- Évaluations : notes des soutenances passées, en attente pour les autres
INSERT INTO evaluation (id_jury, note, avis, evalue_le) VALUES
    (1, 17.00, 'Travail solide et très bonne maîtrise du sujet.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '10:15:00')),
    (2, 16.00, 'Démarche méthodologique claire, démonstration convaincante.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '10:20:00')),
    (3, 18.00, 'Excellente présentation, réponses précises aux questions.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '10:25:00')),

    (4, 14.00, 'Bon travail, quelques limites sur la validation expérimentale.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7 DAY), '11:10:00')),
    (5, 15.00, 'Rapport bien structuré et résultats intéressants.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7 DAY), '11:15:00')),
    (6, 13.00, 'Prestation correcte, à approfondir sur l''analyse des résultats.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7 DAY), '11:20:00')),

    (7, 12.00, 'Sujet pertinent, mise en œuvre perfectible.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 3 DAY), '15:05:00')),
    (8, 13.00, 'Bonne compréhension des enjeux de sécurité.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 3 DAY), '15:10:00')),
    (9, 11.00, 'Présentation trop rapide, réponses parfois imprécises.', TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 3 DAY), '15:15:00')),

    (10, NULL, NULL, NULL), (11, NULL, NULL, NULL), (12, NULL, NULL, NULL),
    (13, NULL, NULL, NULL), (14, NULL, NULL, NULL), (15, NULL, NULL, NULL),
    (16, NULL, NULL, NULL), (17, NULL, NULL, NULL), (18, NULL, NULL, NULL),
    (19, NULL, NULL, NULL), (20, NULL, NULL, NULL), (21, NULL, NULL, NULL),
    (22, NULL, NULL, NULL), (23, NULL, NULL, NULL), (24, NULL, NULL, NULL),
    (25, NULL, NULL, NULL), (26, NULL, NULL, NULL), (27, NULL, NULL, NULL),
    (28, NULL, NULL, NULL), (29, NULL, NULL, NULL), (30, NULL, NULL, NULL);

-- ============================================================================
-- Fin du script. Les comptes sont prêts : admin1/admin123, ens1/ens123,
-- etu1/etu123 (les autres suivent la même règle).
-- ============================================================================

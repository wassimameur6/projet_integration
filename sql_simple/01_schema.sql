CREATE DATABASE IF NOT EXISTS giscop_pestimat_simple;
USE giscop_pestimat_simple;

CREATE TABLE GISCOP84_Exposures (
    idexp INT PRIMARY KEY,
    lblexp INT,
    lblexp_desc TEXT,
    ddebexp DATE,
    dfinexp DATE,
    durexp DECIMAL(6,2),
    freqexp VARCHAR(30),
    intexp VARCHAR(20),
    picexp VARCHAR(10),
    probexp VARCHAR(20),
    naf_code VARCHAR(10),
    patient_num VARCHAR(20),
    INDEX idx_patient (patient_num),
    INDEX idx_dates (ddebexp, dfinexp),
    INDEX idx_naf (naf_code)
);

CREATE TABLE PESTIMAT_Matrix (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matiere_active VARCHAR(100) NOT NULL,
    culture VARCHAR(100),
    periode_debut INT,
    periode_fin INT,
    duree_annees INT,
    probabilite_max DECIMAL(5,2),
    fiabilite VARCHAR(10),
    pic_utilisation INT,
    intensite_kg_min DECIMAL(8,4),
    intensite_kg_max DECIMAL(8,4),
    frequence_j_min DECIMAL(4,2),
    frequence_j_max DECIMAL(4,2),
    traitement_semence VARCHAR(10),
    INDEX idx_matiere (matiere_active),
    INDEX idx_culture (culture),
    INDEX idx_periode (periode_debut, periode_fin)
);

CREATE TABLE NAF_Culture_Map (
    naf_code VARCHAR(10) PRIMARY KEY,
    naf_label VARCHAR(200),
    culture_pestimat VARCHAR(100),
    INDEX idx_culture (culture_pestimat)
);

INSERT INTO NAF_Culture_Map (naf_code, naf_label, culture_pestimat) VALUES
('01.11', 'Culture de céréales', 'Blé/Orge'),
('01.13', 'Culture de légumes', 'Pomme de Terre'),
('01.14', 'Culture de la canne à sucre', 'Betteraves'),
('01.15', 'Culture du tabac', 'Tabac'),
('01.16', 'Culture de plantes à fibres', 'Colza'),
('01.19', 'Autres cultures non permanentes', 'Maïs'),
('01.20', 'Culture de plantes fourragères', 'Pois'),
('01.21', 'Culture de la vigne', 'Vigne'),
('01.24', 'Culture de fruits à pépins et à noyau', 'Arboriculture'),
('01.25', 'Culture d''autres fruits d''arbres ou d''arbustes', 'Arboriculture'),
('01.26', 'Culture de fruits oléagineux', 'Tournesol');

SELECT 'Schema created' AS status;

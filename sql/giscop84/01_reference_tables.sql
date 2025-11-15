
CREATE DATABASE IF NOT EXISTS giscop84;
USE giscop84;

CREATE TABLE Disease (
    disease_code VARCHAR(2) PRIMARY KEY,
    disease_name VARCHAR(100) NOT NULL,
    disease_category VARCHAR(50),
    description TEXT,
    CONSTRAINT chk_disease_code CHECK (disease_code IN ('ln', 'mm', 'la'))
);

CREATE TABLE Carcinogen (
    carcinogen_id INT AUTO_INCREMENT PRIMARY KEY,
    carcinogen_label VARCHAR(200) NOT NULL UNIQUE,
    giscop_code VARCHAR(20),
    iarc_classification VARCHAR(10),
    cas_number VARCHAR(50),
    category VARCHAR(100),
    description TEXT,
    INDEX idx_label (carcinogen_label),
    INDEX idx_code (giscop_code)
);

CREATE TABLE Exposure_Probability (
    probability_code VARCHAR(20) PRIMARY KEY,
    probability_label VARCHAR(50) NOT NULL,
    description TEXT,
    CONSTRAINT chk_prob CHECK (probability_code IN ('1_incertaine', '2_probable', '3_certaine'))
);

CREATE TABLE Exposure_Frequency (
    frequency_code VARCHAR(30) PRIMARY KEY,
    frequency_label VARCHAR(100) NOT NULL,
    min_duration_minutes INT,
    max_duration_minutes INT,
    description TEXT,
    CONSTRAINT chk_freq CHECK (frequency_code IN
        ('1_moins_20min', '2_20min_1h30', '3_1h30_4h', '4_4h_8h', '5_plus_8h'))
);

CREATE TABLE Exposure_Intensity (
    intensity_code VARCHAR(20) PRIMARY KEY,
    intensity_label VARCHAR(50) NOT NULL,
    intensity_level INT,
    description TEXT,
    CONSTRAINT chk_intensity CHECK (intensity_code IN
        ('1_tres_faible', '2_faible', '3_moyenne', '4_forte', '5_tres_forte'))
);

CREATE TABLE NAF_Code (
    naf_code VARCHAR(10) PRIMARY KEY,
    naf_label VARCHAR(200) NOT NULL,
    naf_section VARCHAR(5),
    description TEXT,
    INDEX idx_label (naf_label)
);

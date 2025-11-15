-- PESTIMAT Database

CREATE DATABASE IF NOT EXISTS pestimat;
USE pestimat;

CREATE TABLE Crop_Type (
    crop_id INT AUTO_INCREMENT PRIMARY KEY,
    crop_code VARCHAR(10) UNIQUE NOT NULL,
    crop_name VARCHAR(100) NOT NULL,
    crop_category VARCHAR(50),
    description TEXT,
    INDEX idx_name (crop_name),
    INDEX idx_code (crop_code)
);

CREATE TABLE Pesticide (
    pesticide_id INT AUTO_INCREMENT PRIMARY KEY,
    substance_name VARCHAR(150) NOT NULL UNIQUE,
    cas_number VARCHAR(50),
    chemical_family VARCHAR(100),
    mode_of_action VARCHAR(100),
    pesticide_type ENUM('insecticide', 'herbicide', 'fongicide', 'nematicide', 'fumigant', 'autre'),
    iarc_classification VARCHAR(10),
    carcinogenicity_level VARCHAR(50),
    description TEXT,
    INDEX idx_name (substance_name),
    INDEX idx_family (chemical_family),
    INDEX idx_type (pesticide_type)
);

CREATE TABLE Authorization_Period (
    authorization_id INT AUTO_INCREMENT PRIMARY KEY,
    pesticide_id INT NOT NULL,
    country VARCHAR(50) DEFAULT 'France',
    authorization_start_year INT,
    authorization_end_year INT,
    ban_reason VARCHAR(200),
    notes TEXT,
    FOREIGN KEY (pesticide_id) REFERENCES Pesticide(pesticide_id) ON DELETE CASCADE,
    INDEX idx_pesticide (pesticide_id),
    INDEX idx_period (authorization_start_year, authorization_end_year)
);

CREATE TABLE NAF_Crop_Mapping (
    mapping_id INT AUTO_INCREMENT PRIMARY KEY,
    naf_code VARCHAR(10) NOT NULL,
    naf_label VARCHAR(200),
    crop_id INT NOT NULL,
    is_primary_activity BOOLEAN DEFAULT TRUE,
    notes TEXT,
    FOREIGN KEY (crop_id) REFERENCES Crop_Type(crop_id),
    INDEX idx_naf (naf_code),
    INDEX idx_crop (crop_id)
);

CREATE TABLE Crop_Pesticide_Usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    crop_id INT NOT NULL,
    pesticide_id INT NOT NULL,
    usage_start_year INT,
    usage_end_year INT,
    usage_peak_start_year INT,
    usage_peak_end_year INT,
    application_method VARCHAR(100),
    application_season VARCHAR(50),
    frequency_per_year DECIMAL(4,1),
    typical_intensity VARCHAR(20),
    peak_exposure_risk BOOLEAN DEFAULT FALSE,
    probability_code VARCHAR(20) DEFAULT '3_certaine',
    usage_prevalence DECIMAL(5,2),
    regional_variation TEXT,
    notes TEXT,
    FOREIGN KEY (crop_id) REFERENCES Crop_Type(crop_id) ON DELETE CASCADE,
    FOREIGN KEY (pesticide_id) REFERENCES Pesticide(pesticide_id) ON DELETE CASCADE,
    CONSTRAINT chk_usage_years CHECK (
        usage_end_year IS NULL OR usage_end_year >= usage_start_year
    ),
    CONSTRAINT chk_peak_years CHECK (
        (usage_peak_start_year IS NULL AND usage_peak_end_year IS NULL) OR
        (usage_peak_start_year >= usage_start_year AND
         (usage_end_year IS NULL OR usage_peak_end_year <= usage_end_year))
    ),
    INDEX idx_crop (crop_id),
    INDEX idx_pesticide (pesticide_id),
    INDEX idx_years (usage_start_year, usage_end_year),
    UNIQUE KEY unique_crop_pesticide_period (crop_id, pesticide_id, usage_start_year)
);

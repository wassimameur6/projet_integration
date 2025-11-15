
USE giscop84;

CREATE TABLE Patients (
    num VARCHAR(20) PRIMARY KEY,
    disease_code VARCHAR(2) NOT NULL,
    sexe CHAR(1),
    date_naissance DATE,
    niveau_etude VARCHAR(50),
    date_inclusion DATE,
    date_entretien DATE,
    consentement BOOLEAN DEFAULT FALSE,
    date_consentement DATE,
    refus_secondaire BOOLEAN DEFAULT FALSE,
    date_refus_secondaire DATE,
    date_expertise DATE,
    ddeces DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (disease_code) REFERENCES Disease(disease_code),
    CONSTRAINT chk_sexe CHECK (sexe IN ('M', 'F')),
    CONSTRAINT chk_consent_logic CHECK (
        (consentement = TRUE AND date_consentement IS NOT NULL) OR
        (consentement = FALSE)
    ),
    INDEX idx_date_inclusion (date_inclusion),
    INDEX idx_disease (disease_code)
);

CREATE TABLE Diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    num VARCHAR(20) NOT NULL,
    type_histo VARCHAR(100),
    date_diagnostic DATE,
    age_diagnostic INT,
    localisation VARCHAR(100),
    stade VARCHAR(50),
    is_primary BOOLEAN DEFAULT TRUE,
    notes TEXT,
    FOREIGN KEY (num) REFERENCES Patients(num) ON DELETE CASCADE,
    INDEX idx_patient (num),
    INDEX idx_date (date_diagnostic)
);

CREATE TABLE Employment (
    idpar INT AUTO_INCREMENT PRIMARY KEY,
    num VARCHAR(20) NOT NULL,
    lblpar VARCHAR(20) NOT NULL,
    sequence_num INT NOT NULL,
    company_name_custom VARCHAR(200),
    company_type VARCHAR(100),
    naf_code VARCHAR(10),
    company_size VARCHAR(10),
    ddebpar DATE NOT NULL,
    dfinpar DATE,
    durpar DECIMAL(6,2) GENERATED ALWAYS AS
        (TIMESTAMPDIFF(MONTH, ddebpar, dfinpar) / 12.0) STORED,
    date_debut_imprecise BOOLEAN DEFAULT FALSE,
    date_fin_imprecise BOOLEAN DEFAULT FALSE,
    commentaires TEXT,
    FOREIGN KEY (num) REFERENCES Patients(num) ON DELETE CASCADE,
    FOREIGN KEY (naf_code) REFERENCES NAF_Code(naf_code),
    CONSTRAINT chk_employment_dates CHECK (dfinpar IS NULL OR dfinpar >= ddebpar),
    CONSTRAINT chk_employment_lblpar CHECK (lblpar LIKE 'e%'),
    INDEX idx_patient (num),
    INDEX idx_dates (ddebpar, dfinpar),
    INDEX idx_naf (naf_code)
);

CREATE TABLE `Position` (
    idpost INT AUTO_INCREMENT PRIMARY KEY,
    idpar INT NOT NULL,
    pathway_type ENUM('employment') NOT NULL,
    numpost INT NOT NULL,
    intitule VARCHAR(200),
    ville VARCHAR(100),
    code_postal VARCHAR(10),
    pays VARCHAR(100) DEFAULT 'France',
    ddebpost DATE NOT NULL,
    dfinpost DATE,
    durpost DECIMAL(6,2) GENERATED ALWAYS AS
        (TIMESTAMPDIFF(MONTH, ddebpost, dfinpost) / 12.0) STORED,
    date_debut_imprecise BOOLEAN DEFAULT FALSE,
    date_fin_imprecise BOOLEAN DEFAULT FALSE,
    activites TEXT,
    commentaires TEXT,
    CONSTRAINT chk_position_dates CHECK (dfinpost IS NULL OR dfinpost >= ddebpost),
    INDEX idx_pathway (idpar, pathway_type),
    INDEX idx_dates (ddebpost, dfinpost),
    INDEX idx_location (ville, code_postal)
);

CREATE TABLE Exposure (
    idexp INT AUTO_INCREMENT PRIMARY KEY,
    idpost INT NOT NULL,
    carcinogen_id INT,
    lblexp TEXT,
    giscop_code VARCHAR(20),
    ddebexp DATE NOT NULL,
    dfinexp DATE,
    durexp DECIMAL(6,2) GENERATED ALWAYS AS
        (TIMESTAMPDIFF(MONTH, ddebexp, dfinexp) / 12.0) STORED,
    frequency_code VARCHAR(30),
    intensity_code VARCHAR(20),
    peak_exposure BOOLEAN DEFAULT FALSE,
    probability_code VARCHAR(20),
    date_debut_imprecise BOOLEAN DEFAULT FALSE,
    date_fin_imprecise BOOLEAN DEFAULT FALSE,
    commentaires TEXT,
    FOREIGN KEY (idpost) REFERENCES `Position`(idpost) ON DELETE CASCADE,
    FOREIGN KEY (carcinogen_id) REFERENCES Carcinogen(carcinogen_id),
    FOREIGN KEY (frequency_code) REFERENCES Exposure_Frequency(frequency_code),
    FOREIGN KEY (intensity_code) REFERENCES Exposure_Intensity(intensity_code),
    FOREIGN KEY (probability_code) REFERENCES Exposure_Probability(probability_code),
    CONSTRAINT chk_exposure_dates CHECK (dfinexp IS NULL OR dfinexp >= ddebexp),
    INDEX idx_position (idpost),
    INDEX idx_carcinogen (carcinogen_id),
    INDEX idx_dates (ddebexp, dfinexp)
);


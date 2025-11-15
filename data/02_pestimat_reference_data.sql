-- PESTIMAT - Reference Data Population

USE pestimat;

-- EXPOSURE LEVELS
-- EXPOSURE FREQUENCY
-- CROP TYPES
INSERT INTO Crop_Type (crop_code, crop_name, crop_category, description) VALUES
('VITI', 'Viticulture', 'Culture pérenne', 'Culture de la vigne pour production de vin'),
('ARBO', 'Arboriculture fruitière', 'Culture pérenne', 'Culture d''arbres fruitiers'),
('CERE', 'Céréales', 'Grande culture', 'Blé, orge, maïs, etc.'),
('LEGU', 'Maraîchage', 'Culture légumière', 'Production de légumes'),
('FLOR', 'Floriculture', 'Horticulture', 'Production de fleurs'),
('PPDT', 'Pomme de terre', 'Grande culture', 'Culture de pommes de terre'),
('BETA', 'Betterave', 'Grande culture', 'Culture de betterave sucrière');

-- PESTICIDES (Focus on viticulture - from project sample)
INSERT INTO Pesticide (substance_name, cas_number, chemical_family, pesticide_type, iarc_classification, carcinogenicity_level) VALUES
-- Organochlorés
('Lindane', '58-89-9', 'Organochlorés', 'insecticide', '2B', 'Probable cancérogène'),
('DDT', '50-29-3', 'Organochlorés', 'insecticide', '2B', 'Probable cancérogène'),
('Hexachlorobenzène', '118-74-1', 'Organochlorés', 'fongicide', '2B', 'Probable cancérogène'),
('Chlordécone', '143-50-0', 'Organochlorés', 'insecticide', '2B', 'Probable cancérogène'),
('Endosulfan', '115-29-7', 'Organochlorés', 'insecticide', '3', 'Non classifié'),

-- Chlorophénols
('Pentachlorophénol', '87-86-5', 'Chlorophénols', 'fongicide', '2A', 'Probable cancérogène'),
('2,4,5-Trichlorophénol', '95-95-4', 'Chlorophénols', 'herbicide', '2B', 'Probable cancérogène'),

-- Fumigants
('Bromure de méthyle', '74-83-9', 'Halogénés', 'fumigant', '3', 'Non classifié'),
('1,3-Dichloropropène', '542-75-6', 'Halogénés', 'nematicide', '2B', 'Probable cancérogène'),

-- Organophosphorés
('Parathion', '56-38-2', 'Organophosphorés', 'insecticide', '3', 'Non classifié'),
('Malathion', '121-75-5', 'Organophosphorés', 'insecticide', '2A', 'Probable cancérogène'),
('Chlorpyrifos', '2921-88-2', 'Organophosphorés', 'insecticide', '2B', 'Possible cancérogène'),

-- Carbamates
('Carbaryl', '63-25-2', 'Carbamates', 'insecticide', '2B', 'Possible cancérogène'),
('Manèbe', '12427-38-2', 'Dithiocarbamates', 'fongicide', '2B', 'Probable cancérogène'),
('Zinèbe', '12122-67-7', 'Dithiocarbamates', 'fongicide', '3', 'Non classifié'),

-- Cuivre (fongicides)
('Sulfate de cuivre', '7758-98-7', 'Composés cuivriques', 'fongicide', NULL, 'Usage historique important'),
('Bouillie bordelaise', NULL, 'Composés cuivriques', 'fongicide', NULL, 'Mélange cuivre'),

-- Herbicides
('Glyphosate', '1071-83-6', 'Phosphonoglycine', 'herbicide', '2A', 'Probable cancérogène'),
('2,4-D', '94-75-7', 'Phénoxyacétiques', 'herbicide', '2B', 'Possible cancérogène'),
('Atrazine', '1912-24-9', 'Triazines', 'herbicide', '3', 'Non classifié'),
('Diuron', '330-54-1', 'Urées substituées', 'herbicide', '3', 'Non classifié'),

-- Pyréthrinoïdes
('Deltaméthrine', '52918-63-5', 'Pyréthrinoïdes', 'insecticide', '3', 'Non classifié'),
('Cyperméthrine', '52315-07-8', 'Pyréthrinoïdes', 'insecticide', '3', 'Non classifié'),

-- Soufre (ancien usage)
('Soufre', '7704-34-9', 'Minéral', 'fongicide', NULL, 'Usage traditionnel'),

-- Arsenic (très ancien)
('Arséniate de plomb', '7784-40-9', 'Arsenic', 'insecticide', '1', 'Cancérogène avéré');

-- AUTHORIZATION PERIODS (France)
INSERT INTO Authorization_Period (pesticide_id, country, authorization_start_year, authorization_end_year, ban_reason) VALUES
-- Organochlorés (interdits)
(1, 'France', 1952, 1998, 'Persistance environnementale, bioaccumulation'),  -- Lindane
(2, 'France', 1945, 1972, 'Toxicité environnementale, bioaccumulation'),     -- DDT
(3, 'France', 1945, 1975, 'Cancérogénicité, persistance'),                   -- Hexachlorobenzène
(4, 'France', 1972, 1993, 'Toxicité, persistance'),                          -- Chlordécone
(5, 'France', 1960, 2007, 'Perturbation endocrinienne'),                     -- Endosulfan

-- Chlorophénols
(6, 'France', 1950, 2003, 'Cancérogénicité probable'),                       -- Pentachlorophénol
(7, 'France', 1950, 1985, 'Toxicité'),                                       -- 2,4,5-Trichlorophénol

-- Fumigants
(8, 'France', 1960, 1992, 'Appauvrissement couche d''ozone'),               -- Bromure de méthyle
(9, 'France', 1965, 2007, 'Cancérogénicité'),                               -- 1,3-Dichloropropène

-- Organophosphorés
(10, 'France', 1950, 2001, 'Toxicité aiguë élevée'),                        -- Parathion
(11, 'France', 1956, NULL, 'Encore autorisé dans certains pays'),           -- Malathion
(12, 'France', 1965, 2020, 'Toxicité pour les abeilles, neurotoxicité'),   -- Chlorpyrifos

-- Carbamates et dithiocarbamates
(13, 'France', 1958, 2008, 'Cancérogénicité possible'),                     -- Carbaryl
(14, 'France', 1962, NULL, 'Usage restreint'),                              -- Manèbe
(15, 'France', 1960, 1988, 'Remplacé par autres fongicides'),              -- Zinèbe

-- Cuivre (toujours autorisé en bio)
(16, 'France', 1885, NULL, 'Toujours autorisé, usage réglementé'),         -- Sulfate de cuivre
(17, 'France', 1885, NULL, 'Toujours autorisé en agriculture biologique'), -- Bouillie bordelaise

-- Herbicides
(18, 'France', 1975, NULL, 'Débat en cours sur cancérogénicité'),          -- Glyphosate
(19, 'France', 1946, NULL, 'Toujours autorisé'),                            -- 2,4-D
(20, 'France', 1962, 2003, 'Contamination des eaux'),                       -- Atrazine
(21, 'France', 1966, 2008, 'Contamination des eaux'),                       -- Diuron

-- Pyréthrinoïdes (toujours autorisés)
(22, 'France', 1982, NULL, 'Toujours autorisé'),                            -- Deltaméthrine
(23, 'France', 1977, NULL, 'Toujours autorisé'),                            -- Cyperméthrine

-- Ancien usage
(24, 'France', 1850, NULL, 'Toujours autorisé'),                            -- Soufre
(25, 'France', 1900, 1975, 'Cancérogénicité avérée de l''arsenic');        -- Arséniate de plomb

-- NAF to CROP MAPPING
INSERT INTO NAF_Crop_Mapping (naf_code, naf_label, crop_id, is_primary_activity) VALUES
('01.21', 'Culture de la vigne (viticulture)', 1, TRUE),
('01.24', 'Culture de fruits à pépins et à noyau', 2, TRUE),
('01.25', 'Culture d''autres fruits d''arbres ou d''arbustes', 2, TRUE),
('01.11', 'Culture de céréales', 3, TRUE),
('01.13', 'Culture de légumes', 4, TRUE),
('01.19', 'Autres cultures non permanentes', 6, FALSE);

-- CROP-PESTICIDE USAGE MATRIX (Focus on Viticulture - NAF 01.21)
-- Based on sample data showing pesticide exposures from 1957-2010
INSERT INTO Crop_Pesticide_Usage (
    crop_id, pesticide_id, usage_start_year, usage_end_year,
    usage_peak_start_year, usage_peak_end_year,
    application_method, frequency_per_year,
    typical_intensity, peak_exposure_risk, probability_code
) VALUES
-- Organochlorés en viticulture (usage massif années 1950-1970)
(1, 1, 1952, 1998, 1960, 1985, 'Pulvérisation', 8, '4_4h_8h', TRUE, '3_certaine'),  -- Lindane
(1, 2, 1945, 1972, 1950, 1970, 'Pulvérisation', 10, '4_4h_8h', TRUE, '3_certaine'), -- DDT
(1, 3, 1950, 1975, 1955, 1970, 'Pulvérisation', 6, '4_4h_8h', TRUE, '3_certaine'),  -- Hexachlorobenzène

-- Chlorophénols
(1, 6, 1950, 2003, 1960, 1980, 'Pulvérisation', 4, '3_1h30_4h', FALSE, '3_certaine'), -- Pentachlorophénol

-- Fumigants (traitement du sol)
(1, 8, 1960, 1992, 1970, 1985, 'Injection sol', 2, '4_4h_8h', TRUE, '3_certaine'), -- Bromure de méthyle
(1, 9, 1965, 2007, 1975, 1995, 'Injection sol', 1, '4_4h_8h', TRUE, '2_probable'),  -- 1,3-Dichloropropène

-- Organophosphorés (remplacent les organochlorés)
(1, 10, 1950, 2001, 1960, 1985, 'Pulvérisation', 6, '4_4h_8h', TRUE, '3_certaine'), -- Parathion
(1, 11, 1960, 2010, 1970, 1995, 'Pulvérisation', 8, '4_4h_8h', FALSE, '3_certaine'), -- Malathion
(1, 12, 1970, 2020, 1980, 2010, 'Pulvérisation', 6, '4_4h_8h', FALSE, '3_certaine'), -- Chlorpyrifos

-- Carbamates et dithiocarbamates (fongicides)
(1, 13, 1960, 2008, 1970, 1995, 'Pulvérisation', 5, '3_1h30_4h', FALSE, '3_certaine'), -- Carbaryl
(1, 14, 1962, 2024, 1975, 2005, 'Pulvérisation', 10, '4_4h_8h', FALSE, '3_certaine'), -- Manèbe
(1, 15, 1960, 1988, 1965, 1980, 'Pulvérisation', 8, '4_4h_8h', FALSE, '3_certaine'), -- Zinèbe

-- Cuivre (usage continu depuis fin XIXe)
(1, 16, 1885, 2024, 1920, 1990, 'Pulvérisation', 12, '4_4h_8h', FALSE, '3_certaine'), -- Sulfate de cuivre
(1, 17, 1885, 2024, 1920, 1990, 'Pulvérisation', 12, '4_4h_8h', FALSE, '3_certaine'), -- Bouillie bordelaise

-- Herbicides
(1, 18, 1980, 2024, 1990, 2015, 'Pulvérisation', 3, '2_20min_1h30', FALSE, '3_certaine'), -- Glyphosate
(1, 19, 1950, 2024, 1960, 1990, 'Pulvérisation', 4, '3_1h30_4h', FALSE, '3_certaine'), -- 2,4-D
(1, 20, 1965, 2003, 1975, 1995, 'Pulvérisation', 3, '2_20min_1h30', FALSE, '3_certaine'), -- Atrazine
(1, 21, 1970, 2008, 1980, 2000, 'Pulvérisation', 3, '2_20min_1h30', FALSE, '3_certaine'), -- Diuron

-- Pyréthrinoïdes (depuis années 1980)
(1, 22, 1985, 2024, 1990, 2015, 'Pulvérisation', 6, '3_1h30_4h', FALSE, '3_certaine'), -- Deltaméthrine
(1, 23, 1980, 2024, 1985, 2010, 'Pulvérisation', 6, '3_1h30_4h', FALSE, '3_certaine'), -- Cyperméthrine

-- Soufre (usage très ancien, toujours d''actualité)
(1, 24, 1850, 2024, 1900, 1980, 'Poudrage/pulvérisation', 15, '4_4h_8h', FALSE, '3_certaine'), -- Soufre

-- Arséniate (usage très ancien, abandonné)
(1, 25, 1900, 1975, 1920, 1960, 'Pulvérisation', 8, '4_4h_8h', TRUE, '3_certaine'); -- Arséniate de plomb

-- EXPOSURE TASKS (Agricultural activities)
-- GEOGRAPHIC REGIONS (Vaucluse context)

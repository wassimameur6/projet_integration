-- GISCOP 84 - Reference Data Population

USE giscop84;

-- DISEASE TYPES
INSERT INTO Disease (disease_code, disease_name, disease_category, description) VALUES
('ln', 'Lymphome', 'Hémopathie maligne', 'Cancer du système lymphatique'),
('mm', 'Myélome', 'Hémopathie maligne', 'Cancer de la moelle osseuse'),
('la', 'Leucémie', 'Hémopathie maligne', 'Cancer du sang et de la moelle osseuse');

-- EXPOSURE PROBABILITY
INSERT INTO Exposure_Probability (probability_code, probability_label, description) VALUES
('1_incertaine', 'Incertaine', 'Exposition possible mais non confirmée'),
('2_probable', 'Probable', 'Exposition vraisemblable selon le contexte'),
('3_certaine', 'Certaine', 'Exposition avérée et documentée');

-- EXPOSURE FREQUENCY
INSERT INTO Exposure_Frequency (frequency_code, frequency_label, min_duration_minutes, max_duration_minutes) VALUES
('1_moins_20min', 'Moins de 20 minutes par jour', 0, 20),
('2_20min_1h30', '20 minutes à 1h30 par jour', 20, 90),
('3_1h30_4h', '1h30 à 4h par jour', 90, 240),
('4_4h_8h', '4h à 8h par jour', 240, 480),
('5_plus_8h', 'Plus de 8h par jour', 480, NULL);

-- EXPOSURE INTENSITY
INSERT INTO Exposure_Intensity (intensity_code, intensity_label, intensity_level) VALUES
('1_tres_faible', 'Très faible', 1),
('2_faible', 'Faible', 2),
('3_moyenne', 'Moyenne', 3),
('4_forte', 'Forte', 4),
('5_tres_forte', 'Très forte', 5);

-- MAJOR CARCINOGENS (selection of key substances)
INSERT INTO Carcinogen (carcinogen_label, giscop_code, iarc_classification, category) VALUES
-- Pesticides
('Pesticides : lindane, chlorophénols, hexachlorobenzène, DDT, bromure de méthyle, etc.', '37', '2A/2B', 'Pesticides'),
('Lindane', '37.1', '2B', 'Pesticide organochloré'),
('DDT', '37.2', '2B', 'Pesticide organochloré'),
('Chlorophénols', '37.3', '2B', 'Pesticide'),
('Hexachlorobenzène', '37.4', '2B', 'Fongicide'),
('Bromure de méthyle', '37.5', '3', 'Fumigant'),
-- Asbestos
('Amiante', '01', '1', 'Fibres minérales'),
-- Benzene
('Benzène', '05', '1', 'Solvant aromatique'),
-- Diesel
('Gaz d''échappement moteurs diesel', '18', '1', 'Émissions'),
-- Wood dust
('Poussières de bois', '25', '1', 'Poussières organiques'),
-- PAHs
('Hydrocarbures aromatiques polycycliques (HAP)', '20', '1', 'Hydrocarbures'),
-- Metals
('Arsenic et composés', '03', '1', 'Métaux lourds'),
('Cadmium et composés', '07', '1', 'Métaux lourds'),
('Chrome hexavalent', '11', '1', 'Métaux lourds'),
('Nickel et composés', '23', '1', 'Métaux lourds'),
-- Solvents
('Trichloréthylène', '34', '1', 'Solvant chloré'),
('Perchloréthylène', '28', '2A', 'Solvant chloré'),
-- Other
('Formaldéhyde', '16', '1', 'Aldéhyde'),
('Silice cristalline', '30', '1', 'Poussières minérales'),
('Fumées de soudage', '17', '2B', 'Émissions'),
('Rayonnements ionisants', '29', '1', 'Radiations'),
('Aucune exposition notable', '00', NULL, 'Aucune');

-- NAF CODES (selection for agriculture)
INSERT INTO NAF_Code (naf_code, naf_label, naf_section) VALUES
('01.11', 'Culture de céréales', 'A'),
('01.13', 'Culture de légumes', 'A'),
('01.21', 'Culture de la vigne (viticulture)', 'A'),
('01.24', 'Culture de fruits à pépins et à noyau', 'A'),
('01.25', 'Culture d''autres fruits d''arbres ou d''arbustes', 'A'),
('01.28', 'Culture de plantes à épices, aromatiques, médicinales', 'A'),
('01.30', 'Reproduction de plantes', 'A'),
('01.41', 'Élevage de vaches laitières', 'A'),
('01.50', 'Culture et élevage associés', 'A'),
('02.10', 'Sylviculture et autres activités forestières', 'A'),
('10.11', 'Transformation et conservation de la viande', 'C'),
('16.10', 'Sciage et rabotage du bois', 'C'),
('23.51', 'Fabrication de ciment', 'C'),
('25.11', 'Fabrication de structures métalliques', 'C'),
('29.10', 'Construction de véhicules automobiles', 'C'),
('41.20', 'Construction de bâtiments résidentiels et non résidentiels', 'F'),
('43.11', 'Travaux de démolition', 'F'),
('49.41', 'Transports routiers de fret', 'H');

-- PCS CATEGORIES (simplified list)
-- TRAINING LEVELS
-- COMPANY SIZE
-- INTERRUPTION TYPES
-- EMPLOYMENT STATUS
-- MP ORIENTATION TYPES
-- MP RECOGNITION STATUS
-- INVESTIGATORS

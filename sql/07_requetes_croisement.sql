-- Vue de croisement GISCOP84 x PESTIMAT
-- Croise les expositions déclarées avec les pesticides attendus selon PESTIMAT

USE giscop84;

CREATE OR REPLACE VIEW vw_croisement_giscop_pestimat AS
SELECT
    -- Patient
    p.num AS 'Patient',
    p.disease_code AS 'Maladie',

    -- Emploi
    e.naf_code AS 'NAF',
    naf.naf_label AS 'Secteur',
    e.ddebpar AS 'Début',
    e.dfinpar AS 'Fin',

    -- Exposition déclarée (GISCOP84)
    car.carcinogen_label AS 'Exposition Déclarée',
    exp.intensity_code AS 'Intensité GISCOP',
    exp.frequency_code AS 'Fréquence GISCOP',

    -- Données PESTIMAT
    ct.crop_name AS 'Culture PESTIMAT',
    pest.substance_name AS 'Pesticide PESTIMAT',
    cpu.usage_start_year AS 'Année Début Usage',
    cpu.usage_end_year AS 'Année Fin Usage',
    cpu.typical_intensity AS 'Intensité PESTIMAT',
    cpu.frequency_per_year AS 'Fréquence/an PESTIMAT',

    -- Concordance
    CASE
        WHEN car.carcinogen_label LIKE CONCAT('%', pest.substance_name, '%')
        THEN 'CONCORDANCE'
        WHEN pest.substance_name IS NOT NULL
        THEN 'EXPOSITION SUPPLÉMENTAIRE PESTIMAT'
        ELSE 'EXPOSITION GISCOP SEULEMENT'
    END AS 'Statut'

FROM giscop84.Patients p
INNER JOIN giscop84.Employment e ON p.num = e.num
LEFT JOIN giscop84.NAF_Code naf ON e.naf_code = naf.naf_code
LEFT JOIN giscop84.Position pos ON e.idpar = pos.idpar
LEFT JOIN giscop84.Exposure exp ON pos.idpost = exp.idpost
LEFT JOIN giscop84.Carcinogen car ON exp.carcinogen_id = car.carcinogen_id

-- Jointure avec PESTIMAT
LEFT JOIN pestimat.NAF_Crop_Mapping ncm ON e.naf_code = ncm.naf_code
LEFT JOIN pestimat.Crop_Type ct ON ncm.crop_id = ct.crop_id
LEFT JOIN pestimat.Crop_Pesticide_Usage cpu ON ct.crop_id = cpu.crop_id
LEFT JOIN pestimat.Pesticide pest ON cpu.pesticide_id = pest.pesticide_id
LEFT JOIN pestimat.Authorization_Period ap ON pest.pesticide_id = ap.pesticide_id

ORDER BY e.ddebpar, pest.substance_name;

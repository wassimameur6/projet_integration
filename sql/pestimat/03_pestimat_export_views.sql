USE pestimat;

CREATE OR REPLACE VIEW vw_export_pestimat_format AS
SELECT
    p.substance_name AS 'Matière active',
    ct.crop_name AS 'Cultures',
    CONCAT(COALESCE(cpu.usage_start_year, ap.authorization_start_year), ' - ',
           COALESCE(cpu.usage_end_year, ap.authorization_end_year)) AS 'Période',
    (COALESCE(cpu.usage_end_year, ap.authorization_end_year) -
     COALESCE(cpu.usage_start_year, ap.authorization_start_year)) AS 'Durée d''exposition (en années)',
    ROUND(cpu.usage_prevalence, 2) AS 'Probabilité max (%)',
    '* * *' AS 'Fiabilité des probabilités',
    COALESCE(cpu.usage_peak_start_year, cpu.usage_peak_end_year) AS 'Pic d''utilisation',
    cpu.typical_intensity AS 'Intensité (kg/ha)',
    cpu.frequency_per_year AS 'Fréquence (j/an)',
    'Non' AS 'Traitement des semence possible'
FROM Pesticide p
INNER JOIN Crop_Pesticide_Usage cpu ON p.pesticide_id = cpu.pesticide_id
INNER JOIN Crop_Type ct ON cpu.crop_id = ct.crop_id
LEFT JOIN Authorization_Period ap ON p.pesticide_id = ap.pesticide_id
ORDER BY p.substance_name, ct.crop_name;

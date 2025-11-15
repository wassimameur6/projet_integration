USE giscop84;

CREATE OR REPLACE VIEW vw_export_expositions AS
SELECT
    exp.lblexp AS LBLEXP,
    exp.idexp AS IDEXP,
    DATE_FORMAT(exp.ddebexp, '%d/%m/%Y') AS DDEBEXP,
    DATE_FORMAT(exp.dfinexp, '%d/%m/%Y') AS DFINEXP,
    ROUND(exp.durexp, 1) AS DUREXP,
    exp.frequency_code AS FREQEXP,
    exp.intensity_code AS INTEXP,
    CASE WHEN exp.peak_exposure = 1 THEN 'oui' ELSE 'non' END AS PICEXP,
    exp.probability_code AS PROBEXP,
    e.naf_code AS 'parcours_pro::CNAFENT',
    e.num AS 'parcours_pro::NUM'
FROM Exposure exp
JOIN Position pos ON exp.idpost = pos.idpost
JOIN Employment e ON pos.idpar = e.idpar
ORDER BY exp.idexp;

CREATE OR REPLACE VIEW vw_export_complet AS
SELECT
    p.num AS NUM,
    p.sexe AS SEXE,
    TIMESTAMPDIFF(YEAR, p.date_naissance, CURDATE()) AS AGE,
    p.disease_code AS CODE_MALADIE,
    d.disease_name AS MALADIE,
    e.lblpar AS LBLPAR,
    e.naf_code AS NAF,
    naf.naf_label AS SECTEUR_NAF,
    e.company_name_custom AS ENTREPRISE,
    DATE_FORMAT(e.ddebpar, '%d/%m/%Y') AS DEBUT_EMPLOI,
    DATE_FORMAT(e.dfinpar, '%d/%m/%Y') AS FIN_EMPLOI,
    ROUND(e.durpar, 1) AS DUREE_EMPLOI_ANS,
    pos.intitule AS POSTE,
    pos.ville AS VILLE,
    exp.lblexp AS EXPOSITION,
    c_exp.carcinogen_label AS CANCEROGENE,
    c_exp.iarc_classification AS IARC,
    DATE_FORMAT(exp.ddebexp, '%d/%m/%Y') AS DEBUT_EXPOSITION,
    DATE_FORMAT(exp.dfinexp, '%d/%m/%Y') AS FIN_EXPOSITION,
    ROUND(exp.durexp, 1) AS DUREE_EXPOSITION_ANS,
    exp.frequency_code AS FREQUENCE,
    exp.intensity_code AS INTENSITE,
    CASE WHEN exp.peak_exposure = 1 THEN 'oui' ELSE 'non' END AS PIC_EXPOSITION,
    exp.probability_code AS PROBABILITE
FROM Patients p
LEFT JOIN Disease d ON p.disease_code = d.disease_code
LEFT JOIN Employment e ON p.num = e.num
LEFT JOIN NAF_Code naf ON e.naf_code = naf.naf_code
LEFT JOIN Position pos ON e.idpar = pos.idpar AND pos.pathway_type = 'employment'
LEFT JOIN Exposure exp ON pos.idpost = exp.idpost
LEFT JOIN Carcinogen c_exp ON exp.carcinogen_id = c_exp.carcinogen_id
ORDER BY p.num, e.sequence_num, pos.numpost, exp.idexp;

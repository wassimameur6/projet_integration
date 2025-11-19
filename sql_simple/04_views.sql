USE giscop_pestimat_simple;

DROP VIEW IF EXISTS v_croisement;

CREATE VIEW v_croisement AS
SELECT
    ge.patient_num,
    ge.ddebexp AS date_debut,
    ge.dfinexp AS date_fin,
    ncm.culture_pestimat AS culture,
    pm.matiere_active AS pesticide,
    pm.periode_debut,
    pm.periode_fin,
    pm.probabilite_max AS probabilite_pct,
    pm.intensite_kg_max,
    pm.frequence_j_max
FROM GISCOP84_Exposures ge
INNER JOIN NAF_Culture_Map ncm ON ge.naf_code = ncm.naf_code
INNER JOIN PESTIMAT_Matrix pm ON ncm.culture_pestimat = pm.culture
WHERE YEAR(ge.ddebexp) <= COALESCE(pm.periode_fin, 9999)
  AND YEAR(ge.dfinexp) >= pm.periode_debut;

SELECT 'View created' AS status, COUNT(*) AS total_matches FROM v_croisement;

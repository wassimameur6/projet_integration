# Base de Données GISCOP84

Projet universitaire - Intégration et qualité des données

## Description

Base de données relationnelle pour l'étude des cancers d'origine professionnelle (GISCOP 84).

Deux bases de données:
- **GISCOP84**: Patients, parcours professionnels, expositions
- **PESTIMAT**: Matrice pesticides-cultures

## Installation

### Créer les bases

```bash
# GISCOP84 database
mysql -u root < sql/giscop84/01_reference_tables.sql
mysql -u root < sql/giscop84/02_core_tables.sql
mysql -u root < sql/giscop84/06_export_views.sql

# PESTIMAT database
mysql -u root < sql/pestimat/01_pestimat_schema.sql
mysql -u root < sql/pestimat/03_pestimat_export_views.sql

# Croisement view (GISCOP84 x PESTIMAT)
mysql -u root < sql/07_requetes_croisement.sql
```

### Insérer les données

```bash
mysql -u root < data/01_giscop84_reference_data.sql
mysql -u root < data/02_pestimat_reference_data.sql
mysql -u root < data/05_pestimat_official_data.sql
mysql -u root < data/04_synthetic_patients.sql
```

## Requêtes

### Expositions (format export GISCOP)

```sql
SELECT * FROM vw_export_expositions WHERE `parcours_pro::NUM` = 'la150210';
```

### Croisement GISCOP x PESTIMAT

```sql
-- Voir tous les croisements pour un patient
SELECT * FROM giscop84.vw_croisement_giscop_pestimat WHERE Patient = 'la150210';

-- Voir uniquement les concordances (expositions confirmées par PESTIMAT)
SELECT * FROM giscop84.vw_croisement_giscop_pestimat
WHERE Patient = 'la150210' AND Statut = 'CONCORDANCE';

-- Voir les expositions supplémentaires suggérées par PESTIMAT
SELECT * FROM giscop84.vw_croisement_giscop_pestimat
WHERE Patient = 'la150210' AND Statut = 'EXPOSITION SUPPLÉMENTAIRE PESTIMAT';
```

## Structure

**GISCOP84** (11 tables + 3 vues)
- Tables: Patients, Employment, Position, Exposure, Disease, Carcinogen, NAF_Code, Exposure_Frequency, Exposure_Intensity, Exposure_Probability, Diagnosis
- Vues: vw_export_complet, vw_export_expositions, vw_croisement_giscop_pestimat

**PESTIMAT** (5 tables + 1 vue)
- Tables: Pesticide, Crop_Type, Crop_Pesticide_Usage, NAF_Crop_Mapping, Authorization_Period
- Vue: vw_export_pestimat_format

## Données

**GISCOP84:**
- 100 patients
- 221 emplois
- 326 postes
- 629 expositions
- 22 cancérigènes
- 18 codes NAF
- 3 maladies

**PESTIMAT:**
- 25 pesticides
- 7 types de cultures
- 22 usages pesticide-culture
- 6 mappings NAF-Culture

**Croisement:**
- 11,255 associations patient-emploi-exposition-pesticide

## Génération de données

```bash
pip install -r requirements.txt
python generate_synthetic_data.py
```

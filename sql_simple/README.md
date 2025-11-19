# GISCOP84 + PESTIMAT

Cross-reference system between GISCOP84 occupational exposures and PESTIMAT pesticide usage matrix.

## Quick Start

```bash
cd sql_simple
mysql -u root < 01_schema.sql
mysql -u root < 02_data_giscop84.sql
mysql -u root < 03_data_pestimat.sql
mysql -u root < 04_views.sql
mysql -u root < 05_donnees_synthetiques.sql  # optional
```

## Files

- `01_schema.sql` - Database schema (3 tables)
- `02_data_giscop84.sql` - 32 real exposures (from PDF)
- `03_data_pestimat.sql` - 684 pesticides across 10 crops
- `04_views.sql` - Cross-reference view
- `05_donnees_synthetiques.sql` - 65 synthetic exposures (testing)

## Usage

```sql
USE giscop_pestimat_simple;

-- View all matches
SELECT * FROM v_croisement LIMIT 10;

-- Specific patient
SELECT * FROM v_croisement WHERE patient_num = 'ln170403';

-- Stats by crop
SELECT culture, COUNT(*) as matches
FROM v_croisement
GROUP BY culture
ORDER BY matches DESC;
```

## Data Sources

**GISCOP84_Exposures**
- 32 real: viticulture workers (1957-2010)
- 65 synthetic: all crops (1950-2009)

**PESTIMAT_Matrix**
- 684 pesticides
- 10 crops: Vigne, Blé/Orge, Maïs, Arboriculture, Pomme de Terre, Betteraves, Colza, Tournesol, Tabac, Pois

**Results**
- 4,255 total matches (1,472 real + 2,783 synthetic)

## Scripts

Generate PESTIMAT data from CSV files:
```bash
python3 parse_pestimat_csv.py
```

Generate synthetic test data:
```bash
python3 generate_synthetic_giscop.py
```

## Project

UCBL 2025-2026 - Data Integration and Quality

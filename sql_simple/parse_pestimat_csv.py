#!/usr/bin/env python3
import csv
import re
from pathlib import Path


def parse_periode(periode_str):
    if not periode_str or periode_str.strip() == '':
        return None, None
    match = re.match(r'(\d{4})\s*-\s*(\d{4})', periode_str.strip())
    if match:
        return int(match.group(1)), int(match.group(2))
    return None, None


def parse_range(range_str):
    if not range_str or range_str.strip() == '':
        return None, None
    match = re.match(r'([\d.]+)\s*-\s*([\d.]+)', range_str.strip().replace(',', '.'))
    if match:
        return float(match.group(1)), float(match.group(2))
    return None, None


def clean_value(val):
    if val is None:
        return 'NULL'
    if isinstance(val, str):
        escaped = val.replace("'", "''").strip()
        return f"'{escaped}'"
    return str(val)


def parse_csv_file(csv_path):
    inserts = []
    current_pesticide = None

    with open(csv_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f, delimiter=';')
        reader.fieldnames = [name.strip() if name else name for name in reader.fieldnames]

        for row in reader:
            matiere = row.get('Matière active', '').strip()
            culture = row.get('Cultures', '').strip()

            if matiere and not matiere.startswith('1 culture'):
                current_pesticide = matiere

            if culture and culture not in ['', '1 culture(s)']:
                periode = row.get('Période', '').strip()
                debut, fin = parse_periode(periode)

                duree_str = row.get('Durée d\'exposition (en années)', '').strip()
                duree_str = row.get("Durée d'exposition (en années)", '').strip() if not duree_str else duree_str
                duree = int(duree_str) if duree_str else None

                proba = row.get('Probabilité max (%)', '').strip().replace(',', '.')
                proba = float(proba) if proba else None

                fiabilite = row.get('Fiabilité des probabilités', '').strip()

                pic = row.get('Pic d\'utilisation', '').strip()
                pic = pic if pic else row.get("Pic d'utilisation", '').strip()
                pic = int(pic) if pic else None

                intensite = row.get('Intensité (kg/ha)', '').strip()
                int_min, int_max = parse_range(intensite)

                frequence = row.get('Fréquence (j/an)', '').strip()
                freq_min, freq_max = parse_range(frequence)

                traitement = row.get('Traitement des semence possible', '').strip()

                values = (
                    clean_value(current_pesticide),
                    clean_value(culture),
                    debut if debut else 'NULL',
                    fin if fin else 'NULL',
                    duree if duree else 'NULL',
                    proba if proba else 'NULL',
                    clean_value(fiabilite),
                    pic if pic else 'NULL',
                    int_min if int_min else 'NULL',
                    int_max if int_max else 'NULL',
                    freq_min if freq_min else 'NULL',
                    freq_max if freq_max else 'NULL',
                    clean_value(traitement)
                )

                insert = f"({', '.join(map(str, values))})"
                inserts.append(insert)

    print(f"  {csv_path.name}: {len(inserts)} rows")
    return inserts


def main():
    base_path = Path(__file__).parent.parent.parent
    output_path = Path(__file__).parent / '03_data_pestimat.sql'

    csv_files = list(base_path.glob('Resultat*.csv'))

    if not csv_files:
        print(f"No CSV files found in {base_path}")
        return

    print(f"Found {len(csv_files)} CSV file(s)")

    all_inserts = []
    for csv_file in sorted(csv_files):
        inserts = parse_csv_file(csv_file)
        all_inserts.extend(inserts)

    print(f"\nTotal: {len(all_inserts)} rows generated")

    header = f"""USE giscop_pestimat_simple;

INSERT INTO PESTIMAT_Matrix
(matiere_active, culture, periode_debut, periode_fin, duree_annees,
 probabilite_max, fiabilite, pic_utilisation, intensite_kg_min, intensite_kg_max,
 frequence_j_min, frequence_j_max, traitement_semence)
VALUES
"""

    footer = """;

SELECT culture, COUNT(*) AS nb_pesticides
FROM PESTIMAT_Matrix
GROUP BY culture
ORDER BY nb_pesticides DESC;
"""

    sql_content = header + ',\n'.join(all_inserts) + footer
    output_path.write_text(sql_content, encoding='utf-8')

    print(f"\nGenerated: {output_path}")


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
import random
from datetime import datetime, timedelta
from pathlib import Path


NAF_CODES = {
    '01.11': 'Blé/Orge',
    '01.13': 'Pomme de Terre',
    '01.14': 'Betteraves',
    '01.15': 'Tabac',
    '01.16': 'Colza',
    '01.19': 'Maïs',
    '01.20': 'Pois',
    '01.21': 'Vigne',
    '01.24': 'Arboriculture',
    '01.25': 'Arboriculture',
    '01.26': 'Tournesol',
}

FREQUENCES = ['1_moins_20min', '2_20min_1h30', '3_1h30_4h', '4_4h_8h', '5_plus_8h']
INTENSITES = ['1_tres_faible', '2_faible', '3_moyenne', '4_forte', '5_tres_forte']
PROBABILITES = ['1_incertaine', '2_probable', '3_certaine']
MALADIES = ['ln', 'mm', 'la']


def generer_date(annee_min, annee_max):
    annee = random.randint(annee_min, annee_max)
    mois = random.randint(1, 12)
    jour = random.randint(1, 28)
    return datetime(annee, mois, jour)


def generer_patient_num(index, culture_code):
    maladie = random.choice(MALADIES)
    return f"syn_{maladie}{culture_code:02d}{index:04d}"


def calculer_duree_mois(date_debut, date_fin):
    return (date_fin.year - date_debut.year) * 12 + (date_fin.month - date_debut.month)


def generer_exposition(idexp, patient_num, naf_code, annee_min=1950, annee_max=2009):
    date_debut = generer_date(annee_min, annee_max - 5)
    duree_annees = random.randint(1, 30)
    date_fin = date_debut + timedelta(days=duree_annees * 365)

    if date_fin.year > annee_max:
        date_fin = datetime(annee_max, 12, 31)

    duree_mois = calculer_duree_mois(date_debut, date_fin)

    frequence = random.choices(FREQUENCES, weights=[5, 10, 20, 50, 15])[0]
    intensite = random.choices(INTENSITES, weights=[5, 15, 30, 35, 15])[0]
    probabilite = random.choices(PROBABILITES, weights=[10, 30, 60])[0]
    pic = random.choice(['oui', 'non'])
    culture_nom = NAF_CODES[naf_code]

    return {
        'idexp': idexp,
        'lblexp': 37,
        'lblexp_desc': f"Pesticides {culture_nom}",
        'ddebexp': date_debut.strftime('%Y-%m-%d'),
        'dfinexp': date_fin.strftime('%Y-%m-%d'),
        'durexp': duree_mois,
        'freqexp': frequence,
        'intexp': intensite,
        'picexp': pic,
        'probexp': probabilite,
        'naf_code': naf_code,
        'patient_num': patient_num
    }


def generer_patients_synthetiques(nb_patients_par_culture=3, id_start=5000):
    expositions = []
    idexp = id_start
    patient_index = 1

    print("Generating synthetic data...")

    for naf_code, culture_nom in NAF_CODES.items():
        culture_code = int(naf_code.replace('.', ''))

        print(f"  {culture_nom} (NAF {naf_code})")

        for i in range(nb_patients_par_culture):
            patient_num = generer_patient_num(patient_index, culture_code % 100)
            nb_expositions = random.randint(1, 3)

            print(f"    Patient {patient_num}: {nb_expositions} exposure(s)")

            for j in range(nb_expositions):
                expo = generer_exposition(idexp, patient_num, naf_code)
                expositions.append(expo)
                idexp += 1

            patient_index += 1

    print(f"\nTotal: {patient_index - 1} patients, {len(expositions)} exposures")
    return expositions


def generer_sql_insert(expositions):
    sql = """USE giscop_pestimat_simple;

DELETE FROM GISCOP84_Exposures WHERE patient_num LIKE 'syn_%';

INSERT INTO GISCOP84_Exposures
(idexp, lblexp, lblexp_desc, ddebexp, dfinexp, durexp, freqexp, intexp, picexp, probexp, naf_code, patient_num)
VALUES
"""

    values = []
    for expo in expositions:
        value = f"({expo['idexp']}, {expo['lblexp']}, '{expo['lblexp_desc']}', '{expo['ddebexp']}', '{expo['dfinexp']}', {expo['durexp']}, '{expo['freqexp']}', '{expo['intexp']}', '{expo['picexp']}', '{expo['probexp']}', '{expo['naf_code']}', '{expo['patient_num']}')"
        values.append(value)

    sql += ',\n'.join(values) + ';\n\n'

    sql += """SELECT 'Synthetic data loaded' AS status,
       COUNT(*) AS nb_exposures,
       COUNT(DISTINCT patient_num) AS nb_patients
FROM GISCOP84_Exposures
WHERE patient_num LIKE 'syn_%';
"""

    return sql


def main():
    expositions = generer_patients_synthetiques(nb_patients_par_culture=3, id_start=5000)
    sql_content = generer_sql_insert(expositions)

    output_path = Path(__file__).parent / '05_donnees_synthetiques.sql'
    output_path.write_text(sql_content, encoding='utf-8')

    print(f"\nGenerated: {output_path}")


if __name__ == '__main__':
    main()

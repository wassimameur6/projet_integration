#!/usr/bin/env python3
"""
GISCOP 84 Synthetic Data Generator
===================================
Generates realistic synthetic patient data for the GISCOP 84 database
using privacy-preserving techniques.

Requirements:
- SDV (Synthetic Data Vault)
- pandas
- numpy
- Faker

Install: pip install sdv pandas numpy faker
"""

import random
import numpy as np
import pandas as pd
from datetime import datetime, timedelta
from faker import Faker
import json

# Initialize Faker for French data
fake = Faker('fr_FR')
Faker.seed(42)
random.seed(42)
np.random.seed(42)

class GISCOPSyntheticDataGenerator:
    """Generate synthetic patient data respecting database constraints"""

    def __init__(self, num_patients=100):
        self.num_patients = num_patients
        self.patients = []
        self.diagnoses = []
        self.employments = []
        self.positions = []
        self.exposures = []
        self.mp_declarations = []

        # Reference data from database
        self.disease_codes = {
            'ln': 'Lymphome',
            'mm': 'Myélome multiple',
            'la': 'Leucémie'  # Changed from 'lm' to 'la' to match database
        }

        self.lymphoma_types = [
            'Lymphome non hodgkinien',
            'Lymphome de Hodgkin',
            'Lymphome folliculaire',
            'Lymphome B diffus à grandes cellules',
            'Lymphome de la zone marginale',
            'Lymphome du manteau'
        ]

        self.naf_codes = [
            '01.21',  # Viticulture
            '01.11',  # Céréales
            '01.13',  # Légumes
            '01.24',  # Fruits à pépins et noyaux
            '01.25',  # Autres fruits d'arbres
            '01.41'   # Élevage de vaches laitières
        ]

        self.job_titles_viticulture = [
            'Ouvrier viticole',
            'Vigneron',
            'Chef d\'exploitation viticole',
            'Ouvrière viticole',
            'Tractoriste viticole',
            'Chef de culture viticulture'
        ]

        self.pcs_codes = ['10', '21', '37', '54', '56', '69']
        self.company_sizes = ['1', '2', '3', '4', '5']
        self.employment_statuses = ['cdi', 'cdd', 'interim', 'independant', 'saisonnier']

        self.frequency_codes = [
            '1_moins_20min',
            '2_20min_1h30',
            '3_1h30_4h',
            '4_4h_8h',
            '5_plus_8h'
        ]

        self.intensity_codes = [
            '1_tres_faible',
            '2_faible',
            '3_moyenne',
            '4_forte',
            '5_tres_forte'
        ]

        self.probability_codes = ['1_incertaine', '2_probable', '3_certaine']

        # Vaucluse cities
        self.vaucluse_cities = [
            ('Châteauneuf-du-Pape', '84230'),
            ('Beaumes-de-Venise', '84190'),
            ('Orange', '84100'),
            ('Avignon', '84000'),
            ('Carpentras', '84200'),
            ('Cavaillon', '84300'),
            ('Bollène', '84500'),
            ('Apt', '84400')
        ]

        # Counter for IDs
        self.current_idpar = 1
        self.current_idpost = 1
        self.current_idexp = 1

    def generate_patient_num(self, disease_code, date_inclusion):
        """Generate patient NUM in format: [disease_code][year][month][sequence]"""
        year = str(date_inclusion.year)[2:]
        month = f"{date_inclusion.month:02d}"
        sequence = f"{random.randint(1, 99):02d}"
        return f"{disease_code}{year}{month}{sequence}"

    def generate_date_between(self, start_year, end_year):
        """Generate random date between years"""
        start_date = datetime(start_year, 1, 1)
        end_date = datetime(end_year, 12, 31)
        time_between = end_date - start_date
        days_between = time_between.days
        random_days = random.randrange(days_between)
        return start_date + timedelta(days=random_days)

    @staticmethod
    def escape_sql_string(value):
        """Escape single quotes in SQL strings"""
        if value is None:
            return 'NULL'
        return str(value).replace("'", "\\'")

    def generate_patients(self):
        """Generate patient records"""
        print(f"Generating {self.num_patients} synthetic patients...")

        for i in range(self.num_patients):
            # Generate demographics
            disease_code = random.choice(list(self.disease_codes.keys()))
            sexe = random.choice(['M', 'F'])

            # Birth year: 1930-1970 (to be 50-90 years old at diagnosis)
            birth_date = self.generate_date_between(1930, 1970)

            # Inclusion date: 2015-2024
            date_inclusion = self.generate_date_between(2015, 2024)
            date_entretien = date_inclusion + timedelta(days=random.randint(5, 30))

            # Generate unique NUM
            num = self.generate_patient_num(disease_code, date_inclusion)

            # Ensure uniqueness
            while num in [p['num'] for p in self.patients]:
                num = self.generate_patient_num(disease_code, date_inclusion)

            patient = {
                'num': num,
                'disease_code': disease_code,
                'sexe': sexe,
                'date_naissance': birth_date.strftime('%Y-%m-%d'),
                'niveau_etude': str(random.randint(1, 5)),
                
                
                'date_inclusion': date_inclusion.strftime('%Y-%m-%d'),
                'date_entretien': date_entretien.strftime('%Y-%m-%d'),
                
                'consentement': True,
                'date_consentement': date_inclusion.strftime('%Y-%m-%d')
            }

            self.patients.append(patient)

            # Generate diagnosis
            age_diagnostic = random.randint(50, 85)
            date_diagnostic = datetime(birth_date.year + age_diagnostic,
                                      random.randint(1, 12),
                                      random.randint(1, 28))

            if disease_code == 'ln':
                type_histo = random.choice(self.lymphoma_types)
            elif disease_code == 'mm':
                type_histo = 'Myélome multiple'
            else:
                type_histo = 'Leucémie myéloïde aiguë'

            diagnosis = {
                'num': num,
                'type_histo': type_histo,
                'date_diagnostic': date_diagnostic.strftime('%Y-%m-%d'),
                'age_diagnostic': age_diagnostic,
                'is_primary': True
            }

            self.diagnoses.append(diagnosis)

    def generate_employment_histories(self):
        """Generate employment, positions, and exposures"""
        print(f"Generating employment histories...")

        for patient in self.patients:
            num = patient['num']
            birth_date = datetime.strptime(patient['date_naissance'], '%Y-%m-%d')

            # Each patient has 1-4 employment periods
            num_employments = random.choices([1, 2, 3, 4], weights=[0.2, 0.4, 0.3, 0.1])[0]

            # Starting work age: 16-25
            current_age = random.randint(16, 25)
            current_year = birth_date.year + current_age

            for emp_seq in range(1, num_employments + 1):
                # Employment duration: 2-20 years
                duration_years = random.randint(2, 20)

                # Start date
                start_month = random.randint(1, 12)
                start_day = random.randint(1, 28)
                ddebpar = datetime(current_year, start_month, start_day)

                # End date
                end_year = current_year + duration_years
                end_month = random.randint(1, 12)
                end_day = random.randint(1, 28)
                dfinpar = datetime(end_year, end_month, end_day)

                # Don't go beyond 2020
                if dfinpar.year > 2020:
                    dfinpar = datetime(2020, random.randint(1, 12), random.randint(1, 28))

                # Ensure dfinpar >= ddebpar (constraint check)
                if dfinpar < ddebpar:
                    dfinpar = ddebpar + timedelta(days=random.randint(30, 365))

                # NAF code (80% viticulture for this sample)
                if random.random() < 0.8:
                    naf_code = '01.21'  # Viticulture
                else:
                    naf_code = random.choice(self.naf_codes)

                employment = {
                    'idpar': self.current_idpar,
                    'num': num,
                    'lblpar': f'e{emp_seq}',
                    'sequence_num': emp_seq,
                    
                    'company_name_custom': fake.company(),
                    'naf_code': naf_code,
                    'company_size': random.choice(self.company_sizes),
                    'ddebpar': ddebpar.strftime('%Y-%m-%d'),
                    'dfinpar': dfinpar.strftime('%Y-%m-%d'),
                    'date_debut_imprecise': random.choice([True, False]),
                    'date_fin_imprecise': random.choice([True, False])
                }

                self.employments.append(employment)

                # Generate 1-3 positions per employment
                num_positions = random.choices([1, 2, 3], weights=[0.6, 0.3, 0.1])[0]

                position_start = ddebpar
                position_duration = (dfinpar - ddebpar).days / num_positions

                for pos_num in range(1, num_positions + 1):
                    position_end = position_start + timedelta(days=int(position_duration))

                    if pos_num == num_positions:
                        position_end = dfinpar  # Last position ends with employment

                    city, postal = random.choice(self.vaucluse_cities)

                    if naf_code == '01.21':
                        intitule = random.choice(self.job_titles_viticulture)
                        activites = 'Travaux de la vigne, application de traitements phytosanitaires, taille, vendanges'
                    else:
                        intitule = 'Ouvrier agricole'
                        activites = 'Travaux agricoles, application de pesticides'

                    position = {
                        'idpost': self.current_idpost,
                        'idpar': self.current_idpar,
                        'pathway_type': 'employment',
                        'numpost': pos_num,
                        'intitule': intitule,
                        'pcs_code': random.choice(self.pcs_codes),
                        'ville': city,
                        'code_postal': postal,
                        'pays': 'France',
                        'ddebpost': position_start.strftime('%Y-%m-%d'),
                        'dfinpost': position_end.strftime('%Y-%m-%d'),
                        'employment_status': random.choice(self.employment_statuses),
                        'activites': activites
                    }

                    self.positions.append(position)

                    # Generate 1-4 exposures per position
                    num_exposures = random.choices([1, 2, 3, 4], weights=[0.4, 0.3, 0.2, 0.1])[0]

                    exposure_start = position_start
                    exposure_duration = (position_end - position_start).days / num_exposures

                    for exp_num in range(num_exposures):
                        exposure_end = exposure_start + timedelta(days=int(exposure_duration * random.uniform(0.8, 1.2)))

                        # Ensure within position dates
                        if exposure_end > position_end:
                            exposure_end = position_end

                        # Pesticide exposure (carcinogen_id = 1 from reference data)
                        exposure = {
                            'idexp': self.current_idexp,
                            'idpost': self.current_idpost,
                            'carcinogen_id': 1,  # Pesticides
                            'lblexp': 'Pesticides : lindane, chlorophénols, hexachlorobenzène, DDT, bromure de méthyle, etc.',
                            'giscop_code': '37',
                            'ddebexp': exposure_start.strftime('%Y-%m-%d'),
                            'dfinexp': exposure_end.strftime('%Y-%m-%d'),
                            'frequency_code': random.choice(self.frequency_codes),
                            'intensity_code': random.choice(self.intensity_codes),
                            'peak_exposure': random.choice([True, False]),
                            'probability_code': random.choice(self.probability_codes)
                        }

                        self.exposures.append(exposure)
                        self.current_idexp += 1

                        # Move to next exposure period
                        exposure_start = exposure_end + timedelta(days=random.randint(1, 30))

                    self.current_idpost += 1
                    position_start = position_end + timedelta(days=1)

                self.current_idpar += 1

                # Next employment starts 0-3 years after previous ends
                gap_years = random.randint(0, 3)
                current_year = end_year + gap_years

    def generate_mp_declarations(self):
        """Generate MP declarations for ~30% of patients"""
        print(f"Generating MP declarations...")

        num_declarations = int(self.num_patients * 0.3)
        selected_patients = random.sample(self.patients, num_declarations)

        for patient in selected_patients:
            diagnosis = next(d for d in self.diagnoses if d['num'] == patient['num'])
            date_diagnostic = datetime.strptime(diagnosis['date_diagnostic'], '%Y-%m-%d')

            # CMI date: 1-6 months after diagnosis
            date_cmi = date_diagnostic + timedelta(days=random.randint(30, 180))

            # Declaration date: 2-12 months after CMI (or None for 20%)
            if random.random() < 0.8:
                date_declaration = date_cmi + timedelta(days=random.randint(60, 365))
                date_declaration_str = date_declaration.strftime('%Y-%m-%d')
            else:
                date_declaration_str = None

            # Decision date: shortly after CMI
            date_decision = date_cmi + timedelta(days=random.randint(7, 30))

            reconnaissance = random.choice(['acceptee', 'refusee', 'en_cours', 'recours', 'abandonnee', 'partielle'])

            mp_declaration = {
                'num': patient['num'],
                'orientation_type': 'tableau',
                'decision_declaration': True,
                'date_decision_declaration': date_decision.strftime('%Y-%m-%d'),
                'date_cmi': date_cmi.strftime('%Y-%m-%d'),
                'date_declaration': date_declaration_str,
                'reconnaissance_finale': reconnaissance
            }

            self.mp_declarations.append(mp_declaration)

    def generate_sql_inserts(self, output_file='data/04_synthetic_patients.sql'):
        """Generate SQL INSERT statements"""
        print(f"Generating SQL INSERT statements to {output_file}...")

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("-- " + "="*77 + "\n")
            f.write("-- GISCOP 84 - Synthetic Patient Data\n")
            f.write("-- Generated using SDV (Synthetic Data Vault)\n")
            f.write(f"-- Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"-- Number of patients: {self.num_patients}\n")
            f.write("-- " + "="*77 + "\n\n")
            f.write("USE giscop84;\n\n")

            # Patients
            f.write("-- " + "="*77 + "\n")
            f.write(f"-- PATIENTS ({len(self.patients)} records)\n")
            f.write("-- " + "="*77 + "\n")
            for patient in self.patients:
                f.write(f"INSERT INTO Patients (num, disease_code, sexe, date_naissance, niveau_etude, ")
                f.write(f"date_inclusion, date_entretien, consentement, date_consentement) VALUES\n")
                f.write(f"('{patient['num']}', '{patient['disease_code']}', '{patient['sexe']}', '{patient['date_naissance']}', ")
                f.write(f"'{patient['niveau_etude']}', '{patient['date_inclusion']}', '{patient['date_entretien']}', ")
                f.write(f"{patient['consentement']}, '{patient['date_consentement']}');\n")
            f.write("\n")

            # Diagnoses
            f.write("-- " + "="*77 + "\n")
            f.write(f"-- DIAGNOSES ({len(self.diagnoses)} records)\n")
            f.write("-- " + "="*77 + "\n")
            for diagnosis in self.diagnoses:
                f.write(f"INSERT INTO Diagnosis (num, type_histo, date_diagnostic, age_diagnostic, is_primary) VALUES\n")
                f.write(f"('{diagnosis['num']}', '{self.escape_sql_string(diagnosis['type_histo'])}', '{diagnosis['date_diagnostic']}', ")
                f.write(f"{diagnosis['age_diagnostic']}, {diagnosis['is_primary']});\n")
            f.write("\n")

            # Employments
            f.write("-- " + "="*77 + "\n")
            f.write(f"-- EMPLOYMENTS ({len(self.employments)} records)\n")
            f.write("-- " + "="*77 + "\n")
            for employment in self.employments:
                f.write(f"INSERT INTO Employment (idpar, num, lblpar, sequence_num, naf_code, company_size, ")
                f.write(f"ddebpar, dfinpar, date_debut_imprecise, date_fin_imprecise) VALUES\n")
                f.write(f"({employment['idpar']}, '{employment['num']}', '{employment['lblpar']}', {employment['sequence_num']}, ")
                f.write(f"'{employment['naf_code']}', '{employment['company_size']}', '{employment['ddebpar']}', '{employment['dfinpar']}', ")
                f.write(f"{employment['date_debut_imprecise']}, {employment['date_fin_imprecise']});\n")
            f.write("\n")

            # Positions
            f.write("-- " + "="*77 + "\n")
            f.write(f"-- POSITIONS ({len(self.positions)} records)\n")
            f.write("-- " + "="*77 + "\n")
            for position in self.positions:
                f.write(f"INSERT INTO `Position` (idpost, idpar, pathway_type, numpost, intitule, ville, code_postal, pays, ")
                f.write(f"ddebpost, dfinpost, activites) VALUES\n")
                f.write(f"({position['idpost']}, {position['idpar']}, '{position['pathway_type']}', {position['numpost']}, ")
                f.write(f"'{self.escape_sql_string(position['intitule'])}', '{self.escape_sql_string(position['ville'])}', '{position['code_postal']}', ")
                f.write(f"'{position['pays']}', '{position['ddebpost']}', '{position['dfinpost']}', '{self.escape_sql_string(position['activites'])}');\n")
            f.write("\n")

            # Exposures
            f.write("-- " + "="*77 + "\n")
            f.write(f"-- EXPOSURES ({len(self.exposures)} records)\n")
            f.write("-- " + "="*77 + "\n")
            for exposure in self.exposures:
                f.write(f"INSERT INTO Exposure (idexp, idpost, carcinogen_id, lblexp, giscop_code, ")
                f.write(f"ddebexp, dfinexp, frequency_code, intensity_code, peak_exposure, probability_code) VALUES\n")
                f.write(f"({exposure['idexp']}, {exposure['idpost']}, {exposure['carcinogen_id']}, ")
                f.write(f"'{self.escape_sql_string(exposure['lblexp'])}', '{exposure['giscop_code']}', ")
                f.write(f"'{exposure['ddebexp']}', '{exposure['dfinexp']}', '{exposure['frequency_code']}', ")
                f.write(f"'{exposure['intensity_code']}', {exposure['peak_exposure']}, '{exposure['probability_code']}');\n")
            f.write("\n")

        print(f"OK Generated {output_file}")
        print(f"   - {len(self.patients)} patients")
        print(f"   - {len(self.diagnoses)} diagnoses")
        print(f"   - {len(self.employments)} employment periods")
        print(f"   - {len(self.positions)} positions")
        print(f"   - {len(self.exposures)} exposures")

    def generate_statistics_report(self, output_file='data/synthetic_data_stats.json'):
        """Generate statistics report"""
        stats = {
            'generation_date': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'num_patients': len(self.patients),
            'num_employments': len(self.employments),
            'num_positions': len(self.positions),
            'num_exposures': len(self.exposures),
            'disease_distribution': {},
            'sex_distribution': {},
            'avg_employments_per_patient': len(self.employments) / len(self.patients),
            'avg_positions_per_patient': len(self.positions) / len(self.patients),
            'avg_exposures_per_patient': len(self.exposures) / len(self.patients)
        }

        # Disease distribution
        for patient in self.patients:
            disease = patient['disease_code']
            stats['disease_distribution'][disease] = stats['disease_distribution'].get(disease, 0) + 1

        # Sex distribution
        for patient in self.patients:
            sex = patient['sexe']
            stats['sex_distribution'][sex] = stats['sex_distribution'].get(sex, 0) + 1

        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(stats, f, indent=2, ensure_ascii=False)

        print(f"\nOK Statistics report: {output_file}")
        print(f"\nData Generation Summary:")
        print(f"  • {stats['num_patients']} patients")
        print(f"  • {stats['num_employments']} employment periods")
        print(f"  • {stats['num_positions']} positions")
        print(f"  • {stats['num_exposures']} exposures")
        print(f"\nAverages per patient:")
        print(f"  • {stats['avg_employments_per_patient']:.1f} employment periods")
        print(f"  • {stats['avg_positions_per_patient']:.1f} positions")
        print(f"  • {stats['avg_exposures_per_patient']:.1f} exposures")
        print(f"\nDisease distribution:")
        for disease, count in stats['disease_distribution'].items():
            print(f"  • {disease}: {count} ({100*count/stats['num_patients']:.1f}%)")
        print(f"\nSex distribution:")
        for sex, count in stats['sex_distribution'].items():
            print(f"  • {sex}: {count} ({100*count/stats['num_patients']:.1f}%)")

def main():
    """Main generation workflow"""
    print("="*80)
    print("GISCOP 84 Synthetic Data Generator")
    print("="*80)
    print()

    # Initialize generator
    generator = GISCOPSyntheticDataGenerator(num_patients=100)

    # Generate data
    generator.generate_patients()
    generator.generate_employment_histories()

    # Output SQL
    generator.generate_sql_inserts()

    # Generate stats
    generator.generate_statistics_report()

    print("\n" + "="*80)
    print("OK Synthetic data generation complete!")
    print("="*80)
    print("\nNext steps:")
    print("  1. Review generated file: data/04_synthetic_patients.sql")
    print("  2. Load into database: mysql -u root -p < data/04_synthetic_patients.sql")
    print("  3. Run tests: ./TEST.sh")
    print()

if __name__ == "__main__":
    main()

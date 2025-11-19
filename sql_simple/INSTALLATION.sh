#!/bin/bash
# ============================================
# Script d'installation automatique
# Projet GISCOP84 + PESTIMAT (version simplifiée)
# ============================================

set -e  # Arrêter si erreur

echo "🚀 Installation du projet GISCOP84 + PESTIMAT"
echo "=============================================="
echo ""

# Configuration
DB_NAME="giscop_pestimat_simple"
MYSQL_USER="root"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonctions
function check_mysql() {
    echo -n "🔍 Vérification MySQL... "
    if ! command -v mysql &> /dev/null; then
        echo -e "${RED}✗ MySQL non trouvé${NC}"
        echo "   Installer MySQL : https://dev.mysql.com/downloads/"
        exit 1
    fi
    echo -e "${GREEN}✓${NC}"
}

function check_python() {
    echo -n "🔍 Vérification Python3... "
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}✗ Python3 non trouvé${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ $(python3 --version)${NC}"
}

function check_csv() {
    echo -n "🔍 Vérification fichiers CSV... "
    CSV_COUNT=$(find ../../ -maxdepth 1 -name "Resultat*.csv" | wc -l)
    if [ "$CSV_COUNT" -eq 0 ]; then
        echo -e "${YELLOW}⚠ Aucun fichier CSV trouvé${NC}"
        echo "   Ajouter des fichiers Resultat*.csv dans /Users/jihane/Downloads/Matériel/"
        read -p "   Continuer sans données PESTIMAT ? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}✓ $CSV_COUNT fichier(s) CSV trouvé(s)${NC}"
    fi
}

# Étape 1 : Vérifications
echo "📋 Étape 1/5 : Vérifications préalables"
check_mysql
check_python
check_csv
echo ""

# Étape 2 : Création du schéma
echo "🗄️  Étape 2/5 : Création du schéma"
echo -n "   Création de la base $DB_NAME... "
mysql -u $MYSQL_USER -p < 01_schema_simple.sql
echo -e "${GREEN}✓${NC}"
echo ""

# Étape 3 : Chargement GISCOP84
echo "📊 Étape 3/5 : Chargement données GISCOP84"
echo -n "   Insertion de 32 expositions... "
mysql -u $MYSQL_USER -p $DB_NAME < 02_data_giscop84.sql
echo -e "${GREEN}✓${NC}"
echo ""

# Étape 4 : Génération PESTIMAT
echo "🌾 Étape 4/5 : Génération données PESTIMAT"
if [ "$CSV_COUNT" -gt 0 ]; then
    echo "   Parsing des fichiers CSV..."
    python3 parse_pestimat_csv.py
    echo ""
    echo -n "   Chargement dans MySQL... "
    mysql -u $MYSQL_USER -p $DB_NAME < 03_data_pestimat.sql
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}   ⊘ Ignoré (pas de CSV)${NC}"
fi
echo ""

# Étape 5 : Test des requêtes
echo "🔍 Étape 5/5 : Test des requêtes de croisement"
echo "   Chargement des requêtes..."
mysql -u $MYSQL_USER -p $DB_NAME < 04_requetes_croisement.sql 2>/dev/null
echo ""

# Résumé
echo "=============================================="
echo -e "${GREEN}✅ Installation terminée !${NC}"
echo ""
echo "📊 Statistiques :"
mysql -u $MYSQL_USER -p -e "
USE $DB_NAME;
SELECT 'GISCOP84 Exposures' AS Table_Name, COUNT(*) AS Rows FROM GISCOP84_Exposures
UNION ALL
SELECT 'PESTIMAT Matrix', COUNT(*) FROM PESTIMAT_Matrix
UNION ALL
SELECT 'NAF Culture Map', COUNT(*) FROM NAF_Culture_Map;
"

echo ""
echo "🚀 Prochaines étapes :"
echo ""
echo "   1. Tester une requête :"
echo "      mysql -u $MYSQL_USER -p $DB_NAME"
echo "      > SELECT * FROM v_exposition_detail WHERE idexp = 115;"
echo ""
echo "   2. Voir le README :"
echo "      cat README.md"
echo ""
echo "   3. Parcours d'un patient :"
echo "      > SELECT * FROM v_exposition_detail"
echo "      > WHERE patient_num = 'ln170403'"
echo "      > ORDER BY prob_utilisation_pct DESC;"
echo ""

#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/obiwor/boilerplates.git"
TEMPLATES_DIR="templates"

# helper function
show_help() {
    echo -e "${BLUE}Usage:${NC} ./create.sh [template] [project-name]"
    echo -e "\n${BLUE}Templates disponibles:${NC}"
    echo "- c          : Python FastAPI template"
    echo -e "\n${BLUE}Exemple:${NC}"
    echo "./create.sh c my-project"
}

TEMPLATE=$1
PROJECT_NAME=$2

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [ -z "$TEMPLATE" ] || [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Erreur: Template et nom du projet requis${NC}"
    show_help
    exit 1
fi

TMP_DIR=$(mktemp -d)
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo -e "${BLUE}Récupération du template '$TEMPLATE'...${NC}"

# Repo initialization with sparse-checkout
git -C "$TMP_DIR" init -q
git -C "$TMP_DIR" remote add origin "$REPO_URL"
git -C "$TMP_DIR" config core.sparseCheckout true
echo "$TEMPLATES_DIR/$TEMPLATE/*" > "$TMP_DIR/.git/info/sparse-checkout"

if ! git -C "$TMP_DIR" pull --depth=1 origin main -q; then
    echo -e "${RED}Error: Template '$TEMPLATE' not found or network failure${NC}"
    exit 1
fi

if [ ! -d "$TMP_DIR/$TEMPLATES_DIR/$TEMPLATE" ]; then
    echo -e "${RED}Error: Template '$TEMPLATE' not found${NC}"
    exit 1
fi


echo -e "${BLUE}Project's creation'$PROJECT_NAME'...${NC}"
cp -r "$TMP_DIR/$TEMPLATES_DIR/$TEMPLATE" "$PROJECT_NAME"


echo -e "${BLUE}Configuration...${NC}"
find "$PROJECT_NAME" -type f -exec sed -i "s/{{project_name}}/$PROJECT_NAME/g" {} \; 2>/dev/null || true


if [ -d "$PROJECT_NAME/.git" ]; then
    rm -rf "$PROJECT_NAME/.git"
fi
git -C "$PROJECT_NAME" init -q

echo -e "${GREEN}✨ Project create with success in ./$PROJECT_NAME${NC}"


if [ -f "$PROJECT_NAME/README.md" ]; then
    echo -e "\n${BLUE} Instructions:${NC}"
    cat "$PROJECT_NAME/README.md"
fi

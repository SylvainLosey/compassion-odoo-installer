#!/bin/bash

# Config
ODOO_VERSION="12.0"
PYTHON_VERSION="3.7.7"
read -p "Enter the path where you want Odoo installed [Click enter for default: /home/${USER}/compassion]: " INSTALL_PATH
INSTALL_PATH=${INSTALL_PATH:-"/home/${USER}/compassion"}

# Vars
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


#-- DEPENDENCIES --#

if ! [ -x "$(command -v pyenv)" ]; then
    echo -e "${RED}Please install Pyenv, make sure it works and relaunch this script${NC}"
    echo -e "Installation link: https://github.com/pyenv/pyenv-installer"
    exit 1
fi

if ! [ -x "$(command -v poetry)" ]; then
    echo -e "${RED}Please install Poetry, make sure it works and relaunch this script${NC}"
    echo -e "Installation link: https://github.com/python-poetry/poetry"
    exit 1
fi

echo -e "${GREEN}Installing linux dependencies ...${NC}"
mkdir -p "${INSTALL_PATH}/${ODOO_VERSION}" && cd "${INSTALL_PATH}/${ODOO_VERSION}"

# Postgres12 APT repository
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list

sudo apt update
sudo apt install -y myrepos postgresql-12 postgresql-client-12 postgis postgresql-12-postgis-3 libcups2-dev python-dev libxml2 \
libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev expect python-lxml python-simplejson \
python3-serial python-yaml python3-cups python3-mysqldb zbar-tools node-less

# Create postgres user
sudo su - postgres -c "createuser -s $USER"


#-- ENVIRONMENT --#

echo -e  "${GREEN}Setup python version ...${NC}"
pyenv install $PYTHON_VERSION
pyenv local $PYTHON_VERSION

echo -e  "${GREEN}Setup virtual environment ...${NC}"
cp "${SCRIPTPATH}/pyproject.toml" ./pyproject.toml
cp "${SCRIPTPATH}/poetry.lock" ./poetry.lock
poetry install


#-- ODOO --#

echo -e  "${GREEN}Setup Odoo ...${NC}"
git clone https://github.com/odoo/odoo.git -b $ODOO_VERSION
cd "odoo"

echo -e  "${GREEN}Setup Compassion and OCA addons${NC}"
mkdir "compassion" && cd "compassion"
cp "${SCRIPTPATH}/.mrconfig" ./.mrconfig
echo "${PWD}/.mrconfig" >> ~/.mrtrust
mr update

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
NC='\033[0m'


#-- DEPENDENCIES --#

echo -e "${GREEN}Installing linux dependencies ...${NC}"
sudo apt update
sudo apt install myrepos postgresql-10 postgresql-10-postgis-2.4 libcups2-dev python-dev libxml2 \
libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev expect python-lxml python-simplejson \
python-serial python-yaml python-cups python-mysqldb zbar-tools node-less

# Create postgres user
sudo su - postgres -c "createuser -s $USER"

# Install poetry and pipenv if they aren't
if ! [ -x "$(command -v pyenv)" ]; then
    echo -e  "${GREEN}Installing pyenv ...${NC}"
    echo -e  "${GREEN}The script will stop and you will have to update you shell's PATH${NC}"

    sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
    curl https://pyenv.run | bash
    exec $SHELL
fi

if ! [ -x "$(command -v poetry)" ]; then
    echo -e  "${GREEN}Installing poetry ...${NC}"
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
    export PATH="$HOME/.poetry/bin:$PATH"
    source $HOME/.poetry/env
fi


#-- ENVIRONMENT --#

echo -e  "${GREEN}Setup python version ...${NC}"
mkdir "${INSTALL_PATH}/${ODOO_VERSION}" && cd "${INSTALL_PATH}/${ODOO_VERSION}"
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
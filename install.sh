#!/bin/bash

# Config
ODOO_VERSION="12.0"
PYTHON_VERSION="3.7.7"
read -p "Enter path where you want Odoo installed [Default: /home/sylvain/compassion]: " INSTALL_PATH
INSTALL_PATH=${INSTALL_PATH:-"/home/sylvain/compassion"}
echo $INSTALL_PATH

# Vars
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# Install linux dependencies
# No need to check if they are already installed, if they are install is skipped
sudo apt update
# Multi repo management
sudo apt install mr
# Odoo dependencies
sudo apt install libcups2-dev
# Postgres and PostGIS
sudo apt install postgresql-10
sudo apt install postgresql-10-postgis-2.4

# Install poetry and pipenv
read -r -p "Is pyenv already installed ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then :; else
    echo "Installing pyenv ..."
    sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
    curl https://pyenv.run | bash
    exec $SHELL
fi

read -r -p "Is poetry already installed ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then :; else
    echo "Installing poetry ..."
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
    export PATH="$HOME/.poetry/bin:$PATH"
    exec $SHELL
fi


# Setup python version and virtual env
mkdir "${INSTALL_PATH}/${ODOO_VERSION}"
cd "${INSTALL_PATH}/${ODOO_VERSION}"
pyenv install $PYTHON_VERSION
pyenv local $PYTHON_VERSION
cp "${SCRIPTPATH}/pyprojet.toml" ./pyproject.toml
cp "${SCRIPTPATH}/poetry.lock" ./poetry.lock
poetry install

# Setup Odoo
#git clone https://github.com/odoo/odoo.git -b $ODOO_VERSION
#cd "odoo"

# Setup Compassion and OCA addons
#mkdir "compassion"
#cd "compassion"
#cp "${SCRIPTPATH}/.mrconfig" ./.mrconfig
#echo "${PWD}/.mrconfig" >> ~/.mrtrust
#mr update


# If you need to convert requirements.txt to pyproject.toml: (takes forever)
# for item in $(cat requirements.txt); do   poetry add "${item}"; done 

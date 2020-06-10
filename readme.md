# Compassion Odoo Installer

## How to

1. Clone this repo somewhere
2. From the cloned repo:

```
chmod 755 ./install.sh
./install.sh
```

3. Create odoo.conf in the /odoo directory (ask someone for the configs)

## Usage

### Terminal

Once succesfully installed, from where you chose to install:

```
poetry shell
./odoo/odoo-bin
```

### Pycharm

- Open the folder where Odoo was installed as new project
- Install the poetry pycharm plugin: https://plugins.jetbrains.com/plugin/14307-poetry (official support is being implemented)
- Restart and go in File > Settings > Project > Python Interpreter > Wheel Icon > Add > Poetry Environment
- Select "Existing environment", should have /pypoetry/virtualenv in the path, apply.
- At the top right click on "Add configuration", then plus icon, with: (update with your paths)

```
Script path: /home/sylvain/compassion/12.0/odoo/odoo-bin
Parameters: -c /home/sylvain/compassion/12.0/odoo/odoo.conf
```

## Add test database

Get backup from /web/database/selector ad pg_dump then (`test` is a db name example):

```
createdb test
pg_restore {path_to_pg_dump} -d test --verbose --no-owner
```

## Why pyenv and poetry

Python versions and virtual environments can be a mess, but these two tools simplify this greatly.

More info here: https://blog.jayway.com/2019/12/28/pyenv-poetry-saviours-in-the-python-chaos/

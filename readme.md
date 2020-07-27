# Compassion Odoo Installer

## Installation

### Prerequisites

- [Pyenv](https://github.com/pyenv/pyenv-installer)
- [Poetry](https://github.com/python-poetry/poetry)

### Setup

1. Make sure pyenv and poetry are installed
2. Clone this repo somewhere
3. From the cloned repo execute `./install.sh`
4. Get access to the paid-addons repo (ask Ema), and clone it in `{odoo_install_path}/12.0/odoo/compassion`
5. Create odoo.conf in `{odoo_install_path}/12.0/odoo`, you can use [this template](https://confluence.compassion.ch/display/CI/Odoo+installation+script).

### Add a test database

Get a backup from the devel (ask someone for the current address) at /web/database/selector as pg_dump then:

```
createdb {database_name}
pg_restore {path_to_pg_dump} -d {database_name} --verbose --no-owner
```

### Configure Pycharm

- Open the folder where Odoo was installed (`{odoo_install_path}/12.0`) as a new project
- Install the [poetry pycharm plugin](https://plugins.jetbrains.com/plugin/14307-poetry) (official support is being implemented)
- Restart and go in File > Settings > Project > Python Interpreter > Wheel Icon > Add > Poetry Environment
- Select "Existing environment", should have /pypoetry/virtualenv in the path, apply.
- At the top right click on "Add configuration", then plus icon, then Python with: (update with your paths)

```
Script path: /home/sylvain/compassion/12.0/odoo/odoo-bin
Parameters: -c /home/sylvain/compassion/12.0/odoo/odoo.conf
```

## FAQ

### How do I access the virtual env from the shell ?

From `{odoo_install_path}/12.0/` execute `poetry shell`

### How do I add a python dependency ?

From `{odoo_install_path}/12.0/` run `poetry add {name_of_dependency}`

### How do I update the addons repos ?

From `{odoo_install_path}/12.0/odoo/compassion` execute `mr update`

### Why pyenv and poetry ?

Python versions and virtual environments can be a mess, but these two tools simplify this greatly.

More info here: https://blog.jayway.com/2019/12/28/pyenv-poetry-saviours-in-the-python-chaos/

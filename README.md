# Scaffolder for a simple Django Project

# Execute script

### Run using wget

```bash
bash <(wget -qO- https://raw.githubusercontent.com/leonidlezner/create-django-project/main/django-scaffold.sh)
```

### Run using curl

```bash
bash <(curl -s https://raw.githubusercontent.com/leonidlezner/create-django-project/main/django-scaffold.sh)
```

## Tipps

## Include DaisyUI

Uncomment `TAILWIND_CLI_USE_DAISY_UI`in settings.py.

### Running tests in VSCode

Add an .env file with following content:

```
MANAGE_PY_PATH="./manage.py"
```

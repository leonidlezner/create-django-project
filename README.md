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

## Adding allauth to the project

tbd.

### Creating random username for allauth

Create `adapter.py` in the App APPNAME with following code:

```python
import uuid
from allauth.account.adapter import DefaultAccountAdapter

class RandomUsernameAdapter(DefaultAccountAdapter):
    def generate_unique_username(self, txts, regex=None):
        random_base = uuid.uuid4()
        return super().generate_unique_username([random_base], regex)

```

And configure it in settings.py:

```python
ACCOUNT_ADAPTER = "APPNAME.adapter.RandomUsernameAdapter"
```

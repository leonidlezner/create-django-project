#!/bin/bash

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "uv could not be found. Please install uv before running this script."
    exit 1
fi

# Prompt for project name if not provided as an argument
if [ -z "$1" ]; then
  read -p "Enter the project name: " PROJECT_NAME
else
  PROJECT_NAME=$1
fi

SETTINGS_FILE="$PROJECT_NAME/settings.py"
URLS_FILE="$PROJECT_NAME/urls.py"

mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

uv init .

rm -rf main.py

uv add django django-tailwind-cli whitenoise django-browser-reload

uv run django-admin startproject "$PROJECT_NAME" .

# Add apps to INSTALLED_APPS around 'django.contrib.staticfiles'
sed -i '' "/'django.contrib.staticfiles',/i\\
    'whitenoise.runserver_nostatic',
" "$SETTINGS_FILE"

sed -i '' "/'django.contrib.staticfiles',/a\\
    'django_tailwind_cli',\\
    'django_browser_reload',
" "$SETTINGS_FILE"

# Add WhiteNoise middleware after SecurityMiddleware
sed -i '' "/'django.middleware.security.SecurityMiddleware',/a\\
    'whitenoise.middleware.WhiteNoiseMiddleware',
" "$SETTINGS_FILE"

# Add BrowserReload middleware after XFrameOptionsMiddleware
sed -i '' "/'django.middleware.clickjacking.XFrameOptionsMiddleware',/a\\
    'django_browser_reload.middleware.BrowserReloadMiddleware',
" "$SETTINGS_FILE"

# Add templates dir to TEMPLATES DIRS
sed -i '' "s|'DIRS': \[\]|'DIRS': [BASE_DIR / 'templates']|" "$SETTINGS_FILE"

# Add static and tailwind settings after STATIC_URL
sed -i '' "/^STATIC_URL = /a\\
STATIC_ROOT = BASE_DIR / 'static'\\
STATICFILES_DIRS = [BASE_DIR / 'assets']\\
TAILWIND_CLI_SRC_CSS = BASE_DIR / 'src' / 'styles' / 'main.css'
" "$SETTINGS_FILE"

# Add STORAGES setting at the end of the file
cat <<EOL >> "$SETTINGS_FILE"

STORAGES = {
    'staticfiles': {
        'BACKEND': 'whitenoise.storage.CompressedManifestStaticFilesStorage',
    },
}
EOL

# Adjust urls.py to wire up django_browser_reload

sed -i '' 's|from django.urls import path|from django.urls import path, include|' "$URLS_FILE"

sed -i '' "/^urlpatterns = \[/a\\
    path('__reload__/', include('django_browser_reload.urls')),
" "$URLS_FILE"

mkdir -p assets
mkdir -p templates
mkdir -p static
mkdir -p src/styles

# Create base.html
cat <<EOL > templates/base.html
{% load tailwind_cli %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Django App</title>
    {% tailwind_css %}
</head>
<body>
    {% block content %}{% endblock %}
</body>
</html>
EOL

cat <<EOL > src/styles/main.css
@import "tailwindcss";
EOL


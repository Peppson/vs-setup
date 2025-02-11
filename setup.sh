#!/bin/bash

GITHUB_USER="Peppson"
PUBLIC_REPO="vs-setup"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$PUBLIC_REPO/main"

# Dirs
mkdir -p .vscode

# Download the stuff
curl -o .gitignore "https://raw.githubusercontent.com/github/gitignore/main/VisualStudio.gitignore"
curl -o .vscode/settings.json "$BASE_URL/settings.json"
curl -o .vscode/launch.json "$BASE_URL/launch.json"

echo "Done!🗿🗿🗿"
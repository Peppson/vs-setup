#!/bin/bash

GITHUB_USER="Peppson"
PUBLIC_REPO="vs-setup"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$PUBLIC_REPO/$BRANCH"


# Does curl and grep exist? They should?
if ! command -v curl &> /dev/null 
then
    echo -e "\n> \033[0;31mError:\033[0m curl is not installed!"
    exit 1
fi

if ! command -v grep &> /dev/null
then
    echo -e "\n> \033[0;31mError:\033[0m grep is not installed!"
    exit 1
fi


# Make dirs
mkdir -p .vscode


download_file() {
    curl --fail -sS "$BASE_URL/$1"
}

remove_first_and_last_lines() {
    echo "$1" | sed '1d;$d'
}




if [ ! -f .vscode/settings.json ]; then
    echo "> Downloading settings.json..."
    curl --fail -sS -o .vscode/settings.json "$BASE_URL/settings.json"
else 
    echo "> Appending..."

    # Download new file
    file=$(download_file "settings.json")
    stripped_file=$(remove_first_and_last_lines "$file")

    # Grab current file
    current_file=$(<.vscode/settings.json)

    # Search if current_file contains stripped_file contents
    normalized_current_file=$(echo "$current_file" | tr -s '[:space:]' '\n' | tr -d '[:space:]')
    normalized_stripped_file=$(echo "$stripped_file" | tr -s '[:space:]' '\n' | tr -d '[:space:]')

    if ! echo "$normalized_current_file" | grep -qF "$normalized_stripped_file"; then
        # Insert stripped_file content into current_file after the first {
        # Why temp? Nothing else worked...
        temp_file=$(mktemp)
        echo "$stripped_file," > "$temp_file"
        modified_file=$(sed '/^$/d' <<< "$current_file" | sed "0,/{/r $temp_file")
        rm "$temp_file"

        echo "$modified_file" > .vscode/settings.json
    fi
fi








# Download only if missing
if [ ! -f .gitignore ]; then
    echo "> Downloading .gitignore..."
    curl --fail -sS -o .gitignore "https://raw.githubusercontent.com/github/gitignore/main/VisualStudio.gitignore"
fi


exit 0


if [ ! -f .vscode/settings.json ]; then
    download_file .vscode/ settings.json
fi

if [ ! -f .vscode/launch.json ]; then
  #curl -o .vscode/launch.json "$BASE_URL/launch.json"
fi

echo -e "\n> \033[0;32mAll done!\033[0m 🗿🗿🗿"

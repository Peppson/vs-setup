#!/bin/bash

#############################################################

# Github
USER="Peppson"
PUBLIC_REPO="vs-setup"
BRANCH="main"
GITHUB_URL="https://raw.githubusercontent.com/$USER/$PUBLIC_REPO/$BRANCH"

# .gitignore
GITIGNORE_URL="https://raw.githubusercontent.com/github/gitignore/main/VisualStudio.gitignore"

# Files and paths
declare -A FILE_MAP
FILE_MAP["settings.json"]=".vscode/"
FILE_MAP["launch.json"]=".vscode/"

#############################################################


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

update_file_if_needed() {
    file_name="$1" 
    path="${2:-}"

    # Download new file
    file=$(curl --fail -sS "$GITHUB_URL/$file_name")

    # Remove first and last '{' '}'
    stripped_file=$(echo "$file" | sed '1{/^{/d}' | sed '${/}$/d}') 

    # Grab local file
    local_file=$(<$path$file_name)

    normalized_current_file=$(echo "$local_file" | tr -s '[:space:]' '\n' | tr -d '[:space:]')
    normalized_stripped_file=$(echo "$stripped_file" | tr -s '[:space:]' '\n' | tr -d '[:space:]')

    # Look if local_file contains stripped_file content
    if ! echo "$normalized_current_file" | grep -qF "$normalized_stripped_file"; then
        append_file "$local_file" "$stripped_file" "$file_name" "$path"
    fi
}

get_stripped_file() {
    
}

append_file() {
    local_file="$1"
    stripped_file="$2"
    file_name="$3" 
    path="$4"

    # Insert stripped_file content into local_file after the first "{"
    temp_file=$(mktemp)
    echo "$stripped_file," > "$temp_file"
    modified_file=$(sed '/^$/d' <<< "$local_file" | sed "0,/{/r $temp_file")
    rm "$temp_file"

    echo "$modified_file" > $path$file_name
    echo "> Downloading and updating $file_name..."
}

# Make dir
mkdir -p .vscode

echo -e "\n"

# Download .gitignore
if [ ! -f .gitignore ]; then
    echo "> Downloading .gitignore..."
    curl --fail -sS -o .gitignore "$GITIGNORE_URL"
    
elif [ ! -s .gitignore ]; then
    echo "> .gitignore is empty, downloading..."
    curl --fail -sS -o .gitignore "$GITIGNORE_URL"
fi

# Download and append files if needed
for file in "${!FILE_MAP[@]}"; do
    path="${FILE_MAP[$file]}"

    # Missing
    if [ ! -f $path$file ]; then
        echo "> Downloading $file..."
        curl --fail -sS -o $path$file "$GITHUB_URL/$file"
    # Empty
    elif [ ! -s $path$file ]; then
        echo "> $file is empty, downloading..."
        curl --fail -sS -o $path$file "$GITHUB_URL/$file"
    # Append content?
    else 
        update_file_if_needed $file $path
    fi
done

echo -e "> \033[0;32mAll done!\033[0m 🗿🗿🗿"

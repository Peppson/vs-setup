## Install script - *`vs-setup`* 
```bash
ALIAS="vs-setup"
DIR="$HOME/bash_scripts/"
SCRIPT_PATH=$DIR"vs-setup.sh"
SCRIPT_URL="https://raw.githubusercontent.com/Peppson/vs-setup/main/setup.sh"

mkdir -p $DIR 
curl --fail -sS -o "$SCRIPT_PATH" "$SCRIPT_URL" || exit 1
chmod +x "$SCRIPT_PATH"

touch ~/.bashrc
sed -i "/alias $ALIAS=/d" ~/.bashrc
echo "alias $ALIAS='bash $SCRIPT_PATH'" >> ~/.bashrc
source ~/.bashrc
```

## git nasa - *`Open repo in browser`* 
```bash
git config --global alias.nasa '!start "" "$(printf "%s/tree/%s" "$(git config remote.origin.url | sed "s/\.git$//")" "$(git branch --show-current)")"'
```

## git bash - *`Open root in git bash`* 
```bash
git config --global alias.bash '!start "" "C:\Program Files\Git\git-bash.exe" --cd="$PWD"'
```

# Personal vscode setup script

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

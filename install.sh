#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"
TARGET_DIR=$HOME


ask_question() {
  local prompt="$1"
  local response=""

  while [[ -z "$response" ]]; do
    read -rp "$prompt " response
    if [[ -z "$response" ]]; then
      echo "Erreur : la réponse ne peut pas être vide."
    fi
  done
  echo "$response"
}

# Ensure the files directory exists
if [ ! -d "$FILES_DIR" ]; then
  echo "Error: The 'files' directory does not exist."
  exit 1
fi

# Utilisation de la fonction
github_username=$(ask_question "Quel nom GitHub utiliser ?")

# Affichage du résultat
echo "Nom GitHub choisi : $github_username"
exit


echo "Install OMZ"
# Install OMZ
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install OMZ plugins & theme
git clone https://github.com/mattmc3/zshrc.d $HOME/.oh-my-zsh/custom/plugins/zshrc.d
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

echo "Create links"
# Loop through all files in the files directory
shopt -s dotglob
# Create files @ root only
for file in "$FILES_DIR"/*; do
  if [ -f "$file" ]; then
    RELATIVE_PATH="${file#$FILES_DIR/}"
    ln -s -f "$file" "$TARGET_DIR/$RELATIVE_PATH"
    echo "Created symlink for: $RELATIVE_PATH"
  fi
done

# For folders, take the last one and create a link to the folder
for DIR in $(find "$FILES_DIR" -mindepth 1 -type d -exec bash -c '[[ $(find "$1" -mindepth 1 -type d) ]] || echo "$1"' bash {} \;); do
  RELATIVE_PATH="${DIR#$FILES_DIR/}"
  PARENT=$TARGET_DIR/$(dirname $RELATIVE_PATH)
  [[ ! -d $PARENT ]] && mkdir -p $PARENT
  ln -s -f "$DIR" "$TARGET_DIR/$RELATIVE_PATH"
  echo "Created symlink for: $RELATIVE_PATH"
done
echo "All symlinks created successfully."


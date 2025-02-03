#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"
TARGET_DIR=$HOME

# Ensure the files directory exists
if [ ! -d "$FILES_DIR" ]; then
  echo "Error: The 'files' directory does not exist."
  exit 1
fi

# Git config
while [[ -z "${GITHUB_USER}" ]]; do
  read -p "Entrez votre nom d'utilisateur GitHub : " GITHUB_USER
done
while [[ -z "${GITHUB_EMAIL}" ]]; do
  read -p "Entrez votre email GitHub : " GITHUB_EMAIL
done

cat <<EOF > ~/.git-credentials
[user]
  name = ${GITHUB_USER}
  email = ${GITHUB_EMAIL}
EOF
chmod 600 ~/.git-credentials

echo "Install FZF"
if [[ ! -d ~/.fzf ]]
then
  # Install FZF
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --completion --key-bindings --no-update-rc --no-bash
fi

echo "Install OMZ"
if [[ ! -d ~/.oh-my-zsh ]]
then
  # Install OMZ
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # Install OMZ plugins & theme
  git clone https://github.com/mattmc3/zshrc.d $HOME/.oh-my-zsh/custom/plugins/zshrc.d
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
  git clone https://github.com/wfxr/forgit.git $HOME/.oh-my-zsh/custom/plugins/forgit
  git clone https://github.com/z-shell/F-Sy-H.git $HOME/.oh-my-zsh/custom/plugins/F-Sy-H
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi 

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


#!/bin/bash

# Clones or update origin url for a Git repo
# https://gist.githubusercontent.com/lavoiesl/3867674/raw/wmc-clone.sh

if [[ "$1" == "update" ]]; then
  wget "https://gist.githubusercontent.com/lavoiesl/3867674/raw/wmc-clone.sh" -O "$0"
  chmod +x "$0"
  exit
fi

prompt_value() {
  prompt="$1 "
  default="$2"

  [[ -n "$default" ]] && prompt="$prompt($default) "

  read -p "$prompt" reply

  [[ -z "$reply" ]] && reply="$default"

  if [[ -z "$reply" ]]; then
    prompt_value "$prompt" "$default"
    exit
  fi

  echo "$reply"
}

confirm() {
  prompt="$1"

  read -p "$prompt (Y/n) " reply
  
  [[ $reply != "n" ]]

  return $?
}

username="$(git config --global wmc.username)"
email="$(git config --global wmc.email)"
path="$(git config --global wmc.path)"
shared="$(git config --global wmc.shared)"

[[ -z "$username" ]] && username="$(prompt_value "What is your name ?" "$(git config --global user.name)")" && git config --global wmc.username "$username"

[[ -z "$email" ]] && email="$(prompt_value "What is your email ?" "$(git config --global user.email)")" && git config --global wmc.email "$email"

[[ -z "$path" ]] && path="$(prompt_value "Where are the projects stored ?" "$HOME/projects")" && git config --global wmc.path "$path"

[[ -z "$shared" ]] && shared="$(prompt_value "Where are shared folders stored ?" "$HOME/Google Drive/WMC/03 - Repository")" && git config --global wmc.shared "$shared"


user="git"
server="gitlab.wemakecustom.com"

if [ -z "$1" ]
then
  echo "Usage: $0 client/project" >&2
  exit 1
fi

project="$1"
git="$project.git"
url="$user@$server:$git"

# Clone to
folder="$path/$1"
[ -n "$2" ] && folder="$2"

if [ -d "$folder/.git" ]
then
    echo "$folder already exists, setting origin to $url"
    cd $folder
    git remote set-url origin "$url"
    git fetch origin
    cd ..
else
    git clone $url $folder
fi

# Symlinking shared
shared_target="$folder/shared"
shared_source="$shared/$1"

if [[ -e "$shared_target" ]]; then

  if [[ ! -L "$shared_target" || "$(readlink "$shared_target")" != "$shared_source" ]]; then
    echo "WARNING: $shared_target already exists and does not point to $shared_source." >&2
  fi

else
  if confirm "Shared folder does not exist, would like to create it ?"; then

    if [[ ! -d "$shared_source" ]]; then
      mkdir -pv "$shared_source"
    fi

    ln -sv "$shared_source" "$shared_target"

  fi

fi

if [[ -L "$shared_target" && "$(readlink "$shared_target")" == "$shared_source" ]]; then
  if [[ ! -f "$folder/.gitignore" ]] || ! grep -q "^/shared$" "$folder/.gitignore"; then
    confirm "WARNING: /shared is not in .gitignore, would like to add it now ?" && echo "/shared" >> "$folder/.gitignore"
  fi
fi

# Ensure username
git config --file "$folder/.git/config" user.name  "$username"
git config --file "$folder/.git/config" user.email "$email"

#!/usr/bin/env bash

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

if [ ! -e ~/.gitconfig ]; then
  wget -nv https://gist.githubusercontent.com/lavoiesl/3864795/raw/gitconfig -O ~/.gitconfig
fi

fullname="$(prompt_value "What is your full name ?" "$(git config --global user.name)")" && git config --global user.name "$fullname"
email="$(prompt_value "What is your email ?" "$(git config --global user.email)")" && git config --global user.email "$email"

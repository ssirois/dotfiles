#!/bin/bash

# shellcheck source=/dev/null
cd "$DOTFILES_PATH" \
  && source "$DOTFILES_PATH/src/os/helpers.sh"

#------------------------------------------------------------------------------#

link_configs() {
  # look for all files/directories ending in ".symlink".
  for SOURCE in $(find "$DOTFILES_PATH/src" \( -path "$DOTFILES_PATH/src/*/.config/*" -a -name \*.symlink \))
  do
    ITEM="${SOURCE#$DOTFILES_PATH/src/*/.config/}"
    DEST="$HOME/.config/${ITEM%.*}"

    # item already exists
    if [[ -e "$DEST" ]]; then
      ask_user_option "Item already exists '$ITEM': What should I do? [b]ackup, [o]verwrite, [s]kip"
      if answer_is_backup; then
        mkdir -p "$DOTFILES_BACKUP_PATH" \
          && mv "$DEST" "$DOTFILES_BACKUP_PATH/"
      elif answer_is_overwrite; then
        rm -Rf "$DEST"
      else
        continue
      fi
    fi

    # make sure path to $DEST exists before linking
    if [[ ! -e $(dirname $DEST) ]]; then
      mkdir -p "$(dirname $DEST)"
    fi

    execute \
      "ln -s $SOURCE $DEST" \
      "$SOURCE → $DEST"
  done
}

#------------------------------------------------------------------------------#

main() {
  ask_user_option "Would you like to adjust preferences: (y/n)"
  if answer_is_yes; then
    print_talk "Time to symlink config files/directories"

    link_configs
  fi
}

main

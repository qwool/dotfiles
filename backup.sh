
#!/bin/bash

CONFIG_FOLDERS=("nvim" "kitty" "fish" "helix")
BACKUP_DIR="$HOME/git/dotfiles/"

mkdir -p "$BACKUP_DIR"

echo "starting backup"

for folder in "${CONFIG_FOLDERS[@]}"; do
    SOURCE="$HOME/.config/$folder"
    DEST="$BACKUP_DIR/$folder"

    if [ -d "$SOURCE" ]; then
        rsync -av --delete "$SOURCE/" "$DEST/"
        echo "backed up: $folder"
    else
        echo "!!!skipped $folder: not found"
    fi
done

echo "complete"

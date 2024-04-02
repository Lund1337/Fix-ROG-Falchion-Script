#!/bin/bash

# Define the file path
FILE_PATH="/etc/udev/hwdb.d/99-asus-falchion.hwdb"

# Check if the file already exists
if [ -f "$FILE_PATH" ]; then
  echo "File $FILE_PATH already exists. Exiting."
  exit 1
fi

# Define the content of the file
# Thank you @jnettlet for the fix
# https://gist.github.com/jnettlet/afb20a048b8720f3b4eb8506d8b05643
CONTENT=$(cat <<EOF
evdev:input:b*v0B05p193Ee0111*
  KEYBOARD_KEY_10081=reserved
  KEYBOARD_KEY_10082=reserved
  KEYBOARD_KEY_70070=reserved
  KEYBOARD_KEY_70071=reserved
  KEYBOARD_KEY_70072=reserved
  KEYBOARD_KEY_70073=reserved
  KEYBOARD_KEY_70074=reserved
  KEYBOARD_KEY_70075=reserved
  KEYBOARD_KEY_70076=reserved
  KEYBOARD_KEY_70077=reserved
EOF
)

# Create the file with the specified content
echo "$CONTENT" | sudo tee "$FILE_PATH" > /dev/null

# Check if the file is created and the content is correct
if [ -f "$FILE_PATH" ] && [ "$(sudo cat $FILE_PATH)" = "$CONTENT" ]; then
  echo "Success creating file."
  read -r -p "Would you like to run sudo systemd-hwdb update? (yes/no): " choice
  case "$choice" in
    yes|y)
      sudo systemd-hwdb update 99-asus-falchion.hwdb
      ;;
    *)
      echo "Exiting script."
      ;;
  esac
else
  echo "Error creating file or content is incorrect."
fi

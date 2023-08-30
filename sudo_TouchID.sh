#!/bin/sh

patchsudo() {
  if grep -q 'pam_tid.so' '/etc/pam.d/sudo'; then
    echo "Touch ID authentication is already present in /etc/pam.d/sudo"
  else
    echo "Adding Touch ID authentication ('auth sufficient pam_tid.so') to 
/etc/pam.d/sudo..."
    sudo sed -i '' '1s/^/auth sufficient pam_tid.so\n/' '/etc/pam.d/sudo'
    echo "Touch ID authentication applied successfully"
  fi
}

patchsudo

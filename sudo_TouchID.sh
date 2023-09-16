#!/bin/sh

patchsudo() {
  CUSTOM_SUDO_PAM='/etc/pam.d/sudo_custom'
  DEFAULT_SUDO_PAM='/etc/pam.d/sudo'

  # Check if the custom PAM configuration file exists
  if [ ! -e "$CUSTOM_SUDO_PAM" ]; then
    echo "Creating custom PAM configuration for sudo..."
    
    # Copy the default sudo PAM configuration to the custom file
    sudo cp "$DEFAULT_SUDO_PAM" "$CUSTOM_SUDO_PAM"
    
    # Add Touch ID authentication to the custom PAM configuration
    sudo sh -c 'echo "auth       sufficient     pam_tid.so" >> "$CUSTOM_SUDO_PAM"'
    
    echo "Touch ID authentication added to sudo."
  else
    echo "Custom PAM configuration for sudo already exists."
  fi
}

patchsudo

echo "Script execution completed."
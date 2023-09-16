#!/bin/bash

update_sudo_pam() {
  # Define the paths for sudo PAM configuration files
  SUDO_PAM="/etc/pam.d/sudo"
  SUDO_LOCAL="/etc/pam.d/sudo_local"
  SUDO_LOCAL_TEMPLATE="/etc/pam.d/sudo_local.template"
  CUSTOM_SUDO_PAM="/etc/pam.d/sudo_custom"  # Add this line to define the custom PAM file

  # Check if the macOS version is Sonoma (macOS 14) or newer
  if [[ "$(sw_vers -productVersion)" > "14."* ]]; then
    # Check if the sudo_local file exists
    if [[ ! -e "$SUDO_LOCAL" ]]; then
      # Copy the template file to sudo_local
      sudo cp "$SUDO_LOCAL_TEMPLATE" "$SUDO_LOCAL"
      echo "Created sudo_local configuration file."
    fi

    # Uncomment the line to enable Touch ID in sudo_local
    sudo sed -i '' '/^# auth       sufficient     pam_tid.so/s/^# //' "$SUDO_LOCAL"
    
    echo "Touch ID authentication is now set up for sudo."
  else
    # For Ventura (macOS 13) and older, use the custom PAM method
    if [[ ! -e "$CUSTOM_SUDO_PAM" ]]; then
      echo "Creating custom PAM configuration for sudo..."
      sudo cp "$SUDO_PAM" "$CUSTOM_SUDO_PAM"
      sudo sh -c 'echo "auth       sufficient     pam_tid.so" >> "$CUSTOM_SUDO_PAM"'
      echo "Custom PAM configuration for sudo created."
    else
      echo "Custom PAM configuration for sudo already exists."
    fi
  fi

  # Prompt to test Touch ID authentication
  read -p "Do you want to test Touch ID authentication for sudo? (y/n): " test_choice
  if [[ "$test_choice" == "y" || "$test_choice" == "Y" ]]; then
    sudo -v
    if [[ $? -eq 0 ]]; then
      echo "Touch ID authentication for sudo is working correctly!"
    else
      echo "Touch ID authentication for sudo failed. Please check your configuration."
    fi
  fi
}

update_sudo_pam
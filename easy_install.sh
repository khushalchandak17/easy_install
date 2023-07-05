#!/bin/bash
### This script is specially designed for Ubuntu OS

# Function to display menu and prompt user for input
show_menu () {
  echo "Please select an option for Installations:"
  echo "1. Install dependencies in Ubuntu OS"
  echo "2. Install Rancher Manager Using Helm"
  echo "3. Install Rancher Manager Using Docker"
  echo "4. Install RKE"
  echo "5. Install RKE2 Server using apt"
  echo "6. Install k3s"
  echo "7. Install Helm/kubectl"
  echo "8. Configure DNS"
  echo "9. Exit"
  read -p "Enter your choice [1-9]: " choice
}

invalid() {
  clear
  echo "Invalid option. Please try again. \n"
  sleep 1
}

configure_ubuntu() {
  echo "Configuring Ubuntu OS for Rancher Ready..."
# Ubuntu instructions
# stop the software firewall
systemctl disable --now ufw

# get updates, install nfs, and apply

apt-mark hold linux-image-*
apt update
apt install nfs-common curl -y
apt upgrade -y
apt-mark unhold linux-image-*
# clean up
apt autoremove -y  

}

install_rancher() {
  clear  
  echo "Installing Rancher Manager using Helm... \n Fetching all the avaialble version from upstream \n \n"
  get_rancher_version
  echo "$RANCHER_VERSION"
  sleep 3
}

get_rancher_version () {
  # Get list of available Rancher versions from GitHub API
  VERSIONS_URL="https://api.github.com/repos/rancher/rancher/releases"
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | grep -v 'alpha\|beta' | sort -rV)

  # Display menu of available versions
  echo "Please select a Rancher version to install or use option 1 for the latest stable version: \n"
  select VERSION in "latest" $VERSIONS; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Set RANCHER_VERSION variable
  if [ "$VERSION" = "latest" ]; then
    RANCHER_VERSION=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | grep -v 'alpha\|beta' | head -n 1)
  else
    RANCHER_VERSION=$VERSION
  fi
}


docker_rancher() {
  echo "Installing Rancher Manager using Docker..."
  # Add your installation logic for Rancher Manager using Docker here
}






install_rke() {
  clear
  echo "Installing RKE... \n Fetching all the avaialble version from upstream \n \n"
  # Add your installation logic for RKE here
  get_rke_version
  echo "$RKE_VERSION"
  sleep 3
}


function get_rke_version {
  # Get list of available RKE versions from GitHub API
  VERSIONS_URL="https://api.github.com/repos/rancher/rke/releases"
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | sort -rV)

  # Add "Latest" option to the list
  VERSIONS="Latest $VERSIONS"

  # Display menu of available versions
  echo "Please select an RKE version to install or use option 1 for the latest stable version : \n"
  select VERSION in $VERSIONS; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Check if "Latest" option was selected
  if [ "$VERSION" = "Latest" ]; then
    # Fetch the latest version from the GitHub API
    LATEST_VERSION=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | head -n 1)
    RKE_VERSION=$LATEST_VERSION
  else
    # Set RKE_VERSION variable to the selected version
    RKE_VERSION=$VERSION
  fi
}





install_rke2_apt_get() {
  clear
  echo "Installing RKE2 Server using apt... \n Fetching all the avaialble version from upstream \n \n"
  # Add your installation logic for RKE2 Server using apt here
  get_rke2_version
  echo "$RKE2_VERSION"
  sleep 2
}

# Function to display menu for all avaialble RKE2 version and get user's choice
function get_rke2_version {
  # Get list of available RKE2 versions from GitHub API
  VERSIONS_URL="https://api.github.com/repos/rancher/rke2/releases"
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | sort -rV)

  # Add "Latest" option to the list
  VERSIONS="Latest $VERSIONS"

  # Display menu of available versions
  echo "Please select an RKE2 version to install or use option 1 for the latest stable version: \n"
  select VERSION in $VERSIONS; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Check if "Latest" option was selected
  if [ "$VERSION" = "Latest" ]; then
    # Fetch the latest version from the GitHub API
    LATEST_VERSION=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | head -n 1)
    RKE2_VERSION=$LATEST_VERSION
  else
    # Set RKE2_VERSION variable to the selected version
    RKE2_VERSION=$VERSION
  fi
}


install_k3s() {
  clear  
  echo "Installing k3s... \n Fetching all the avaialble version from upstream \n \n"
  get_k3s_version
  echo "$K3S_VERSION"
  sleep 2
}

function get_k3s_version {
  # Get list of available k3s versions from GitHub API
  VERSIONS_URL="https://api.github.com/repositories/135516270/releases"
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | sort -rV)

  # Display menu of available versions
  echo "Please select a k3s version to install or use option 1 for the latest stable version: \n"
  select VERSION in "latest" $VERSIONS ; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Set K3S_VERSION variable
  if [ "$VERSION" = "latest" ]; then
    K3S_VERSION=$(curl -s $VERSIONS_URL | grep '"name":' | cut -d '"' -f 4 | head -n 1)
  else
    K3S_VERSION=$VERSION
  fi
}

install_tools() {
  clear
  echo "Installing Helm/kubectl... \n Fetching all the avaialble version from upstream \n \n"

  get_kubectl_version
  echo "$KUBECTL_VERSION"
  sleep 3
  
}

get_kubectl_version () {
  # Get list of available kubectl versions from GitHub API
  VERSIONS_URL="https://api.github.com/repos/kubernetes/kubectl/tags"
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"name":' | cut -d '"' -f 4 | sort -rV)

  # Append "stable" option by fetching the stable version from the given URL
  STABLE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  VERSIONS+=" stable"

  # Display menu of available versions
  echo "Please select a kubectl version or use option 1 for stable version: \n"
  select VERSION in $VERSIONS; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Set KUBECTL_VERSION variable based on the selected version
  if [ "$VERSION" == "stable" ]; then
    KUBECTL_VERSION=$STABLE_VERSION
  else
    KUBECTL_VERSION=$VERSION
  fi
}



configure_dns() {
  echo "Deploying DNS server..."
}


if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Loop through menu until user selects "9. Exit"
while true; do
  sleep 1
  clear
  show_menu
  case $choice in
    1) configure_ubuntu ;;
    2) install_rancher ;;
    3) docker_rancher ;;
    4) install_rke ;;
    5) install_rke2_apt_get ;;
    6) install_k3s ;;
    7) install_tools ;;
    8) configure_dns ;;
    9) exit 0 ;;
    *) invalid ;;
    # *) echo "Invalid option. Please try again." ;;
  esac
done

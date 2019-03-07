#!/bin/bash

PROJECT_NAME="velero"
VELERO_INSTALL_DIR="/usr/local/bin"
VELERO_VERSION=""

set -euo pipefail

target="./main.yml"
rm "$target"
echo "# Derived from config" >>"$target"

#Downloading version specific manifests
downloadVersionSpecificYamlFilesForMinio() {
  # Remove old yamls
  rm -rf manifests/*
  wget -nc -P ./manifests/common https://raw.githubusercontent.com/heptio/velero/${VELERO_VERSION}/examples/common/00-prereqs.yaml


  wget -nc -P ./manifests/minio https://raw.githubusercontent.com/heptio/velero/${VELERO_VERSION}/examples/minio/00-minio-deployment.yaml
  wget -nc -P ./manifests/minio https://raw.githubusercontent.com/heptio/velero/${VELERO_VERSION}/examples/minio/05-backupstoragelocation.yaml
  wget -nc -P ./manifests/minio https://raw.githubusercontent.com/heptio/velero/${VELERO_VERSION}/examples/minio/20-deployment.yaml

  while true; do
    read -p "Install restic yaml Y(y)/N(n)?" yn
    case $yn in
    [Yy]*)
      wget -nc -P ./manifests/minio https://raw.githubusercontent.com/heptio/velero/${VELERO_VERSION}/examples/minio/30-restic-daemonset.yaml
      break
      ;;
    [Nn]*)
      break
      ;;
    *) echo "Please answer yes or no." ;;
    esac
  done
}

# checkVeleroInstalledVersion checks which version of velero is installed and
# if it needs to be changed.
checkVeleroInstalledVersion() {
  if [ -x "${VELERO_INSTALL_DIR}/${PROJECT_NAME}" ]; then
    local version=$(velero version | grep 'Version' | cut -d':' -f2 | sed -e 's/^[ \t]*//')
    VELERO_VERSION=$version
    echo "Velero client ${version} found, proceeding with velero installation."
    return 0
  else
    echo "Velero client not found in $VELERO_INSTALL_DIR Please check if it's installed"
    echo "Installation steps can be found below. Re-run the install addon command again after velero client installation."
    echo "
    Get the latest release corresponding to your OS and system architecture and copy the link address
    wget https://<link-copied-from-releases-page>
    tar -xvzf <downloaded-from-above-step>.tar.gz
    sudo mv velero /usr/local/bin/ 
    $ velero help "
    return 1
  fi
}

# Copy Velero manifests into main.yml
copyManifestsToMainYaml() {
  echo "Installing Velero .."
  for file in $(find ./manifests -type f -name "*.yaml" | sort); do
    echo "add " $file
    cat "$file" >>"$target"
    echo " " >>"$target"
    echo "---" >>"$target"
  done
}

#  Velero minio Installation
if checkVeleroInstalledVersion; then
  downloadVersionSpecificYamlFilesForMinio
  copyManifestsToMainYaml
fi

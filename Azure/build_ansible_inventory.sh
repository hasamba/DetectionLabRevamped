#! /usr/bin/env bash

# This script is used to populate the Azure Ansible inventory.yml with 
# the results of "terraform output"

if [ ! -d "./Terraform" ]; then
  echo "This script needs to be run from the DetectionLab/Azure folder"
  exit 1
fi

if [ ! -d "./Ansible" ]; then
  echo "This script needs to be run from the DetectionLab/Azure folder"
  exit 1
fi

if ! which terraform >/dev/null; then
  echo "Terraform needs to be accessible from PATH."
  exit 1
fi

cd ./Terraform || exit 1
TF_OUTPUT=$(terraform output)

DC_IP=$(echo "$TF_OUTPUT" | grep -E -o "dc_public_ip = \"([0-9]{1,3}[\.]){3}[0-9]{1,3}\"" | cut -d '=' -f 2 | tr -d ' ' | tr -d '"')
WEF_IP=$(echo "$TF_OUTPUT" | grep -E -o "wef_public_ip = \"([0-9]{1,3}[\.]){3}[0-9]{1,3}\"" | cut -d '=' -f 2 | tr -d ' ' | tr -d '"')
win11_IP=$(echo "$TF_OUTPUT" | grep -E -o "win11_public_ip = \"([0-9]{1,3}[\.]){3}[0-9]{1,3}\"" | cut -d '=' -f 2 | tr -d ' ' | tr -d '"')
EXCHANGE_IP=$(echo "$TF_OUTPUT" | grep -E -o "exchange_public_ip = \"([0-9]{1,3}[\.]){3}[0-9]{1,3}\"" | cut -d '=' -f 2 | tr -d ' ' | tr -d '"')

# Don't update unless there's default values in inventory.yml
GREP_COUNT=$(grep -E -c 'x\.x\.x\.x|y\.y\.y\.y|z\.z\.z\.z' ../Ansible/inventory.yml)
if [ "$GREP_COUNT" -ne 3 ]; then
  echo "This script is expecting the default values of x.x.x.x, y.y.y.y, and z.z.z.z for the dc, wef, and win11 hosts respectively in Ansible/inventory.yml."
  echo "You can restore the file to this state by running 'git checkout -- Ansible/inventory.yml'"
  echo "Rerun this script once that is complete."
  exit 1
fi

echo "Replacing the default values in DetectionLab/Azure/Ansible/inventory.yml..."
sed -i.bak "s/x.x.x.x/$DC_IP/g; s/y.y.y.y/$WEF_IP/g; s/z.z.z.z/$win11_IP/g" ../Ansible/inventory.yml

if [ ! -z "$EXCHANGE_IP" ]; then
  echo "Exchange server found! Adding the IP to the Ansible inventory..."
  sed -i.bak "s/# v.v.v.v/$EXCHANGE_IP/g" ../Ansible/inventory.yml
fi

echo "Displaying the updated inventory.yml below!"
cat ../Ansible/inventory.yml

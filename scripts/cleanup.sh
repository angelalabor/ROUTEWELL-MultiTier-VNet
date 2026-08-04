#!/usr/bin/env bash
set -euo pipefail

RG="rg-routewell"

echo "This will permanently delete resource group '$RG' and everything in it:"
echo "  - VNet, all 3 subnets"
echo "  - web-nsg, app-nsg, db-nsg and all their rules"
echo "  - web-nic, app-nic, db-nic"
echo "  - web-pip (public IP)"
echo "  - web-vm, app-vm, db-vm and their disks"
echo ""
read -p "Type the resource group name to confirm: " CONFIRM

if [ "$CONFIRM" != "$RG" ]; then
  echo "Confirmation did not match. Aborting — nothing was deleted."
  exit 1
fi

echo "Deleting resource group '$RG'..."
az group delete --name "$RG" --yes

echo "Deletion complete."

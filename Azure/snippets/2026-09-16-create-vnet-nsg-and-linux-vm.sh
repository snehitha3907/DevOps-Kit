#!/bin/bash
# last_verified: 2026-09-16 · Azure CLI
# I wanted to stand up a small isolated network and a Linux VM using only the az CLI,
# so I built a VNet with one subnet, locked SSH down with an NSG rule, then deployed the VM into it.

# Create a resource group to hold everything for this experiment.
az group create --name my-vnet-demo-rg --location eastus

# Create the virtual network with one subnet.
az network vnet create --resource-group my-vnet-demo-rg --name demo-vnet --address-prefix 10.1.0.0/16 --subnet-name demo-subnet --subnet-prefix 10.1.1.0/24

# Create a network security group and open SSH (port 22) into it.
az network nsg create --resource-group my-vnet-demo-rg --name demo-nsg
az network nsg rule create --resource-group my-vnet-demo-rg --nsg-name demo-nsg --name allow-ssh --priority 100 --destination-port-ranges 22 --access Allow --protocol Tcp

# Deploy a small Ubuntu VM into the subnet and attach the NSG.
az vm create --resource-group my-vnet-demo-rg --name demo-vm --image Ubuntu2204 --size Standard_B1s --vnet-name demo-vnet --subnet demo-subnet --nsg demo-nsg --admin-username azureuser --generate-ssh-keys

# I confirmed the VM is running and got its public IP so I can SSH in.
az vm show --resource-group my-vnet-demo-rg --name demo-vm --show-details --query "{name:name, power:powerState, ip:publicIps}" --output table

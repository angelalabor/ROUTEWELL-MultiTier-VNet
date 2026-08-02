#!/usr/bin/env bash

# ============================================================
# RouteWell Multi-Tier VNet Project
# Common variables used by all deployment scripts
# ============================================================

# Azure Region
LOCATION="westeurope"

# Resource Group
RESOURCE_GROUP="rg-routewell"

# Virtual Network
VNET_NAME="vnet-routewell"
VNET_ADDRESS_SPACE="10.10.0.0/16"

# Subnets
WEB_SUBNET_NAME="web-subnet"
WEB_SUBNET_PREFIX="10.10.0.0/27"

APP_SUBNET_NAME="app-subnet"
APP_SUBNET_PREFIX="10.10.1.0/26"

DB_SUBNET_NAME="db-subnet"
DB_SUBNET_PREFIX="10.10.2.0/28"

# Network Security Groups
WEB_NSG="nsg-web"
APP_NSG="nsg-app"
DB_NSG="nsg-db"

# Virtual Machines
WEB_VM="vm-web"
APP_VM="vm-app"
DB_VM="vm-db"

# Administrator username
ADMIN_USERNAME="azureuser"
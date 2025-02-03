#!/bin/bash
mkdir -p ~/Code/stacc/clusters
cd ~/Code/stacc/clusters

zoxide add ~/Code/stacc/clusters
# Link demo
az aks get-credentials -n link-demo-dev-aks -g link-demo-dev-aks-rg --subscription 5b37ef96-b4b4-483f-9955-92f7a3e74ee1 --file .kubeconfig

# Intrum
az aks get-credentials -n intrum-stacc-dev-aks -g intrum-stacc-dev-aks-rg --subscription 4f132ffe-7b3c-4a8f-a454-9bb47fe9b53f --file .kubeconfig

# OPF
az aks get-credentials -g scc-dev-opf-01-aks-rg -n scc-dev-opf-01-aks --subscription 2f93b313-32b7-46ee-810e-c200626ca841 --file .kubeconfig
az aks get-credentials -g scc-prod-opf-01-aks-rg -n scc-prod-opf-01-aks --subscription f973cfa8-0099-4609-a06d-d9d65a8a1250 --file .kubeconfig

# LBA
az aks get-credentials -g stacc-lba-link-dev-aks-rg -n stacc-lba-link-dev-aks --subscription 0cc7ab0d-ff46-40f1-9008-5da5f7f6c2f6 --file .kubeconfig
az aks get-credentials -g lokalbank-stacc-prod-aks-rg -n lokalbank-stacc-prod-aks --subscription a1f1d2dc-46a0-4a8a-ba51-8f49adfee490 --file .kubeconfig

# Create .envrc file
echo "export KUBECONFIG=\$PWD/.kubeconfig" > .envrc



#!/bin/bash

# variables
rgName=$1
location=$2
aksName=$3
nodeCount=$4
spnAppId=$5
spnSecret=$6
kubeVersion="1.11.5"

# assumes you're logged in already - if running in AzDO, use Azure CLI task with endpoint

# create resource group
echo "Ensure resource group exists"
az group create -n $rgName -l $location --tags owner=colind app=k8spu

# create the ACR enabling admin access
aksExists=$(az aks list --query "[].name" | grep $aksName)
if [ "$aksExists" = "" ]; then
    echo "Create AKS"
    az aks create -n $aksName -g $rgName -l $location -k $kubeVersion --node-count $nodeCount --generate-ssh-keys --service-principal $spnAppId --client-secret $spnSecret
else
    echo "Cluster $aksName exists"
fi    
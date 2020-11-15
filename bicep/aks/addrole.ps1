# Add to AKS approved list
#az aks get-credentials -n aks-egress -g aks-demo-rg
#az aks update -g aks-demo-rg -n aks-egress --api-server-authorized-ip-ranges $CURRENT_IP

$VNETID=$(az network vnet show -g 'aks-demo-rg' --name 'spoke-hub' --query id -o tsv)
$APPID='f3769645-52c3-4bf6-bf30-18e211558b8b'

az role assignment create --assignee $APPID --scope $VNETID --role "Network Contributor"

#78b266d7-1f27-4607-9a72-7e18c464edef
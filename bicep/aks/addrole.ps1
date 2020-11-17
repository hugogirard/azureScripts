# Add to AKS approved list
# az aks get-credentials -n aks-egress -g aks-demo-rg
# az aks update -g aks-demo-rg -n aks-egress --api-server-authorized-ip-ranges  76.68.175.224
# $SERVICE_IP=$(k get svc voting-app -o jsonpath='{.status.loadBalancer.ingress[*].ip}')
# $FWPUBLIC_IP='40.88.208.26'
# az network firewall nat-rule create --collection-name exampleset --destination-addresses $FWPUBLIC_IP --destination-ports 80 --firewall-name azureFw --name inboundrule --protocols Any --resource-group aks-demo-rg --source-addresses '*' --translated-port 80 --action Dnat --priority 100 --translated-address $SERVICE_IP
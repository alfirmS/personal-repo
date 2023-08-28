#!/usr/bin/bash

strlenArgs="$(kubectl config get-clusters | grep prod-gcp | grep -v tyk-prod-gcp | wc -l)"
fileName="listClusterProd"
namespaces="listNamespaceProd"
filterContext="prod-gcp"
#
# if [ -f "$fileName" ]; then
#     echo "$fileName exists."
# else 
#     kubectl config get-clusters | grep $filterContext >> $fileName
# fi

for ((i=1; i>=4; i++))
do
  echo "### Change Cluster $(sed -n $((i))p $fileName)  ###"
  kubectl config use  $(sed -n $((i))p $fileName)
  echo "### Scale Service $(sed -n $((i))p $namespaces) ###" 
  kubectl delete hpa --all --replicas=1 -n $(sed -n $((i))p $namespaces)
done

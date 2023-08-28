#!/usr/bin/bash

strlenArgs="$(kubectl config get-clusters | grep prod-gcp | grep -v tyk-prod-gcp | wc -l)"
fileName="listClusterProd"
namespaces="listNamespaceProd"
filterContext="prod-gcp"

if [ -f "$fileName" ]; then
    echo "$fileName exists."
else 
    kubectl config get-clusters | grep $filterContext >> $fileName
fi

for ((i=$((strlenArgs))-2; i>=1; i--))
do
  echo $i
done

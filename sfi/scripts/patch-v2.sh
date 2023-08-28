#!/bin/zsh

strlenArgs="$(ls -1 | wc -l)"

# for ((i=1; i<=$((strlenArgs)); i++))
# do
#   git -C $(ls -1 | sed -n $((i))p) reset --hard
#   git -C $(ls -1 | sed -n $((i))p) pull origin $(git -C $(ls -1 | sed -n $((i))p) rev-parse --abbrev-ref HEAD)
#   patch -f -d $(ls -1 | sed -n $((i))p)/helm/*-gcp/templates < /tmp/hpa.patch
#   rm -rf $(ls -1 | sed -n $((i))p)/helm/$(ls -1 | sed -n $((i))p)-gcp/templates/hpa.yaml.orig
# done

for ((i=1; i<=$((strlenArgs)); i++))
do
  git -C $(ls -1 | sed -n $((i))p) add .
  git -C $(ls -1 | sed -n $((i))p) commit -m "fix(prod) update version manifest hpa.yaml to v2"
  git -C $(ls -1 | sed -n $((i))p) push origin $(git -C $(ls -1 | sed -n $((i))p) rev-parse --abbrev-ref HEAD) 
done

for ((i=1; i<=$((strlenArgs)); i++))
do
  rm -f $(ls -1 | sed -n $((i))p)/helm/template/configmap.yaml $(ls -1 | sed -n $((i))p)/helm/template/secret.yaml
done


# for ((i=1; i<=$((strlenArgs))-2; i++))
# do
#   echo "### Change Cluster $(sed -n $((i))p $fileName)  ###"
#   kubectl config use  $(sed -n $((i))p $fileName)
#   echo "### Scale Service $(sed -n $((i))p $namespaces) ###" 
#   kubectl scale deploy --all --replicas=0 -n $(sed -n $((i))p $namespaces)
# done


# ls -l \
#   | xargs -I {} bash -c "git -C {} pull origin $(git -C {} rev-parse --abbrev-ref HEAD) \
#   && patch -d {}/helm/{}-gcp/templates < /tmp/hpa.patch" 
# ls -l | xargs -I {} bash -c "git -C {} add . \
#   && git -c {} commit -m 'update hpa.yaml v2' \
#   && git push origin $(git -C {} rev-parse --abbrev-ref HEAD)"

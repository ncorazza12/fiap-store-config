#!/bin/bash
# testa-rbac.sh

echo "| Recurso/Verbo | dev (Dev) | dev (Prod) | qa (Dev) | qa (Prod) | sre (Dev) | sre (Prod) | auditor (Dev) | auditor (Prod) |"
echo "|---|---|---|---|---|---|---|---|---|"

VERBOS=(
  "get pods"
  "create pods"
  "get pods/log"
  "create pods/exec"
  "get secrets"
  "create deployments"
  "create jobs"
  "delete jobs"
  "get rolebindings"
  "get nodes"
  "create clusterrolebindings"
  "get persistentvolumes"
  "create services"
  "delete configmaps"
)

for v in "${VERBOS[@]}"; do
  LINHA="| $v |"
  for g in dev qa sre auditor; do
    for ns in store-dev store-prod; do
      if [[ "$v" == "get nodes" || "$v" == "create clusterrolebindings" || "$v" == "get persistentvolumes" ]]; then
        RES=$(kubectl auth can-i $v --as=teste.$g --as-group=fiap:$g 2>/dev/null)
      else
        RES=$(kubectl auth can-i $v -n $ns --as=teste.$g --as-group=fiap:$g 2>/dev/null)
      fi
      LINHA+=" $RES |"
    done
  done
  echo "$LINHA"
done

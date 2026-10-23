Recurso/Verbo,dev (Dev),dev (Prod),qa (Dev),qa (Prod),sre (Dev),sre (Prod),auditor (Dev),auditor (Prod)
get pods,yes,yes,yes,yes,yes,yes,yes,yes
create pods,yes,no,no,no,yes,yes,no,no
get pods/log,yes,yes,yes,yes,yes,yes,yes,yes
create pods/exec,yes,no,no,no,yes,yes,no,no
get secrets,no,no,no,no,yes,yes,no,no
create deployments,yes,no,no,no,yes,yes,no,no
create jobs,yes,no,yes,no,yes,yes,no,no
delete jobs,yes,no,yes,no,yes,yes,no,no
get rolebindings,no,yes,yes,yes,no,no,yes,yes
get nodes,no,no,no,no,yes,yes,no,no
create clusterrolebindings,no,no,no,no,no,no,no,no
get persistentvolumes,no,no,no,no,yes,yes,no,no
create services,yes,no,no,no,yes,yes,no,no
delete configmaps,yes,no,no,no,yes,yes,no,no

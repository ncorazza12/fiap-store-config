# Checklist de Produção (FIAP Store)

- [x] **Namespace isolado:** Ambientes separados (`store-dev` e `store-prod`).
- [x] **Resource Quotas & Limit Ranges:** Quota aplicada no `store-prod` limitando CPU e Memória global.
- [x] **Requests e Limits:** Configurados no patch do Kustomize para a API.
- [x] **Probes (Liveness/Readiness):** ReadinessProbe implementada e validada no Exercício 10.3.
- [x] **Graceful Shutdown:** `preStop` hook (sleep 10) e `terminationGracePeriodSeconds` configurados.
- [x] **PodDisruptionBudget (PDB):** Criado no overlay de prod garantindo `minAvailable: 2`.
- [x] **HorizontalPodAutoscaler (HPA):** Criado no overlay de prod para escalar baseado em CPU.
- [x] **Network Policies:** Política `default-deny` aplicada isolando o tráfego do namespace.
- [x] **Pod Security Admission (PSA):** `store-prod` enforcing perfil `restricted`.
- [x] **SecurityContext:** `runAsNonRoot`, `drop: ["ALL"]` e `readOnlyRootFilesystem` aplicados.
- [-] **ServiceMonitor:** Não aplicável (cluster local sem stack do Prometheus Operator instalado).

---

### Análise Serverless (AWS Lambda) vs Kubernetes

Na migração de um container (store-api) para AWS Lambda, a linha de responsabilidade compartilhada se move significativamente. 
Um item do checklist que **deixa de fazer sentido** é o *Pod Security Admission (PSA) / SecurityContext*: no Lambda, a AWS gerencia inteiramente o microVM (Firecracker) e o isolamento do processo, tornando obsoletas configurações manuais de `runAsNonRoot` ou `drop capabilities`. 
Por outro lado, um item que **continua exatamente igual** é a *Configuração de Limite de Memória e Timeout*: mesmo no Lambda, o desenvolvedor precisa definir explicitamente quanta memória a função alocará e o tempo máximo de execução, sob risco de a função ser abortada por OOM (Out Of Memory) ou gerar custos descontrolados.

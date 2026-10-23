# FIAP Store Kubernetes Config - Entrega Final CP3

**Aluno:** Nickolas Corazza Alves[cite: 2]  
**RM:** 562265[cite: 2]  
**Disciplina:** Kubernetes & Container Orchestration[cite: 2]  

Este repositório contém a entrega final do Checkpoint 3, abrangendo as práticas avançadas de Kubernetes divididas em quatro capítulos principais: Cargas de Trabalho (Cap 8), Controle de Acesso e RBAC (Cap 9), Segurança e Empacotamento (Cap 10) e GitOps (Cap 11)[cite: 2].

## 📁 Estrutura do Repositório

- `docs/`: Documentações técnicas e relatórios (`ANALISE.md`, `CHECKLIST.md`, `COMPARACAO.md`, `COMPARA_PSA.md`, `COMPARACAO_VULN.md`, `DEPURACAO.md`, `EVIDENCIAS.md`, `RELATORIO.md`, `MATRIZ.md`)[cite: 2].
- `k8s/`: Estrutura Kustomize contendo `base` e os overlays de `dev` e `prod` (Fonte de verdade do Argo CD)[cite: 2].
- `docker-trivy/`: Arquivos Docker, relatórios do Trivy e o SBOM CycloneDX[cite: 2].
- `manifestos-avulsos/`: YAMLs utilizados nos laboratórios isolados (Jobs, CronJobs, Secrets) e configurações RBAC (Roles, Bindings, Certificados e kubeconfigs)[cite: 2].
- `Prints_Evidencias/`: Provas de execução de cada etapa[cite: 2].
- `app-prod.yaml`: Application manifesto do Argo CD[cite: 2].
- `Makefile`: Automação de deploy, scan e destroy[cite: 2].

---

## 📸 Evidências Práticas (Prints do Laboratório)

### Capítulo 8 - Cargas de Trabalho e Desafios[cite: 2]

**8.1 Jobs Paralelos e Indexados:**[cite: 2]
- Pods paralelos limitados a 3 simultâneos:[cite: 2]
  ![Evidência 1](./Prints_Evidencias/print-XX.png)
- Conclusão do Job (10/10):[cite: 2]
  ![Evidência 2](./Prints_Evidencias/print-XX.png)
- Logs com LOTE OK:[cite: 2]
  ![Evidência 3](./Prints_Evidencias/print-XX.png)
- Logs dos Jobs Indexados (0, 1, 2 e 3):[cite: 2]
  ![Evidência 4](./Prints_Evidencias/print-XX.png)

**8.2 CronJobs e Secrets:**[cite: 2]
- Concorrência Allow (Pods simultâneos):[cite: 2]
  ![Evidência Allow](./Prints_Evidencias/print-XX.png)
- Concorrência Forbid (Skipping):[cite: 2]
  ![Evidência Forbid](./Prints_Evidencias/print-XX.png)
- Atualização do Secret reflete no Volume, não no Env:[cite: 2]
  ![Evidência Secret](./Prints_Evidencias/print-XX.png)

**8.3 Depuração de Falhas:**[cite: 2]
- Cenário A (Erro de Job BackoffLimit):[cite: 2]
  ![Evidência 1 Cenário A](./Prints_Evidencias/print-XX.png)
  ![Evidência 2 Cenário A](./Prints_Evidencias/print-XX.png)
- Cenário C (Service e Endpoints quebrados):[cite: 2]
  ![Evidência 1 Cenário C](./Prints_Evidencias/print-XX.png)
  ![Evidência 2 Cenário C](./Prints_Evidencias/print-XX.png)
  ![Evidência 3 Cenário C](./Prints_Evidencias/print-XX.png)

**8.4 KEDA (Escala a Zero):**[cite: 2]
- Escala a Zero Pods:[cite: 2]
  ![Evidência 1a KEDA](./Prints_Evidencias/print-XX.png)
- Pico de Escalonamento:[cite: 2]
  ![Evidência 1b KEDA](./Prints_Evidencias/print-XX.png)
- Retorno a Zero e Eventos HPA:[cite: 2]
  ![Evidência 1c KEDA](./Prints_Evidencias/print-XX.png)
  ![Evidência 2 KEDA](./Prints_Evidencias/print-XX.png)

---

### Capítulo 9 - Controle de Acesso (RBAC) e Identidades

**9.1 ServiceAccount somente-leitura:**
- Testes de permissão com `can-i`:
  ![Evidência can-i](./Prints_Evidencias/print-XX.png)
- Payload JWT decodificado:
  ![Evidência JWT](./Prints_Evidencias/print-XX.png)
- Validação de acesso de dentro do Pod (Retornos HTTP 200 e 403):
  ![Evidência curl](./Prints_Evidencias/print-XX.png)

**9.2 Usuário por Certificado (João QA):**
- Geração e extração do Subject no Certificado:
  ![Evidência Certificado](./Prints_Evidencias/print-XX.png)
- Acesso negado com 403 (Prova de autenticação sem autorização):
  ![Evidência 403](./Prints_Evidencias/print-XX.png)
- Herança de permissão pelo grupo fiap:qa (RoleBinding view):
  ![Evidência QA View](./Prints_Evidencias/print-XX.png)
- Restrição do `exec` ao namespace store-dev (Falha no store-prod):
  ![Evidência Exec Restrito](./Prints_Evidencias/print-XX.png)
- Revogação de acesso (Retorno ao 403):
  ![Evidência Revogacao](./Prints_Evidencias/print-XX.png)

**9.3 Depuração de Cenários (Forbidden):**
- Cenário A (Correção de subresource pods/log):
  ![Evidência Cenário A](./Prints_Evidencias/print-XX.png)
- Cenário B (Correção do apiGroup apps para Deployments):
  ![Evidência Cenário B](./Prints_Evidencias/print-XX.png)
- Cenário C (Verbos ocultos get/patch no apply):
  ![Evidência Cenário C](./Prints_Evidencias/print-XX.png)
- Cenário D (Isolamento de RoleBinding por Namespace):
  ![Evidência Cenário D](./Prints_Evidencias/print-XX.png)

**9.4 Desafio Integrador:**
- Execução automatizada e geração da Matriz RBAC para perfis (dev, qa, sre, auditor):
  ![Evidência Matriz](./Prints_Evidencias/print-XX.png)

---

### Capítulo 10 - Segurança, Vulnerabilidades e Kustomize[cite: 2]

**10.1 Pod Security Admission:**[cite: 2]
- Namespace em modo Restricted:[cite: 2]
  ![Evidência 1 PSA](./Prints_Evidencias/print-XX.png)
- Pods baseline executando:[cite: 2]
  ![Evidência 2 PSA](./Prints_Evidencias/print-XX.png)
- Bloqueio de Pod Privilegiado:[cite: 2]
  ![Evidência 3 PSA](./Prints_Evidencias/print-XX.png)
- Execução como Não Root (UID 65532):[cite: 2]
  ![Evidência 5 PSA](./Prints_Evidencias/print-XX.png)

**10.2 Vulnerabilidades e Distroless:**[cite: 2]
- Imagem pesada (mais de 1GB):[cite: 2]
  ![Evidência 1 Trivy](./Prints_Evidencias/print-XX.png)
- Processo Root Vulnerável:[cite: 2]
  ![Evidência 2 Trivy](./Prints_Evidencias/print-XX.png)
- Processo Otimizado Não Root:[cite: 2]
  ![Evidência 4 Trivy](./Prints_Evidencias/print-XX.png)

**10.3 Zero-Downtime Deploy:**[cite: 2]
- Deploy Quebrado (502/Timeout):[cite: 2]
  ![Evidência 1 Rollout](./Prints_Evidencias/print-XX.png)
- Deploy Seguro (Zero-downtime contínuo):[cite: 2]
  ![Evidência 2 Rollout](./Prints_Evidencias/print-XX.png)

**10.4 Kustomize (Ambientes Isolados):**[cite: 2]
- Ambiente DEV:[cite: 2]
  ![Evidência 1 Kustomize](./Prints_Evidencias/print-XX.png)
- Ambiente PROD (Seguro e com Quotas):[cite: 2]
  ![Evidência 2 Kustomize](./Prints_Evidencias/print-XX.png)

---

### Capítulo 11 - GitOps com Argo CD[cite: 2]

**11.1 e 11.2 - Sincronização e Self-Heal:**[cite: 2]
- ArgoCD provando a auto-recuperação após deleção de um Service:[cite: 2]
  ![Evidência Self-Heal](./Prints_Evidencias/print-XX.png)
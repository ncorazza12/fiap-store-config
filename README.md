# FIAP Store Kubernetes Config - Entrega Final CP3

**Aluno:** Nickolas Corazza Alves  
**RM:** 562265  
**Disciplina:** Kubernetes & Container Orchestration  

Este repositório contém a entrega final do Checkpoint 3, abrangendo as práticas avançadas de Kubernetes divididas em quatro capítulos principais: Cargas de Trabalho (Cap 8), Controle de Acesso e RBAC (Cap 9), Segurança e Empacotamento (Cap 10) e GitOps (Cap 11).

## 📁 Estrutura do Repositório

- docs/: Documentações técnicas e relatórios (ANALISE.md, CHECKLIST.md, COMPARACAO.md, COMPARA_PSA.md, COMPARACAO_VULN.md, DEPURACAO.md, EVIDENCIAS.md, MATRIZ.md, RELATORIO.md).
- k8s/: Estrutura Kustomize contendo ase e os overlays de dev e prod (Fonte de verdade do Argo CD).
- docker-trivy/: Arquivos Docker, relatórios do Trivy e o SBOM CycloneDX.
- manifestos-avulsos/: YAMLs utilizados nos laboratórios isolados e configurações RBAC.
- Prints_Evidencias/: Provas de execução de cada etapa (renderizadas abaixo).
- pp-prod.yaml: Application manifesto do Argo CD.
- Makefile: Automação de deploy, scan e destroy.

---

## 📸 Evidências Práticas (Prints do Laboratório)

### Capítulo 8 - Cargas de Trabalho e Desafios

**8.1 Jobs Paralelos e Indexados:**
- Pods paralelos limitados a 3 simultâneos:
  ![Evidência 1](./Prints_Evidencias/print-09.png)
- Conclusão do Job (10/10):
  ![Evidência 2](./Prints_Evidencias/print-20.png)
- Logs com LOTE OK:
  ![Evidência 3](./Prints_Evidencias/print-26.png)
- Logs dos Jobs Indexados (0, 1, 2 e 3):
  ![Evidência 4](./Prints_Evidencias/print-29.png)

**8.2 CronJobs e Secrets:**
- Concorrência Allow (Pods simultâneos):
  ![Evidência Allow](./Prints_Evidencias/print-14.png)
- Concorrência Forbid (Skipping):
  ![Evidência Forbid](./Prints_Evidencias/print-22.png)
- Atualização do Secret reflete no Volume, não no Env:
  ![Evidência Secret](./Prints_Evidencias/print-07.png)

**8.3 Depuração de Falhas:**
- Cenário A (Erro de Job BackoffLimit):
  ![Evidência 1 Cenário A](./Prints_Evidencias/print-03.png)
  ![Evidência 2 Cenário A](./Prints_Evidencias/print-15.png)
- Cenário C (Service e Endpoints quebrados):
  ![Evidência 1 Cenário C](./Prints_Evidencias/print-04.png)
  ![Evidência 2 Cenário C](./Prints_Evidencias/print-01.png)
  ![Evidência 3 Cenário C](./Prints_Evidencias/print-21.png)

**8.4 KEDA (Escala a Zero):**
- Escala a Zero Pods:
  ![Evidência 1a KEDA](./Prints_Evidencias/print-11.png)
- Pico de Escalonamento:
  ![Evidência 1b KEDA](./Prints_Evidencias/print-12.png)
- Retorno a Zero e Eventos HPA:
  ![Evidência 1c KEDA](./Prints_Evidencias/print-13.png)
  ![Evidência 2 KEDA](./Prints_Evidencias/print-02.png)

---

### Capítulo 9 - Controle de Acesso (RBAC) e Identidades

**9.1 ServiceAccount somente-leitura:**
- Testes de permissão com can-i:
  ![Evidência can-i](./Prints_Evidencias/print-31.png)
- Payload JWT decodificado:
  ![Evidência JWT](./Prints_Evidencias/print-32.png)
- Validação de acesso do Pod (HTTP 200/403):
  ![Evidência curl](./Prints_Evidencias/print-33.png)

**9.2 Usuário por Certificado:**
- Geração e extração do Subject no Certificado:
  ![Evidência Certificado](./Prints_Evidencias/print-34.png)
- Acesso negado com 403:
  ![Evidência 403](./Prints_Evidencias/print-35.png)
- Herança de permissão pelo grupo (RoleBinding view):
  ![Evidência View](./Prints_Evidencias/print-36.png)
- Restrição do exec ao store-dev:
  ![Evidência Exec](./Prints_Evidencias/print-37.png)
- Revogação de acesso (403):
  ![Evidência Revogacao](./Prints_Evidencias/print-38.png)

**9.3 Depuração de Cenários:**
- Cenário A (pods/log):
  ![Evidência Cenário A](./Prints_Evidencias/print-39.png)
- Cenário B (apiGroup apps):
  ![Evidência Cenário B](./Prints_Evidencias/print-40.png)
- Cenário C (verbos get/patch no apply):
  ![Evidência Cenário C](./Prints_Evidencias/print-41.png)
- Cenário D (RoleBinding por Namespace):
  ![Evidência Cenário D](./Prints_Evidencias/print-42.png)

**9.4 Desafio Integrador:**
- Matriz RBAC para perfis (dev, qa, sre, auditor):
  ![Evidência Matriz](./Prints_Evidencias/print-28.png)

---

### Capítulo 10 - Segurança, Vulnerabilidades e Kustomize

**10.1 Pod Security Admission:**
- Namespace em modo Restricted:
  ![Evidência 1 PSA](./Prints_Evidencias/print-10.png)
- Pods baseline executando:
  ![Evidência 2 PSA](./Prints_Evidencias/print-18.png)
- Bloqueio de Pod Privilegiado:
  ![Evidência 3 PSA](./Prints_Evidencias/print-24.png)
- Execução como Não Root (UID 65532):
  ![Evidência 5 PSA](./Prints_Evidencias/print-30.png)

**10.2 Vulnerabilidades e Distroless:**
- Imagem pesada (mais de 1GB):
  ![Evidência 1 Trivy](./Prints_Evidencias/print-08.png)
- Processo Root Vulnerável:
  ![Evidência 2 Trivy](./Prints_Evidencias/print-17.png)
- Processo Otimizado Não Root:
  ![Evidência 4 Trivy](./Prints_Evidencias/print-27.png)

**10.3 Zero-Downtime Deploy:**
- Deploy Quebrado (502/Timeout):
  ![Evidência 1 Rollout](./Prints_Evidencias/print-05.png)
- Deploy Seguro (Zero-downtime contínuo):
  ![Evidência 2 Rollout](./Prints_Evidencias/print-19.png)

**10.4 Kustomize (Ambientes Isolados):**
- Ambiente DEV:
  ![Evidência 1 Kustomize](./Prints_Evidencias/print-06.png)
- Ambiente PROD (Seguro e com Quotas):
  ![Evidência 2 Kustomize](./Prints_Evidencias/print-16.png)

---

### Capítulo 11 - GitOps com Argo CD

**11.1 e 11.2 - Sincronização e Self-Heal:**
- ArgoCD provando a auto-recuperação:
  ![Evidência Self-Heal](./Prints_Evidencias/print-23.png)

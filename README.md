# FIAP Store Kubernetes Config - Entrega Final CP3

**Aluno:** Nickolas Corazza Alves  
**RM:** 562265  
**Disciplina:** Kubernetes & Container Orchestration  

Este repositório contém a entrega final do Checkpoint 3, abrangendo as práticas avançadas de Kubernetes divididas em três capítulos principais: Cargas de Trabalho (Cap 8), Segurança e Empacotamento (Cap 10) e GitOps (Cap 11).

## 📁 Estrutura do Repositório

- `docs/`: Documentações técnicas (`ANALISE.md`, `CHECKLIST.md`, `COMPARACAO.md`, `COMPARA_PSA.md`, `COMPARACAO_VULN.md`, `DEPURACAO.md`).
- `k8s/`: Estrutura Kustomize contendo `base` e os overlays de `dev` e `prod` (Fonte de verdade do Argo CD).
- `docker-trivy/`: Arquivos Docker, relatórios do Trivy e o SBOM CycloneDX.
- `manifestos-avulsos/`: YAMLs utilizados nos laboratórios isolados (Jobs, CronJobs, Secrets).
- `Prints_Evidencias/`: Provas de execução de cada etapa (renderizadas abaixo).
- `app-prod.yaml`: Application manifesto do Argo CD.
- `Makefile`: Automação de deploy, scan e destroy.

---

## 📸 Evidências Práticas (Prints do Laboratório)

### Capítulo 8 - Cargas de Trabalho e Desafios

**8.1 Jobs Paralelos e Indexados:**
- Pods paralelos limitados a 3 simultâneos:
  ![Evidência 1](<./Prints_Evidencias/EVIDÊNCIA 1 - Tire dois prints em momentos distintos provando que existem no maximo 3 Pods com o status Running ou ContainerCreating ao mesmo tempo.png>)
- Conclusão do Job (10/10):
  ![Evidência 2](<./Prints_Evidencias/EVIDÊNCIA 2 Quando a coluna COMPLETIONS chegar a 10-10, tire um print. (Pressione Ctrl+C para sair do modo watch).png>)
- Logs com LOTE OK:
  ![Evidência 3](<./Prints_Evidencias/EVIDÊNCIA 3 Tire print desta saída. Você deve ver 10 linhas contendo LOTE OK e os respectivos hostnames.png>)
- Logs dos Jobs Indexados (0, 1, 2 e 3):
  ![Evidência 4](<./Prints_Evidencias/EVIDÊNCIA 4 - Tire print desta tela A saída deve mostrar exatamente os índices 0, 1, 2 e 3 impressos, sem repeticoes.png>)

**8.2 CronJobs e Secrets:**
- Concorrência Allow (Pods simultâneos):
  ![Evidência Allow](<./Prints_Evidencias/EVIDÊNCIA 2 (Allow) - Quando você vir dois Pods do CronJob em Running ao mesmo tempo, tire um print!.png>)
- Concorrência Forbid (Skipping):
  ![Evidência Forbid](<./Prints_Evidencias/EVIDÊNCIA 3 (Forbid) - Vá até o final da saída, na seção Events. Você verá algo como JobAlreadyActive - Job already active, skipping.png>)
- Atualização do Secret reflete no Volume, não no Env:
  ![Evidência Secret](<./Prints_Evidencias/EVIDÊNCIA 1 (Secret) - Tire o print mostrando o printenv API_TOKEN (que retornou o valor velho) e esse comando do cat -etc-catalogo-API_TOKEN (que vai retornar o valor novo)..png>)

**8.3 Depuração de Falhas:**
- Cenário A (Erro de Job BackoffLimit):
  ![Evidência 1 Cenário A](<./Prints_Evidencias/EVIDÊNCIA 1 (Cenário A - Pods) - Tire um print mostrando exatamente os 3 Pods em Error (1 tentativa inicial + 2 retentativas do backoffLimit 2)..png>)
  ![Evidência 2 Cenário A](<./Prints_Evidencias/EVIDÊNCIA 2 (Cenário A - Describe) - Tire um print do final da saída, mostrando a Warning nos Events com o motivo BackoffLimitExceeded.png>)
- Cenário C (Service e Endpoints quebrados):
  ![Evidência 1 Cenário C](<./Prints_Evidencias/EVIDÊNCIA 1 (Cenário C) - A coluna ENDPOINTS estará vazia (0 endpoints).png>)
  ![Evidência 2 Cenário C](<./Prints_Evidencias/Captura de tela 2026-10-23 171235EVIDÊNCIA 2 (Cenário C) - O comando vai falhar com wget - download timed out.png>)
  ![Evidência 3 Cenário C](<./Prints_Evidencias/EVIDÊNCIA 3 (Cenário C) - Agora sim, a coluna ENDPOINTS não terá nenhum IP válido mapeado.png>)

**8.4 KEDA (Escala a Zero):**
- Escala a Zero Pods:
  ![Evidência 1a KEDA](<./Prints_Evidencias/EVIDÊNCIA 1a (Zero Pods) - O comando deve retornar No resources found in store-dev namespace.png>)
- Pico de Escalonamento:
  ![Evidência 1b KEDA](<./Prints_Evidencias/EVIDÊNCIA 1b (Pico) - Assim que você ver vários Pods rodando (N Pods) na tela do watch.png>)
- Retorno a Zero e Eventos HPA:
  ![Evidência 1c KEDA](<./Prints_Evidencias/EVIDÊNCIA 1c (Volta a Zero) - Quando todos os Pods sumirem e a tela voltar a mostrar No resources found, tire seu terceiro print.png>)
  ![Evidência 2 KEDA](<./Prints_Evidencias/Captura de tela 2026-10-23 1EVIDÊNCIA 2 (Eventos KEDA) - Tire um print do final da saída, focando na seção Events e Status73953.png>)

---

### Capítulo 10 - Segurança, Vulnerabilidades e Kustomize

**10.1 Pod Security Admission:**
- Namespace em modo Restricted:
  ![Evidência 1 PSA](<./Prints_Evidencias/EVIDÊNCIA 1 - Tire um print mostrando as labels aplicadas no namespace restrito.png>)
- Pods baseline executando:
  ![Evidência 2 PSA](<./Prints_Evidencias/EVIDÊNCIA 2 - Tire print dos 2 Pods em estado Running 1-1.png>)
- Bloqueio de Pod Privilegiado:
  ![Evidência 3 PSA](<./Prints_Evidencias/EVIDÊNCIA 3 - Tire print do erro. A mensagem será Error from server (Forbidden) - ... violates PodSecurity restricted, listando todas as violações encontradas.png>)
- Execução como Não Root (UID 65532):
  ![Evidência 5 PSA](<./Prints_Evidencias/EVIDÊNCIA 5 - Tire print da saída. Você verá uid=65532 gid=0(root) groups=65532. Isso comprova que a aplicação não rodou como root.png>)

**10.2 Vulnerabilidades e Distroless:**
- Imagem pesada (mais de 1GB):
  ![Evidência 1 Trivy](<./Prints_Evidencias/EVIDÊNCIA 1 - Anote o tamanho que aparece na coluna SIZE (provavelmente passará de 1GB). Pode tirar um print.png>)
- Processo Root Vulnerável:
  ![Evidência 2 Trivy](<./Prints_Evidencias/EVIDÊNCIA 2 - Tire print da saída. Como não definimos a instrução USER, ela retornará uid=0(root) gid=0(root).png>)
- Processo Otimizado Não Root:
  ![Evidência 4 Trivy](<./Prints_Evidencias/EVIDÊNCIA 4 - A saída será 65532, provando que o processo não é root.png>)

**10.3 Zero-Downtime Deploy:**
- Deploy Quebrado (502/Timeout):
  ![Evidência 1 Rollout](<./Prints_Evidencias/EVIDÊNCIA 1 (Falha no Rollout) - Tire um print do terminal mostrando as mensagens de FALHA! Isso prova o impacto negativo (downtime) do deploy mal configurado.png>)
- Deploy Seguro (Zero-downtime contínuo):
  ![Evidência 2 Rollout](<./Prints_Evidencias/EVIDÊNCIA 2 - Você não verá nenhuma mensagem de FALHA durante todo o processo. Tire um print dos OKs contínuos provando o zero downtime! (Pode apertar Ctrl+C para encerrar depois).png>)

**10.4 Kustomize (Ambientes Isolados):**
- Ambiente DEV:
  ![Evidência 1 Kustomize](<./Prints_Evidencias/EVIDÊNCIA 1 (Kustomize Dev) - Tire um print desse comando kubectl get all -n store-dev mostrando a API e o Front rodando.png>)
- Ambiente PROD (Seguro e com Quotas):
  ![Evidência 2 Kustomize](<./Prints_Evidencias/EVIDÊNCIA 2 (Kustomize Prod) - Tire um print desse comando mostrando as 3 réplicas, PDB, HPA e Quota criados e isolados do ambiente Dev.png>)

---

### Capítulo 11 - GitOps com Argo CD

**11.1 e 11.2 - Sincronização e Self-Heal:**
- ArgoCD provando a auto-recuperação após deleção de um Service:
  ![Evidência Self-Heal](<./Prints_Evidencias/EVIDÊNCIA 3 (Self-Heal) - Tire o seu print final dessa saída provando que o Argo CD manteve tudo saudável e sincronizado!.png>)

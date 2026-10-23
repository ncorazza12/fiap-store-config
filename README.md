# FIAP Store Kubernetes Config - Entrega Final CP3

**Aluno:** Nickolas Corazza Alves  
**RM:** 562265  
**Disciplina:** Kubernetes & Container Orchestration  

Este repositório contém a entrega final do Checkpoint 3, abrangendo as práticas avançadas de Kubernetes divididas em três capítulos principais: Cargas de Trabalho (Cap 8), Segurança e Empacotamento (Cap 10) e GitOps (Cap 11).

## 📁 Estrutura do Repositório

Toda a organização reflete o padrão de mercado para projetos GitOps e manifestos Kubernetes:

- `docs/`: Contém todas as documentações técnicas (`ANALISE.md`, `CHECKLIST.md`, `COMPARACAO.md`, `COMPARA_PSA.md`, `COMPARACAO_VULN.md`, `DEPURACAO.md`).
- `k8s/`: Estrutura Kustomize contendo `base` e os overlays de `dev` e `prod` (Fonte de verdade do Argo CD).
- `docker-trivy/`: Arquivos Docker (`Dockerfile.vuln`, `Dockerfile.secure`), relatórios do Trivy e o SBOM em formato CycloneDX.
- `manifestos-avulsos/`: YAMLs utilizados nos laboratórios isolados (Jobs, CronJobs, Secrets, Depuração).
- `Prints_Evidencias/`: Provas de execução de cada etapa.
- `app-prod.yaml`: Application manifesto do Argo CD.
- `Makefile`: Automação de deploy, scan e destroy.

---

## 📸 Mapeamento das Evidências (Prints)

Todas as capturas de tela solicitadas estão na pasta `Prints_Evidencias/` com seus nomes de origem gerados durante o laboratório. Abaixo, o índice de onde cada prova se encaixa:

### Capítulo 8 - Cargas de Trabalho e Desafios
* **8.1 Jobs Paralelos e Indexados:**
  * `EVIDÊNCIA 1 - Tire dois prints em momentos distintos provando que existem no maximo 3 Pods...`
  * `EVIDÊNCIA 2 Quando a coluna COMPLETIONS chegar a 10-10...`
  * `EVIDÊNCIA 3 Tire print desta saída. Você deve ver 10 linhas contendo LOTE OK...`
  * `EVIDÊNCIA 4 - Tire print desta tela A saída deve mostrar exatamente os índices 0, 1, 2 e 3 impressos...`
* **8.2 CronJobs e Secrets:**
  * `EVIDÊNCIA 2 (Allow) - Quando você vir dois Pods do CronJob em Running...`
  * `EVIDÊNCIA 3 (Forbid) - Vá até o final da saída, na seção Events...`
  * `EVIDÊNCIA 1 (Secret) - Tire o print mostrando o printenv API_TOKEN...`
* **8.3 Depuração de Falhas:**
  * `EVIDÊNCIA 1 (Cenário A - Pods) - Tire um print mostrando exatamente os 3 Pods em Error...`
  * `EVIDÊNCIA 2 (Cenário A - Describe) - Tire um print do final da saída...`
  * `EVIDÊNCIA 1 (Cenário C) - A coluna ENDPOINTS estará vazia...`
  * `Captura de tela 2026-10-23 171235EVIDÊNCIA 2 (Cenário C) - O comando vai falhar com wget...`
  * `EVIDÊNCIA 3 (Cenário C) - Agora sim, a coluna ENDPOINTS não terá nenhum IP válido mapeado.png`
* **8.4 KEDA (Escala a Zero):**
  * `EVIDÊNCIA 1a (Zero Pods) - O comando deve retornar No resources found...`
  * `EVIDÊNCIA 1b (Pico) - Assim que você ver vários Pods rodando (N Pods)...`
  * `EVIDÊNCIA 1c (Volta a Zero) - Quando todos os Pods sumirem e a tela voltar a mostrar No resources found...`
  * `Captura de tela 2026-10-23 1EVIDÊNCIA 2 (Eventos KEDA)...`

### Capítulo 10 - Segurança, Vulnerabilidades e Kustomize
* **10.1 Pod Security Admission:**
  * `EVIDÊNCIA 1 - Tire um print mostrando as labels aplicadas no namespace restrito.png`
  * `EVIDÊNCIA 2 - Tire print dos 2 Pods em estado Running 1-1.png`
  * `EVIDÊNCIA 3 - Tire print do erro. A mensagem será Error from server (Forbidden)...`
  * `EVIDÊNCIA 5 - Tire print da saída. Você verá uid=65532...`
* **10.2 Vulnerabilidades e Distroless:**
  * `EVIDÊNCIA 1 - Anote o tamanho que aparece na coluna SIZE (provavelmente passará de 1GB)...`
  * `EVIDÊNCIA 2 - Tire print da saída. Como não definimos a instrução USER...`
  * `EVIDÊNCIA 4 - A saída será 65532, provando que o processo não é root.png`
* **10.3 Zero-Downtime Deploy:**
  * `EVIDÊNCIA 1 (Falha no Rollout) - Tire um print do terminal mostrando as mensagens de FALHA...`
  * `EVIDÊNCIA 2 - Você não verá nenhuma mensagem de FALHA durante todo o processo...`
* **10.4 Kustomize e Checklist:**
  * `EVIDÊNCIA 1 (Kustomize Dev) - Tire um print desse comando kubectl get all -n store-dev...`
  * `EVIDÊNCIA 2 (Kustomize Prod) - Tire um print desse comando mostrando as 3 réplicas, PDB, HPA e Quota...`

### Capítulo 11 - GitOps com Argo CD
* **11.1 e 11.2 Sincronização e Self-Heal:**
  * `EVIDÊNCIA 3 (Self-Heal) - Tire o seu print final dessa saída provando que o Argo CD manteve tudo saudável e sincronizado!.png`

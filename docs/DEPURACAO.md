### Exercício 10.3: Depuração de Rolling Update

**Tabela de Falhas por Correção**
Durante o processo de endurecimento do deploy, as taxas de falha em 100 requisições variaram conforme a tabela abaixo:

| Etapa | Correção Aplicada | Requisições falhadas (em 100) |
| :--- | :--- | :--- |
| **Original** | Nenhuma (versão quebrada) | ~ 15 a 25 falhas |
| **(a)** | readinessProbe em / | ~ 10 a 20 falhas |
| **(b)** | preStop (sleep 10) + terminationGracePeriod (45s) | ~ 5 a 10 falhas |
| **(c)** | ENTRYPOINT para forma exec | ~ 2 a 5 falhas |
| **(d)** | maxUnavailable: 0 e maxSurge: 1 | 0 falhas |
| **Final** | Todas em conjunto (Zero Downtime Deploy) | 0 falhas em 500+ reqs |

**Por que os Endpoints e o SIGTERM correm em paralelo?**
Quando o Kubernetes inicia o encerramento de um Pod durante um rollout, duas ações ocorrem simultaneamente e de forma assíncrona: (1) O painel de controle remove o IP do Pod da lista de Endpoints (atualizando o kube-proxy/iptables) e (2) O kubelet envia o sinal `SIGTERM` para o container. Como a propagação das regras de rede (iptables) pelos nós do cluster leva alguns segundos, se a aplicação morrer instantaneamente ao receber o `SIGTERM`, as requisições que ainda estavam em trânsito ou sendo roteadas pelas regras de iptables desatualizadas resultarão em erro 502/504 (FALHA). O hook `preStop` (ex: sleep 10) força o container a ignorar o desligamento por tempo suficiente para que a remoção do IP se propague por todo o cluster, garantindo que nenhum tráfego novo seja enviado a um Pod que está morrendo.
# Depuração de Falhas no Kubernetes

### Cenário A: Job estourado (backoffLimit)
- **(i) STATUS/estado observado:** Pods acumulados em status `Error` e Job não concluído (condição Failed).
- **(ii) Comando e mensagem:** O comando `kubectl describe job relatorio-quebrado` revelou a mensagem `reason: BackoffLimitExceeded` na seção Events.
- **(iii) Correção aplicada:** O container estava falhando propositalmente (código 1) ao tentar ler um arquivo inexistente. A correção foi editar o manifesto (`job-corrigido.yaml`) para executar um comando válido (`echo 'Relatório gerado com sucesso'`).
- **(iv) Evidência da correção:** Após recriar o Job, o comando `kubectl get pods` mostrou o Pod com status `Completed` e o Job atingiu a completude (1/1).

### Cenário B: Secret inválido e Quebra de Linha
- **(i) STATUS/estado observado:** Erro de requisição (BadRequest) ao tentar criar o primeiro Secret. No segundo teste, a senha mapeada no container possuía 1 caractere invisível a mais.
- **(ii) Comando e mensagem:** Na aplicação do primeiro manifesto, o erro exato foi `illegal base64 data`. No Pod de teste, ao executar `kubectl exec teste-secret -n store-dev -- sh -c 'echo "${#MINHA_SENHA}"'`, o tamanho retornado foi `6` (o esperado era 5).
- **(iii) Correção aplicada:** O Kubernetes exige Base64 válido e sem quebras de linha (`\n`). A correção (`secret-corrigido.yaml`) foi gerar o hash da senha usando `echo -n 'senha' | base64`, o que remove o caractere invisível.
- **(iv) Evidência da correção:** O arquivo corrigido contém o hash Base64 de exatamente 5 caracteres (`c2VuaGE=`).

### Cenário C: Service sem endpoints
- **(i) STATUS/estado observado:** Endpoints vazios no Service em duas situações distintas. Na primeira, por erro de digitação no seletor. Na segunda, por falha na verificação de saúde (readiness) do Pod.
- **(ii) Comando e mensagem:** O comando `kubectl get endpoints store-api-svc` retornou `<none>`, e o teste de conexão com `wget` resultou em `download timed out`. Na segunda etapa, `kubectl get pods` mostrou o Pod com status `0/1 READY` (rodando, mas barrado de receber tráfego).
- **(iii) Correção aplicada:** (1) Ajuste do `selector` no Service para `app: store-api` (com hífen, para bater exatamente com a label do Deployment). (2) Ajuste da `readinessProbe` apontando o path para `/` em vez de `/pronto`, que não existia.
- **(iv) Evidência da correção:** Em ambos os casos, após a correção, a saída de `kubectl get endpoints` voltou a ser populada com os IPs dos Pods que ficaram com status `1/1 Ready`.

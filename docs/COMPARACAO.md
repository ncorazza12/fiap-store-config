# Comparação Arquitetural: Processamento de Fila de Pedidos

Para a FIAP Store, o processamento de pedidos é uma tarefa crítica. Com o pico de acessos concentrado na Black Friday e um volume substancialmente menor no restante do ano, a escolha da arquitetura de processamento em background deve equilibrar performance, escalabilidade, limite de execução, tolerância a falhas e, principalmente, custos operacionais. Abaixo, contrastamos três arquiteturas distintas.

## 1. Job com Parallelism Fixo no Kubernetes
A abordagem tradicional com `Job` do Kubernetes utilizando `parallelism` fixo consiste em instanciar um número estático de Pods para consumir a fila. 
- **Comportamento sob pico (10.000 mensagens):** Ineficiente. Como o número de workers é estático, um pico de 10.000 mensagens formará um gargalo severo, aumentando a latência de entrega dos pedidos.
- **Latência de Cold Start:** Lenta. O agendamento de novos Pods no cluster, associado ao download da imagem (pull) e inicialização do processo, pode levar de dezenas de segundos a mais de um minuto.
- **Tempo de execução:** Ilimitado. Processos demorados (ex: geração de notas fiscais pesadas) rodam o tempo que for necessário.
- **Tratamento de falhas:** Kubernetes gerencia retentativas nativamente através do `backoffLimit`.
- **Custo:** Alto e ineficiente. Paga-se pelo Control Plane do EKS (US$ 0,10/hora = ~US$ 72/mês) mais os nós em execução (ex: 2 instâncias t3.medium custam ~US$ 60/mês). Há custo de ociosidade, pois os nós e o control plane são pagos independentemente do uso.

## 2. KEDA ScaledJob / ScaledObject
O KEDA transforma o cluster Kubernetes em uma plataforma orientada a eventos, escalando workloads de 0 a N com base no tamanho da fila.
- **Comportamento sob pico (10.000 mensagens):** Excelente. O KEDA detecta o aumento da métrica no Redis/RabbitMQ e altera as réplicas dinamicamente até o limite configurado (`maxReplicaCount`), absorvendo as 10.000 mensagens rapidamente.
- **Latência de Cold Start:** Moderada. A transição de 0 para 1 Pod sofre o atraso natural do Kubernetes (scheduling, image pull) e do polling interval do KEDA, demorando alguns segundos.
- **Tempo de execução:** Ilimitado. Ideal para processamento batch demorado.
- **Tratamento de falhas:** Flexível, utilizando `podFailurePolicy` ou `backoffLimit` em jobs dinâmicos.
- **Custo:** Moderado. Elimina a ociosidade dos Pods consumindo CPU (escala a zero), mas o cluster subjacente (Control Plane US$ 0,10/h e os Node Groups, como t3.medium) continua gerando custos fixos de infraestrutura 24/7.

## 3. SQS + AWS Lambda (Serverless Gerenciado)
Uma abordagem totalmente nativa em nuvem, mapeando eventos do Amazon SQS diretamente para funções AWS Lambda.
- **Comportamento sob pico (10.000 mensagens):** Perfeito. A AWS escala as execuções horizontal e instantaneamente, processando milhares de itens em paralelo de forma transparente.
- **Latência de Cold Start:** Milissegundos a poucos segundos. Ambientes Firecracker da AWS provisionam microVMs quase instantaneamente.
- **Tempo de execução:** Limitado. O Lambda impõe um hard limit de **15 minutos** por invocação. Tarefas maiores precisam ser quebradas (Step Functions) ou migradas.
- **Tratamento de falhas:** Avançado e nativo. Mensagens que falham sucessivas vezes vão automaticamente para uma DLQ (Dead Letter Queue) no SQS para análise posterior.
- **Custo:** Extremamente eficiente. Cobra-se estritamente pelo uso: US$ 0,20 por invocação (1 milhão de requisições) e US$ 0.0000166667 por GB-segundo. Zero ociosidade. Sem custo fixo de control plane ou instâncias EC2 rodando na madrugada.

## Recomendação Justificada para a FIAP Store
Considerando que a FIAP Store possui um pico brutal durante a **Black Friday** e passa a maior parte do ano com baixo volume de vendas, a **recomendação arquitetural é o uso de AWS SQS + AWS Lambda**. 

O modelo Serverless resolve o principal ofensor do fluxo sazonal: o custo fixo. Manter um cluster EKS (mesmo usando KEDA para escalar os Pods a zero) exige o pagamento mensal do Control Plane (US$ 72) e dos worker nodes aguardando carga (t3.medium). Com Lambda e SQS, o custo será virtualmente zero na maior parte do ano e escalará agressivamente, sem gargalos, apenas nas horas críticas da Black Friday. A limitação de 15 minutos do Lambda não afeta este cenário, visto que um processamento padrão de pedido não deve ultrapassar essa margem de tempo.

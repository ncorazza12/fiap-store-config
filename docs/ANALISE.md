# Análise: CronJob e Injeção de Secrets

## 1. Concorrência: Allow vs Forbid
- **Allow**: Com a política Allow, o CronJob permitiu a criação de um novo Job mesmo com a execução anterior ainda ativa (já que o container dura 6 minutos e o schedule é a cada 5 minutos). Foi possível observar ≥2 Jobs rodando simultaneamente.
- **Forbid**: Ao alterar para Forbid, o Kubernetes passou a respeitar o limite de concorrência. Quando o novo ciclo tentou iniciar, a execução foi pulada e o evento `JobAlreadyActive` ("Job already active, skipping") foi registrado, mantendo no máximo 1 Job ativo por vez.

## 2. Consumo de Secrets: Variável de Ambiente vs Volume
Ao atualizar o Secret dinamicamente durante a execução do Pod:
- **Variável de Ambiente (env)**: Manteve o valor desatualizado (`token-original-123`). Variáveis de ambiente são injetadas apenas no startup do container e não sofrem atualização dinâmica.
- **Volume**: Foi atualizado automaticamente pelo kubelet para o novo valor (`token-novo-xyz`) sem necessidade de reiniciar o Pod. Isso ocorre porque volumes de Secrets são montados como tmpfs e o kubelet os reconcilia periodicamente.

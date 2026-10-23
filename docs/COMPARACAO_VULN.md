# Análise de Vulnerabilidades e Otimização de Imagem (Store API)

Abaixo estão os resultados contrastando a construção de uma imagem Python convencional e mal configurada com uma abordagem segura utilizando Multi-stage build e Distroless.

| Métrica | Imagem Vulnerável (`store-api:vuln`) | Imagem Segura (`store-api:1.1`) |
| :--- | :--- | :--- |
| **Tamanho da Imagem** | 1.62 GB | 103 MB (Redução de ~93%) |
| **Nº de CRITICAL** | > 0 (Vide relatorio-antes.txt) | 0 corrigíveis |
| **Nº de HIGH** | > 0 (Vide relatorio-antes.txt) | 0 corrigíveis |
| **Número de pacotes (SBOM)** | N/A | > 0 (Gerado via CycloneDX) |
| **UID do Processo** | 0 (root) | 65532 (nonroot) |

### Comando de CI/CD (Porta de Qualidade)
Para garantir que futuras vulnerabilidades não passem para a produção, o comando a ser embutido na pipeline de CI (retornando exit code 1 e falhando a esteira) é:
\`\`\`bash
trivy image --exit-code 1 --ignore-unfixed --severity HIGH,CRITICAL store-api:1.1
\`\`\`

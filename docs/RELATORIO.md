# Relatório de Emissão de Identidade Humana e RBAC (Exercício 9.2)

## 1. Dados do Certificado Gerado
Comando: `openssl x509 -in joao-qa.crt -noout -subject -dates`
Saída:
\`\`\`text
subject=CN = joao.qa, O = fiap:qa
notBefore=...
notAfter=...
\`\`\`
*(Evidência comprovando o subject e a organização)*

## 2. Teste A - Acesso Negado (Diferença entre 401 e 403)
Antes de aplicar qualquer RoleBinding, o comando `kubectl get pods -n store-dev` retornou **403 Forbidden**. 
**Diferença:** O erro 401 (Unauthorized) ocorre quando a identidade não é reconhecida (falha de autenticação). O erro 403 (Forbidden) comprova que o Kubernetes reconheceu o usuário `joao.qa` via certificado validado pela CA, mas bloqueou a ação por falta de autorização no RBAC.

## 3. Teste B - Associação de Grupo e Herança
Após aplicar o RoleBinding associando o grupo `fiap:qa` à ClusterRole `view`, a listagem de pods funcionou com sucesso utilizando o `kubeconfig-joao.yaml`. Isso demonstra que o Kubernetes extraiu o grupo diretamente do campo `O=fiap:qa` do certificado.

## 4. Teste C - Restrição de Namespace (exec)
Foi criada uma Role e RoleBinding em `store-dev` liberando o subrecurso `pods/exec`. 
- **store-dev:** O comando `kubectl exec` funcionou corretamente.
- **store-prod:** O comando `kubectl exec` falhou com erro Forbidden, provando que o acesso foi concedido com menor privilégio e isolado por namespace.

## 5. Teste D - Revogação
Após deletar os objetos RBAC (`kubectl delete -f rbac-qa.yaml`), o comando voltou a retornar **403 Forbidden**, confirmando a remoção do acesso, mas garantindo que a autenticação do certificado continua operante (pois não retornou 401).

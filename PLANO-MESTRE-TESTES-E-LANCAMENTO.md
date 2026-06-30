# Plano mestre de testes e lançamento - PsiReal Clínica

Versão: 1.0  
Data: 30/06/2026  
Produto avaliado: pacote atual do PsiReal Clínica  
Projeto Supabase correto: `psireal-hub` (`qpwjxacdjzzsyjbuuwsq`)

## Módulo IC-TDAH — Investigação Clínica

- [ ] Abrir o módulo pela tela Protocolos.
- [ ] Selecionar um paciente e confirmar o preenchimento automático do nome.
- [ ] Preencher parcialmente etapas diferentes, fechar e reabrir a tela.
- [ ] Confirmar recuperação da etapa, respostas e síntese do mesmo paciente.
- [ ] Trocar de paciente e confirmar que os rascunhos não se misturam.
- [ ] Confirmar salvamento na conta em outro navegador ou dispositivo.
- [ ] Testar campos livres, opções, caixas de seleção e escalas 0–10.
- [ ] Gerar a síntese e conferir motivo, temporalidade, prejuízos, diferenciais e forças.
- [ ] Editar os blocos da síntese e confirmar a persistência das alterações.
- [ ] Concluir a investigação e confirmar o status `Concluído`.
- [ ] Confirmar que nenhuma mensagem apresenta diagnóstico automático de TDAH.
- [ ] Verificar que uma psicóloga não acessa investigações de outra conta.
- [ ] Verificar o layout em celulares de 320 px, 375 px e 430 px.
- [ ] Revisar o conteúdo com a psicóloga responsável antes do lançamento.
- [ ] Validar consentimento, finalidade, retenção e exclusão conforme a LGPD.

## 1. Objetivo

Validar o PsiReal Clínica de ponta a ponta e estabelecer critérios objetivos para decidir quando o produto está pronto para comercialização.

O lançamento somente será autorizado quando:

- todos os testes críticos estiverem aprovados;
- não houver defeitos P0 ou P1 abertos;
- o isolamento entre psicólogas estiver comprovado por testes técnicos;
- backup e restauração estiverem comprovados;
- fluxos clínicos de risco estiverem revisados por profissional responsável;
- documentos comerciais, privacidade e suporte estiverem publicados;
- uma turma beta tiver concluído o uso real sem perda ou mistura de dados.

## 2. Diagnóstico atual do produto

### Funcionalidades presentes no pacote

- landing page e planos;
- autenticação por Supabase Auth;
- recuperação de senha;
- dashboard da psicóloga;
- cadastro/listagem de pacientes e aplicações;
- geração de links para pacientes;
- formulários YSQ-S3, GAD-7, PHQ-9, OASIS e AAQ-II;
- painel longitudinal de instrumentos;
- perfil clínico e Mapa de Esquemas;
- Ressonância Clínica;
- gestão administrativa de psicólogas;
- biblioteca clínica;
- Edge Function para criação de usuárias.

### Lacunas que impedem considerar o produto completo

- registro estruturado de sessão não está implementado como módulo completo;
- plano de tratamento não está implementado como módulo operacional;
- Google Calendar não está integrado no pacote atual;
- autosalvamento ainda precisa ser padronizado fora do Mapa de Esquemas;
- cobrança, renovação, cancelamento e bloqueio por inadimplência não formam um fluxo completo;
- não existe ambiente separado de homologação;
- não existe suíte automatizada de regressão;
- o roteiro antigo menciona telas ausentes, como `painel-psi.html`, `painel-esquemas.html` e `admin-contatos.html`;
- falta comprovação documentada das políticas RLS de todas as tabelas;
- falta processo comprovado de backup e restauração;
- falta confirmar licença/autorização de uso comercial de cada instrumento.

## 3. Classificação dos defeitos

| Nível | Definição | Exemplos | Decisão |
|---|---|---|---|
| P0 - bloqueador | Risco de segurança, privacidade, perda grave ou dano clínico | uma psi vê paciente de outra; chave secreta exposta; resposta perdida; score clínico incorreto | interromper testes e lançamento |
| P1 - crítico | Fluxo principal indisponível ou inconsistente | login falha; formulário não envia; recuperação de senha quebra; mapa desaparece | corrigir antes do beta |
| P2 - importante | Fluxo funciona com limitação ou solução alternativa | filtro incorreto; mensagem confusa; falha de responsividade | corrigir antes do lançamento público |
| P3 - melhoria | Ajuste visual ou conveniência sem perda funcional | espaçamento, rótulo, animação | pode entrar no backlog |

## 4. Ambientes e dados de teste

### Ambientes obrigatórios

1. **Desenvolvimento local:** alterações em andamento.
2. **Homologação:** Supabase e domínio exclusivos, sem pacientes reais.
3. **Produção:** domínio comercial e banco de dados reais.

Nunca testar exclusão, migração ou mudança de RLS diretamente em produção.

### Contas de teste

- `admin_teste`;
- `psi_a_ativa`;
- `psi_b_ativa`;
- `psi_trial`;
- `psi_inativa`;
- `psi_sem_perfil`;
- dois pacientes fictícios por psicóloga;
- uma conta com senha expirada ou sessão inválida.

### Conjunto clínico controlado

Criar respostas com resultados previamente calculados:

- escore mínimo;
- escore intermediário;
- escore máximo;
- respostas incompletas;
- PHQ-9 com item 9 igual a zero;
- PHQ-9 com item 9 maior que zero;
- duas ou mais aplicações do mesmo instrumento em datas diferentes;
- paciente com acentos, nome composto e telefone formatado;
- paciente sem telefone e sem data de nascimento, quando permitido.

Nenhum teste deve usar dados de paciente real.

## 5. Portões de aprovação

### Gate A - base técnica

- [ ] Git é a fonte única da versão publicada.
- [ ] Homologação está separada de produção.
- [ ] Migrações do banco estão versionadas.
- [ ] Nenhuma chave `service_role`, senha ou segredo aparece no frontend ou Git.
- [ ] Supabase de produção não está sujeito a pausa por inatividade.
- [ ] Existe monitoramento de disponibilidade e erros.
- [ ] Cache/service worker é atualizado sem manter versão antiga do sistema.

### Gate B - segurança e privacidade

- [ ] RLS está habilitada em todas as tabelas expostas no schema `public`.
- [ ] Usuário anônimo não consegue listar pacientes, respostas, perfis ou psicólogas.
- [ ] Psi A não consegue consultar, alterar ou excluir dados da Psi B.
- [ ] Admin é validada no servidor, não apenas por botão oculto no frontend.
- [ ] Links de paciente usam token imprevisível, possuem status e podem expirar.
- [ ] Sessões são encerradas corretamente no logout e após expiração.
- [ ] MFA está habilitado para administradoras.
- [ ] Logs não registram respostas clínicas, senhas ou tokens completos.
- [ ] Política de privacidade, termos e canal do titular estão publicados.
- [ ] Existe procedimento de incidente de segurança.

### Gate C - consistência clínica

- [ ] Cálculos de todos os instrumentos conferem com uma planilha de referência.
- [ ] Classificações e faixas são revisadas por psicóloga responsável.
- [ ] O sistema não apresenta hipótese como diagnóstico.
- [ ] Alertas do PHQ-9 item 9 funcionam e têm texto clínico aprovado.
- [ ] Resultados mantêm instrumento, data, paciente e psicóloga corretos.
- [ ] Reaplicações são ordenadas cronologicamente.
- [ ] Alterações em registros clínicos têm data e autoria.
- [ ] Licença/autorização de cada instrumento foi confirmada documentalmente.

### Gate D - operação comercial

- [ ] Cadastro de assinante cria Auth e perfil de forma atômica.
- [ ] Trial, ativação, renovação, cancelamento e inadimplência têm regras definidas.
- [ ] Plano contratado limita recursos de maneira consistente.
- [ ] Falha de pagamento não apaga dados clínicos.
- [ ] Cancelamento permite exportação conforme política contratual.
- [ ] Suporte, SLA, política de backup e responsabilidades estão documentados.
- [ ] Fluxo de exclusão de conta respeita retenção legal e contratual.

## 6. Casos de teste críticos

### 6.1 Autenticação e sessão

| ID | Teste | Resultado esperado |
|---|---|---|
| AUT-01 | Login de psi ativa | entra e carrega somente o perfil correto |
| AUT-02 | Senha incorreta | nega acesso sem revelar se a conta existe |
| AUT-03 | Psi inativa | autenticação não libera o painel clínico |
| AUT-04 | Perfil ausente em `psis` | mostra orientação controlada e não carrega dados |
| AUT-05 | Recuperação de senha | e-mail abre página válida e nova senha funciona |
| AUT-06 | Link de recuperação expirado | informa expiração e permite solicitar novo link |
| AUT-07 | Logout | remove tokens e bloqueia páginas protegidas |
| AUT-08 | Token expirado | redireciona ao login sem perder rascunho local |
| AUT-09 | Voltar do navegador após logout | conteúdo clínico não reaparece |
| AUT-10 | Admin sem MFA | deve ser bloqueada quando MFA for obrigatório |

### 6.2 Isolamento multiusuário e RLS

| ID | Teste | Resultado esperado |
|---|---|---|
| RLS-01 | Psi A lista pacientes | recebe somente pacientes da Psi A |
| RLS-02 | Psi A força ID da Psi B na URL | banco nega acesso |
| RLS-03 | Psi A consulta REST manualmente | banco não retorna linhas da Psi B |
| RLS-04 | Psi A tenta atualizar/excluir dado da Psi B | banco nega operação |
| RLS-05 | Requisição anônima às tabelas clínicas | nenhum dado sensível é retornado |
| RLS-06 | Admin legítima consulta gestão | acesso autorizado e auditável |
| RLS-07 | Usuária comum chama função administrativa | operação negada |
| RLS-08 | Duas contas no mesmo navegador | rascunhos e sessões não se misturam |

Executar esses testes também fora da interface, usando chamadas diretas à API. Esconder botões não é controle de acesso.

### 6.3 Pacientes e links

| ID | Teste | Resultado esperado |
|---|---|---|
| PAC-01 | Criar paciente válido | aparece imediatamente na conta correta |
| PAC-02 | Paciente duplicado | regra definida evita duplicidade silenciosa |
| PAC-03 | Editar paciente | alteração persiste após recarregar |
| PAC-04 | Excluir/arquivar paciente | exige confirmação e respeita retenção definida |
| LNK-01 | Gerar link para cada instrumento | abre instrumento correto com token válido |
| LNK-02 | Token inexistente | não revela dados e mostra link inválido |
| LNK-03 | Token expirado/revogado | bloqueia o envio |
| LNK-04 | Reutilizar link respondido | aplica regra definida sem duplicar resposta |
| LNK-05 | Compartilhar por WhatsApp | mensagem contém nome, instrumento e URL corretos |
| LNK-06 | Link da Psi A | resposta sempre é vinculada à Psi A |

### 6.4 Formulários e instrumentos

Aplicar a matriz abaixo a YSQ-S3, GAD-7, PHQ-9, OASIS e AAQ-II.

| ID | Teste | Resultado esperado |
|---|---|---|
| FOR-01 | Abrir em celular sem login | carrega sem expor dados da psicóloga |
| FOR-02 | Consentimento não marcado | envio permanece bloqueado |
| FOR-03 | Campos obrigatórios vazios | mostra erro próximo ao campo |
| FOR-04 | Respostas incompletas | não envia silenciosamente |
| FOR-05 | Respostas mínimas/máximas | score confere com referência |
| FOR-06 | Dois cliques em enviar | grava somente uma resposta |
| FOR-07 | Internet cai durante envio | preserva respostas e permite tentar novamente |
| FOR-08 | Atualização da página | comportamento de rascunho é previsível e informado |
| FOR-09 | Resposta concluída | painel recebe resultado correto |
| FOR-10 | Acentos e caracteres especiais | dados permanecem íntegros e sem código injetado |

### 6.5 PHQ-9 e risco clínico

- [ ] Item 9 maior que zero aciona destaque antes e depois do envio.
- [ ] A psicóloga recebe sinalização visível no painel.
- [ ] O alerta não promete atendimento emergencial automático.
- [ ] O texto orienta procura de ajuda imediata conforme protocolo aprovado.
- [ ] O evento não fica escondido apenas em gráfico ou cor.
- [ ] O sistema não envia conteúdo clínico sensível por WhatsApp ou e-mail comum.
- [ ] Fluxo revisado e assinado pela responsável técnica.

### 6.6 Dashboard e evolução

| ID | Teste | Resultado esperado |
|---|---|---|
| DSH-01 | Contadores | conferem com o banco da conta autenticada |
| DSH-02 | Lista recente | ordenada pela data correta |
| DSH-03 | Pendências | não inclui links concluídos ou de outra psi |
| DSH-04 | Estado vazio | não exibe pacientes fictícios |
| EVO-01 | Uma aplicação | mostra score sem inventar tendência |
| EVO-02 | Múltiplas aplicações | gráfico segue ordem cronológica |
| EVO-03 | Datas iguais/fusos | ordem permanece determinística |
| EVO-04 | Filtro por paciente/instrumento | não mistura séries clínicas |

### 6.7 Mapa de Esquemas e autosalvamento

| ID | Teste | Resultado esperado |
|---|---|---|
| MAP-01 | Digitar e aguardar | indicador muda para “Salvo na sua conta” |
| MAP-02 | Recarregar página | dados reaparecem integralmente |
| MAP-03 | Fechar e abrir navegador | dados são recuperados |
| MAP-04 | Abrir em outro dispositivo | mapa vem do Supabase |
| MAP-05 | Internet cai | cópia local permanece e informa estado correto |
| MAP-06 | Internet retorna | alterações pendentes sincronizam sem apagar dados novos |
| MAP-07 | Duas abas editam o mapa | regra de conflito é previsível e não perde conteúdo silenciosamente |
| MAP-08 | Psi A e Psi B no mesmo computador | cada conta recupera somente o próprio mapa |
| MAP-09 | Salvar/gerar perfil | mapa continua após sair e voltar |
| MAP-10 | Campo muito longo | interface e banco tratam limite definido |

Aplicar posteriormente essa mesma matriz de autosalvamento a registro de sessão e plano de tratamento.

### 6.8 Administração e assinatura

- [ ] Apenas administradora autorizada abre a gestão.
- [ ] Criação de psi não deixa Auth sem perfil ou perfil sem Auth.
- [ ] E-mail duplicado gera mensagem controlada.
- [ ] Plano, trial e status persistem.
- [ ] Desativar psi bloqueia novos acessos sem apagar histórico.
- [ ] Reativar psi restaura o acesso correto.
- [ ] `service_role` existe somente no servidor/Edge Function.
- [ ] Toda ação administrativa crítica gera log com autora e data.
- [ ] Renovação não depende apenas de link manual ou WhatsApp.

### 6.9 Mobile, acessibilidade e UX

Testar em 320, 360, 390, 768, 1024, 1366 e 1920 px.

- [ ] Nenhum texto, botão, modal, tabela ou fotografia corta horizontalmente.
- [ ] Menu abre, fecha e devolve foco corretamente.
- [ ] Campos permanecem visíveis quando o teclado móvel abre.
- [ ] Alvos de toque têm dimensão adequada.
- [ ] Fluxos principais funcionam somente com teclado.
- [ ] Campos possuem rótulos e erros associados.
- [ ] Contraste não depende apenas de cor.
- [ ] Alertas são anunciados por tecnologia assistiva.
- [ ] Zoom de 200% não impede uso.
- [ ] Estado de carregamento impede cliques duplicados.

### 6.10 Desempenho e resiliência

- [ ] Painel abre em conexão móvel sem tela branca prolongada.
- [ ] Listas com 500 pacientes e 5.000 respostas permanecem utilizáveis.
- [ ] Consultas têm paginação e índices adequados.
- [ ] Falha do Supabase mostra mensagem útil e permite nova tentativa.
- [ ] Pausa, indisponibilidade ou limite do provedor gera alerta operacional.
- [ ] Deploy novo não mantém HTML/JS antigo no service worker.
- [ ] Requisições repetidas possuem proteção contra duplicidade.
- [ ] Restauração de backup é testada em ambiente separado.

## 7. Funcionalidades a terminar antes da venda

### Crítico

1. Comprovar e corrigir RLS de todas as tabelas e funções.
2. Concluir recuperação de senha publicada e configurada.
3. Aplicar e validar migração de autosalvamento do Mapa de Esquemas.
4. Padronizar autosalvamento nos demais registros clínicos.
5. Criar homologação separada de produção.
6. Contratar infraestrutura que não pause por inatividade e definir backups.
7. Corrigir documentação para refletir somente telas existentes.
8. Validar licenças dos instrumentos e textos clínicos.
9. Criar política de privacidade, termos, contrato e procedimento de incidente.

### Importante

1. Implementar registro de sessão com histórico e autoria.
2. Implementar plano de tratamento com objetivos, status e revisão.
3. Definir se Google Calendar fará parte do primeiro plano comercial; se sim, implementar OAuth seguro, desconexão e tratamento de conflitos.
4. Implementar cobrança e ciclo completo da assinatura.
5. Criar exportação de dados e atendimento aos direitos do titular.
6. Criar logs de auditoria e monitoramento.
7. Adicionar MFA para administradoras.
8. Criar testes automatizados dos cálculos, RLS e jornadas principais.

### Desejável

1. Preferências de notificação.
2. Personalização de logo e mensagens.
3. Relatórios exportáveis.
4. Melhorias de acessibilidade avançada.
5. Métricas de uso anonimizadas e consentidas.

## 8. Sequência sugerida de execução

### Semana 1 - segurança e inventário

- congelar escopo da primeira versão;
- criar homologação;
- inventariar tabelas, políticas, funções e segredos;
- executar matriz RLS com duas psicólogas;
- corrigir P0 encontrados.

### Semana 2 - fluxos principais

- autenticação e recuperação;
- pacientes e links;
- cinco formulários;
- cálculos e duplicidade;
- dashboard e evolução.

### Semana 3 - persistência clínica

- autosalvamento completo;
- Mapa de Esquemas;
- registro de sessão;
- plano de tratamento;
- auditoria e histórico.

### Semana 4 - comercial e operação

- assinatura e bloqueios;
- backup/restauração;
- monitoramento;
- documentos jurídicos e privacidade;
- suporte e incidentes.

### Semana 5 - UX e regressão

- mobile e acessibilidade;
- desempenho com volume;
- compatibilidade entre navegadores;
- correção de P1/P2;
- regressão completa.

### Semana 6 - beta controlado

- 3 a 5 psicólogas convidadas;
- dados fictícios ou consentidos conforme protocolo;
- acompanhamento diário de erros;
- entrevista de uso;
- decisão formal de lançamento.

## 9. Evidências obrigatórias

Cada teste deve registrar:

- ID do caso;
- versão/commit testado;
- ambiente;
- conta utilizada;
- data e responsável;
- resultado esperado e obtido;
- print ou vídeo quando aplicável;
- registro do banco antes/depois para persistência;
- defeito relacionado;
- situação final: aprovado, reprovado ou bloqueado.

Modelo:

| Caso | Versão | Ambiente | Resultado | Evidência | Defeito |
|---|---|---|---|---|---|
| RLS-01 | commit | homologação | aprovado/reprovado | link interno | P0-000 |

## 10. Critério final de Go/No-Go

### GO

- 100% dos casos P0/P1 aprovados;
- 100% da matriz RLS aprovada;
- 100% dos cálculos clínicos aprovados;
- zero perda de dados durante o beta;
- restauração de backup comprovada;
- documentos e suporte publicados;
- aprovação da responsável clínica e da responsável pelo produto.

### NO-GO

- qualquer mistura de dados entre contas;
- qualquer resposta clínica perdida ou atribuída à psi errada;
- cálculo ou alerta clínico incorreto;
- recuperação de senha ou login instável;
- ausência de backup restaurável;
- instrumento sem situação de licença esclarecida;
- termos e privacidade ausentes;
- infraestrutura sujeita a pausa durante uso comercial;
- cobrança ativa sem política de cancelamento e preservação/exportação dos dados.

## 11. Referências oficiais

- [Lei Geral de Proteção de Dados - Lei nº 13.709/2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709compilado.htm): dados de saúde são dados pessoais sensíveis; a lei também prevê transparência, direitos do titular e medidas de segurança.
- [ANPD - Guia de Segurança da Informação para Agentes de Tratamento de Pequeno Porte](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-vf.pdf): orienta controles de acesso, proteção de dados, vulnerabilidades, comunicações e nuvem.
- [ANPD - Resolução CD/ANPD nº 2/2022](https://www.gov.br/anpd/pt-br/acesso-a-informacao/institucional/atos-normativos/regulamentacoes_anpd/resolucao-cd-anpd-no-2-de-27-de-janeiro-de-2022): exige medidas administrativas e técnicas compatíveis com o risco, inclusive para agentes de pequeno porte.
- [CFP/CRP - Registro documental](https://transparencia.cfp.org.br/crp10/pergunta-frequente/registro-documental/): orienta registro documental/prontuário e guarda mínima aplicável.
- [Supabase - Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security): recomenda RLS em tabelas expostas e políticas ligadas ao usuário autenticado.
- [Supabase - MFA](https://supabase.com/docs/guides/auth/auth-mfa): referência para autenticação multifator de contas administrativas.

Este plano não substitui revisão jurídica, contábil, de segurança independente ou orientação do Conselho profissional aplicável.

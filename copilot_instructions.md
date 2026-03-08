# Instruções para uso do Copilot neste projeto

## 1. Tokens e Constantes

* Nunca use valores literais (hard coded) para espaçamento, tamanhos, durations, opacidades, etc, diretamente em widgets ou layouts.
* Sempre utilize tokens centralizados em arquivos como `app_sizes.dart`, `app_constants.dart`, `app_colors.dart`, `app_durations.dart`.
* Se precisar de um novo valor, adicione no arquivo de tokens correspondente antes de usar.

## 2. Organização de Código

* Prefira extrair lógica de negócio para controllers/cubits/blocs.
* Mantenha widgets focados apenas em UI e delegue lógica para camadas apropriadas.

## 3. Testes

* Sempre que criar um novo widget ou lógica, adicione testes.
* Busque manter cobertura de testes acima de 80% para widgets e lógica de timer.

## 4. Acessibilidade

* Adicione labels, tooltips e Semantics em todos os botões e elementos interativos.

## 5. Manutenção

* Se alterar um token, revise todos os usos para garantir consistência visual.
* Documente novos tokens e regras neste arquivo.

---

Essas instruções garantem consistência, manutenibilidade e qualidade no projeto. Siga sempre antes de submeter PRs ou novas features.

# Instruções para uso do Copilot neste projeto

## 1. Tokens e Constantes

* Nunca use valores literais (hard coded) para espaçamento, tamanhos, durations, opacidades, etc, diretamente em widgets ou layouts.
* Sempre utilize tokens centralizados em arquivos como `app_sizes.dart`, `app_constants.dart`, `app_colors.dart`, `app_durations.dart`.
* Se precisar de um novo valor, adicione no arquivo de tokens correspondente antes de usar.

## 2. Organização de Código

* Prefira extrair lógica de negócio para controllers/cubits/blocs.
* Mantenha widgets focados apenas em UI e delegue lógica para camadas apropriadas.
* Sempre que um widget privado (ex: `_MeuBotao`) for reutilizável ou autocontido, extraia-o para um arquivo próprio em `lib/src/app/widgets/` como classe pública (ex: `MeuBotao` em `meu_botao.dart`).
* Evite manter widgets privados dentro de páginas; prefira componentes separados para facilitar testes e reuso.

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

## 6. Textos e Mensagens

* Nunca escreva textos literais (hard coded) diretamente em widgets, componentes ou páginas.
* Sempre defina textos de interface, mensagens de ajuda, tooltips, títulos, descrições e mensagens amigáveis em arquivos de constantes, como `help_texts.dart` ou arquivos similares.
* Para adicionar um novo texto, crie uma constante no arquivo de textos e utilize-a no widget/componente correspondente.
* Isso facilita manutenção, tradução e padronização dos textos em toda a aplicação.

### Exemplo

```dart
// help_texts.dart
static const String cyclesCompletedMessage = 'Parabéns! Você completou todos os ciclos de foco. Faça uma pausa antes de recomeçar.';

// Uso no widget
Text(HelpTexts.cyclesCompletedMessage)
```

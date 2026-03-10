---
applyTo: "**"
---

# Regras de Componentização de Widgets

## Organização de Widgets

- **Widgets específicos de uma página** devem ficar dentro da pasta `widgets/` da própria página.
  - Exemplo: `lib/src/app/pages/habits/widgets/date_header.dart`
- **Widgets compartilhados** (reutilizáveis entre múltiplas páginas) devem ficar em `lib/src/app/widgets/`.
  - Exemplo: `lib/src/app/widgets/dotted_border_decoration.dart`

## Estrutura de pastas

```
lib/src/app/
├── pages/
│   └── <page_name>/
│       ├── <page_name>_view.dart
│       ├── <page_name>_controller.dart
│       └── widgets/          ← widgets específicos da página
│           └── my_widget.dart
└── widgets/                  ← widgets compartilhados do app
    └── shared_widget.dart
```

## Regras

1. Extraia widgets privados (`_WidgetName`) das views para arquivos separados na pasta `widgets/` da página, tornando-os públicos.
2. Se um widget pode ser reutilizado em mais de uma página, mova-o para `lib/src/app/widgets/`.
3. Mantenha a view (`_view.dart`) limpa, apenas compondo os widgets extraídos.

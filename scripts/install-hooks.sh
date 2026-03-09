#!/bin/sh
# Instala os git hooks do projeto
# Execute: sh scripts/install-hooks.sh

HOOK_DIR=".git/hooks"
SCRIPTS_DIR="scripts"

echo "Instalando git hooks..."

cp "$SCRIPTS_DIR/pre-commit" "$HOOK_DIR/pre-commit"
chmod +x "$HOOK_DIR/pre-commit"

echo "✅ Pre-commit hook instalado com sucesso!"
echo ""
echo "O hook irá antes de cada commit:"
echo "  - Corrigir lint automaticamente (dart fix + dart format)"
echo "  - Bloquear se houver erros que não podem ser corrigidos"
echo "  - Verificar código não utilizado (imports, variáveis, funções)"
echo "  - Verificar arquivos .dart não utilizados"
echo "  - Verificar cobertura de testes >= 80%"

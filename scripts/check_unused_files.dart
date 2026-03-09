// ignore_for_file: avoid_print
import 'dart:io';

/// Verifica arquivos .dart em lib/ que não são importados por nenhum outro arquivo.
/// Retorna exit code 1 se encontrar arquivos não utilizados.
void main() {
  final projectRoot = Directory.current.path;
  final libDir = Directory('$projectRoot/lib');

  if (!libDir.existsSync()) {
    print('Diretório lib/ não encontrado.');
    exit(1);
  }

  final allDartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  // Arquivos que devem ser ignorados (entry points, gerados, etc.)
  final ignoredPatterns = [
    'lib/main.dart',
    'firebase_options.dart',
    '.g.dart',
    '.freezed.dart',
    '.gen.dart',
    'generated',
    'dataconnect_generated',
  ];

  bool isIgnored(String path) {
    final normalized = path.replaceAll('\\', '/');
    return ignoredPatterns.any((p) => normalized.contains(p));
  }

  // Coleta todos os imports de todos os arquivos .dart (lib/ e test/)
  final allImports = <String>{};
  final dirsToScan = [
    Directory('$projectRoot/lib'),
    Directory('$projectRoot/test'),
  ];

  for (final dir in dirsToScan) {
    if (!dir.existsSync()) continue;
    for (final file in dir.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      for (final line in file.readAsLinesSync()) {
        final trimmed = line.trim();
        if (trimmed.startsWith('import ') || trimmed.startsWith('export ')) {
          allImports.add(trimmed);
        }
        if (trimmed.startsWith('part ')) {
          allImports.add(trimmed);
        }
      }
    }
  }

  final unusedFiles = <String>[];

  for (final file in allDartFiles) {
    final relativePath =
        file.path.substring(projectRoot.length + 1).replaceAll('\\', '/');

    if (isIgnored(relativePath)) continue;

    // Converte para formato de import package
    final packagePath =
        relativePath.replaceFirst('lib/', 'package:mindease_app/');

    // Converte para formato de import relativo
    final relativeImportPath = relativePath.replaceFirst('lib/', '');

    // Verifica se algum import referencia este arquivo
    final isImported = allImports.any((imp) {
      return imp.contains(packagePath) ||
          imp.contains(relativeImportPath) ||
          imp.contains(file.uri.pathSegments.last);
    });

    if (!isImported) {
      unusedFiles.add(relativePath);
    }
  }

  if (unusedFiles.isEmpty) {
    print('✅ Nenhum arquivo não utilizado encontrado.');
    exit(0);
  } else {
    print('❌ Arquivos não utilizados encontrados (${unusedFiles.length}):');
    for (final f in unusedFiles..sort()) {
      print('   - $f');
    }
    exit(1);
  }
}

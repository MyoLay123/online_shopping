// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart' as path;

Future<void> _runWindowsCommand(String command) async {
  try {
    final commandParts = _splitCommand(command);
    final result = await Process.run(
      'cmd.exe',
      ['/c', ...commandParts],
      // workingDirectory: 'C:\\path\\to\\directory',
      // environment: {'MY_ENV_VAR': 'value'},
      // includeParentEnvironment: true,
    );

    _handleCommandResult(result, command);
  } catch (e, st) {
    print('Error running Windows command: $e');
    print(st);
  }
}

Future<void> _runUnixCommand(String command) async {
  try {
    final commandParts = _splitCommand(command);
    final result = await Process.run(
      commandParts[0],
      commandParts.sublist(1),
      // workingDirectory: '/path/to/directory',
      // environment: {'MY_ENV_VAR': 'value'},
      // includeParentEnvironment: true,
    );

    _handleCommandResult(result, command);
  } catch (e, st) {
    print('Error running Unix command: $e');
    print(st);
  }
}

void _handleCommandResult(ProcessResult result, String command) {
  if (result.exitCode == 0) {
    /* if (result.stdout != null) {
      print('Stdout:\n${result.stdout}');
    } */
  } else {
    print('Error: ${result.stderr}');
    print('Exit code: ${result.exitCode}');
    throw Exception('Command failed: $command');
  }
}

List<String> _splitCommand(String command) {
  // (Same as before - handles quoted arguments)
  final parts = <String>[];
  var inQuotes = false;
  var currentPart = '';

  for (var i = 0; i < command.length; i++) {
    final char = command[i];
    if (char == '"') {
      inQuotes = !inQuotes;
    } else if (char == ' ' && !inQuotes) {
      parts.add(currentPart);
      currentPart = '';
    } else {
      currentPart += char;
    }
  }
  parts.add(currentPart);

  return parts.where((part) => part.isNotEmpty).toList();
}

String _getArbContent(String locale) {
  return '''
{
  "@@locale": "$locale",
  "counterAppBarTitle": "Counter",
  "@counterAppBarTitle": {
    "description": "Text shown in the AppBar of the Counter Page"
  }
}
''';
}

Future<void> _createDirectoryIfNotExists(String directoryPath) async {
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    await directory.create(recursive: true);
  }
}

// function: create arb files if not exists
Future<void> _createArbFiles(
  String moduleName,
  String locale,
  String modulePath,
) async {
  final arbFilePath = path.join(modulePath, '${moduleName}_$locale.arb');
  final file = File(arbFilePath);

  if (file.existsSync()) {
    return;
  }

  await file.writeAsString(_getArbContent(locale));
}

String _snakeCaseToCamelCase(String snakeCase) {
  if (snakeCase.isEmpty) {
    return snakeCase;
  }

  final parts = snakeCase.split('_');
  if (parts.length == 1) {
    return snakeCase; // Already in camelCase or single word
  }

  final camelCase = parts[0] +
      parts
          .skip(1)
          .map((part) => part[0].toUpperCase() + part.substring(1))
          .join();

  return camelCase;
}

String _snakeCaseToPascalCase(String snakeCase) {
  if (snakeCase.isEmpty) {
    return snakeCase;
  }

  final parts = snakeCase.split('_');
  if (parts.isEmpty) {
    return snakeCase; // Handle cases with only underscores.
  }

  final pascalCase = parts.map((part) {
    if (part.isEmpty) {
      return ''; // Handle consecutive underscores or leading/trailing underscores.
    }
    return part[0].toUpperCase() + part.substring(1);
  }).join();

  return pascalCase;
}

Future<void> main() async {
  try {
    final currentFilePath = Platform.script.toFilePath();
    final currentDirectory = path.dirname(currentFilePath);

    final modules = File(
      path.join(currentDirectory, 'modules'),
    ).readAsLinesSync();
    final locales = File(
      path.join(currentDirectory, 'locales'),
    ).readAsLinesSync();

    final l10nPath = path.join(currentDirectory, 'l10n');

    // make sure that each modules have their own arb files
    for (final module in modules) {
      final modulePath = path.join(l10nPath, module);
      await _createDirectoryIfNotExists(modulePath);
      for (final locale in locales) {
        await _createArbFiles(module, locale, modulePath);
        print('Generated translations for $locale in $module');
      }
    }

    // clean up the files in the generated directory, if the directory exists
    final generatedDirectory = path.join(
      currentDirectory,
      '..',
      '.dart_tool',
      'flutter_gen',
      'gen_l10n',
    );
    if (Directory(generatedDirectory).existsSync()) {
      await Directory(generatedDirectory).delete(recursive: true);
    }

    // then run generate command for each module
    for (final module in modules) {
      final moduleName = _snakeCaseToPascalCase(module);
      final modulePath = path.join(l10nPath, module);
      final command = 'flutter gen-l10n --arb-dir $modulePath '
          '--template-arb-file ${module}_en.arb '
          '--output-localization-file ${module}_localizations.dart '
          '--output-class ${moduleName}Localizations';

      if (Platform.isWindows) {
        await _runWindowsCommand(command);
      } else {
        await _runUnixCommand(command);
      }
    }

    final fileGenerator = L10nMainFileGenerator(
      modules: modules,
      filePath: path.join(l10nPath, 'l10n.dart'),
    );
    await fileGenerator.generate();

    // show user feedback message
    print('');
    print('Translation files generated successfully!');
    print("Don't forget to add newly generated delegate(s) to your app!");
  } on Exception catch (e, st) {
    print('Error: $e');
    print(st);
  }
}

class L10nMainFileGenerator {
  L10nMainFileGenerator({
    required List<String> modules,
    required this.filePath,
  }) : _modules = List.from(modules)..sort();

  final String _template = '''
import 'package:flutter/widgets.dart';
{{import_part}}
{{export_part}}
extension AppLocalizationsX on BuildContext {
{{getter_part}}}
''';

  final List<String> _modules;

  final String filePath;

  Future<void> generate() async {
    final file = File(filePath);
    final content = _template
        .replaceFirst('{{import_part}}', _getImportPart())
        .replaceFirst('{{export_part}}', _getExportPart())
        .replaceFirst('{{getter_part}}', _getGetterPart());

    await file.writeAsString(content);
  }

  String _getGetterPart() {
    final buffer = StringBuffer();
    for (final module in _modules) {
      final pModuleName = _snakeCaseToPascalCase(module);
      final cModuleName = _snakeCaseToCamelCase(module);
      final className = '${pModuleName}Localizations';
      buffer.writeln(
        '  $className get ${cModuleName}L10n => $className.of(this)!;',
      );
    }

    return buffer.toString();
  }

  String _getImportPart() {
    final buffer = StringBuffer();
    for (final module in _modules) {
      buffer.writeln(
        "import 'package:flutter_gen/gen_l10n/${module}_localizations.dart';",
      );
    }
    return buffer.toString();
  }

  String _getExportPart() {
    final buffer = StringBuffer();
    for (final module in _modules) {
      buffer.writeln(
        "export 'package:flutter_gen/gen_l10n/${module}_localizations.dart';",
      );
    }
    return buffer.toString();
  }
}

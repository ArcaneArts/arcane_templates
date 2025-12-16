import 'package:darted_cli/darted_cli.dart';

import 'package:{{name.snakeCase()}}/cli/commands.dart';

/// Entry point for {{name.snakeCase()}} CLI application
void main(List<String> arguments) async {
  await dartedEntry(
    input: arguments,
    commandsTree: commandsTree,
    customEntryHelper: (_) async => '''
╔═══════════════════════════════════════════════════════════╗
║                    {{class_name.constantCase()}}                           ║
║                 Command Line Interface                    ║
╚═══════════════════════════════════════════════════════════╝
''',
    customVersionResponse: () => '{{name.snakeCase()}} CLI v1.0.0',
  );
}

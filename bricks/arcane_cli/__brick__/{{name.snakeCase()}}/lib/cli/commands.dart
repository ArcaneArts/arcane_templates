import 'package:darted_cli/darted_cli.dart';

import 'handlers/hello_handlers.dart';
import 'handlers/config_handlers.dart';

/// All CLI commands for {{name.snakeCase()}}
final List<DartedCommand> commandsTree = [
  // Hello command - demonstrates basic CLI structure
  DartedCommand(
    name: 'hello',
    helperDescription: 'Hello world command - demonstrates basic CLI structure',
    callback: (_, __) => handleVersion(),
    subCommands: [
      DartedCommand(
        name: 'greet',
        helperDescription: 'Say hello with optional customization',
        arguments: [
          DartedArgument(name: 'name', abbreviation: 'n'),
        ],
        flags: [
          DartedFlag(name: 'times', abbreviation: 't'),
          DartedFlag(name: 'enthusiastic', abbreviation: 'e'),
        ],
        callback: (args, flags) => handleGreet(args ?? {}, _boolToMap(flags)),
      ),
      DartedCommand(
        name: 'version',
        helperDescription: 'Display version information',
        callback: (_, __) => handleVersion(),
      ),
    ],
  ),

  // Config command - configuration management
  DartedCommand(
    name: 'config',
    helperDescription: 'Configuration management commands',
    callback: (_, __) => handleConfigList(),
    subCommands: [
      DartedCommand(
        name: 'init',
        helperDescription: 'Initialize configuration file with default values',
        flags: [DartedFlag(name: 'force', abbreviation: 'f')],
        callback: (args, flags) => handleConfigInit(args ?? {}, _boolToMap(flags)),
      ),
      DartedCommand(
        name: 'get',
        helperDescription: 'Get a configuration value by key',
        arguments: [DartedArgument(name: 'key', abbreviation: 'k')],
        callback: (args, flags) => handleConfigGet(args ?? {}, _boolToMap(flags)),
      ),
      DartedCommand(
        name: 'set',
        helperDescription: 'Set a configuration value',
        arguments: [
          DartedArgument(name: 'key', abbreviation: 'k'),
          DartedArgument(name: 'value', abbreviation: 'v'),
        ],
        callback: (args, flags) => handleConfigSet(args ?? {}, _boolToMap(flags)),
      ),
      DartedCommand(
        name: 'list',
        helperDescription: 'List all configuration values',
        callback: (_, __) => handleConfigList(),
      ),
      DartedCommand(
        name: 'path',
        helperDescription: 'Show configuration file path',
        callback: (_, __) => handleConfigPath(),
      ),
    ],
  ),

  // Version command
  DartedCommand(
    name: 'version',
    helperDescription: 'Show version information',
    callback: (_, __) {
      print('{{name.snakeCase()}} CLI v1.0.0');
      print('Built with Arcane Templates');
    },
  ),
];

/// Convert bool map to dynamic map for handler compatibility
Map<String, dynamic> _boolToMap(Map<String, bool>? flags) {
  if (flags == null) return {};
  return flags.map((k, v) => MapEntry(k, v));
}

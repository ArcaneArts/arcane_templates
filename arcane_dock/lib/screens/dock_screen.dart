import 'package:arcane/arcane.dart';
import 'package:arcane_dock/main.dart';
import 'package:arcane_dock/util/window_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Main dock screen that appears when tray icon is clicked
class DockScreen extends StatefulWidget {
  const DockScreen({super.key});

  @override
  State<DockScreen> createState() => _DockScreenState();
}

class _DockScreenState extends State<DockScreen> {
  bool autolaunchEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load settings from Hive
  void _loadSettings() {
    setState(() {
      autolaunchEnabled = boxSettings.get('autolaunch', defaultValue: false);
    });
  }

  /// Toggle autolaunch setting
  Future<void> _toggleAutolaunch(bool value) async {
    await boxSettings.put('autolaunch', value);
    setState(() {
      autolaunchEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      backgroundColor: context.colorScheme.bg.primary,
      child: Collection(
        children: [
          // Header with app title
          _buildHeader(),

          Gap.lg,

          // Quick actions section
          _buildQuickActions(),

          Gap.lg,

          // Settings section
          _buildSettings(),

          Gap.lg,

          // About section
          _buildAbout(),

          Gap.lg,

          // Exit button
          _buildExitButton(),
        ],
      ).padded(),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Collection(
      children: [
        Text(
          'Arcane Dock',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.txt.primary,
          ),
        ),
        Gap.xs,
        Text(
          'v${packageInfo.version}',
          style: TextStyle(
            fontSize: 12,
            color: context.colorScheme.txt.secondary,
          ),
        ),
      ],
    );
  }

  /// Build quick actions section
  Widget _buildQuickActions() {
    return Section(
      titleText: 'Quick Actions',
      children: [
        Tile(
          leading: const Icon(Icons.info_outline),
          titleText: 'Example Action',
          subtitleText: 'This is an example quick action',
          onPressed: () {
            // TODO: Implement action
            info('Example action pressed');
          },
        ),
        Tile(
          leading: const Icon(Icons.folder_open),
          titleText: 'Open Config Folder',
          subtitleText: configPath,
          onPressed: () async {
            await launchUrlString('file://$configPath');
            await WindowManager.hide();
          },
        ),
      ],
    );
  }

  /// Build settings section
  Widget _buildSettings() {
    return Section(
      titleText: 'Settings',
      children: [
        Tile(
          leading: const Icon(Icons.power_settings_new),
          titleText: 'Launch at Startup',
          subtitleText: autolaunchEnabled
              ? 'App will start automatically'
              : 'App will not start automatically',
          trailing: Switch(
            value: autolaunchEnabled,
            onChanged: _toggleAutolaunch,
          ),
        ),
      ],
    );
  }

  /// Build about section
  Widget _buildAbout() {
    return Section(
      titleText: 'About',
      children: [
        Tile(
          leading: const Icon(Icons.language),
          titleText: 'Visit Website',
          subtitleText: 'github.com/ArcaneArts/arcane',
          onPressed: () async {
            await launchUrlString('https://github.com/ArcaneArts/arcane');
            await WindowManager.hide();
          },
        ),
        Tile(
          leading: const Icon(Icons.code),
          titleText: 'Built with Arcane',
          subtitleText: 'Material Design-free Flutter UI',
        ),
      ],
    );
  }

  /// Build exit button
  Widget _buildExitButton() {
    return PrimaryButton(
      text: 'Exit Arcane Dock',
      trailing: const Icon(Icons.exit_to_app),
      color: context.colorScheme.err.primary,
      onPressed: () => WindowManager.exit(),
    );
  }
}

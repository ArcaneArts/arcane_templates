import 'package:arcane/arcane.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      header: Bar(titleText: "{{class_name.pascalCase()}}", subtitleText: "Home"),
      gutter: true,
      child: Collection(
        children: [
          // Welcome card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to {{class_name.pascalCase()}}",
                    style: Theme.of(context).typography.large,
                  ),
                  const Gap(12),
                  const Text(
                    "This is a template project using Arcane styling with Beamer navigation. "
                    "Start building by modifying this home screen or adding new screens in lib/screens/.",
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),

          // Getting started section
          Section(
            titleText: "Getting Started",
            child: Collection(
              children: [
                Tile(
                  leading: const Icon(Icons.book),
                  title: const Text("Documentation"),
                  subtitle: const Text("Learn about Arcane components"),
                  trailing: const Icon(Icons.chevron_forward_ionic),
                  onPressed: () {
                    // Navigate to documentation or show info
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

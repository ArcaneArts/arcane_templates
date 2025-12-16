import 'package:{{name.snakeCase()}}/screens/home_screen.dart';
import 'package:arcane/arcane.dart';
import 'package:beamer/beamer.dart';

BuildContext? globalContext;

typedef BeamerRouteBuilder = dynamic Function(BuildContext, BeamState, Object?);

/// Helper to create a simple route with a static screen
MapEntry<Pattern, BeamerRouteBuilder> route(
  String path,
  String title,
  Widget screen,
) => MapEntry(
  path,
  (context, state, data) =>
      BeamPage(key: ValueKey("beamer.$path"), child: screen, title: title),
);

/// The main router delegate for Beamer
final BeamerDelegate routerDelegate = BeamerDelegate(
  initialPath: "/",
  notFoundRedirectNamed: "/404",
  buildListener: (context, router) => globalContext = context,
  locationBuilder: RoutesLocationBuilder(
    routes: Map.fromEntries([
      // Main routes
      route("/", "Home - {{class_name.pascalCase()}}", const HomeScreen()),

      // Add more routes here as needed
      // route("/example", "Example Page", const ExampleScreen()),
    ]),
  ).call,
);

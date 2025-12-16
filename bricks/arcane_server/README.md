# Arcane Server Brick

A Mason brick for creating Dart backend servers with Firebase integration using [Shelf](https://pub.dev/packages/shelf) and [Ostrich](https://pub.dev/packages/ostrich).

## Features

- Shelf-based HTTP server framework
- Firebase Admin SDK integration via Arcane Admin
- Fire CRUD for Firestore operations
- Request authentication middleware
- Pre-configured API and service structure
- Google Cloud deployment ready
- CORS support out of the box

## Usage

### Via Oracular CLI

```bash
oracular mason make --brick arcane_server
```

### Via Mason CLI

```bash
mason make arcane_server
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | - | Project name in snake_case (package becomes `{name}_server`) |
| `class_name` | string | - | Base class name in PascalCase |
| `firebase_project_id` | string | `""` | Firebase project ID |

## Generated Structure

```
my_app_server/
├── lib/
│   ├── main.dart                    # Server entry point
│   ├── api/
│   │   ├── user_api.dart            # User endpoints
│   │   ├── settings_api.dart        # Settings endpoints
│   │   └── command_api.dart         # Command endpoints
│   ├── service/
│   │   ├── user_service.dart        # User business logic
│   │   ├── command_service.dart     # Command processing
│   │   └── media_service.dart       # Media/storage operations
│   └── util/
│       └── request_authenticator.dart
└── pubspec.yaml
```

## Server Architecture

### Main Server Class

```dart
class MyAppServer implements Routing {
  static late final MyAppServer instance;
  late final HttpServer server;
  late final RequestAuthenticator authenticator;

  // Services
  static late UserService svcUser;
  static late CommandService svcCommand;
  static late MediaService svcMedia;

  // APIs
  static late UserAPI apiUser;
  static late SettingsAPI apiSettings;
  static late CommandAPI apiCommand;

  Future<void> start() async {
    registerCrud();
    await ArcaneAdmin.initialize();
    instance = this;
    await Future.wait([_startServices(), _startAPIs()]);

    authenticator = RequestAuthenticator();
    server = await serve(_pipeline, InternetAddress.anyIPv4, listenPort());
  }
}
```

### Entry Point

```dart
void main() => runFlutterServer((context) => MyAppServer().start());
```

## API Structure

APIs use Shelf Router for endpoint definitions:

```dart
class UserAPI implements Routing {
  @override
  String get prefix => "/api/user";

  @override
  Router get router => Router()
    ..get("/info/<userId>", _getUserInfo)
    ..post("/update/<userId>", _updateUser)
    ..get("/list", _listUsers);

  Future<Response> _getUserInfo(Request request, String userId) async {
    try {
      final user = await MyAppServer.svcUser.getUser(userId);
      if (user == null) {
        return Response.notFound('{"error": "User not found"}');
      }
      return Response.ok(
        jsonEncode({'userId': userId, 'name': user.name}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }
}
```

## Service Layer

Services contain business logic and interact with Fire CRUD:

```dart
class UserService {
  Future<User?> getUser(String userId) async {
    return await $crud.getUser(userId);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    final user = await getUser(userId);
    if (user == null) throw Exception("User not found");

    final updatedUser = User(
      name: data['name'] as String? ?? user.name,
      email: data['email'] as String? ?? user.email,
    );
    await $crud.setUser(userId, updatedUser);
  }

  Future<List<User>> listUsers({int limit = 10}) async {
    return await $crud.getUsers((ref) => ref.limit(limit));
  }
}
```

## Request Pipeline

The server uses Shelf middleware for request processing:

```dart
Handler get _pipeline => Pipeline()
    .addMiddleware(_corsMiddleware)
    .addMiddleware(_middleware)
    .addHandler(router.call);

Middleware get _middleware => createMiddleware(
  requestHandler: _onRequest,     // Authentication
  errorHandler: _onError,         // Error handling
  responseHandler: _onResponse,   // Response processing
);
```

## CORS Configuration

Pre-configured CORS headers for cross-origin requests:

```dart
Middleware get _corsMiddleware => corsHeaders(
  headers: {
    ACCESS_CONTROL_ALLOW_ORIGIN: "*",
    ACCESS_CONTROL_ALLOW_METHODS: "GET, POST, PUT, DELETE, OPTIONS",
    ACCESS_CONTROL_ALLOW_HEADERS: "*",
  },
);
```

## Shared Models

The server uses the shared models package:

```dart
import 'package:my_app_models/my_app_models.dart';

// Initialize CRUD on startup
registerCrud();
```

Add as path dependency in `pubspec.yaml`:

```yaml
dependencies:
  my_app_models:
    path: ../my_app_models
```

## Included Dependencies

### Server Framework
- `shelf` - HTTP server framework
- `shelf_router` - URL routing
- `shelf_cors_headers` - CORS middleware
- `ostrich` - Flutter server utilities

### Firebase & Database
- `arcane_admin` - Firebase Admin SDK
- `fire_api` / `fire_api_dart` - Fire API
- `fire_crud` - Firestore CRUD operations

### Google Cloud
- `google_cloud` - GCP utilities
- `eventarc` - Cloud event handling
- `memcached` - Caching support

### Utilities
- `fast_log` - Colored logging
- `toxic` - Reactive utilities
- `artifact` - Model serialization
- `http` - HTTP client
- `uuid` - UUID generation
- `mime` - MIME type handling

## Adding API Endpoints

1. Create new API class:

```dart
// lib/api/product_api.dart
class ProductAPI implements Routing {
  @override
  String get prefix => "/api/product";

  @override
  Router get router => Router()
    ..get("/<id>", _getProduct)
    ..post("/", _createProduct);

  Future<Response> _getProduct(Request request, String id) async {
    // Implementation
  }

  Future<Response> _createProduct(Request request) async {
    // Implementation
  }
}
```

2. Register in main server:

```dart
// In main.dart
static late ProductAPI apiProduct;

Future<void> _startAPIs() async {
  apiUser = UserAPI();
  apiProduct = ProductAPI();  // Add here
}

@override
Router get router => Router()
  ..mount(apiUser.prefix, apiUser.router.call)
  ..mount(apiProduct.prefix, apiProduct.router.call)  // Mount here
```

## Deployment

### Via Oracular CLI

```bash
oracular scripts exec deploy
```

### Manual Deployment

```bash
sh ./script_deploy.sh
```

### Google Cloud Run

The server is configured for Cloud Run deployment with:
- Automatic port detection via `listenPort()`
- Firebase Admin initialization
- CORS headers for cross-origin requests

## Logging

Use `fast_log` for server logging:

```dart
import 'package:fast_log/fast_log.dart';

verbose("Debug information");
info("Server started");
warn("Rate limit approaching");
error("Failed to process request");
success("User created successfully");
```

## Scripts

```yaml
scripts:
  # Oracular Commands
  deploy: oracular deploy server
  deploy_all: oracular deploy all
  check_tools: oracular check server

  # Manual Deployment
  deploy_manual: sh ./script_deploy.sh
```

## Health Check

Built-in health check endpoint:

```dart
..get("/keepAlive", _requestGetKeepAlive);

Future<Response> _requestGetKeepAlive(Request request) async =>
    Response.ok('{"ok": true}');
```

## Requirements

- Dart SDK ^3.10.0
- Flutter SDK ^3.10.0 (for Ostrich)
- Firebase project with Admin SDK enabled
- Google Cloud project (for deployment)

## Related Bricks

- [arcane_models](../arcane_models/) - Shared models (required dependency)
- [arcane_app](../arcane_app/) - Flutter application
- [arcane_cli](../arcane_cli/) - Command-line interface

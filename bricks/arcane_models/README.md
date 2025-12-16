# Arcane Models Brick

A Mason brick for creating shared data model packages using [Artifact](https://pub.dev/packages/artifact) and [Fire CRUD](https://pub.dev/packages/fire_crud).

## Features

- **Pure Dart** (no Flutter dependency)
- Artifact-based model definitions with code generation
- Fire CRUD integration for Firestore operations
- Shared between Flutter clients and Dart servers
- Type-safe model serialization and compression
- Example User, Settings, and Command models

## Usage

### Via Oracular CLI

```bash
oracular mason make --brick arcane_models
```

### Via Mason CLI

```bash
mason make arcane_models
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | - | Project name in snake_case (package becomes `{name}_models`) |
| `class_name` | string | - | Base class name in PascalCase |
| `firebase_project_id` | string | `""` | Firebase project ID for rules deployment |

## Generated Structure

```
my_app_models/
├── lib/
│   ├── my_app_models.dart    # Main library with model definitions
│   └── gen/                  # Generated code (do not edit)
│       ├── artifacts.gen.dart
│       └── crud.gen.dart
└── pubspec.yaml
```

## Model Definition

Models use the `@model` annotation from Artifact:

```dart
const model = Artifact(
  generateSchema: false,
  reflection: false,
  compression: true,
);

@model
class User with ModelCrud {
  final String name;
  final String email;
  final String? profileHash;

  User({required this.name, required this.email, this.profileHash});

  @override
  List<FireModel<ModelCrud>> get childModels => [
    FireModel<UserSettings>.artifact("data", exclusiveDocumentId: "settings"),
  ];
}
```

## Fire CRUD Integration

Models define their Firestore structure through `childModels`:

```dart
@model
class User with ModelCrud {
  // User fields...

  @override
  List<FireModel<ModelCrud>> get childModels => [
    // Nested collection at user/{userId}/data with single "settings" doc
    FireModel<UserSettings>.artifact("data", exclusiveDocumentId: "settings"),
  ];
}
```

Register models on startup:

```dart
void registerCrud() => $crud
  ..setupArtifact($artifactFromMap, $artifactToMap, $constructArtifact)
  ..registerModels([
    FireModel<User>.artifact("user"),
    FireModel<ServerCommand>.artifact("command"),
  ]);
```

## CRUD Operations

After code generation, use the generated `$crud` API:

```dart
// Create
final userId = await $crud.addUser(User(name: "John", email: "john@example.com"));

// Read
final user = await $crud.getUser(userId);

// Update
await $crud.setUser(userId, updatedUser);

// Delete
await $crud.deleteUser(userId);

// Query
final users = await $crud.getUsers((ref) => ref.limit(10));
```

## Code Generation

Run build_runner to generate serialization and CRUD code:

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild on changes)
dart run build_runner watch --delete-conflicting-outputs
```

Or use scripts:

```bash
oracular scripts exec build_runner
oracular scripts exec build_runner_watch
```

## Server Signature

The brick includes a server signature model for authentication:

```dart
@model
class MyAppServerSignature {
  final String signature;
  final String session;
  final int time;

  // Generate new signature
  static MyAppServerSignature newSignature() => MyAppServerSignature(
    signature: randomSignature,
    session: sessionId,
    time: DateTime.timestamp().millisecondsSinceEpoch,
  );

  // Compute hash for verification
  String get hash => sha256.convert(utf8.encode("$signature:$session@$time")).toString();
}
```

## Included Dependencies

- `artifact` - Model annotations and serialization
- `fire_crud` - Firestore CRUD operations
- `toxic` - Reactive utilities
- `arcane_admin` - Firebase Admin SDK utilities
- `crypto` - Cryptographic utilities

### Dev Dependencies

- `artifact_gen` - Code generation for Artifact
- `fire_crud_gen` - Code generation for Fire CRUD
- `build_runner` - Dart code generation runner

## Adding New Models

1. Define the model class with `@model` annotation:

```dart
@model
class Product with ModelCrud {
  final String name;
  final double price;
  final int stock;

  Product({required this.name, required this.price, required this.stock});

  @override
  List<FireModel<ModelCrud>> get childModels => [];
}
```

2. Register in `registerCrud()`:

```dart
void registerCrud() => $crud
  ..setupArtifact($artifactFromMap, $artifactToMap, $constructArtifact)
  ..registerModels([
    FireModel<User>.artifact("user"),
    FireModel<Product>.artifact("product"),  // Add here
  ]);
```

3. Run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Nested Collections

Define child models for nested Firestore collections:

```dart
@model
class Order with ModelCrud {
  final String userId;
  final DateTime createdAt;

  Order({required this.userId, required this.createdAt});

  @override
  List<FireModel<ModelCrud>> get childModels => [
    // Creates order/{orderId}/items collection
    FireModel<OrderItem>.artifact("items"),
  ];
}

@model
class OrderItem with ModelCrud {
  final String productId;
  final int quantity;

  OrderItem({required this.productId, required this.quantity});

  @override
  List<FireModel<ModelCrud>> get childModels => [];
}
```

## Sharing Between Client and Server

This package is designed to be imported by both:

- **Flutter apps** (`arcane_app`, `arcane_beamer`, `arcane_dock`)
- **Dart servers** (`arcane_server`)

Add as a path dependency:

```yaml
dependencies:
  my_app_models:
    path: ../my_app_models
```

## Scripts

```yaml
scripts:
  # Code Generation
  build_runner: dart run build_runner build --delete-conflicting-outputs
  build_runner_watch: dart run build_runner watch --delete-conflicting-outputs

  # Firebase Rules (when firebase_project_id is set)
  deploy_rules: firebase deploy --only firestore
```

## Requirements

- Dart SDK ^3.10.0

## Related Bricks

- [arcane_app](../arcane_app/) - Flutter application
- [arcane_server](../arcane_server/) - Backend server
- [arcane_cli](../arcane_cli/) - Command-line interface

#!/bin/bash

# Run pub get on all template packages
# Usage: ./pub_get_all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running pub get on all templates..."
echo ""

# Flutter templates
for dir in arcane_app arcane_beamer_app arcane_dock_app arcane_server; do
  if [ -d "$SCRIPT_DIR/$dir" ]; then
    echo "=== $dir (flutter) ==="
    cd "$SCRIPT_DIR/$dir"
    flutter pub get
    echo ""
  fi
done

# Dart-only templates
for dir in arcane_cli_app arcane_models; do
  if [ -d "$SCRIPT_DIR/$dir" ]; then
    echo "=== $dir (dart) ==="
    cd "$SCRIPT_DIR/$dir"
    dart pub get
    echo ""
  fi
done

echo "Done!"

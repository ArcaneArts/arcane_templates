#!/bin/bash

# Create Projects
# Creates the 3-project architecture: client app, models package, and server

# Source utilities
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$LIB_DIR/utils.sh"
source "$LIB_DIR/generate_banner.sh"

# Add ASCII banner to a Dart file
# Args: $1 - file path
#       $2 - banner text (e.g., "MY_APP")
#       $3 - description text
add_banner_to_file() {
    local file_path="$1"
    local banner_text="$2"
    local description="$3"

    if [ ! -f "$file_path" ]; then
        log_warning "File not found: $file_path"
        return 1
    fi

    # Generate the banner
    local banner=$(generate_banner "$banner_text" "//")

    # Create temp file with banner + original content
    local temp_file="${file_path}.banner_tmp"

    # Write banner
    echo "$banner" > "$temp_file"
    echo "//" >> "$temp_file"
    echo "// $description" >> "$temp_file"
    echo "" >> "$temp_file"

    # Append original file content
    cat "$file_path" >> "$temp_file"

    # Replace original with new file
    mv "$temp_file" "$file_path"

    log_success "Added banner to $(basename "$file_path")"
    return 0
}

create_client_app() {
    local app_name="$1"
    local org="$2"
    local platforms="${3:-android,ios,web,linux,windows,macos}"

    log_step "Creating Client App: $app_name"

    if [ -d "$app_name" ]; then
        log_warning "Directory $app_name already exists"
        if ! confirm "Do you want to overwrite it?"; then
            log_error "Cannot continue without creating the app"
            return 1
        fi
    fi

    echo ""
    log_info "Creating app with platforms: $platforms"
    retry_command "Create client app" flutter create \
        --platforms="$platforms" \
        -a java \
        -t app \
        --suppress-analytics \
        -e \
        --org "$org" \
        --project-name "$app_name" \
        --overwrite \
        "$app_name"
    return $?
}

create_models_package() {
    local app_name="$1"
    local models_name="${app_name}_models"

    log_step "Creating Models Package: $models_name"

    if [ -d "$models_name" ]; then
        log_warning "Directory $models_name already exists"
        if ! confirm "Do you want to overwrite it?"; then
            log_error "Cannot continue without creating the models package"
            return 1
        fi
    fi

    echo ""
    retry_command "Create models package" flutter create \
        -t package \
        --suppress-analytics \
        --project-name "$models_name" \
        --overwrite \
        "$models_name"
    return $?
}

create_server_app() {
    local app_name="$1"
    local org="$2"
    local server_name="${app_name}_server"

    log_step "Creating Server App: $server_name"

    if [ -d "$server_name" ]; then
        log_warning "Directory $server_name already exists"
        if ! confirm "Do you want to overwrite it?"; then
            log_error "Cannot continue without creating the server"
            return 1
        fi
    fi

    echo ""
    retry_command "Create server app" flutter create \
        --platforms=linux \
        -t app \
        --suppress-analytics \
        -e \
        --org "$org" \
        --project-name "$server_name" \
        --overwrite \
        "$server_name"
    return $?
}

link_models_to_projects() {
    local app_name="$1"
    local create_server="${2:-yes}"
    local models_name="${app_name}_models"
    local server_name="${app_name}_server"

    log_step "Linking Models Package to Client"
    if [ "$create_server" = "yes" ]; then
        log_step "Linking Models Package to Client and Server"
    fi

    # Add models dependency to client app
    log_info "Adding models dependency to $app_name..."

    # Find the line number where dependencies: section ends (before dev_dependencies or flutter section)
    local insert_line=$(grep -n "^dev_dependencies:" "$app_name/pubspec.yaml" | cut -d: -f1)
    if [ -z "$insert_line" ]; then
        # If no dev_dependencies, insert before flutter section
        insert_line=$(grep -n "^flutter:" "$app_name/pubspec.yaml" | cut -d: -f1)
    fi

    if [ -n "$insert_line" ]; then
        # Insert before the found line
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "${insert_line}i\\
\\
  $models_name:\\
    path: ../$models_name
" "$app_name/pubspec.yaml"
        else
            sed -i "${insert_line}i\\\\n  $models_name:\\n    path: ../$models_name" "$app_name/pubspec.yaml"
        fi
        log_success "Added models dependency to client app"
    else
        log_error "Could not find insertion point in pubspec.yaml"
        return 1
    fi

    # Add models dependency to server app (if server is being created)
    if [ "$create_server" = "yes" ]; then
        log_info "Adding models dependency to $server_name..."

        insert_line=$(grep -n "^dev_dependencies:" "$server_name/pubspec.yaml" | cut -d: -f1)
        if [ -z "$insert_line" ]; then
            insert_line=$(grep -n "^flutter:" "$server_name/pubspec.yaml" | cut -d: -f1)
        fi

        if [ -n "$insert_line" ]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "${insert_line}i\\
\\
  $models_name:\\
    path: ../$models_name
" "$server_name/pubspec.yaml"
            else
                sed -i "${insert_line}i\\\\n  $models_name:\\n    path: ../$models_name" "$server_name/pubspec.yaml"
            fi
            log_success "Added models dependency to server app"
        else
            log_error "Could not find insertion point in pubspec.yaml"
            return 1
        fi
    fi

    return 0
}

create_all_projects() {
    local app_name="$1"
    local org="$2"
    local platforms="${3:-android,ios,web,linux,windows,macos}"

    log_info "Current directory: $(pwd)"
    log_info "Projects will be created as:"
    log_instruction "  /$app_name - Flutter client application"
    log_instruction "  /${app_name}_models - Shared Dart package"
    log_instruction "  /${app_name}_server - Flutter server application"
    echo ""

    if ! confirm "Create these projects?"; then
        log_warning "Project creation cancelled"
        return 1
    fi

    # Create client app
    create_client_app "$app_name" "$org" "$platforms" || return 1

    # Create models package
    create_models_package "$app_name" || return 1

    # Create server app
    create_server_app "$app_name" "$org" || return 1

    # Link models to projects
    link_models_to_projects "$app_name" || return 1

    log_success "All projects created successfully!"

    return 0
}

copy_template_files() {
    local app_name="$1"
    local template_dir="$2"
    local template_name="$(basename "$template_dir")"

    log_step "Copying Template Files"

    if [ ! -d "$template_dir" ]; then
        log_error "Template directory not found: $template_dir"
        return 1
    fi

    # Copy lib directory (the source code)
    if [ -d "$template_dir/lib" ]; then
        log_info "Copying lib/ directory from template..."
        rm -rf "$app_name/lib"
        cp -r "$template_dir/lib" "$app_name/"

        # Replace template package name with actual app name in imports
        find "$app_name/lib" -type f -name "*.dart" -exec \
            sed -i.bak "s/package:$template_name/package:$app_name/g" {} \; -exec rm {}.bak \;

        log_success "Template lib/ copied"
    fi

    # Copy pubspec.yaml
    if [ -f "$template_dir/pubspec.yaml" ]; then
        log_info "Copying pubspec.yaml from template..."
        cp "$template_dir/pubspec.yaml" "$app_name/pubspec.yaml"

        # Update name in pubspec
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/^name: .*/name: $app_name/" "$app_name/pubspec.yaml"
        else
            sed -i "s/^name: .*/name: $app_name/" "$app_name/pubspec.yaml"
        fi

        log_success "Template pubspec.yaml copied"
    fi

    # Copy analysis_options.yaml if exists
    if [ -f "$template_dir/analysis_options.yaml" ]; then
        log_info "Copying analysis_options.yaml..."
        cp "$template_dir/analysis_options.yaml" "$app_name/"
    fi

    # Copy README if exists
    if [ -f "$template_dir/README.md" ]; then
        log_info "Copying README.md..."
        cp "$template_dir/README.md" "$app_name/"
    fi

    # Copy assets directory if exists
    if [ -d "$template_dir/assets" ]; then
        log_info "Copying assets/ directory..."
        rm -rf "$app_name/assets"
        cp -r "$template_dir/assets" "$app_name/"
    fi

    # Copy platform-specific configurations (for templates like arcane_dock)
    for platform_dir in macos ios android web linux windows; do
        if [ -d "$template_dir/$platform_dir" ]; then
            log_info "Copying $platform_dir/ platform configuration..."
            # Only copy specific files to avoid overwriting critical flutter-generated files

            if [ "$platform_dir" = "macos" ]; then
                # Copy macOS Runner files (Info.plist, entitlements, Swift code, etc.)
                if [ -f "$template_dir/macos/Runner/Info.plist" ]; then
                    cp "$template_dir/macos/Runner/Info.plist" "$app_name/macos/Runner/" 2>/dev/null || true
                fi
                if [ -f "$template_dir/macos/Runner/DebugProfile.entitlements" ]; then
                    cp "$template_dir/macos/Runner/DebugProfile.entitlements" "$app_name/macos/Runner/" 2>/dev/null || true
                fi
                if [ -f "$template_dir/macos/Runner/Release.entitlements" ]; then
                    cp "$template_dir/macos/Runner/Release.entitlements" "$app_name/macos/Runner/" 2>/dev/null || true
                fi
                if [ -f "$template_dir/macos/Runner/MainFlutterWindow.swift" ]; then
                    cp "$template_dir/macos/Runner/MainFlutterWindow.swift" "$app_name/macos/Runner/" 2>/dev/null || true
                    log_info "Copied MainFlutterWindow.swift with launch_at_startup platform code"
                fi
            fi

            if [ "$platform_dir" = "linux" ]; then
                # Copy Linux runner files if they exist
                if [ -f "$template_dir/linux/flutter/CMakeLists.txt" ]; then
                    cp "$template_dir/linux/flutter/CMakeLists.txt" "$app_name/linux/flutter/" 2>/dev/null || true
                fi
            fi
        fi
    done

    # Add ASCII banner to main.dart
    if [ -f "$app_name/lib/main.dart" ]; then
        log_info "Adding ASCII banner to client app..."
        local banner_text=$(echo "$app_name" | tr '[:lower:]' '[:upper:]')

        # Determine the template type and set appropriate description
        local description=""
        case "$template_name" in
            arcane_template)
                description="Pure Arcane UI application - Multi-platform support"
                ;;
            arcane_beamer)
                description="Arcane UI with Beamer navigation - Multi-platform with routing"
                ;;
            arcane_dock)
                description="Desktop system tray application - macOS, Linux, Windows"
                banner_text="$banner_text DOCK"
                ;;
            *)
                description="Flutter application with Arcane UI"
                ;;
        esac

        add_banner_to_file "$app_name/lib/main.dart" "$banner_text" "$description"
    fi

    log_success "Template files copied successfully"
    return 0
}

copy_template_pubspec() {
    local app_name="$1"
    local template_dir="$2"

    log_step "Copying Template pubspec.yaml"

    if [ ! -f "$template_dir/pubspec.yaml" ]; then
        log_warning "Template pubspec.yaml not found, skipping copy"
        return 0
    fi

    log_info "Copying template pubspec.yaml to preserve comments and configuration..."

    # Backup the generated pubspec
    cp "$app_name/pubspec.yaml" "$app_name/pubspec.yaml.backup"

    # Copy template pubspec
    cp "$template_dir/pubspec.yaml" "$app_name/pubspec.yaml"

    # Update name in pubspec
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^name: .*/name: $app_name/" "$app_name/pubspec.yaml"
    else
        sed -i "s/^name: .*/name: $app_name/" "$app_name/pubspec.yaml"
    fi

    log_success "Template pubspec.yaml copied and customized"
    return 0
}

delete_test_folders() {
    local app_name="$1"
    local create_models="${2:-yes}"
    local create_server="${3:-yes}"
    local models_name="${app_name}_models"
    local server_name="${app_name}_server"

    log_step "Cleaning Up Test Folders"

    # Always delete client app test folder
    if [ -d "$app_name/test" ]; then
        log_info "Removing $app_name/test..."
        rm -rf "$app_name/test"
        log_success "Removed $app_name/test"
    fi

    # Delete models test folder if models package was created
    if [ "$create_models" = "yes" ] && [ -d "$models_name/test" ]; then
        log_info "Removing $models_name/test..."
        rm -rf "$models_name/test"
        log_success "Removed $models_name/test"
    fi

    # Delete server test folder if server app was created
    if [ "$create_server" = "yes" ] && [ -d "$server_name/test" ]; then
        log_info "Removing $server_name/test..."
        rm -rf "$server_name/test"
        log_success "Removed $server_name/test"
    fi

    return 0
}

# Run if script is executed directly
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <app_name> <org>"
        echo "Example: $0 my_app art.arcane"
        exit 1
    fi

    create_all_projects "$1" "$2"
fi

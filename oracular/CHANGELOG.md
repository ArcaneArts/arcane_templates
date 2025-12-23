## 2.2.0

- **Template Updates - arcane_jaspr_docs**:
  - Full theme switching system with 18 theme presets (colors, neutrals, OLED)
  - CSS variable-based theming using `ArcaneThemeProvider`
  - Theme persistence via localStorage
  - Search functionality with keyboard navigation
  - Code block copy buttons
  - Stateful theme toggle (sun/moon icons)
  - Updated sidebar with `ArcaneSideContent` and modern styling
  - Removed index.html for static mode compatibility

- **Template Updates - arcane_jaspr_app**:
  - Added shared `AppHeader` component with theme toggle
  - Stateful `App` component with dark/light mode switching
  - CSS variable-based theming using `ArcaneThemeProvider`
  - Theme persistence via localStorage
  - Updated screens to use shared header (DRY)
  - Added `AppConstants` class for centralized configuration
  - Theme initialization script in index.html (prevents flash)
  - Modern scrollbar and focus state styling

## 2.1.0

- **CLI Improvements**:
  - Interactive prompts for project configuration
  - Template-specific next steps in success message

## 2.0.0

- **Template Distribution**: Templates are now downloaded from GitHub at runtime
  - No longer bundled in the package - keeps install size small
  - Cached locally at `~/.oracular/templates/`
  - Automatic version checking and updates
- **New `templates` command**: Manage template cache
  - `oracular templates status` - Show cache status
  - `oracular templates update` - Download/update templates
  - `oracular templates clear` - Clear the cache
  - `oracular templates path` - Show cache location
- **CLI Framework**: Migrated to darted_cli
- **Script Runner**: Fuzzy matching with abbreviation support
- **Complete rewrite** of project scaffolding system

## 1.0.0

- Initial version.

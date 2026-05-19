# Changelog

All notable changes to this project will be documented in this file.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [0.2.7] - 2026-05-19

### Added
- Unit tests for `RedmineSubsimplify::Configuration` — covers `simplified_user?` (nil/admin), and all `hide_*?` setting methods.

## [0.2.6] - 2026-03-12
### Changed
- Improved accessibility: `a.user` links are strictly disabled for screen readers and keyboard navigation when hidden.
- Increased CSS specificity for simplified views, practically eliminating `!important` usage and preventing theme conflicts.
- Made JavaScript module URL matching more robust for custom reverse proxy paths.
- Removed dead fallback loops in JavaScript logic.

## [0.2.5] - 2026-03-12
### Added
- Feature to completely disable and hide user profile links globally (`Hide Link to User Profile`).
- Dynamic hiding of User Profile Privacy configuration when global hiding is active.
- Custom CSS text area to allow admins to inject custom `display: none !important` rules into the `<head>`.

### Fixed
- Tab visibility logic incorrectly hiding the whole tab bar (including the `+` menu) when only 1 tab was visible. The `+` new object menu now persists gracefully without container borders.

## [0.2.4] - 2026-03-01
### Changed
- Switched module visibility logic to strict whitelist mode, simplifying permission and module management.
- Refactored settings UI (use fieldsets, standardize checkboxes).

## [0.2.3] - 2026-02-15
### Removed
- Removed the manual "Simplified View" toggle from the top menu to enforce configuration globally.

## [0.2.2] - 2026-01-20
### Fixed
- Restored missing core files (Configuration, Hooks, Controller patch).

## [0.2.1] - 2025-12-10
### Added
- Added MIT License.
- Explicit requirement for Redmine >= 5.0.0.
- Core redirection logic for blocked pages and global pages.

## [0.2.0] - 2025-11-25
### Added
- Added profile customization settings (hiding activity, issues, projects).
- Added Overview page redirect.

## [0.1.1] - 2025-11-10
### Added
- Added Wiki Navigation sidebar support.

## [0.1.0] - 2025-10-01
### Added
- Initial release.

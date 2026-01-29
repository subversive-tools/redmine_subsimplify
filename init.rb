# Redmine Mini Plugin
# Provides a simplified UI for users with specific roles

Redmine::Plugin.register :redmine_mini do
  name 'Redmine Mini'
  author 'Your Name'
  description 'Provides a simplified UI for specific users - showing only Wiki and Issues with minimal UI clutter'
  version '1.0.0'
  url 'https://github.com/yourusername/redmine_mini'
  author_url 'https://github.com/yourusername'

  # Plugin settings
  settings default: {
    'simplified_roles' => [],  # Array of role IDs that get simplified view
    'hide_sidebar' => true,
    'hide_filters' => true,
    'hide_top_menu' => true,
    'allowed_modules' => ['issues', 'wiki']
  }, partial: 'settings/mini_settings'
end

# Load hooks and configuration
require_relative 'lib/redmine_mini/hooks'
require_relative 'lib/redmine_mini/configuration'

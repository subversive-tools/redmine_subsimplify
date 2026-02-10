# Redmine Subsimplify Plugin
# Provides a simplified UI for users with specific roles

Redmine::Plugin.register :redmine_subsimplify do
  name 'Redmine Subsimplify'
  author 'Stefan Mischke'
  description 'Provides a simplified UI for specific users - showing only Wiki and Issues with minimal UI clutter'
  version '0.2.4'
  url 'https://github.com/modoq/redmine_subsimplify'
  author_url 'https://github.com/modoq'
  
  requires_redmine :version_or_higher => '5.0.0'

  # Plugin settings
  settings default: {
    'simplified_roles' => [],  # Array of role IDs that get simplified view
    'simplified_groups' => [],
    'hide_sidebar' => true,
    'hide_filters' => true,
    'hide_user_issues' => true,
    'hide_user_projects' => true,
    'hide_user_activity' => true,
    'hide_user_others' => true,
    'hide_top_menu' => true,
    'hide_footer' => true,
    'hide_my_account' => true,
    'hide_overview' => true,
    'allowed_modules' => ['issues', 'wiki']
  }, partial: 'settings/subsimplify_settings'

  # Menu removed in v0.2.3
end

# Load hooks and configuration
require_relative 'lib/redmine_subsimplify/hooks'
require_relative 'lib/redmine_subsimplify/configuration'

# Apply Patches
Rails.application.config.after_initialize do
  require File.expand_path('../lib/redmine_subsimplify/patches/application_controller_patch', __FILE__)
  
  if defined?(ApplicationController)
    unless ApplicationController.included_modules.include?(RedmineSubsimplify::Patches::ApplicationControllerPatch)
      ApplicationController.send(:include, RedmineSubsimplify::Patches::ApplicationControllerPatch)
    end
  end
end

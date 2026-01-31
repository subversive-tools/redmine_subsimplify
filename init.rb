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
  }, partial: 'settings/mini_settings'

  menu :top_menu, :redmine_mini_toggle, { controller: 'redmine_mini', action: 'toggle' }, 
    caption: Proc.new {
      if User.current.pref[:redmine_mini_disabled] == 'true'
        I18n.t(:label_enable_simplified_view)
      else
        I18n.t(:label_disable_simplified_view)
      end
    },
    if: Proc.new {
      # Show only if user is configured for simplified view (has role or group)
      # We check the underlying configuration match, ignoring the override preference itself for visibility
      # to prevent the button from disappearing when disabled.
      user = User.current
      config = RedmineMini::Configuration
      
      # Copy specific logic from Configuration but matching RAW eligibility
      roles = Setting.plugin_redmine_mini['simplified_roles'] || []
      groups = Setting.plugin_redmine_mini['simplified_groups'] || []
      
      role_match = !roles.empty? && user.roles.any? { |r| roles.map(&:to_i).include?(r.id) }
      group_match = !groups.empty? && user.groups.any? { |g| groups.map(&:to_i).include?(g.id) }
      
      !user.admin? && !user.anonymous? && (role_match || group_match)
    },
    last: true
end

# Load hooks and configuration
require_relative 'lib/redmine_mini/hooks'
require_relative 'lib/redmine_mini/configuration'
require_relative 'lib/redmine_mini/wiki_sidebar_helper'

# Apply Patches
Rails.configuration.to_prepare do
  require_relative 'lib/redmine_mini/patches/projects_controller_patch'
  ProjectsController.send(:include, RedmineMini::Patches::ProjectsControllerPatch)
end

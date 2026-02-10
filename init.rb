# Redmine Subsimplify Plugin
# Provides a simplified UI for users with specific roles

Redmine::Plugin.register :redmine_subsimplify do
  name 'Redmine Subsimplify'
  author 'Stefan Mischke'
  description 'Provides a simplified UI for specific users - showing only Wiki and Issues with minimal UI clutter'
  version '0.2.2'
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

  menu :top_menu, :redmine_subsimplify_toggle, { controller: 'redmine_subsimplify', action: 'toggle' }, 
    caption: Proc.new {
      if User.current.pref[:redmine_subsimplify_disabled] == 'true'
        I18n.t(:label_enable_simplified_view)
      else
        I18n.t(:label_disable_simplified_view)
      end
    },
    if: Proc.new {
      # Show only if user is configured for simplified view (has role or group)
      # Check the underlying configuration match, ignoring the override preference itself for visibility
      # to prevent the button from disappearing when disabled.
      user = User.current
      config = RedmineSubsimplify::Configuration
      
      # Copy specific logic from Configuration but matching RAW eligibility
      roles = Setting.plugin_redmine_subsimplify['simplified_roles'] || []
      groups = Setting.plugin_redmine_subsimplify['simplified_groups'] || []
      
      role_match = !roles.empty? && user.roles.any? { |r| roles.map(&:to_i).include?(r.id) }
      group_match = !groups.empty? && user.groups.any? { |g| groups.map(&:to_i).include?(g.id) }
      
      !user.admin? && !user.anonymous? && (role_match || group_match)
    },
    last: true
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

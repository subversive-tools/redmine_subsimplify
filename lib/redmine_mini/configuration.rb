# frozen_string_literal: true

module RedmineMini
  class Configuration
    class << self
      # Check if the current user should see the simplified view
      def simplified_user?(user = User.current)
        return false if user.nil? || user.anonymous?
        return false if user.admin?  # Admins always see full UI

        # Check for user preference override (Toggle button)
        return false if user.pref[:redmine_mini_disabled] == 'true'

        simplified_role_ids = Setting.plugin_redmine_mini['simplified_roles'] || []
        simplified_group_ids = Setting.plugin_redmine_mini['simplified_groups'] || []
        
        return false if simplified_role_ids.empty? && simplified_group_ids.empty?

        # Check Roles
        if !simplified_role_ids.empty?
          simplified_role_ids = simplified_role_ids.map(&:to_i)
          return true if user.roles.any? { |role| simplified_role_ids.include?(role.id) }
        end

        # Check Groups
        if !simplified_group_ids.empty?
          simplified_group_ids = simplified_group_ids.map(&:to_i)
          return true if user.groups.any? { |group| simplified_group_ids.include?(group.id) }
        end

        false
      end

      # Get the list of allowed module names
      def allowed_modules
        Setting.plugin_redmine_mini['allowed_modules'] || ['issues', 'wiki']
      end

      # Check if sidebar should be hidden
      def hide_sidebar?
        val = Setting.plugin_redmine_mini['hide_sidebar']
        val.nil? ? true : (val.to_s != 'false')
      end

      # Check if filters should be hidden
      def hide_filters?
        val = Setting.plugin_redmine_mini['hide_filters']
        val.nil? ? true : (val.to_s != 'false')
      end

      # Check if top menu should be reduced
      def hide_top_menu?
        val = Setting.plugin_redmine_mini['hide_top_menu']
        val.nil? ? true : (val.to_s != 'false')
      end

      # Check if footer should be hidden
      def hide_footer?
        val = Setting.plugin_redmine_mini['hide_footer']
        val.nil? ? true : (val.to_s != 'false')
      end

      # Check if "My Account" should be hidden
      def hide_my_account?
        val = Setting.plugin_redmine_mini['hide_my_account']
        val.nil? ? true : (val.to_s != 'false')
      end

      # Check if "Overview" should be hidden
      def hide_overview?
        val = Setting.plugin_redmine_mini['hide_overview']
        val.nil? ? true : (val.to_s != 'false')
      end

      # User Profile Settings
      def hide_user_issues?
        val = Setting.plugin_redmine_mini['hide_user_issues']
        val.nil? ? true : (val.to_s != 'false')
      end

      def hide_user_projects?
        val = Setting.plugin_redmine_mini['hide_user_projects']
        val.nil? ? true : (val.to_s != 'false')
      end

      def hide_user_activity?
        val = Setting.plugin_redmine_mini['hide_user_activity']
        val.nil? ? true : (val.to_s != 'false')
      end

      def hide_user_others?
        val = Setting.plugin_redmine_mini['hide_user_others']
        val.nil? ? true : (val.to_s != 'false')
      end
    end
  end
end

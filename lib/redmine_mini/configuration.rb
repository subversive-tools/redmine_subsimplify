# frozen_string_literal: true

module RedmineMini
  class Configuration
    class << self
      # Check if the current user should see the simplified view
      def simplified_user?(user = User.current)
        return false if user.nil? || user.anonymous?
        return false if user.admin?  # Admins always see full UI

        simplified_role_ids = Setting.plugin_redmine_mini['simplified_roles'] || []
        return false if simplified_role_ids.empty?

        # Convert to integers for comparison
        simplified_role_ids = simplified_role_ids.map(&:to_i)

        # Check if user has any role that is in the simplified roles list
        user.roles.any? { |role| simplified_role_ids.include?(role.id) }
      end

      # Get the list of allowed module names
      def allowed_modules
        Setting.plugin_redmine_mini['allowed_modules'] || ['issues', 'wiki']
      end

      # Check if sidebar should be hidden
      def hide_sidebar?
        Setting.plugin_redmine_mini['hide_sidebar'] != false
      end

      # Check if filters should be hidden
      def hide_filters?
        Setting.plugin_redmine_mini['hide_filters'] != false
      end

      # Check if top menu should be reduced
      def hide_top_menu?
        Setting.plugin_redmine_mini['hide_top_menu'] != false
      end
    end
  end
end

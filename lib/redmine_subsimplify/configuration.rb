module RedmineSubsimplify
  class Configuration
    def self.simplified_user?(user = User.current)
      return false if user.nil? || user.admin?
      
      # Optional: Logic for anonymous users
      # return true if user.anonymous? 
      
      # Check Roles
      simplified_roles = Setting.plugin_redmine_subsimplify['simplified_roles'] || []
      return true if user.roles.any? { |r| simplified_roles.map(&:to_i).include?(r.id) }
      
      # Check Groups
      simplified_groups = Setting.plugin_redmine_subsimplify['simplified_groups'] || []
      return true if user.groups.any? { |g| simplified_groups.map(&:to_i).include?(g.id) }
      
      false
    end

    def self.hide_sidebar?
      Setting.plugin_redmine_subsimplify['hide_sidebar'] == 'true' || Setting.plugin_redmine_subsimplify['hide_sidebar'] == true
    end

    def self.hide_filters?
      Setting.plugin_redmine_subsimplify['hide_filters'] == 'true' || Setting.plugin_redmine_subsimplify['hide_filters'] == true
    end

    def self.hide_top_menu?
      Setting.plugin_redmine_subsimplify['hide_top_menu'] == 'true' || Setting.plugin_redmine_subsimplify['hide_top_menu'] == true
    end
    
    def self.hide_footer?
      Setting.plugin_redmine_subsimplify['hide_footer'] == 'true' || Setting.plugin_redmine_subsimplify['hide_footer'] == true
    end

    def self.hide_my_account?
      Setting.plugin_redmine_subsimplify['hide_my_account'] == 'true' || Setting.plugin_redmine_subsimplify['hide_my_account'] == true
    end

    def self.hide_overview?
      Setting.plugin_redmine_subsimplify['hide_overview'] == 'true' || Setting.plugin_redmine_subsimplify['hide_overview'] == true
    end

    def self.hide_user_issues?
      return true if hide_user_profile_links?
      Setting.plugin_redmine_subsimplify['hide_user_issues'] == 'true' || Setting.plugin_redmine_subsimplify['hide_user_issues'] == true
    end

    def self.hide_user_projects?
      return true if hide_user_profile_links?
      Setting.plugin_redmine_subsimplify['hide_user_projects'] == 'true' || Setting.plugin_redmine_subsimplify['hide_user_projects'] == true
    end

    def self.hide_user_activity?
      return true if hide_user_profile_links?
      Setting.plugin_redmine_subsimplify['hide_user_activity'] == 'true' || Setting.plugin_redmine_subsimplify['hide_user_activity'] == true
    end

    def self.hide_user_others?
      return true if hide_user_profile_links?
      Setting.plugin_redmine_subsimplify['hide_user_others'] == 'true' || Setting.plugin_redmine_subsimplify['hide_user_others'] == true
    end

    def self.hide_user_profile_links?
      Setting.plugin_redmine_subsimplify['hide_user_profile_links'] == 'true' || Setting.plugin_redmine_subsimplify['hide_user_profile_links'] == true
    end

    def self.custom_hidden_selectors
      raw = Setting.plugin_redmine_subsimplify['custom_hidden_selectors'] || ""
      raw.split("\n").map(&:strip).reject(&:blank?)
    end

    def self.allowed_modules
      Setting.plugin_redmine_subsimplify['allowed_modules'] || []
    end
  end
end

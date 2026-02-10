module RedmineSubsimplify
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context = {})
      return unless RedmineSubsimplify::Configuration.simplified_user?

      # Inject configuration for JS (Must be before JS file)
      config = {
        hideSidebar: RedmineSubsimplify::Configuration.hide_sidebar?,
        hideFilters: RedmineSubsimplify::Configuration.hide_filters?,
        hideTopMenu: RedmineSubsimplify::Configuration.hide_top_menu?,
        hideFooter: RedmineSubsimplify::Configuration.hide_footer?,
        hideMyAccount: RedmineSubsimplify::Configuration.hide_my_account?,
        hideOverview: RedmineSubsimplify::Configuration.hide_overview?,
        hideUserIssues: RedmineSubsimplify::Configuration.hide_user_issues?,
        hideUserProjects: RedmineSubsimplify::Configuration.hide_user_projects?,
        hideUserActivity: RedmineSubsimplify::Configuration.hide_user_activity?,
        hideUserOthers: RedmineSubsimplify::Configuration.hide_user_others?,
        allowedModules: RedmineSubsimplify::Configuration.allowed_modules
      }

      tags = []
      tags << javascript_tag("window.RedmineSubsimplifyConfig = #{config.to_json};")
      tags << stylesheet_link_tag('simplified_view', plugin: 'redmine_subsimplify')
      tags << javascript_include_tag('simplified_view', plugin: 'redmine_subsimplify')
      
      tags.join("\n")
    end

    def view_layouts_base_body_bottom(context = {})
      # No longer needed as config is injected in head
    end
  end
end

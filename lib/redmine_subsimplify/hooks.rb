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
        hideUserProfileLinks: RedmineSubsimplify::Configuration.hide_user_profile_links?,
        allowedModules: RedmineSubsimplify::Configuration.allowed_modules
      }

      tags = []

      # Inject Custom CSS Hiding Rules
      custom_hiding_css = RedmineSubsimplify::Configuration.custom_hidden_selectors
      if custom_hiding_css.any?
        # Safety: avoid outputting invalid CSS if they somehow entered weird strings
        # Join them all, and apply display: none !important
        css_rules = custom_hiding_css.join(",\n      ") + " {\n        display: none !important;\n      }"
        tags << "<style type=\"text/css\">\n      /* Redmine Subsimplify Custom Hidden Elements */\n      #{css_rules}\n      </style>".html_safe
      end

      tags << javascript_tag("window.RedmineSubsimplifyConfig = #{config.to_json};")
      tags << stylesheet_link_tag('simplified_view', plugin: 'redmine_subsimplify')
      tags << javascript_include_tag('simplified_view', plugin: 'redmine_subsimplify')
      
      tags.join("\n").html_safe
    end

    def view_layouts_base_body_bottom(context = {})
      # No longer needed as config is injected in head
    end
  end
end

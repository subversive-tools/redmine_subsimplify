# frozen_string_literal: true

module RedmineMini
  class Hooks < Redmine::Hook::ViewListener
    # Insert CSS and JS in the HTML head for simplified users
    def view_layouts_base_html_head(context = {})
      return '' unless RedmineMini::Configuration.simplified_user?

      # Build configuration JSON for JavaScript
      config = {
        hideSidebar: RedmineMini::Configuration.hide_sidebar?,
        hideFilters: RedmineMini::Configuration.hide_filters?,
        hideTopMenu: RedmineMini::Configuration.hide_top_menu?,
        hideFooter: RedmineMini::Configuration.hide_footer?,
        hideMyAccount: RedmineMini::Configuration.hide_my_account?,
        hideOverview: RedmineMini::Configuration.hide_overview?,
        hideUserIssues: RedmineMini::Configuration.hide_user_issues?,
        hideUserProjects: RedmineMini::Configuration.hide_user_projects?,
        hideUserActivity: RedmineMini::Configuration.hide_user_activity?,
        hideUserOthers: RedmineMini::Configuration.hide_user_others?,
        allowedModules: RedmineMini::Configuration.allowed_modules
      }

      output = []
      output << stylesheet_link_tag('simplified_view', plugin: 'redmine_mini')
      output << stylesheet_link_tag('wiki_sidebar', plugin: 'redmine_mini')
      output << javascript_include_tag('simplified_view', plugin: 'redmine_mini')
      output << javascript_include_tag('wiki_sidebar', plugin: 'redmine_mini')
      output << "<script>window.RedmineMiniConfig = #{config.to_json};</script>"
      output.join("\n").html_safe
    end

    include RedmineMini::WikiSidebarHelper

    # Add body class for CSS targeting
    def view_layouts_base_body_bottom(context = {})
      return '' unless RedmineMini::Configuration.simplified_user?

      output = []
      
      # Add class to body
      output << '<script>document.body.classList.add("simplified-view");</script>'

      # Render Wiki Sidebar if we are in a project context with wiki enabled
      if context[:project] && context[:project].module_enabled?(:wiki)
        sidebar_content = render_wiki_sidebar_tree(context[:project])
        unless sidebar_content.empty?
          output << <<~HTML
            <div id="mini-wiki-sidebar" class="mini-wiki-sidebar">
              <div class="mini-wiki-sidebar-toggle" onclick="toggleWikiSidebar()">
                <span class="icon"></span>
              </div>
              <div class="mini-wiki-sidebar-content">
                #{sidebar_content}
              </div>
            </div>
            <script>
              document.body.classList.add('has-mini-wiki-sidebar');
            </script>
          HTML
        end
      end

      output.join("\n").html_safe
    end
  end
end

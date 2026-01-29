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
        allowedModules: RedmineMini::Configuration.allowed_modules
      }

      output = []
      output << stylesheet_link_tag('simplified_view', plugin: 'redmine_mini')
      output << javascript_include_tag('simplified_view', plugin: 'redmine_mini')
      output << "<script>window.RedmineMiniConfig = #{config.to_json};</script>"
      output.join("\n").html_safe
    end

    # Add body class for CSS targeting
    def view_layouts_base_body_bottom(context = {})
      return '' unless RedmineMini::Configuration.simplified_user?

      <<-HTML.html_safe
        <script>
          document.body.classList.add('simplified-view');
        </script>
      HTML
    end
  end
end

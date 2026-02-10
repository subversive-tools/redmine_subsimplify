module RedmineSubsimplify
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context = {})
      return unless RedmineSubsimplify::Configuration.simplified_user?

      tags = []
      tags << stylesheet_link_tag('simplified_view', plugin: 'redmine_subsimplify')
      tags << javascript_include_tag('simplified_view', plugin: 'redmine_subsimplify')
      
      tags.join("\n")
    end

    def view_layouts_base_body_bottom(context = {})
      return unless RedmineSubsimplify::Configuration.simplified_user?
      
      # Add simplified-view class to body via JS if not possible via hook directly
      javascript_tag("document.body.classList.add('simplified-view');")
    end
  end
end

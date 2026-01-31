module RedmineMini
  module WikiSidebarHelper
    def render_wiki_sidebar_tree(project)
      return '' unless project.wiki

      pages = project.wiki.pages.includes(:content).order(:title).to_a
      return '' if pages.empty?

      # Group by parent_id to build tree
      pages_by_parent = pages.group_by(&:parent_id)
      root_pages = pages_by_parent[nil] || []

      return '' if root_pages.empty?

      render_tree(root_pages, pages_by_parent)
    end

    private

    def render_tree(pages, pages_by_parent)
      html = '<ul>'
      pages.each do |page|
        html << '<li>'
        html << link_to_page(page)
        html << render_headers(page)
        
        children = pages_by_parent[page.id]
        if children
          html << render_tree(children, pages_by_parent)
        end
        html << '</li>'
      end
      html << '</ul>'
      html
    end

    def link_to_page(page)
      # Basic link, improvements like "active" class can be handled by JS matching URL
      "<a href=\"#{Rails.application.routes.url_helpers.project_wiki_page_path(page.project, page.title)}\" class=\"wiki-page-link\" data-title=\"#{page.title}\">#{page.pretty_title}</a>"
    end

    def render_headers(page)
      return '' unless page.content
      
      # Simple regex to find H2 headers. 
      # Note: This is a rough parsing. For robust parsing we might need a proper markdown parser,
      # but standard Redmine textile/markdown formatting usually works with this or we can refine it.
      # We assume standard Textile 'h2. Title' or Markdown '## Title'
      
      text = page.content.text
      headers = []
      
      # Markdown ## Header
      text.scan(/^##\s+(.+)$/).each do |match|
        headers << match[0].strip
      end
      
      # Textile h2. Header
      text.scan(/^h2\.\s+(.+)$/).each do |match|
        headers << match[0].strip
      end

      return '' if headers.empty?

      html = '<ul class="wiki-page-headers">'
      headers.each do |header|
        anchor = header.parameterize
        html << "<li><a href=\"#{Rails.application.routes.url_helpers.project_wiki_page_path(page.project, page.title)}##{anchor}\" class=\"wiki-header-link\" data-anchor=\"#{anchor}\">#{header}</a></li>"
      end
      html << '</ul>'
      html
    end
  end
end

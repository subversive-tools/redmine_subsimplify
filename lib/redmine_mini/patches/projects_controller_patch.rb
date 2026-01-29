module RedmineMini
  module Patches
    module ProjectsControllerPatch
      def self.included(base)
        base.prepend(InstanceMethods)
      end

      module InstanceMethods
        def show
          if RedmineMini::Configuration.simplified_user? && RedmineMini::Configuration.hide_overview?
            # Redirect to first allowed module
            allowed = RedmineMini::Configuration.allowed_modules
            
            if allowed.include?('issues')
              redirect_to project_issues_path(@project)
              return
            elsif allowed.include?('wiki')
              # We need to handle the case where wiki might not exist yet, 
              # but typically redirection to wiki root handles it or redirects to creation.
              redirect_to project_wiki_path(@project, @project.wiki.try(:start_page) || 'Wiki')
              return
            end
          end
          
          super
        end
      end
    end
  end
end

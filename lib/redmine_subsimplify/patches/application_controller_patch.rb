module RedmineSubsimplify
  module Patches
    module ApplicationControllerPatch
      def self.included(base)
        base.send(:before_action, :redirect_simplified_user)
      end

      def redirect_simplified_user
        # Only check if user is a simplified user
        return unless RedmineSubsimplify::Configuration.simplified_user?
        
        # 1. Global Context (No Project)
        unless @project
          # Not yet implemented in v0.1.0
          return
        end

        # 2. Project Context (Existing Logic)

        # Special Case: Overview (projects#show)
        if controller_name == 'projects' && action_name == 'show'
          if RedmineSubsimplify::Configuration.hide_overview?
            redirect_to_project_module(@project)
            return
          end
        end

        # Dynamic Module Check
        current_action = "#{controller_name}/#{action_name}"
        
        permission = Redmine::AccessControl.permissions.detect do |p|
          p.actions.include?(current_action)
        end

        if permission && permission.project_module
          module_name = permission.project_module.to_s
          
          config_key = case module_name
                       when 'issue_tracking', 'time_tracking'
                         'issues'
                       else
                         module_name
                       end

          allowed = RedmineSubsimplify::Configuration.allowed_modules
          
          unless allowed.include?(config_key)
            redirect_to_project_module(@project)
            return
          end
        end
      end

      private

      def redirect_to_project_module(project)
        allowed = RedmineSubsimplify::Configuration.allowed_modules
        
        if allowed.include?('issues')
          redirect_to project_issues_path(project)
        elsif allowed.include?('wiki')
          redirect_to project_wiki_path(project, nil)
        elsif allowed.include?('news')
          redirect_to project_news_index_path(project)
        elsif allowed.include?('documents')
          redirect_to project_documents_path(project)
        elsif allowed.include?('files')
          redirect_to project_files_path(project)
        elsif allowed.include?('boards')
          redirect_to project_boards_path(project)
        elsif allowed.include?('repository')
          redirect_to project_repository_path(project)
        elsif allowed.include?('calendar')
          redirect_to project_calendar_path(project)
        elsif allowed.include?('gantt')
          redirect_to project_gantt_path(project)
        else
          # Fallback: redirect to home if no module is allowed
          redirect_to home_path
        end
      end
    end
  end
end

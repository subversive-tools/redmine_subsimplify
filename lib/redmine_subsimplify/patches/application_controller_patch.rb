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
          # List of global controllers to block
          blocked_global_controllers = ['projects', 'issues', 'activities', 'news', 'gantts', 'calendars']
          
          if blocked_global_controllers.include?(controller_name)
            # Try to find the first project the user has access to
            first_project = User.current.projects.visible.first
            
            if first_project
              # Redirect to the first allowed module of the first visible project
              redirect_to_project_module(first_project)
              return
            else
              # If the user has no visible projects, redirect to the home page
              redirect_to home_path
              return
            end
          end
          
          # If not a blocked controller, allow (e.g. My Page, Account, etc.)
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
          
          # Special handling for Activity (which has no dedicated project_module permission usually, but we want to control it)
          if config_key == 'activity'
             unless allowed.include?('activity')
               redirect_to_project_module(@project)
               return
             end
          else
             unless allowed.include?(config_key)
               redirect_to_project_module(@project)
               return
             end
          end
        end
      end

      private

      def redirect_to_project_module(project)
        # List of all possible modules in order of preference
        possible_modules = [
          'issues', 'wiki', 'news', 'documents', 'files', 
          'boards', 'repository', 'calendar', 'gantt'
        ]
        
        allowed = RedmineSubsimplify::Configuration.allowed_modules
        
        # Find the first module that IS in the allowed list AND enabled in the project
        first_allowed = possible_modules.detect do |mod| 
          allowed.include?(mod) && project.module_enabled?(mod)
        end

        case first_allowed
        when 'issues'
          redirect_to project_issues_path(project)
        when 'wiki'
          redirect_to project_wiki_path(project, nil)
        when 'news'
          redirect_to project_news_index_path(project)
        when 'documents'
          redirect_to project_documents_path(project)
        when 'files'
          redirect_to project_files_path(project)
        when 'boards'
          redirect_to project_boards_path(project)
        when 'repository'
          redirect_to project_repository_path(project)
        when 'calendar'
          redirect_to project_calendar_path(project)
        when 'gantt'
          redirect_to project_gantt_path(project)
        else
          # Fallback: redirect to home if no module is allowed
          redirect_to home_path
        end
      end
    end
  end
end

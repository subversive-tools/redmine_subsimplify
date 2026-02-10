/**
 * Redmine Subsimplify - Simplified View JavaScript
 * Dynamically hides/removes UI elements based on configuration
 */

(function () {
  'use strict';

  // Wait for DOM to be ready
  document.addEventListener('DOMContentLoaded', function () {
    var config = window.RedmineSubsimplifyConfig || {};

    // Ensure body class is set
    document.body.classList.add('simplified-view');

    // Apply granular visibility classes based on configuration
    if (config.hideSidebar) {
      document.body.classList.add('rm-hide-sidebar');
    }

    if (config.hideFilters) {
      document.body.classList.add('rm-hide-filters');
    }

    if (config.hideTopMenu) {
      document.body.classList.add('rm-hide-top-menu');
    }

    if (config.hideFooter) {
      document.body.classList.add('rm-hide-footer');
    }

    if (config.hideMyAccount) {
      document.body.classList.add('rm-hide-my-account');
    }

    if (config.hideOverview) {
      document.body.classList.add('rm-hide-overview');
    }

    if (config.hideUserIssues) {
      document.body.classList.add('rm-hide-user-issues');
    }

    if (config.hideUserProjects) {
      document.body.classList.add('rm-hide-user-projects');
    }

    if (config.hideUserActivity) {
      document.body.classList.add('rm-hide-user-activity');
    }

    if (config.hideUserOthers) {
      document.body.classList.add('rm-hide-user-others');
    }

    // Hide project menu items based on allowed modules (Whitelist)
    if (config.allowedModules) {
      applyModuleWhitelist(config.allowedModules);
    }

    // Additional DOM manipulations
    hideExtraElements();
  });

  /**
   * Apply whitelist logic: Hide all project menu items unless they are in allowedModules
   */
  function applyModuleWhitelist(allowedModules) {
    var mainMenu = document.getElementById('main-menu');
    if (!mainMenu) return;

    var menuItems = mainMenu.querySelectorAll('ul > li');

    menuItems.forEach(function (item) {
      var link = item.querySelector('a');
      if (!link) return;

      // Extract module name
      var moduleName = getModuleName(item, link);

      // Strict Whitelist: 
      // If we can identify a module name, checks if it is allowed. 
      // If we CANNOT identify it (unknown plugin), HIDE IT by default.
      if (moduleName) {
        if (!allowedModules.includes(moduleName)) {
          item.style.display = 'none';
        }
      } else {
        // Unknown module -> Hide by default for safety
        item.style.display = 'none';
      }
    });
  }

  /**
   * Extract module name from menu item
   */
  function getModuleName(item, link) {
    // 1. Try to get from known module classes
    var classes = item.className.split(' ');
    // Map CSS classes to Redmine Module names (as stored in settings)
    var classToModule = {
      'issues': 'issue_tracking',
      'new-issue': 'issue_tracking',
      'time-entries': 'time_tracking',
      'wiki': 'wiki',
      'news': 'news',
      'documents': 'documents',
      'files': 'files',
      'repository': 'repository',
      'boards': 'boards',
      'calendar': 'calendar',
      'gantt': 'gantt'
    };

    for (var i = 0; i < classes.length; i++) {
      if (classToModule[classes[i]]) {
        return classToModule[classes[i]];
      }
    }

    // 2. Fallback: try to match standard class names if no mapping exists
    // (This covers cases where class name matches module name perfectly)
    for (var i = 0; i < classes.length; i++) {
      // ... (simplified check)
    }

    // 3. Fallback: Try to extract from href
    var href = link.getAttribute('href') || '';

    // Check for activity
    if (href.indexOf('/activity') !== -1) return 'activity';

    // Check for issues (catch-all)
    if (href.indexOf('/issues') !== -1) return 'issue_tracking';

    var match = href.match(/\/projects\/[^\/]+\/([^\/\?]+)/);
    if (match) {
      // Map URL segments to module names if needed
      var segment = match[1];
      if (segment === 'issues') return 'issue_tracking';
      if (segment === 'time_entries') return 'time_tracking';
      return segment;
    }

    return null;
  }

  /**
   * Hide additional UI elements that are hard to target with CSS
   */
  function hideExtraElements() {
    // Hide "Jump to a project" dropdown if present
    var projectJump = document.getElementById('project-jump');
    if (projectJump) {
      // Keep it but simplify - optional
    }

    // Hide custom queries sidebar section
    var queriesSection = document.querySelector('#sidebar .queries');
    if (queriesSection) {
      queriesSection.style.display = 'none';
    }

    // Hide "Add filter" dropdown
    var addFilterButton = document.getElementById('add_filter_select');
    if (addFilterButton) {
      addFilterButton.style.display = 'none';
    }

    // Hide "+" dropdown menu (New Object)
    var plusMenu = document.getElementById('new-object');
    if (plusMenu) {
      plusMenu.style.display = 'none';
    }

    // Remove "All Projects" from Project Quick Jump Box
    var projectJumpBox = document.getElementById('project_quick_jump_box');
    if (projectJumpBox) {
      // The "All Projects" option usually has an empty value or specific text
      // We iterate to find it. Usually it is the first option or value=""
      for (var i = 0; i < projectJumpBox.options.length; i++) {
        if (projectJumpBox.options[i].value === '') {
          projectJumpBox.remove(i);
          break; // Usually only one
        }
      }
    }
  }

})();

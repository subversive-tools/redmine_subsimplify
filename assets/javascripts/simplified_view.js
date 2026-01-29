/**
 * Redmine Mini - Simplified View JavaScript
 * Dynamically hides/removes UI elements based on configuration
 */

(function() {
  'use strict';

  // Wait for DOM to be ready
  document.addEventListener('DOMContentLoaded', function() {
    var config = window.RedmineMiniConfig || {};
    
    // Ensure body class is set
    document.body.classList.add('simplified-view');

    // Hide project menu items based on allowed modules
    if (config.allowedModules && config.allowedModules.length > 0) {
      hideDisallowedModules(config.allowedModules);
    }

    // Additional DOM manipulations
    hideExtraElements();
  });

  /**
   * Hide project menu items that are not in the allowed modules list
   */
  function hideDisallowedModules(allowedModules) {
    var mainMenu = document.getElementById('main-menu');
    if (!mainMenu) return;

    var menuItems = mainMenu.querySelectorAll('ul > li');
    
    menuItems.forEach(function(item) {
      var link = item.querySelector('a');
      if (!link) return;

      // Extract module name from class or href
      var moduleName = getModuleName(item, link);
      
      if (moduleName && !allowedModules.includes(moduleName)) {
        item.style.display = 'none';
      }
    });
  }

  /**
   * Extract module name from menu item
   */
  function getModuleName(item, link) {
    // Try to get from class name (e.g., "issues", "wiki", "news")
    var classes = item.className.split(' ');
    var moduleClasses = ['issues', 'wiki', 'news', 'documents', 'files', 
                         'repository', 'boards', 'calendar', 'gantt', 
                         'activity', 'roadmap', 'time-entries', 'settings'];
    
    for (var i = 0; i < classes.length; i++) {
      if (moduleClasses.includes(classes[i])) {
        return classes[i];
      }
    }

    // Fallback: try to extract from href
    var href = link.getAttribute('href') || '';
    var match = href.match(/\/projects\/[^\/]+\/([^\/\?]+)/);
    if (match) {
      return match[1];
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

    // Hide context menu on right-click for issues (optional)
    // This prevents access to bulk operations
    // Uncomment if needed:
    // document.querySelector('table.issues')?.addEventListener('contextmenu', function(e) {
    //   e.preventDefault();
    // });
  }

})();

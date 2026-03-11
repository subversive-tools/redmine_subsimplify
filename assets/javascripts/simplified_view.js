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

    if (config.hideUserProfileLinks) {
      document.body.classList.add('rm-hide-user-profile-links');
    }

    // Hide project menu items based on allowed modules (Whitelist)
    if (config.allowedModules) {
      applyModuleWhitelist(config.allowedModules);
    }

    // Additional DOM manipulations
    hideExtraElements();
  });

  function applyModuleWhitelist(allowedModules) {
    var mainMenu = document.getElementById('main-menu');
    if (!mainMenu) return;

    // Only select top-level li elements, not nested ones (like in the + dropdown)
    var menuItems = mainMenu.querySelectorAll(':scope > ul > li');
    var visibleCount = 0;

    menuItems.forEach(function (item) {
      var link = item.querySelector(':scope > a');
      if (!link) return;

      // Check if the item is already hidden by Redmine or CSS (e.g., Activity tab)
      // This happens because `rm-hide-user-activity` might hide the `#activity` section, 
      // but if the tab itself is styled away, we shouldn't count it. 
      // A more robust check: does it have display:none?
      var computedStyle = window.getComputedStyle(item);
      if (computedStyle.display === 'none') {
        return; // Already hidden, don't count it
      }

      // Safeguard: Do not process or hide the new-object menu if it is a list item here
      if (item.id === 'new-object' || item.querySelector('#new-object') || (link && link.classList.contains('new-object'))) {
        return;
      }

      // Extract module name
      var moduleName = getModuleName(item, link);

      // Strict Whitelist: 
      // If we can identify a module name, checks if it is allowed. 
      // If we CANNOT identify it (unknown plugin), HIDE IT by default.
      if (moduleName) {
        if (!allowedModules.includes(moduleName)) {
          item.style.display = 'none';
        } else {
          visibleCount++;
        }
      } else {
        // Unknown module -> Hide by default for safety
        item.style.display = 'none';
      }
    });

    // Hide the remaining tab if there is 1 or 0 tabs visible, but keep the + menu
    if (visibleCount <= 1) {
      document.body.classList.add('rm-single-tab');
      
      // Instead of hiding the whole menu, hide all items EXCEPT the + menu
      menuItems.forEach(function (item) {
        var link = item.querySelector(':scope > a');
        if (item.id === 'new-object' || item.querySelector('#new-object') || (link && link.classList.contains('new-object'))) {
          // Keep the + menu visible
        } else {
          item.style.display = 'none';
        }
      });
    }
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

    // "+" dropdown menu (New Object) is intentionally left intact for simplified users.

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

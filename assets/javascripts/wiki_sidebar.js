document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.getElementById('mini-wiki-sidebar');
    if (!sidebar) return;

    // 1. Move sidebar into #main to be a flex item
    const main = document.getElementById('main');
    if (main) {
        if (sidebar.parentElement !== main) {
            main.prepend(sidebar);
        }
    }

    // 2. Restore state (collapsed/open AND width) from localStorage
    const isClosed = localStorage.getItem('redmine_mini_wiki_sidebar_closed') === 'true';
    const storedWidth = localStorage.getItem('redmine_mini_wiki_sidebar_width');

    if (storedWidth && !isClosed) {
        sidebar.style.width = storedWidth + 'px';
        sidebar.style.minWidth = storedWidth + 'px';
    }

    if (isClosed) {
        document.body.classList.add('mini-wiki-sidebar-closed');
    }

    // 3. Resizer Implementation
    const resizer = document.createElement('div');
    resizer.className = 'mini-wiki-sidebar-resizer';
    sidebar.appendChild(resizer);

    let isResizing = false;

    resizer.addEventListener('mousedown', function (e) {
        e.preventDefault();
        isResizing = true;
        resizer.classList.add('resizing');
        document.body.style.cursor = 'col-resize';
        document.body.classList.add('no-select'); // Helper to prevent text selection while dragging
    });

    document.addEventListener('mousemove', function (e) {
        if (!isResizing) return;

        // Calculate new width
        const sidebarRect = sidebar.getBoundingClientRect();
        let newWidth = e.clientX - sidebarRect.left;

        // Constraints
        if (newWidth < 150) newWidth = 150; // Minimum content width
        if (newWidth > 600) newWidth = 600; // Max width safety

        sidebar.style.width = newWidth + 'px';
        sidebar.style.minWidth = newWidth + 'px';
    });

    document.addEventListener('mouseup', function (e) {
        if (!isResizing) return;
        isResizing = false;
        resizer.classList.remove('resizing');
        document.body.style.cursor = '';
        document.body.classList.remove('no-select');

        // Save width
        // Only save if NOT closed
        if (!document.body.classList.contains('mini-wiki-sidebar-closed')) {
            localStorage.setItem('redmine_mini_wiki_sidebar_width', parseInt(sidebar.style.width));
        }
    });


    // 4. Highlight current page
    const currentPath = window.location.pathname;
    let activeLink = null;

    const links = sidebar.querySelectorAll('a.wiki-page-link');
    links.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            activeLink = link;
        }
    });

    if (activeLink) {
        activeLink.classList.add('active');

        let parent = activeLink.parentElement; // li
        while (parent && parent !== sidebar) {
            if (parent.tagName === 'LI') {
                parent.classList.add('expanded');
            }
            if (parent.tagName === 'UL') {
                parent.style.display = 'block';
                if (parent.parentElement.tagName === 'LI') {
                    parent.parentElement.classList.add('expanded');
                }
            }
            parent = parent.parentElement;
        }

        if (!isClosed) {
            setTimeout(() => {
                activeLink.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
            }, 100);
        }
    }

    // 5. Expand/Collapse Tree Icons
    const items = sidebar.querySelectorAll('li');
    items.forEach(li => {
        // Fix: Ensure top level is always expanded
        const isTopLevel = li.parentElement.parentElement.classList.contains('mini-wiki-sidebar-content');
        if (isTopLevel) {
            li.classList.add('expanded');
        }

        const childrenUl = li.querySelector('ul');
        if (childrenUl) {
            // If top level, ensure UL is visible
            if (isTopLevel) {
                childrenUl.style.display = 'block';
            }

            const toggle = document.createElement('span');
            toggle.className = 'expand-icon';
            toggle.onclick = function (e) {
                e.preventDefault();
                e.stopPropagation();
                li.classList.toggle('expanded');
                // Toggle display for direct child UL to match "expanded" class state
                if (li.classList.contains('expanded')) {
                    childrenUl.style.display = 'block';
                } else {
                    childrenUl.style.display = 'none';
                }
            };
            li.insertBefore(toggle, li.firstChild);
        } else {
            const spacer = document.createElement('span');
            spacer.style.display = 'inline-block';
            spacer.style.width = '20px';
            li.insertBefore(spacer, li.firstChild);
        }
    });

    // 6. Global Toggle Function
    window.toggleWikiSidebar = function () {
        const wasClosed = document.body.classList.contains('mini-wiki-sidebar-closed');
        document.body.classList.toggle('mini-wiki-sidebar-closed');
        const isNowClosed = document.body.classList.contains('mini-wiki-sidebar-closed');

        localStorage.setItem('redmine_mini_wiki_sidebar_closed', isNowClosed);

        // Restore width if opening
        if (wasClosed && !isNowClosed) {
            const stored = localStorage.getItem('redmine_mini_wiki_sidebar_width');
            if (stored) {
                sidebar.style.width = stored + 'px';
                sidebar.style.minWidth = stored + 'px';
            } else {
                // Default reset
                sidebar.style.width = '280px';
                sidebar.style.minWidth = '280px';
            }
        }
    }
});

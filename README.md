# Redmine Subsimplify Plugin

![Version](https://img.shields.io/badge/version-0.2.6-blue.svg)
![Redmine](https://img.shields.io/badge/Redmine-5.0%20%7C%206.0-red.svg?logo=redmine)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A Redmine plugin that provides a simplified UI for specific user roles or groups. It hides unnecessary menus, sidebars, and explicitly restricts access to modules other than "Issues" and "Wiki".

---

## 🚀 Features

- **🎭 Role-Based Simplification**: Define exactly which user roles or groups see the simplified interface.
- **🧹 Clean Layout**: Automatically hide the Sidebar, Footer, and complex Top Menu elements.
- **🚫 Distraction-Free**: Hides Issue Filters, "My Account", and other advanced Redmine features.
- **📦 Modular Visibility**: Configure exactly which project modules (e.g., Issues, Wiki) stay visible.
- **↪️ Smart Redirect**: Automatically redirects users away from the "Overview" page to the first allowed module (e.g., directly to Issues).
- **👤 Profile Privacy**: Optionally hide tabs like "Projects", "Activity", and "Reported Issues" on user profiles.
- **🎨 Modern & Non-Destructive**: Uses CSS/JS to simplify the UI without altering Redmine's core functionality or permissions.
- **🌍 Localized**: Available in English and German.

## 📸 Screenshots

| Standard View | Simplified View |
|:---:|:---:|
| *(Add screenshot here)* | *(Add screenshot here)* |

## 📦 Installation

> [!IMPORTANT]
> The plugin directory **MUST** be named `redmine_subsimplify` for assets to load correctly.

1.  **Clone the repository** into your plugins directory:
    ```bash
    cd /path/to/redmine/plugins
    git clone https://github.com/yourusername/redmine_subsimplify.git redmine_subsimplify
    ```

2.  **Restart Redmine**.
    ```bash
    # Docker
    docker-compose restart redmine
    
    # Or for local installations
    touch tmp/restart.txt
    ```

3.  **Configure the plugin**

## ⚙️ Configuration

Navigate to **Administration > Plugins > Redmine Subsimplify > Configure**.

### General Settings

| Option | Description |
|:---|:---|
| **Roles with Simplified View** | Select which User Roles should see the simplified interface. |
| **Groups with Simplified View** | Select which User Groups should see the simplified interface. (Logic: Role OR Group match) |

### UI Simplification

| Option | Description |
|:---|:---|
| **Hide Standard Sidebar** | Completely removes the right-hand sidebar. |
| **Hide Issue Filters** | Hides the filter box above issue lists (queries). |
| **Simplify Top Menu** | Hides most top menu items, leaving only "Home" and "Projects". |
| **Hide Footer** | Removes the Redmine footer. |
| **Hide 'My Account'** | Hides the link to the user's account settings. |
| **Hide Project Overview** |  Hides the "Overview" tab and enables **Smart Redirect**. |

### Allowed Modules

| Option | Description |
|:---|:---|
| **Allowed Project Modules** | **Strict Whitelist**: Only checked modules remain visible. New modules from other plugins are **hidden by default** until explicitly allowed here. |

### User Profile Privacy

| Option | Description |
|:---|:---|
| **Hide Issues Tab** | Hides the list of reported issues on the user profile. |
| **Hide Projects Tab** | Hides the list of projects on the user profile. |
| **Hide Activity Tab** | Hides the user's activity stream on the profile. |
| **Hide Other Details** | Hides additional personal information fields. |

> [!NOTE]
> **Admin Override**: Administrators (users with the "Administrator" flag) will **always** see the full standard Redmine interface, regardless of these settings.

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a Pull Request.

1.  Fork it
2.  Create your feature branch (`git checkout -b feature/my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin feature/my-new-feature`)
5.  Create a new Pull Request

## 📄 License

This plugin is open source software licensed under the [MIT license](LICENSE).

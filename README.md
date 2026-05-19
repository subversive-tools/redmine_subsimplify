# Redmine Subsimplify Plugin

![Version](https://img.shields.io/badge/version-0.2.6-blue.svg)
![Redmine](https://img.shields.io/badge/Redmine-5.0%20%7C%206.0-red.svg?logo=redmine)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A Redmine plugin that presents a simplified interface for selected roles or groups — hiding menus, sidebars, and modules that are irrelevant to external stakeholders, without touching permissions or core functionality.

> Built for mixed-audience teams: keep the full interface for power users, reduce friction for everyone else.

## Screenshots

*(Screenshots coming soon)*

## Features

- **Role-based simplification**: define exactly which roles or groups see the simplified interface
- **Clean layout**: hide sidebar, footer, and complex top menu elements
- **Module whitelist**: configure which project modules stay visible — new modules from other plugins are hidden by default until explicitly allowed
- **Smart redirect**: automatically send users from the Overview page to their first allowed module (e.g. directly to Issues)
- **Profile privacy**: optionally hide Projects, Activity, and Reported Issues tabs on user profiles
- **Non-destructive**: uses CSS/JS only — no Redmine permissions or core data are changed
- **Admin override**: administrators always see the full standard interface regardless of settings
- **Localised**: English and German included

## Requirements

- Redmine 5.0 or higher

## Installation

> [!IMPORTANT]
> The plugin directory **MUST** be named `redmine_subsimplify` for assets to load correctly.

1. **Clone** into your plugins directory:
   ```bash
   cd /path/to/redmine/plugins
   git clone https://github.com/subversive-tools/redmine_subsimplify.git redmine_subsimplify
   ```

2. **Restart Redmine**.

## Configuration

Navigate to **Administration > Plugins > Subsimplify > Configure**.

### Target audience

| Option | Description |
|:---|:---|
| **Roles with simplified view** | Select which roles see the simplified interface |
| **Groups with simplified view** | Select which groups see the simplified interface (Role OR Group match) |

### UI simplification

| Option | Description |
|:---|:---|
| **Hide standard sidebar** | Removes the right-hand sidebar |
| **Hide issue filters** | Hides the filter box above issue lists |
| **Simplify top menu** | Leaves only Home and Projects in the top menu |
| **Hide footer** | Removes the Redmine footer |
| **Hide "My Account"** | Hides the link to account settings |
| **Hide project overview** | Hides the Overview tab and enables Smart Redirect |

### Allowed modules

| Option | Description |
|:---|:---|
| **Allowed project modules** | Strict whitelist — only checked modules remain visible for simplified users |

### User profile privacy

| Option | Description |
|:---|:---|
| **Hide Issues tab** | Hides reported issues on user profiles |
| **Hide Projects tab** | Hides project list on user profiles |
| **Hide Activity tab** | Hides activity stream on user profiles |

> [!NOTE]
> Administrators always see the complete Redmine interface, regardless of these settings.

## Contributing

Contributions are welcome — please fork the repository and open a Pull Request.

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

[MIT License](LICENSE) — Copyright (c) 2026 Stefan Mischke

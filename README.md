# Redmine Mini

Ein Redmine 6 Plugin für eine stark vereinfachte Benutzeroberfläche. Für bestimmte Rollen werden nur Wiki und Tickets angezeigt - ohne Sidebars, Filter oder extra Buttons.

## Features

- **Rollenbasierte Aktivierung**: Wähle welche Rollen die vereinfachte Ansicht sehen
- **Konfigurierbare Module**: Bestimme welche Projektmodule sichtbar bleiben (z.B. Issues, Wiki)
- **Ausblendbare Elemente**:
  - Sidebar
  - Issue-Filter
  - Teile des Top-Menüs
  - Export-Optionen
- **Mehrsprachig**: Deutsch und Englisch

## Installation

1. Plugin in das Redmine `plugins` Verzeichnis kopieren:
   ```bash
   cp -r redmine-mini /path/to/redmine/plugins/
   ```

2. Redmine neustarten:
   ```bash
   # Docker
   docker-compose restart redmine
   
   # Oder bei lokaler Installation
   touch tmp/restart.txt
   ```

3. Konfigurieren unter **Administration → Plugins → Redmine Mini → Configure**

## Konfiguration

| Einstellung | Beschreibung |
|-------------|--------------|
| **Rollen mit vereinfachter Ansicht** | Welche Rollen sehen die reduzierte UI |
| **Seitenleiste ausblenden** | Entfernt die komplette Sidebar |
| **Ticket-Filter ausblenden** | Versteckt den Filter-Bereich bei Issues |
| **Hauptmenü reduzieren** | Zeigt nur Home, My Page, Projects |
| **Erlaubte Module** | Welche Projektmodule im Menü bleiben |

## Hinweise

- **Admins** sehen immer die vollständige Oberfläche
- Das Ausblenden ist **kosmetisch** (CSS/JS-basiert)
- API-Zugriffe werden nicht blockiert

## Kompatibilität

- Redmine 6.x

## Lizenz

MIT License

# Twisted Path of Titans

GameServerApp blueprint files for hosting Path of Titans community servers with Captain Gecko's Windows Docker image.

This project stays based on `captaingecko/pot-server:windows`. It does not build or publish a replacement Docker image. The blueprint focuses on editable Path of Titans config templates, GSA-visible native game logs, and GSA RCON command/control wiring.

This is a community blueprint and is not an official Alderon Games or Captain Gecko project.

Credit to Captain Gecko for the Windows Path of Titans Docker image this blueprint is built around.

## Features

- GameServerApp custom Docker blueprint for Path of Titans.
- Uses Captain Gecko's Docker image: `captaingecko/pot-server:windows`.
- Persistent server data mounted under `\serverfiles`.
- Editable `Game.ini`, `GameUserSettings.ini`, MOTD, rules, commands, and whitelist files in GSA.
- Registers `\serverfiles\PathOfTitans\Saved\Logs` as a GSA `logs` directory so native Path of Titans logs can appear separately from the container log.
- Source Query and Source RCON wired to GSA-assigned ports.
- GSA monitoring configured to use Source Query with recovery enabled.
- GSA command/control configured through `rcon_1`.
- GSA tasks can handle routine restarts while Path of Titans internal restarts stay disabled by default.

## Repository Layout

```text
blueprints/
  path-of-titans-gsa-captain-gecko.json

docs/
  CAPTAIN-GECKO-IMAGE.md
  GSA-IMPORT.md
  RCON-AND-LOGGING.md
  TROUBLESHOOTING.md

marketplace-description.md
CHANGELOG.md
```

## Quick Start

For normal hosting, download the Twisted Path of Titans blueprint from the GameServerApp Marketplace in GameServerApp.

Use the repository JSON only for review, development, or manual testing:

```text
blueprints/path-of-titans-gsa-captain-gecko.json
```

Set the required GSA config values:

- `auth_token`: Alderon/Path of Titans auth token.
- `server_guid`: keep the default `{helper.uuid}` unless you need a fixed identity.
- `map`: `Island` for Gondwa, `Panjura`, `Riparia`, or an exact modded map name.
- `database`: usually `Remote`.

Start the server once and check:

- Docker container log for Captain Gecko image startup progress.
- GSA Logs page for native Path of Titans logs under `Saved\Logs`.
- GSA RCON command/control with save, broadcast, and stop.

## Ports

| GSA type | Default | Protocol | Purpose |
| --- | ---: | --- | --- |
| `game` | `7777` | UDP | Path of Titans game traffic |
| `raw` | `7778` | image-dependent | Extra raw/game port exposed by the image |
| `query` | `27015` | UDP | Source Query |
| `rcon` | `37015` | TCP | Source RCON for GSA |

## MOTD and Rules Formatting

Path of Titans does not support Markdown or HTML in `MOTD.txt` or `Rules.txt`. Alderon's hosting docs describe a small Path of Titans formatting syntax instead:

| Tag | Effect |
| --- | --- |
| `<title>Text</>` | Largest title font size |
| `<large>Text</>` | Large font size |
| `<small>Text</>` | Small font size |
| `<red>Text</>` | Red text |
| `<orange>Text</>` | Orange text |
| `<yellow>Text</>` | Yellow text |
| `<green>Text</>` | Green text |
| `<blue>Text</>` | Blue text |
| `<purple>Text</>` | Purple text |
| `<white>Text</>` | White text |

Formatting cannot be combined or nested. Every formatted line must close with `</>`. For example, `<red>Rule text</>` is valid; `<red>Rule text<>` will show the tag text in-game.

## Logging Model

The blueprint registers this folder as a GSA log source:

```text
\serverfiles\PathOfTitans\Saved\Logs
```

That gives GameServerApp a separate log directory from the Docker container log while still using Captain Gecko's image unchanged. The server must actually write native Path of Titans/Unreal logs there; if live testing shows only container stdout is available, the next step is to test Captain Gecko image-supported startup arguments while keeping this blueprint on the Captain Gecko image.

## RCON Model

The blueprint passes GSA's query/RCON port and bind-IP values through Captain Gecko's `EXTRA_ARGS`:

```text
-QueryPort={gameserver.query_port} -QueryIP=0.0.0.0 -RconPort={gameserver.rcon_port} -RconIP=0.0.0.0 -MULTIHOME=0.0.0.0 -ServerListIP={machine.ip} -log {config_parameter id="additional_launch_params"}
```

Do not copy the query/RCON placeholders into the editable `additional_launch_params` setting. GameServerApp resolves `{gameserver.query_port}` and `{gameserver.rcon_port}` in blueprint-owned fields, but existing saved config text can be inserted literally by the game image. The `additional_launch_params` field is only for extra literal flags that are not already supplied above.

The generated `Game.ini` also includes `[SourceQuery]` and `[SourceRCON]` sections using GSA variables, including the RCON password.

GSA monitoring uses Source Query so the dashboard checks the game query port, not only whether the Docker container is running.

GSA command/control uses:

| GSA action | RCON command |
| --- | --- |
| Save | `Save` |
| Broadcast | `Announce {message}` |
| Stop | `ProfileServer Stop` |

## RCON Command Reference

Path of Titans Source RCON accepts the same style of commands listed in Alderon's admin command docs, but RCON commands are sent without a leading `/` or `#`. For example, send `TeleportAll talonspoint`, not `/teleportall talonspoint`.

Official references:

- [Alderon Source RCON](https://hosting.pathoftitans.wiki/setup/source-rcon)
- [Alderon Chat/Admin Commands](https://hosting.pathoftitans.wiki/guide/chat-commands)
- [Alderon Player Management](https://hosting.pathoftitans.wiki/guide/manage-players)
- [Alderon Server Admins](https://hosting.pathoftitans.wiki/guide/server-admins)

| Category | Command | Purpose |
| --- | --- | --- |
| Server | `Save` | Save server state. |
| Server | `Load` | Load server state. |
| Server | `Announce <message>` | Broadcast a server-wide announcement. |
| Server | `Restart <seconds>` | Schedule a restart countdown. |
| Server | `CancelRestart` | Cancel a scheduled restart. |
| Server | `ServerInfo` | Show server information. |
| Players | `ListPlayers` | List connected players. |
| Players | `ListPlayerPositions` | List player positions. |
| Players | `PlayerInfo <Username/AGID>` | Show detailed player information. |
| Moderation | `Kick <Username/AGID> <reason>` | Kick a player. |
| Moderation | `Ban <Username/AGID> <duration> <admin reason> <user reason>` | Ban a player. Durations can use seconds, minutes, hours, or days. |
| Moderation | `BanIP <ip> <duration> <admin reason> <user reason>` | Ban an IP address. |
| Moderation | `Unban <Username/AGID>` | Remove a ban. |
| Moderation | `ReloadBans` | Reload `bans.txt`. |
| Moderation | `ServerMute <Username/AGID> <time> <admin reason> <user reason>` | Server-mute a player. |
| Moderation | `ServerUnmute <Username/AGID>` | Remove a server mute. |
| Whitelist | `Whitelist <Username/AGID>` | Add a player to the whitelist. |
| Whitelist | `DelWhitelist <Username/AGID>` | Remove a player from the whitelist. |
| Whitelist | `ReloadWhitelist` | Reload `whitelist.txt`. |
| Roles | `Promote <Username/AGID> <adminrole>` | Promote a player to a role. |
| Roles | `Demote <Username/AGID>` | Remove admin roles from a player. |
| Roles | `ListRoles` | List configured roles. |
| Teleport | `Teleport <Username/AGID> <POI or coordinates>` | Teleport a player. |
| Teleport | `Bring <Username/AGID>` | Bring a player to the caller/location context. |
| Teleport | `TeleportAll <POI or coordinates>` | Teleport all players. |
| Stats | `SetMarks <Username/AGID> <number>` | Set player marks. |
| Stats | `AddMarks <Username/AGID> <number>` | Add marks to a player. |
| Stats | `Heal <Username/AGID>` | Heal a player. |
| Stats | `GodMode <Username/AGID>` | Toggle god mode for a player. |
| World | `Weather <type>` | Set weather. |
| World | `TimeOfDay <time>` | Set time of day. |
| World | `Day` | Set daytime. |
| World | `ClearBodies` | Clear bodies. |
| Messages | `SystemMessage <user> <message>` | Send a system message to one player. |
| Messages | `SystemMessageAll <message>` | Send a system message to all players. |
| Messages | `DirectMessage <user> <message>` | Send a direct message. |

## Settings Reference

GameServerApp's public blueprint docs expose config template parameters as ID, name, info, type, and default content. This blueprint also uses GSA `section` values so related Path of Titans settings appear in organized groups while preserving stable parameter IDs for `Game.ini`. Parameter IDs intentionally use only letters and underscores for GSA editor compatibility.

| Section | Typical Settings |
| --- | --- |
| Server Setup | Alderon auth token, database, branch, launch args |
| Game | map, Discord invite, world clock, weather, auto-restart toggle |
| Access | password, reserved slots, admin AGIDs, whitelist, chat, name tags, map/minimap/markers |
| General Gameplay | group size, grouping restrictions, combat timer, group quests |
| Growth and Death | passive growth, quest multipliers, death penalties, fall/permadeath |
| World and Survival | fish, water, bodies, respawn, AFK, ping, logout, characters, speedhack checks |
| Caves and Nesting | home caves, hatchling caves, cave hunger, nest toggles and core nest tuning |
| World Systems | critters, burrows, waystones, trophy cooldowns, POI/explore quests |
| Remote Access | RCON command logging, failed attempts, timeouts, max connections, IP allowlist |
| Chat and Webhooks | webhook toggle, format, chat, command, report, login, logout, death, admin, error, and security endpoints |
| Advanced | allowed/disallowed characters and critters, creator mode save |

Common beginner-safe settings:

| Setting ID | GSA Label | Default | Notes |
| --- | --- | --- | --- |
| `auth_token` | `Alderon Auth Token` | blank | Required before first boot. |
| `map` | `Map` | `Island` | Use `Island`, `Panjura`, `Riparia`, or a modded map name. |
| `server_password` | `Server Password` | blank | Blank means public. |
| `reserved_slots` | `Reserved/Admin Slots` | `0` | Pair with roles in `Commands.ini` for reserved slots. |
| `enforce_whitelist` | `Enforce Whitelist` | `0` | Requires entries in `whitelist.txt`. |
| `allow_chat` | `Allow Chat` | `1` | Master chat toggle. |
| `allow_global_chat` | `Global Chat` | `1` | Disable for local/proximity-style communities. |
| `server_day_length` | `Day Length Minutes` | `60` | Longer values slow the day cycle. |
| `server_night_length` | `Night Length Minutes` | `30` | Longer values slow the night cycle. |
| `max_group_size` | `Maximum Group Size` | `10` | Uses Path of Titans group slots. |
| `passive_growth_per_minute` | `Passive Growth Per Minute` | `0` | `0` disables passive growth. |
| `quest_growth_multiplier` | `Quest Growth Multiplier` | `1` | Lower or raise quest growth rewards. |
| `quest_marks_multiplier` | `Quest Marks Multiplier` | `1.0` | Lower or raise quest mark rewards. |
| `fall_damage` | `Fall Damage` | `1` | Disable only for casual/sandbox servers. |
| `afk_disconnect_time` | `AFK Disconnect Seconds` | `600` | `0` disables AFK disconnect. |
| `max_client_ping_ms` | `Max Client Ping Ms` | `0` | `0` disables ping enforcement. |
| `home_caves` | `Home Caves` | `1` | Core cave system toggle. |
| `server_nesting` | `Nesting` | `1` | Core nesting toggle. |
| `enable_critters` | `Critters` | `1` | Disable for troubleshooting world performance. |
| `enable_waystones` | `Waystones` | `1` | Core travel system toggle. |
| `rcon_log_commands` | `Log RCON Commands` | `1` | Helpful for auditing admin actions. |
| `rcon_ip_allowlist_a` | `RCON IP Allowlist A` | blank | Leave blank unless restricting RCON access to trusted IPs. |

## Documentation

- [Captain Gecko image notes](docs/CAPTAIN-GECKO-IMAGE.md)
- [GSA import guide](docs/GSA-IMPORT.md)
- [RCON and logging](docs/RCON-AND-LOGGING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## License

No license has been declared yet. Add one before accepting external contributions.


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

Import this blueprint into GameServerApp:

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

## Logging Model

The blueprint registers this folder as a GSA log source:

```text
\serverfiles\PathOfTitans\Saved\Logs
```

That gives GameServerApp a separate log directory from the Docker container log while still using Captain Gecko's image unchanged. The server must actually write native Path of Titans/Unreal logs there; if live testing shows only container stdout is available, the next step is to test Captain Gecko image-supported startup arguments while keeping this blueprint on the Captain Gecko image.

## RCON Model

The blueprint passes GSA's query/RCON port and bind-IP values through Captain Gecko's `EXTRA_ARGS`:

```text
-QueryPort={gameserver.query_port} -QueryIP=0.0.0.0 -RconPort={gameserver.rcon_port} -RconIP=0.0.0.0 -MULTIHOME=0.0.0.0 -log
```

The generated `Game.ini` also includes `[SourceQuery]` and `[SourceRCON]` sections using GSA variables, including the RCON password.

GSA monitoring uses Source Query so the dashboard checks the game query port, not only whether the Docker container is running.

GSA command/control uses:

| GSA action | RCON command |
| --- | --- |
| Save | `Save` |
| Broadcast | `Announce {message}` |
| Stop | `ProfileServer Stop` |

## Documentation

- [Captain Gecko image notes](docs/CAPTAIN-GECKO-IMAGE.md)
- [GSA import guide](docs/GSA-IMPORT.md)
- [RCON and logging](docs/RCON-AND-LOGGING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## License

No license has been declared yet. Add one before accepting external contributions.

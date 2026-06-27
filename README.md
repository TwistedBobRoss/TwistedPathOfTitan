# Twisted Path of Titans

Windows Docker and GameServerApp blueprint files for hosting Path of Titans community servers.

This project packages a GameServerApp-ready Path of Titans server using a Windows Server Core container, AlderonGamesCmd updates, editable Path of Titans config templates, GSA-visible game logs, and GSA RCON command/control wiring.

This is a community project and is not an official Alderon Games image.

## Features

- GameServerApp custom Docker blueprint for Path of Titans.
- Windows Server Core LTSC 2022 container image.
- AlderonGamesCmd install/update on container start.
- Persistent server data under `\serverfiles`.
- Editable `Game.ini`, `GameUserSettings.ini`, MOTD, rules, commands, and whitelist files in GSA.
- Dedicated GSA game log file:
  `\serverfiles\PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log`
- Game output still mirrors to the Docker container log for live startup/debug visibility.
- Source Query and Source RCON settings wired to GSA-assigned ports.
- GSA command/control configured through `rcon_1`.
- GSA tasks can handle routine restarts while Path of Titans internal restarts stay disabled by default.

## Repository Layout

```text
blueprints/
  path-of-titans-gsa-windows-logging-rcon.json

docker/windows/ltsc2022/
  Dockerfile
  Start.ps1

docs/
  BUILD-AND-PUBLISH.md
  GSA-IMPORT.md
  RCON-AND-LOGGING.md
  TROUBLESHOOTING.md

marketplace-description.md
CHANGELOG.md
```

## Quick Start

Build and push the Windows image:

```powershell
docker login ghcr.io
docker build -f docker/windows/ltsc2022/Dockerfile -t ghcr.io/twistedbobross/twistedpathoftitan:windows-ltsc2022 docker/windows/ltsc2022
docker push ghcr.io/twistedbobross/twistedpathoftitan:windows-ltsc2022
```

Import this blueprint into GameServerApp:

```text
blueprints/path-of-titans-gsa-windows-logging-rcon.json
```

Set the required GSA config values:

- `auth_token`: Alderon/Path of Titans auth token.
- `server_guid`: keep the default `{helper.uuid}` unless you need a fixed identity.
- `map`: `Island` for Gondwa, `Panjura`, `Riparia`, or an exact modded map name.
- `database`: usually `Remote`.

Start the server once and check:

- Docker container log for install/startup progress.
- GSA Logs page for `PathOfTitansServer-GSA.log`.
- GSA RCON command/control with save, broadcast, and stop.

## Ports

| GSA type | Default | Protocol | Purpose |
| --- | ---: | --- | --- |
| `game` | `7777` | UDP | Path of Titans game traffic |
| `raw` | `7778` | TCP/UDP image-dependent | Extra mapped game/raw port |
| `query` | `27015` | UDP | Source Query |
| `rcon` | `37015` | TCP | Source RCON for GSA |

## Logging Model

The launcher writes server stdout/stderr to:

```text
\serverfiles\PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log
```

The same stream is mirrored to Docker stdout, so the container log still works. The blueprint registers `\serverfiles\PathOfTitans\Saved\Logs` as a GSA `logs` directory so GameServerApp can list the game log separately from the container log.

Path of Titans may also create native Unreal logs in the same `Saved\Logs` directory.

## RCON Model

The blueprint maps GSA's RCON port and password into both the container environment and the generated `Game.ini`.

```ini
[SourceRCON]
bEnabled=true
bLogging=true
Password="{gameserver.rcon_password}"
Port={gameserver.rcon_port}
IP="0.0.0.0"
```

GSA command/control uses:

| GSA action | RCON command |
| --- | --- |
| Save | `Save` |
| Broadcast | `Announce {message}` |
| Stop | `ProfileServer Stop` |

Live GSA acceptance testing is still recommended after pushing the image, because GSA's internal RCON implementation names are not publicly mapped in detail.

## Documentation

- [Build and publish](docs/BUILD-AND-PUBLISH.md)
- [GSA import guide](docs/GSA-IMPORT.md)
- [RCON and logging](docs/RCON-AND-LOGGING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## License

No license has been declared yet. Add one before accepting external contributions.

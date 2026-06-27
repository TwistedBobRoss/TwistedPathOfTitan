# RCON and Logging

This project separates game logging from the Docker container log while keeping the container log useful.

## Dedicated Game Log

The launcher writes server stdout/stderr to:

```text
C:\serverfiles\PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log
```

In GSA this appears under:

```text
\serverfiles\PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log
```

The same output is also mirrored to Docker stdout with `Tee-Object`, so startup failures still appear in the container log.

## Native Path of Titans Logs

Path of Titans may also create native Unreal logs under:

```text
\serverfiles\PathOfTitans\Saved\Logs
```

The blueprint registers the whole folder as a GSA `logs` directory, so both wrapper-created and native logs can be surfaced by GameServerApp.

## GSA RCON Wiring

The blueprint declares an RCON Docker port:

```json
"rcon": {
  "port": "37015",
  "multiplier": "1"
}
```

It passes GSA-owned values into the container:

```json
"RCON_PORT": "{gameserver.rcon_port}",
"RCON_PASSWORD": "{gameserver.rcon_password}"
```

The launcher starts Path of Titans with:

```text
-RconPort=$RconPort
-RconIP=0.0.0.0
-RconPassword=$RconPassword
```

The generated `Game.ini` also includes:

```ini
[SourceRCON]
bEnabled=true
bLogging=true
Password="{gameserver.rcon_password}"
Port={gameserver.rcon_port}
IP="0.0.0.0"
MaxFailedAttempts=5
Timeout=60
PageTimeout=5
MaxConnectionsPerIP=3
```

## GSA Commands

The blueprint uses:

```json
"command_control": {
  "type": "rcon_1",
  "commands": {
    "save": "Save",
    "broadcast": "Announce {message}",
    "quit": "ProfileServer Stop"
  }
}
```

Suggested acceptance tests:

- Send a GSA broadcast and confirm it appears in-game.
- Run save from GSA and check the command succeeds.
- Stop from GSA and confirm the container exits cleanly.
- Check whether RCON commands appear in `PathOfTitansServer-GSA.log` or native Path of Titans logs.

## Known Limit

No confirmed Path of Titans setting was found for a dedicated SourceRCON-only log file path. This project avoids invented `LogFilePath` keys and instead captures the server process output into a GSA-visible game log.

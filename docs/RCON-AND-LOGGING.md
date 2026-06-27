# RCON and Logging

This blueprint keeps Captain Gecko's Docker image unchanged and lets GameServerApp surface the game's native log folder.

## Native Game Logs

The blueprint registers this folder as a GSA log source:

```text
\serverfiles\PathOfTitans\Saved\Logs
```

Path of Titans/Unreal log files created in that folder should appear separately from the Docker container log on the GSA Logs page.

The Docker container log still remains useful for image startup, update/install output, and early failures before the game process starts.

## GSA RCON Wiring

The relevant Alderon hosting docs are:

- Source Query: `https://hosting.pathoftitans.wiki/setup/source-query`
- Source RCON: `https://hosting.pathoftitans.wiki/setup/source-rcon`

The blueprint declares an RCON Docker port:

```json
"rcon": {
  "port": "37015",
  "multiplier": "1"
}
```

It passes GSA-owned query/RCON port and bind-IP values through Captain Gecko's `EXTRA_ARGS`:

```text
-QueryPort={gameserver.query_port} -QueryIP=0.0.0.0 -RconPort={gameserver.rcon_port} -RconIP=0.0.0.0 -MULTIHOME=0.0.0.0 -log
```

The RCON password is written to `Game.ini`, not passed as a launch argument. Alderon's documentation lists command-line overrides for `-RconPort` and `-RconIP`; it documents the password as the `Password` key under `[SourceRCON]`.

The generated `Game.ini` also includes:

```ini
[SourceQuery]
bEnabled=true
Port={gameserver.query_port}
IP="0.0.0.0"

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

The RCON password used by GSA must be at least 8 characters long. Alderon recommends 16 or more characters and notes that `"`, `'`, `` ` ``, `=`, and `|` are not allowed in the password.

## GSA Monitoring

The blueprint uses Source Query monitoring:

```json
"monitoring": {
  "type": "source_query",
  "recovery_mode": true
}
```

GameServerApp's blueprint docs describe Source Query monitoring as checking whether the query port responds. Alderon's Source Query docs require `[SourceQuery]` in `Game.ini` and allow `-QueryPort` / `-QueryIP` command-line overrides, which is how this blueprint lines up GSA's assigned query port with the game server.

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
- Check whether RCON commands appear in native Path of Titans logs.

## Known Limit

This blueprint does not create a separate process-capture log because it does not replace Captain Gecko's image. If Captain Gecko's image only exposes stdout and does not leave native log files in `Saved\Logs`, the next step is to test Captain Gecko image-supported launch args while keeping this blueprint Captain-Gecko-based.

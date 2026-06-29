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

Captain Gecko's `EXTRA_ARGS` is intentionally kept minimal:

```text
-log {config_parameter id="additional_launch_params"}
```

The editable `additional_launch_params` value must stay blank unless you are adding unrelated literal startup flags. Do not put query/RCON placeholders in that field; otherwise they can be appended literally by the image.

The query port, RCON port, bind IPs, and RCON password are written to `Game.ini`, not passed as launch arguments. Alderon's documentation supports `[SourceQuery]` and `[SourceRCON]` config sections, and this avoids unresolved `{gameserver...}` placeholders appearing in the container startup command.

The generated `Game.ini` also includes:

```ini
[SourceQuery]
bEnabled=true
Port={gameserver.query_port}
IP="0.0.0.0"

[SourceRCON]
bEnabled=true
bLogging={config_parameter id="rcon_log_commands"}
Password="{gameserver.rcon_password}"
Port={gameserver.rcon_port}
IP="0.0.0.0"
MaxFailedAttempts={config_parameter id="rcon_max_failed_attempts"}
Timeout={config_parameter id="rcon_timeout"}
PageTimeout={config_parameter id="rcon_page_timeout"}
MaxConnectionsPerIP={config_parameter id="rcon_max_connections_per_ip"}
```

The RCON password used by GSA must be at least 8 characters long. Alderon recommends 16 or more characters and notes that `"`, `'`, `` ` ``, `=`, and `|` are not allowed in the password.

## GSA Monitoring

The blueprint uses Source Query monitoring:

```json
"monitoring": {
  "type": "query",
  "recovery_mode": true
}
```

GameServerApp's blueprint docs describe Source Query monitoring as checking whether the query port responds. Alderon's Source Query docs require `[SourceQuery]` in `Game.ini`, which is how this blueprint lines up GSA's assigned query port with the game server.

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


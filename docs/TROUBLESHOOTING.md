# Troubleshooting

## GSA Only Shows the Container Log

Confirm the imported blueprint has:

```json
"Logs": {
  "path": "\\serverfiles\\PathOfTitans\\Saved\\Logs",
  "create": true,
  "type": "logs"
}
```

Then restart the server and check whether Path of Titans creates native log files under:

```text
\serverfiles\PathOfTitans\Saved\Logs
```

If no files appear there, Captain Gecko's image may only be exposing live stdout for the current launch path. That would be a live-test finding, not something to solve by replacing the image preemptively.

## RCON Does Not Connect

Check these items:

- The GSA server has an admin/RCON password set.
- The RCON password is at least 8 characters long and does not contain `"`, `'`, `` ` ``, `=`, or `|`.
- The `launch_params` parameter still includes `-RconPort={gameserver.rcon_port}`.
- The generated `Game.ini` has `[SourceRCON]` with `Password="{gameserver.rcon_password}"`.
- The generated `Game.ini` has `[SourceRCON]` with `bEnabled=true`.
- The server was restarted after changing RCON settings.
- The GSA command/control type is still `rcon_1`.
- The RCON port is not blocked by host firewall rules.

## Monitoring Shows Offline While Container Is Running

This blueprint uses Source Query monitoring. Check these items:

- The generated `Game.ini` has `[SourceQuery]` with `bEnabled=true`.
- The `launch_params` parameter still includes `-QueryPort={gameserver.query_port}`.
- The query port is reachable over UDP.
- The server has fully finished first boot; Source Query monitoring will not report healthy until the game query service is responding.

## Server Starts Then Stops

Review:

- Docker container log.
- Native logs in `\serverfiles\PathOfTitans\Saved\Logs`, if present.
- Recent changes to `Game.ini`, `GameUserSettings.ini`, and `launch_params`.

If the process exits immediately after a config change, clear only the setting you changed first. Avoid wiping `Saved` unless you intentionally want to remove server data.

## First Boot Takes a Long Time

This can be normal when the Captain Gecko image downloads or updates Path of Titans server files. Watch the Docker container log during the first boot.

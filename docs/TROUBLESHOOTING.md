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
- The `launch_params` parameter still includes `-RconPort={gameserver.rcon_port}`.
- The `launch_params` parameter still includes `-RconPassword={gameserver.rcon_password}`.
- The generated `Game.ini` has `[SourceRCON]` with `bEnabled=true`.
- The server was restarted after changing RCON settings.
- The GSA command/control type is still `rcon_1`.
- The RCON port is not blocked by host firewall rules.

## Server Starts Then Stops

Review:

- Docker container log.
- Native logs in `\serverfiles\PathOfTitans\Saved\Logs`, if present.
- Recent changes to `Game.ini`, `GameUserSettings.ini`, and `launch_params`.

If the process exits immediately after a config change, clear only the setting you changed first. Avoid wiping `Saved` unless you intentionally want to remove server data.

## First Boot Takes a Long Time

This can be normal when the Captain Gecko image downloads or updates Path of Titans server files. Watch the Docker container log during the first boot.

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

Then restart the server. The launcher creates:

```text
\serverfiles\PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log
```

## The Log File Is Empty

Check the Docker container log first. If the server never reaches launch, the failure may have happened during update/install before Path of Titans starts.

Common causes:

- Missing or invalid `auth_token`.
- Windows container host mismatch.
- GHCR image pull failed.
- AlderonGamesCmd download failed.
- Path of Titans server executable was not created.

## RCON Does Not Connect

Check these items:

- The GSA server has an admin/RCON password set.
- The blueprint maps `RCON_PORT` to `{gameserver.rcon_port}`.
- The generated `Game.ini` has `[SourceRCON]` with `bEnabled=true`.
- The server was restarted after changing RCON settings.
- The GSA command/control type is still `rcon_1`.
- The RCON port is not blocked by host firewall rules.

## Server Starts Then Stops

Review:

- Docker container log.
- `PathOfTitansServer-GSA.log`.
- Native logs in `\serverfiles\PathOfTitans\Saved\Logs`.

If the process exits immediately after a config change, clear only the setting you changed first. Avoid wiping `Saved` unless you intentionally want to remove server data.

## First Boot Takes a Long Time

This is expected when `pot_update_on_start` is enabled. The image downloads or updates the Path of Titans server files through AlderonGamesCmd.

After a successful production install, you can disable update-on-start and let GSA scheduled tasks handle updates if preferred.

# GameServerApp Import Guide

Import this file as a custom Docker blueprint:

```text
blueprints/path-of-titans-gsa-windows-logging-rcon.json
```

## Required Values

| Parameter | Recommended value | Notes |
| --- | --- | --- |
| `auth_token` | Your Alderon token | Required for AlderonGamesCmd install/update. |
| `server_guid` | `{helper.uuid}` | Keep stable after first production boot if you need persistent identity. |
| `database` | `Remote` | Use the value expected by your Path of Titans setup. |
| `map` | `Island` | `Island` is Gondwa. Other examples: `Panjura`, `Riparia`. |
| `branch` | `production` | Change only when intentionally testing another branch. |

## Useful Optional Values

| Parameter | Notes |
| --- | --- |
| `server_password` | Leave blank for a public server. |
| `reserved_slots` | Number of reserved slots for admins or roles. |
| `server_discord_invite_code` | Invite code only, not the full Discord URL. |
| `enforce_whitelist` | Requires `whitelist.txt` entries. |
| `pot_update_on_start` | Runs AlderonGamesCmd before every launch when enabled. |
| `launch_params` | Extra args appended after the built-in GSA-owned args. Usually blank. |

## GSA Directories

The blueprint registers:

| Name | Path | Type |
| --- | --- | --- |
| Serverfiles | `\serverfiles` | `normal` |
| Logs | `\serverfiles\PathOfTitans\Saved\Logs` | `logs` |

The `logs` type is important. It lets GameServerApp list game logs separately from the Docker container log.

## First Boot

Use container monitoring for first boot. The first start can take several minutes because the image downloads or updates the server files through AlderonGamesCmd.

Recommended first checks:

1. Open the Docker container log and watch install/startup progress.
2. Open the GSA Logs page and check for `PathOfTitansServer-GSA.log`.
3. Confirm the generated `Game.ini` has `[SourceQuery]` and `[SourceRCON]`.
4. Test GSA RCON save, broadcast, and stop.

## Restart Strategy

Routine restarts should be handled by GSA tasks. The default config keeps Path of Titans internal auto-restart disabled to avoid dueling restart systems.

# GameServerApp Import Guide

Import this file as a custom Docker blueprint:

```text
blueprints/path-of-titans-gsa-captain-gecko.json
```

## Required Values

| Parameter | Recommended value | Notes |
| --- | --- | --- |
| `auth_token` | Your Alderon token | Required by the Captain Gecko image for Path of Titans install/update. |
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
| `launch_params` | Passed to Captain Gecko's `EXTRA_ARGS`; defaults wire Source Query and RCON ports/IPs to GSA. |

## Organized Settings

The blueprint exposes granular `Game.ini` controls as GSA config template parameters. To make the setup friendlier for new hosts, every parameter label starts with a numbered category such as `01 Required`, `06 Growth & Death`, or `10 RCON`. This keeps related settings grouped together in the GSA editor while leaving the underlying parameter IDs stable. Parameter IDs use only letters and underscores for GSA editor compatibility.

## GSA Directories

The blueprint registers:

| Name | Path | Type |
| --- | --- | --- |
| Serverfiles | `\serverfiles` | `normal` |
| Logs | `\serverfiles\PathOfTitans\Saved\Logs` | `logs` |

The `logs` type is important. It lets GameServerApp list native Path of Titans logs separately from the Docker container log.

## First Boot

The blueprint uses Source Query monitoring. The first start can take several minutes if the image downloads or updates server files, and monitoring will not show healthy until the game query service responds.

Recommended first checks:

1. Open the Docker container log and watch startup progress.
2. Open the GSA Logs page and check for files under `\serverfiles\PathOfTitans\Saved\Logs`.
3. Confirm the generated `Game.ini` has `[SourceQuery]` and `[SourceRCON]`.
4. Test GSA RCON save, broadcast, and stop.

## Restart Strategy

Routine restarts should be handled by GSA tasks. The default config keeps Path of Titans internal auto-restart disabled to avoid dueling restart systems.

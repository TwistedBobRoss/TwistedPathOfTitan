# GameServerApp Import Guide

For normal hosting, download the Twisted Path of Titans blueprint from the GameServerApp Marketplace in GSA. The Marketplace copy is the intended install path for production servers.

Use the repository JSON only for review, development, or manual testing:

```text
blueprints/path-of-titans-gsa-captain-gecko.json
```

## Required Values

| Parameter | Recommended value | Notes |
| --- | --- | --- |
| `auth_token` | Your Alderon token | Required by the Captain Gecko image for Path of Titans install/update. |
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
| `additional_launch_params` | Optional literal extra startup flags. Do not add `QueryPort`, `QueryIP`, `RconPort`, `RconIP`, or `-log`; the blueprint writes query and RCON settings into `Game.ini`. |
| `server_admin_agid_a` / `server_admin_agid_b` | Optional permanent admin Alderon Games IDs. The blueprint writes active `ServerAdmins=` lines into `Game.ini`. |

## Organized Settings

The blueprint exposes granular `Game.ini` controls as GSA config template parameters. To make the setup friendlier for new hosts, each parameter includes a `section` value such as `Server Setup`, `Growth and Death`, `Remote Access`, or `Chat and Webhooks`. This lets GSA group related settings into organized sections while leaving the underlying parameter IDs stable. Parameter IDs use only letters and underscores for GSA editor compatibility.

## MOTD and Rules Formatting

Path of Titans does not support Markdown or HTML in `MOTD.txt` or `Rules.txt`. Alderon's docs describe a small Path of Titans formatting syntax instead:

```text
<title>Largest title text</>
<large>Large text</>
<small>Small text</>
<red>Red text</>
<orange>Orange text</>
<yellow>Yellow text</>
<green>Green text</>
<blue>Blue text</>
<purple>Purple text</>
<white>White text</>
```

Use only one formatting tag at a time, and close formatted text with `</>`. For example, `<red>Rule text</>` is valid, while `<red>Rule text<>` will render the tag text literally in-game.

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

## Updating Existing Servers

After activating a newer blueprint version, re-save or reapply the config template so GSA regenerates `Game.ini`. Existing saved config files may still contain old commented `ServerAdmins` lines or literal query/RCON launch placeholders until the config template is applied again.

Expected startup args should no longer include `-QueryPort={gameserver.query_port}` or `-RconPort={gameserver.rcon_port}`. Query/RCON values should appear in `Game.ini` under `[SourceQuery]` and `[SourceRCON]`.

## Restart Strategy

Routine restarts should be handled by GSA tasks. The default config keeps Path of Titans internal auto-restart disabled to avoid dueling restart systems.


# Captain Gecko Image Notes

This repository intentionally stays based on Captain Gecko's Windows Path of Titans image:

```text
captaingecko/pot-server:windows
```

The blueprint does not build, wrap, or publish a replacement image.

Credit to Captain Gecko for the Windows Path of Titans Docker image. This repository maintains the Twisted Path of Titans GameServerApp blueprint layer around that image.

## Why This Approach

Using the existing image keeps the setup close to the working community container and avoids adding a second maintenance surface. The blueprint only controls what GameServerApp can control cleanly:

- Docker image reference.
- Port mappings.
- Persistent mount.
- Environment variables expected by Captain Gecko's image.
- Editable config templates.
- GSA log directory registration.
- GSA RCON command/control settings.

## Image Environment Mapping

The blueprint passes:

| Container env | GSA source |
| --- | --- |
| `GUID` | `{config_parameter id="server_guid"}` |
| `DATABASE` | `{config_parameter id="database"}` |
| `GAME_PORT` | `{gameserver.game_port}` |
| `BRANCH` | `{config_parameter id="branch"}` |
| `SERVER_NAME` | `{gameserver.list_name}` |
| `MAX_PLAYERS` | `{gameserver.slot_limit}` |
| `AG_AUTH_TOKEN` | `{config_parameter id="auth_token"}` |
| `EXTRA_ARGS` | `{config_parameter id="launch_params"}` |

Query and RCON are passed through `EXTRA_ARGS` so GSA owns the assigned query/RCON ports and password.

## If Native Log Files Do Not Appear

If live testing shows that no native Path of Titans log files appear under `Saved\Logs`, keep the blueprint on Captain Gecko's image and test image-supported launch arguments first. This repo should remain blueprint-first and Captain-Gecko-based.

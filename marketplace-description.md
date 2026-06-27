Twisted Path of Titans is a GameServerApp blueprint for hosting Path of Titans community servers with Captain Gecko's Windows Docker image.

Built by TwistedBobRoss, this blueprint gives server owners a clean starting point for running Path of Titans through GameServerApp with editable configuration files, persistent server data, GSA-visible native game logs, and GSA RCON command/control wiring.

Included:

- Windows Docker setup using `captaingecko/pot-server:windows`
- Game, raw, query, and RCON port mappings
- Editable Path of Titans `Game.ini` and `GameUserSettings.ini`
- MOTD, rules, commands, and whitelist file entries
- GSA variables for server name, slots, map, auth token, database mode, password, Discord invite, whitelist toggle, growth/time settings, and launch arguments
- GSA log source for `\serverfiles\PathOfTitans\Saved\Logs`
- Source Query and Source RCON configuration
- Source Query based GSA monitoring with recovery enabled
- GSA command/control using save, broadcast, and graceful stop commands

Recommended first steps:

1. Enter your Alderon auth token.
2. Confirm the internal map name, such as `Island` for Gondwa.
3. Start once and let Source Query monitoring report healthy after the game query service responds.
4. Check the GSA Logs page for native Path of Titans logs.
5. Test GSA RCON save, broadcast, and stop.
6. Use GSA tasks for routine scheduled restarts.

This is a community blueprint and is not an official Alderon Games or Captain Gecko project.

The Docker image used by this blueprint is maintained by Captain Gecko and is included here with permission. Full credit to Captain Gecko for the Windows Path of Titans Docker image that makes this setup possible.

Author: TwistedBobRoss

Twisted Path of Titans is a Windows GameServerApp blueprint for hosting Path of Titans community servers through Docker.

Built by TwistedBobRoss, this blueprint gives server owners a clean starting point for running Path of Titans in a Windows Server container with editable configuration files, persistent server data, GSA-visible game logs, and GSA RCON command/control wiring.

Included:

- Windows Docker setup using `ghcr.io/twistedbobross/twistedpathoftitan:windows-ltsc2022`
- AlderonGamesCmd server install/update on container start
- Game, raw, query, and RCON port mappings
- Editable Path of Titans `Game.ini` and `GameUserSettings.ini`
- MOTD, rules, commands, and whitelist file entries
- GSA variables for server name, slots, map, auth token, database mode, password, Discord invite, whitelist toggle, growth/time settings, and launch arguments
- Dedicated GSA log source for `\serverfiles\PathOfTitans\Saved\Logs`
- Separate launcher-created game log: `PathOfTitansServer-GSA.log`
- Source Query and Source RCON configuration
- GSA command/control using save, broadcast, and graceful stop commands

Recommended first steps:

1. Enter your Alderon auth token.
2. Confirm the internal map name, such as `Island` for Gondwa.
3. Start once with container monitoring.
4. Check the GSA Logs page for `PathOfTitansServer-GSA.log`.
5. Test GSA RCON save, broadcast, and stop.
6. Use GSA tasks for routine scheduled restarts.

This is a community project and is not an official Alderon Games image.

Author: TwistedBobRoss

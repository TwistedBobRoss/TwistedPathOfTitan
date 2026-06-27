# Changelog

## 0.1.0

- Added initial GameServerApp custom Docker blueprint.
- Added Windows Server Core LTSC 2022 Dockerfile and launcher.
- Added AlderonGamesCmd install/update flow.
- Added GSA-visible Path of Titans log directory with `type: logs`.
- Added dedicated launcher-created game log at `PathOfTitansServer-GSA.log`.
- Mirrored game output to Docker stdout for live container log visibility.
- Wired GSA RCON port/password into the container and generated `Game.ini`.
- Added Source Query and Source RCON config sections.
- Added README, import, build, RCON/logging, troubleshooting, and marketplace docs.

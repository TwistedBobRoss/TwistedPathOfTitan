# Changelog

## 0.2.0

- Restored the project to use Captain Gecko's `captaingecko/pot-server:windows` image directly.
- Removed custom Docker image and launcher requirements from the project direction.
- Registered `\serverfiles\PathOfTitans\Saved\Logs` as a GSA `logs` directory for native game logs.
- Kept GSA RCON command/control through `rcon_1`.
- Passed GSA query/RCON values through Captain Gecko's `EXTRA_ARGS`.
- Updated docs to describe the blueprint-first Captain Gecko image approach.

## 0.1.0

- Added initial GameServerApp custom Docker blueprint and docs.

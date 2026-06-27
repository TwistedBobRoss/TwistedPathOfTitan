# Build and Publish

This project uses a Windows Server Core LTSC 2022 container. Build it on a Windows Docker host configured for Windows containers.

## Image Name

The blueprint points at:

```text
ghcr.io/twistedbobross/twistedpathoftitan:windows-ltsc2022
```

If you publish under a different package or tag, update `docker.image.name` and `docker.image.tag` in:

```text
blueprints/path-of-titans-gsa-windows-logging-rcon.json
```

## Build

From the repository root:

```powershell
docker build `
  -f docker/windows/ltsc2022/Dockerfile `
  -t ghcr.io/twistedbobross/twistedpathoftitan:windows-ltsc2022 `
  docker/windows/ltsc2022
```

## Push to GHCR

Authenticate with a GitHub token that can publish packages:

```powershell
docker login ghcr.io
docker push ghcr.io/twistedbobross/twistedpathoftitan:windows-ltsc2022
```

## Local Smoke Test

You can smoke-test the wrapper without exposing a public server. The server still needs a valid Alderon auth token to download/update Path of Titans files.

```powershell
docker run --rm `
  -e SERVER_GUID="00000000-0000-4000-8000-000000000000" `
  -e AG_AUTH_TOKEN="paste-token-here" `
  -e SERVER_NAME="Twisted Path of Titans Test" `
  -e GAME_PORT="7777" `
  -e QUERY_PORT="27015" `
  -e RCON_PORT="37015" `
  -e RCON_PASSWORD="test-password" `
  -p 7777:7777/udp `
  -p 27015:27015/udp `
  -p 37015:37015/tcp `
  ghcr.io/twistedbobross/twistedpathoftitan:windows-ltsc2022
```

Expected results:

- The container downloads or updates Path of Titans server files.
- The launcher prints startup progress to Docker stdout.
- `C:\serverfiles\PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log` is created inside the container.

## Release Checklist

- Build the image.
- Push the image to GHCR.
- Import the blueprint into GameServerApp.
- Create a test GSA server.
- Enter an Alderon auth token.
- Start once with container monitoring.
- Confirm `PathOfTitansServer-GSA.log` appears on the GSA Logs page.
- Confirm GSA RCON save, broadcast, and stop commands.

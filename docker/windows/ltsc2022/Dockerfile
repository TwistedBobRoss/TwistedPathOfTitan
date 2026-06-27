# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass", "-Command"]

WORKDIR C:\serverfiles

ENV INSTALL_DIR="C:\serverfiles" `
    BRANCH="production" `
    DATABASE="Remote" `
    GAME_PORT="7777" `
    QUERY_PORT="27015" `
    RCON_PORT="37015" `
    RCON_PASSWORD="" `
    SERVER_NAME="Path of Titans Server" `
    SERVER_GUID="" `
    GAME_LOG_PATH="C:\serverfiles\PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log" `
    AG_AUTH_TOKEN="" `
    POT_UPDATE_ON_START="true" `
    EXTRA_ARGS=""

COPY Start.ps1 C:\Start.ps1

EXPOSE 7777/udp
EXPOSE 7778/tcp
EXPOSE 27015/udp
EXPOSE 37015/tcp

ENTRYPOINT ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass", "-File", "C:\\Start.ps1"]

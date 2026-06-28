# Chat and Webhooks

Path of Titans can send native server events to Discord webhooks or a general HTTP endpoint. The blueprint exposes these under the **Chat & Webhooks** section of the GameServerApp config template.

## Chat Log to Discord

1. Create a private Discord channel for server chat logs.
2. In the channel settings, open **Integrations** and create a webhook.
3. Copy the webhook URL.
4. In GameServerApp, open the server config template and select **Chat & Webhooks**.
5. Set **Enable Webhooks** to on.
6. Leave **Webhook Format** on `Discord`.
7. Paste the URL into **Player Chat Webhook URL**.
8. Save the config and restart the server.

The server writes the following generated entries to `Game.ini`:

```ini
[ServerWebhooks]
bEnabled=1
Format="Discord"
PlayerChat="https://discord.com/api/webhooks/..."
```

Treat webhook URLs like passwords. Anyone who has the URL can post messages to that Discord channel.

## Other Available Events

The same page also offers optional URLs for player commands, player reports, login and logout events, player deaths, admin commands, server errors, and security alerts. Leave a field blank when that event should not be delivered.

## Player Commands

`PlayerCommand` is separate from normal chat. By default, messages beginning with `!` are sent to the Player Command webhook rather than normal in-game chat. The **Player Command Escape Characters** field controls that prefix.

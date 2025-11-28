import requests
from config import DISCORD_WEBHOOK

def send_discord(message: str):
    if not DISCORD_WEBHOOK:
        return

    data = {"content": message}

    try:
        requests.post(DISCORD_WEBHOOK, json=data, timeout=5)
    except Exception as e:
        print(f"Failed to send Discord alert: {e}")

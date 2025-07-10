import requests
import os
from dotenv import load_dotenv

load_dotenv()

JULEP_API_KEY = os.getenv("JULEP_API_KEY")
AGENT_ID = os.getenv("AGENT_ID")

def run_agent(city):
    url = f"https://api.julep.ai/v1/agents/{AGENT_ID}/chat"
    headers = {
        "Authorization": f"Bearer {JULEP_API_KEY}",
        "Content-Type": "application/json"
    }

    data = {
        "input": f"Plan a foodie tour for {city}",
        "options": {
            "stream": False
        }
    }

    response = requests.post(url, json=data, headers=headers)

    if response.status_code == 200:
        result = response.json()
        print("🟢 Agent Response:\n")
        print(result["output"])
    else:
        print(f"🔴 Error: {response.status_code}")
        print(response.text)

if __name__ == "__main__":
    city = input("Enter a city name: ")
    run_agent(city)

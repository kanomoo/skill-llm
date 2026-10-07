#!/usr/bin/env python3
"""
Test Local AI Server (LM Studio on port 1234 & 9router integration)
"""
import sys
import json
import urllib.request
import urllib.error

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

print("=" * 60)
print("🧪 TESTING LOCAL AI SERVER (Qwen2.5-Coder-7B)")
print("=" * 60)

# 1. Direct LM Studio test
lm_url = "http://127.0.0.1:1234/v1/chat/completions"
print("\n1. Testing LM Studio Direct (http://127.0.0.1:1234/v1)...")
payload = {
    "model": "qwen2.5-coder-7b-instruct",
    "messages": [
        {"role": "system", "content": "You are a fast coding assistant."},
        {"role": "user", "content": "Reply: LOCAL_VULKAN_OK"}
    ],
    "max_tokens": 20,
    "temperature": 0.2
}
try:
    req = urllib.request.Request(
        lm_url,
        data=json.dumps(payload).encode('utf-8'),
        headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read().decode('utf-8'))
        msg = data['choices'][0]['message']['content'].strip()
        print(f"   [PASS] LM Studio Direct: \"{msg}\"")
except Exception as e:
    print(f"   [NOTICE] LM Studio server not active yet: {e}")
    print("            (Make sure download is complete and run scripts/start-lmstudio-server.bat)")

# 2. Test via 9router local-combo
nine_url = "http://127.0.0.1:20128/api/v1/chat/completions"
nine_key = "sk-f3d6cab8b802be93-58rcfd-b626c4b3"
print("\n2. Testing 9router -> Local Combo...")
try:
    req = urllib.request.Request(
        nine_url,
        data=json.dumps({
            "model": "local-combo",
            "messages": [{"role": "user", "content": "Reply: ROUTER_LOCAL_OK"}],
            "max_tokens": 15
        }).encode('utf-8'),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {nine_key}"
        }
    )
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read().decode('utf-8'))
        msg = data['choices'][0]['message']['content'].strip()
        print(f"   [PASS] 9router local-combo: \"{msg}\"")
except Exception as e:
    print(f"   [NOTICE] 9router local-combo test: {e}")

print("\n" + "=" * 60)
print("🎯 TEST COMPLETED")
print("=" * 60)

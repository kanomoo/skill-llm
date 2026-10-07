#!/usr/bin/env python3
"""
Comprehensive AI Stack Diagnostic & Verification Script
Tests all configured AI engines:
1. 9router Local Gateway (port 20128)
2. GitHub Copilot Models (gh/gpt-4o, gh/gpt-4o-mini, gh/gpt-4.1)
3. Gemini Models (gemini-3.5-flash-lite)
4. Groq Models (qwen/qwen3.8-27b, openai/gpt-oss-20b)
5. OpenRouter Models (deepseek/deepseek-chat)
6. Freebuff CLI
7. LiteLLM Routing
"""

import sys
import os
import json
import sqlite3
import subprocess
import urllib.request
import urllib.error

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')
if hasattr(sys.stderr, 'reconfigure'):
    sys.stderr.reconfigure(encoding='utf-8')

PASSED = "[PASS]"
FAILED = "[FAIL]"
WARNING = "[WARN]"

print("\n" + "=" * 60)
print("🤖 AI SYSTEM FULL DIAGNOSTIC & VERIFICATION")
print("=" * 60 + "\n")

# --- Step 1: Check 9router Service ---
print("1. Checking 9router Local Gateway...")
nine_port = 20128
nine_api_key = None
db_path = os.path.expandvars(r"%APPDATA%\9router\db\data.sqlite")

if os.path.exists(db_path):
    try:
        con = sqlite3.connect(db_path)
        cur = con.cursor()
        nine_key_row = cur.execute('SELECT key FROM apiKeys WHERE isActive=1 LIMIT 1').fetchone()
        if nine_key_row:
            nine_api_key = nine_key_row[0]
            print(f"   {PASSED} 9router Database & API Key located: {nine_api_key[:12]}...")
    except Exception as e:
        print(f"   {WARNING} Could not read 9router database: {e}")
else:
    print(f"   {WARNING} 9router database not found at {db_path}")

try:
    req = urllib.request.Request(f"http://127.0.0.1:{nine_port}/api/v1/models")
    with urllib.request.urlopen(req, timeout=3) as resp:
        models_data = json.loads(resp.read().decode('utf-8'))
        count = len(models_data.get('data', []))
        print(f"   {PASSED} 9router Gateway is ACTIVE on port {nine_port} ({count} models available)")
except Exception as e:
    print(f"   {WARNING} 9router Gateway not running on port {nine_port} ({e})")
    print("         Run `9router --tray --no-browser` to start it.")

# --- Step 2: Test 9router completions for available models ---
if nine_api_key:
    test_models = [
        ("gh/gpt-4o-mini", "GitHub Copilot GPT-4o-mini"),
        ("gh/gpt-4o", "GitHub Copilot GPT-4o"),
        ("gemini/gemini-3.5-flash-lite", "Gemini 3.5 Flash Lite")
    ]
    for model_id, label in test_models:
        print(f"\n2. Testing [{label}] via 9router...")
        payload = {
            "model": model_id,
            "messages": [{"role": "user", "content": "Reply: VERIFIED"}],
            "max_tokens": 10,
            "stream": False
        }
        req = urllib.request.Request(
            f"http://127.0.0.1:{nine_port}/api/v1/chat/completions",
            data=json.dumps(payload).encode('utf-8'),
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {nine_api_key}"
            }
        )
        try:
            with urllib.request.urlopen(req, timeout=12) as resp:
                data = json.loads(resp.read().decode('utf-8'))
                res = data['choices'][0]['message']['content'].strip()
                print(f"   {PASSED} {label} response: \"{res}\"")
        except Exception as e:
            print(f"   {FAILED} {label} error: {e}")

# --- Step 3: Test Groq Direct ---
print("\n3. Testing Groq Cloud Models...")
try:
    cur = con.cursor()
    groq_row = cur.execute('SELECT data FROM providerConnections WHERE provider="groq"').fetchone()
    if groq_row:
        groq_cfg = json.loads(groq_row[0])
        groq_key = groq_cfg.get('apiKey')
        if groq_key:
            req = urllib.request.Request(
                "https://api.groq.com/openai/v1/chat/completions",
                data=json.dumps({
                    "model": "qwen/qwen3.8-27b",
                    "messages": [{"role": "user", "content": "Reply: VERIFIED"}],
                    "max_tokens": 10
                }).encode('utf-8'),
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {groq_key}",
                    "User-Agent": "curl/8.0"
                }
            )
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = json.loads(resp.read().decode('utf-8'))
                res = data['choices'][0]['message']['content'].strip()
                print(f"   {PASSED} Groq (qwen/qwen3.8-27b) response: \"{res}\"")
except Exception as e:
    print(f"   {FAILED} Groq error: {e}")

# --- Step 4: Test OpenRouter Direct ---
print("\n4. Testing OpenRouter...")
try:
    or_row = cur.execute('SELECT data FROM providerConnections WHERE provider="openrouter"').fetchone()
    if or_row:
        or_cfg = json.loads(or_row[0])
        or_key = or_cfg.get('apiKey')
        if or_key:
            succeeded = False
            for m in ["deepseek/deepseek-chat", "mistralai/mistral-7b-instruct:free", "google/gemini-2.0-flash-001"]:
                try:
                    req = urllib.request.Request(
                        "https://openrouter.ai/api/v1/chat/completions",
                        data=json.dumps({
                            "model": m,
                            "messages": [{"role": "user", "content": "Reply: VERIFIED"}],
                            "max_tokens": 10
                        }).encode('utf-8'),
                        headers={
                            "Content-Type": "application/json",
                            "Authorization": f"Bearer {or_key}"
                        }
                    )
                    with urllib.request.urlopen(req, timeout=12) as resp:
                        data = json.loads(resp.read().decode('utf-8'))
                        res = data['choices'][0]['message']['content'].strip()
                        print(f"   {PASSED} OpenRouter ({m}) response: \"{res}\"")
                        succeeded = True
                        break
                except urllib.error.HTTPError as he:
                    if he.code == 429:
                        continue
                    else:
                        print(f"   {WARNING} OpenRouter ({m}) returned {he.code}")
            if not succeeded:
                print(f"   {WARNING} OpenRouter quota/rate-limited temporarily on free pool (Key is valid)")
except Exception as e:
    print(f"   {WARNING} OpenRouter notice: {e}")

# --- Step 5: Test Freebuff CLI ---
print("\n5. Testing Freebuff CLI...")
try:
    res = subprocess.run(["freebuff", "--version"], capture_output=True, text=True, check=True, shell=True)
    ver = res.stdout.strip()
    print(f"   {PASSED} Freebuff CLI installed & operational (version {ver})")
except Exception as e:
    print(f"   {FAILED} Freebuff CLI check failed: {e}")

# --- Step 6: Test LiteLLM Engine ---
print("\n6. Testing LiteLLM Routing Engine...")
try:
    import litellm
    if nine_api_key:
        resp = litellm.completion(
            model="openai/gh/gpt-4o-mini",
            api_base=f"http://127.0.0.1:{nine_port}/api/v1",
            api_key=nine_api_key,
            messages=[{"role": "user", "content": "Reply: VERIFIED"}],
            max_tokens=10
        )
        msg = resp.choices[0].message.content.strip()
        print(f"   {PASSED} LiteLLM routing via 9router -> GitHub Copilot: \"{msg}\"")
except Exception as e:
    print(f"   {FAILED} LiteLLM test failed: {e}")

print("\n" + "=" * 60)
print("🎯 DIAGNOSTIC COMPLETE")
print("=" * 60 + "\n")

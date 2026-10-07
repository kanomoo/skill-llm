---
name: litellm
description: Universal AI Gateway, model router, and cost controller for 100+ LLMs (Anthropic, Google, OpenAI, DeepSeek, Ollama). Use when an agent needs multi-model fallback, rate-limit recovery, unified OpenAI-compatible routing, or token usage tracking.
---

# LiteLLM Skill

`litellm` is installed in Python (`litellm` v1.104.0). It standardizes calls to over 100 LLMs into a single format with automatic fallbacks and retries.

## 1. Direct Python Usage with Fallback

```python
import litellm
from litellm import completion

# Automatic fallback if primary model fails (e.g. rate limit, down, context exceeded)
model_fallback_list = ["claude-3-7-sonnet-20250219", "gemini/gemini-2.5-pro", "deepseek/deepseek-chat"]

response = completion(
    model="claude-3-7-sonnet-20250219",
    messages=[{"role": "user", "content": "Explain Dijkstra algorithm"}],
    fallbacks=model_fallback_list,
    num_retries=2,
)

print(response.choices[0].message.content)
```

## 2. Launch Local OpenAI-Compatible Proxy

You can run a local LiteLLM proxy on your machine to route any tool or IDE:
```bash
litellm --port 4000
```
Then point any client to `http://localhost:4000/v1` with your models.

## Key Features
- **Automatic Fallbacks:** Prevents pipeline interruption.
- **Cost & Token Tracking:** Accurately measures latency, cost, and tokens across models.
- **Embedding & Router Support:** Unified interface for embeddings and semantic routing.

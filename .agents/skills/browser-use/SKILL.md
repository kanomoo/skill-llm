---
name: browser-use
description: Autonomous web browsing and visual UI interaction library powered by LLM and Computer Vision. Use when an agent needs to automate real web browsing, interact with websites that have no API, fill complex web forms, or extract data dynamically.
---

# Browser-Use Skill

`browser-use` is installed in Python (`browser_use` v0.13.11). It allows AI agents to control a real browser using visual screenshots and goal-oriented prompts.

## Quick Python Example

```python
import asyncio
from browser_use import Agent
from browser_use.browser.browser import Browser, BrowserConfig

async def main():
    # Configure browser
    browser = Browser(config=BrowserConfig(headless=False)) # Set True for silent
    
    agent = Agent(
        task="Go to https://news.ycombinator.com and find the top 3 AI-related stories",
        llm=None, # Automatically uses configured provider or pass ChatOpenAI / ChatAnthropic
        browser=browser,
    )
    history = await agent.run()
    print(history.final_result())

if __name__ == '__main__':
    asyncio.run(main())
```

## Advanced Capabilities
- **Visual Element Detection:** Identifies buttons, links, inputs even in canvas/shadow DOM without needing brittle CSS selectors.
- **Form Filling & Multi-step Navigation:** Can log in, handle pagination, and follow complex checkout or survey flows.
- **DOM & Screenshot History:** Keeps a full trace of steps taken and intermediate results.

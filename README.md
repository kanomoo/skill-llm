# ⚡ Universal Skills, MCP & Standards Installer

[![Antigravity](https://img.shields.io/badge/Antigravity-Universal%20Skills-purple?logo=google&logoColor=white)](https://github.com/kanomoo/Skill)
[![Automation](https://img.shields.io/badge/Automation-PowerShell%20%7C%20Bash-blue?logo=powershell&logoColor=white)](setup-global-skills.ps1)
[![Cross-Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-green.svg)](setup-global-skills.sh)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

ชุดสคริปต์อัตโนมัติสำหรับการติดตั้ง ซิงโครไนซ์ และแจกจ่าย **Universal Skills, MCP Servers, Agent Rules, และมาตรฐานการปฏิบัติการ (Effective Agent Principles)** ของ AI Agent ไปยังทุกเครื่อง ทั้ง **Windows** และ **Linux (เช่น Arch Linux / Ubuntu)**

---

## 🌟 วัตถุประสงค์ (Overview & Capabilities)

1. **Cross-Platform Sync (Windows & Linux):** เชื่อมโยงการตั้งค่า ทักษะ และเครื่องมือระหว่างเครื่องทำงาน Windows และเครื่อง Linux (Arch-Hyprland) ให้มีความสามารถระดับสูงสุดเท่ากัน 100%
2. **Global Deployment:** ติดตั้ง Skills, Rules, และ `mcp_config.json` เข้าสู่ Global Directory (`~/.gemini/config` และ `~/.agents`)
3. **Automated Package Check:** ตรวจสอบและติดตั้งแพ็กเกจ CLI และ Python ที่จำเป็นอัตโนมัติ (`repomix`, `litellm`, `browser-use`, `dspy`, `mem0ai`, `composio`, `@composio/core`)
4. **Project-level Deployment & Git Sync:** สแกนหาโปรเจกต์ทั้งหมดเพื่อกระจาย `.agents` และซิงค์ขึ้น GitHub อัตโนมัติ

---

## 📁 สิ่งที่สคริปต์แจกจ่าย (Deployed Assets)

### 1. กฎเหล็กและหลักการ (Rules)
* **`effective_agent_principles.md`:** กฎข้อ 0 (ประเมินเจตนาและหยิบ Skill/MCP อัตโนมัติ) + 5 ท่ามาตรฐาน Anthropic (Evaluator loop, workflows first, context hygiene)
* **`pdf_document_standards.md`:** มาตรฐานเอกสาร PDF แบบ In-place filling ไม่สร้างกล่องลอยเกะกะ
* **`ui_design_inspo_guidelines.md`:** แนวทางออกแบบ UI/UX ระดับโปรดักชัน ปราศจาก Generic AI Look
* **`windows_gui_foreground_principles.md`:** หลักการจัดการหน้าต่าง GUI และ Foreground

### 2. ทักษะขั้นสูง (Skills)
* **`academic-project-report`:** สร้างรายงานโครงงาน/เล่มจบ มาตรฐานมหาวิทยาลัย/KMUTNB (.docx, .pdf)
* **`browser-use`:** ควบคุมเบราว์เซอร์จริงผ่าน Vision และ LLM สำหรับเว็บที่ไม่มี API
* **`composio`:** เชื่อมต่อ AI กับ 1,000+ SaaS apps (GitHub, Slack, Gmail, Trello, Google Calendar)
* **`dspy-and-mem0`:** คอมไพล์ Prompt อัตโนมัติด้วย DSPy และระบบความจำระยะยาว Mem0
* **`inspo-design`:** ออกแบบ UI/UX อ้างอิงจาก 800+ เว็บจริง (Linear, Stripe)
* **`litellm`:** Universal Model Gateway, Fallback Router สลับโมเดลอัตโนมัติ และคุมงบ Token
* **`pdf-worksheet-solver`:** แก้โจทย์และกรอกใบงาน/ข้อสอบ PDF อัตโนมัติ
* **`repomix`:** รวมไฟล์ทั้งโปรเจกต์/Wiki เป็นไฟล์เดียว (XML/Markdown) พร้อมนับ Token
* **`slide-designer`:** ออกแบบสไลด์นำเสนอ Pitching สไตล์ Modern Executive Bento Grid (16:9)

### 3. MCP Configuration (`mcp_config.json`)
เทมเพลตสำหรับเชื่อมต่อ 17 MCP Servers:
`composio`, `inspo`, `chrome-devtools`, `playwright`, `mineru`, `perplexity`, `context7`, `supabase`, `neon`, `vercel`, `cloudflare`, `github`, `linear`, `postman`, `sentry`, `posthog`, `sequential-thinking`

---

## 🚀 วิธีการใช้งาน (Usage)

### 💻 บน Windows (PowerShell)

```powershell
# ติดตั้งแบบมาตรฐานไปยังทุกโปรเจกต์ใน C:\Project
.\setup-global-skills.ps1

# ติดตั้งเฉพาะ Global Profile (~/.gemini และ ~/.agents) พร้อมลงแพ็กเกจ Python/NPM อัตโนมัติ
.\setup-global-skills.ps1 -GlobalOnly -InstallPackages

# กำหนดโฟลเดอร์ Root อื่นๆ
.\setup-global-skills.ps1 -ProjectsRoot "D:\MyProjects"

# ติดตั้งและ Commit แต่ไม่ต้องรัน Git Push
.\setup-global-skills.ps1 -SkipGitPush
```

### 🐧 บน Linux / macOS / Arch-Hyprland (Bash)

```bash
# ให้สิทธิ์รันสคริปต์
chmod +x setup-global-skills.sh

# ติดตั้งแบบมาตรฐานไปยังทุกโปรเจกต์ใน $HOME/Projects
./setup-global-skills.sh

# ติดตั้งเฉพาะ Global Profile พร้อมลงแพ็กเกจ Python/NPM อัตโนมัติ (แนะนำสำหรับเครื่องใหม่)
./setup-global-skills.sh --global-only --install-packages

# กำหนดโฟลเดอร์ Root อื่นๆ
./setup-global-skills.sh --projects-root "$HOME/Projects"

# ติดตั้งและ Commit แต่ไม่ต้องรัน Git Push
./setup-global-skills.sh --skip-git-push
```

---

## 🤖 เครื่องมือ AI Gateway, Launchers & ตัวทดสอบระบบ (Diagnostics)

ภายในโฟลเดอร์ `scripts/` มีเครื่องมืออำนวยความสะดวกสำหรับการรัน AI เบื้องหลังและการทดสอบระบบ:

### 1. ทดสอบระบบ AI ทั้งหมดในเครื่อง (Comprehensive Diagnostic)
รันคำสั่งเพื่อทดสอบ 9router, GitHub Copilot, Gemini, Groq, OpenRouter, Freebuff CLI และ LiteLLM:
```powershell
python scripts/test-all-ai.py
```

### 2. รัน 9router เป็น Background Service (System Tray)
```powershell
# ผ่าน Batch script หรือ PowerShell
.\scripts\start-9router.bat
# หรือ
.\scripts\start-9router.ps1
```
* เปิดที่ `http://127.0.0.1:20128`
* เชื่อมโยงโมเดลอัตโนมัติ: `gh/gpt-4o`, `gh/gpt-4.1`, `gh/gpt-4o-mini`, `gemini/gemini-3.5-flash-lite`, ฯลฯ

### 3. รัน LiteLLM Unified Proxy
```powershell
.\scripts\start-litellm.bat
# หรือ
.\scripts\start-litellm.ps1
```
* เปิด OpenAI-compatible endpoint ที่ `http://127.0.0.1:4000`
* ใช้คอนฟิกจาก `litellm_config.yaml` รวมทุกโมเดลเข้าด้วยกัน

### 4. รัน Local AI (Qwen2.5-Coder-7B บน RX 580 Vulkan GPU)
```powershell
# รันเซิร์ฟเวอร์ LM Studio พอร์ต 1234
.\scripts\start-lmstudio-server.bat
# หรือ
.\scripts\start-lmstudio-server.ps1

# ทดสอบ Local AI Server
python scripts\test-local-ai.py
```
* เปิด OpenAI-compatible endpoint ที่ `http://127.0.0.1:1234/v1`
* ปรับแต่งด้วย **Vulkan Backend** ดึง VRAM การ์ดจอ 100% พร้อม Context 32K สำหรับอ่าน Wiki โดยเฉพาะ
* เชื่อมโยงเข้ากับ 9router ผ่านโมเดล `local-combo` หรือ `local/qwen2.5-coder-7b-instruct` อัตโนมัติ



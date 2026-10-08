# 🐧 Cross-Platform AI Setup Guide: Windows Notebook & Arch Linux (Hyprland)

คู่มือการติดตั้งและการตั้งค่าระบบ AI สำหรับเครื่องทำงานต่างแพลตฟอร์ม เพื่อให้ **Notebook (Windows)** และ **Arch Linux (Hyprland)** มีความสามารถและทักษะ Agent เท่าเทียมกัน 100%

---

## 🪟 1. สำหรับเครื่อง Windows Notebook

บน Windows คุณสามารถใช้งานโปรแกรม GUI และสคริปต์อัตโนมัติได้อย่างสมบูรณ์:

1. **Local LLM Engine:**
   * **LM Studio:** ดาวน์โหลดตัวติดตั้ง `.exe` รองรับ GPU Acceleration (CUDA) ใช้งานง่าย
   * **Ollama for Windows:** ติดตั้งผ่าน Windows Installer หรือรันเบื้องหลัง
2. **การซิงค์ทักษะและโปรเจกต์ (1-Click Setup):**
   * รันคำสั่งใน PowerShell:
     ```powershell
     cd C:\Project\skill-llm
     .\setup-global-skills.ps1 -InstallPackages
     ```
   * สคริปต์จะติดตั้ง Universal Skills, MCP Servers (`mcp_config.json`), และ Rules (รวมถึงสิทธิ์ฟรีและเมลนักศึกษา `user_emails_and_free_perks.md`) เข้าสู่ `~/.gemini/config` และ `~/.agents` โดยอัตโนมัติ

---

## 🐧 2. สำหรับเครื่อง Arch Linux (Hyprland / Wayland)

บน Arch Linux โดยเฉพาะสภาพแวดล้อม **Hyprland (Wayland)** ไม่แนะนำให้ใช้ LM Studio เนื่องจาก:
* ไม่มีแพ็กเกจทางการใน `pacman`
* ไฟล์ AppImage มีปัญหากับการแสดงผลบน Wayland (Fractional scaling, XWayland blur) และการเชื่อมโยง CUDA มักไม่เสถียร

### 💡 เครื่องมือที่แนะนำให้ใช้แทนบน Arch Linux:

| เครื่องมือ | วิธีติดตั้งบน Arch Linux | จุดเด่น & การทำงานร่วมกับ Hyprland |
| :--- | :--- | :--- |
| **1. Ollama (แนะนำอันดับ 1)** | `sudo pacman -S ollama`<br>*(การ์ดจอ Nvidia: `yay -S ollama-cuda`)* | รันเป็น Systemd Service ในเบื้องหลัง (`systemctl enable --now ollama`), ไม่มี GUI ให้เกะกะ, ต่อ API กับ LiteLLM ทันทีที่พอร์ต `11434` |
| **2. llama.cpp** | `yay -S llama.cpp-cuda` | เร็วที่สุด เบาที่สุด ควบคุมผ่าน CLI 100% รันคำสั่ง `llama-server -m model.gguf --port 8080` |
| **3. Jan (GUI Alternative)** | `yay -S jan-bin` | แอปพลิเคชัน GUI หน้าตาคล้าย LM Studio แต่เป็น Open-source แท้ และรองรับ Wayland ได้เสถียรกว่า |
| **4. Open-WebUI** | `docker run -d -p 3000:8080 ghcr.io/open-webui/open-webui:main` | เว็บแอปหน้าตาสวยงามเหมือน ChatGPT รองรับ RAG และเชื่อมต่อ Ollama ได้ทันที |

### 🚀 ขั้นตอนการติดตั้งบน Arch Linux:

1. **ติดตั้ง Dependencies และเครื่องมือพื้นฐาน:**
   ```bash
   sudo pacman -S git python python-pip nodejs npm
   # ติดตั้ง Ollama สำหรับ Local AI
   sudo pacman -S ollama
   sudo systemctl enable --now ollama
   
   # ดึงโมเดลสำหรับงานเขียนโค้ด (เช่น Qwen2.5 Coder 7B)
   ollama pull qwen2.5-coder:7b
   ```

2. **รันสคริปต์ติดตั้ง Universal Skills & Rules:**
   ```bash
   cd ~/Projects/skill-llm  # หรือโฟลเดอร์ที่คุณ clone ไว้
   chmod +x setup-global-skills.sh
   ./setup-global-skills.sh --install-packages
   ```

3. **การเชื่อมต่อ Local LLM เข้ากับ LiteLLM Gateway:**
   ในไฟล์ `litellm_config.yaml` สามารถกำหนด Endpoint ชี้ไปที่ Ollama บน Arch Linux ได้ทันที:
   ```yaml
   model_list:
     - model_name: local-coder
       litellm_params:
         model: ollama/qwen2.5-coder:7b
         api_base: http://localhost:11434
   ```

---

## 🔄 3. การซิงค์และใช้งานสิทธิ์ฟรี (Free Perks & Emails)

ในเครื่องทุกเครื่อง เมื่อรัน `setup-global-skills` แล้ว จะได้รับ Rule [`user_emails_and_free_perks.md`](file:///C:/Users/PC/.gemini/config/rules/user_emails_and_free_perks.md) โดยอัตโนมัติ:
* **`few717254@gmail.com`**: GitHub Student Pack, Copilot Free, Git Commit/Push
* **`36965@sbw.ac.th`**: Google Drive Vault (คลังเก็บข้อสอบและชีทขนาดใหญ่)
* **`s6806021612037@email.kmutnb.ac.th`**: KMUTNB Google Classroom, Microsoft Azure for Students ($100/yr), M365 (Word/Excel/OneDrive)

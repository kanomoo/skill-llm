# ⚡ Universal Skills & Standards Installer

[![Antigravity](https://img.shields.io/badge/Antigravity-Universal%20Skills-purple?logo=google&logoColor=white)](https://github.com/kanomoo/Skill)
[![Automation](https://img.shields.io/badge/Automation-PowerShell%20%7C%20Bash-blue?logo=powershell&logoColor=white)](setup-global-skills.ps1)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

ชุดสคริปต์อัตโนมัติสำหรับการติดตั้ง ซิงโครไนซ์ และแจกจ่าย **Universal Skills, Agent Rules, และมาตรฐานเอกสาร (Document Standards)** ของ Antigravity AI ไปยังทุก Workspace และระดับ Global User Profile

---

## 🌟 วัตถุประสงค์ (Overview & Capabilities)

โปรเจกต์นี้จัดทำขึ้นเพื่อแก้ปัญหาการอัปเดต Agent Configuration ซ้ำซ้อนในหลายๆ โปรเจกต์ โดยทำหน้าที่:
1. **Global Deployment:** ติดตั้ง Skills และ Rules เข้าสู่ Global Configuration Directory (`~/.gemini/config` และ `~/.agents`)
2. **Project-level Deployment:** สแกนหาโปรเจกต์ทั้งหมดในโฟลเดอร์ Root (`C:\Project` หรือ `$HOME/Projects`) เพื่อคัดลอก `.agents/skills`, `.agents/rules` และ `AGENTS.md` เข้าไปติดตั้งให้อัตโนมัติ
3. **Automated Git Sync:** ตรวจจับการเปลี่ยนแปลงใน Git repository แต่ละตัว ทำการ Add, Commit และ Push ขึ้นรีโมตสาขาหลักอย่างรวดเร็ว

---

## 📁 สิ่งที่สคริปต์แจกจ่าย (Deployed Assets)

* **`.agents/rules/pdf_document_standards.md`:** กฎและมาตรฐานการสร้างเอกสาร PDF / เอกสารวิชาการคุณภาพสูง
* **`.agents/skills/academic-project-report/`:** สกิลเครื่องมือช่วยสร้างและจัดฟอร์แมตรายงานโครงงานและเล่มจบ
* **`.agents/skills/pdf-worksheet-solver/`:** สกิลเครื่องมือแก้โจทย์และวิเคราะห์แบบฝึกหัดจากไฟล์เอกสาร
* **`.agents/skills/slide-designer/`:** สกิลออกแบบสไลด์นำเสนอและการ Pitching ระดับมืออาชีพ (16:9 Widescreen, Visual Bento Grids, Modern Layouts)
* **`AGENTS.md`:** คู่มือภาพรวมและแนวทางปฏิบัติสำหรับผู้ช่วย AI ในแต่ละโปรเจกต์

---

## 🚀 วิธีการใช้งาน (Usage)

### รันผ่าน PowerShell (Windows)

```powershell
# ติดตั้งแบบมาตรฐานไปยังทุกโปรเจกต์ใน C:\Project พร้อม Git Push
.\setup-global-skills.ps1

# กำหนดโฟลเดอร์ Root อื่นๆ
.\setup-global-skills.ps1 -ProjectsRoot "D:\MyProjects"

# ติดตั้งเฉพาะ Global Profile (~/.gemini และ ~/.agents)
.\setup-global-skills.ps1 -GlobalOnly

# ติดตั้งและ Commit แต่ไม่ต้องรัน Git Push
.\setup-global-skills.ps1 -SkipGitPush
```

### รันผ่าน Bash (Linux / macOS)

```bash
# ติดตั้งแบบมาตรฐานไปยังทุกโปรเจกต์ใน $HOME/Projects พร้อม Git Push
./setup-global-skills.sh

# กำหนดโฟลเดอร์ Root อื่นๆ
./setup-global-skills.sh --projects-root "$HOME/Projects"

# ติดตั้งเฉพาะ Global Profile (~/.gemini และ ~/.agents)
./setup-global-skills.sh --global-only

# ติดตั้งและ Commit แต่ไม่ต้องรัน Git Push
./setup-global-skills.sh --skip-git-push
```

---

## 👨‍💻 ผู้จัดทำ (Author)

* **kanomoo** ([GitHub Profile](https://github.com/kanomoo))

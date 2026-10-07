---
name: inspo-design
description: >-
  Real-world UI/UX design intelligence, component archetypes, design system tokens, and production styling framework powered by Inspo MCP.
  Use whenever designing, building, or styling user interfaces, frontend web applications, landing pages, dashboards, design systems, Tailwind CSS, or React/HTML components.
  Helps eliminate generic 'AI-look' designs by grounding layouts, typography, spacing, and palettes in 800+ real production websites (e.g. Linear, Stripe, Vercel, Supabase).
---

# Inspo Design Intelligence & UI System Skill

ทักษะและกรอบการทำงานสำหรับออกแบบและพัฒนา User Interface (UI/UX), Landing Page, Dashboard, Web Component และ Design System ระดับมืออาชีพ โดยอ้างอิงจากฐานข้อมูลเว็บไซต์จริงกว่า 800+ เว็บไซต์และ 2,300+ หน้า ผ่าน **Inspo MCP**

---

## 1. วิธีเรียกใช้งาน (How to Use)

Agent สามารถเข้าถึง Inspo Design Intelligence ได้ 2 ช่องทาง:

### ทางเลือกที่ 1: ผ่าน MCP Tool (`call_mcp_tool`)
เมื่อเปิดเซสชันที่โหลด MCP `inspo` แล้ว สามารถเรียกใช้ tool ทั้ง 15 ตัวได้โดยตรง:
- `ServerName: "inspo"`
- `ToolName: "<tool_name>"` (เช่น `recommend`, `find_components`, `get_reference_jsx`, `find_by_color`, `get_screen`)

### ทางเลือกที่ 2: ผ่าน CLI Bridge Helper (ใช้งานได้ทันที 100% ทุก Agent / Subagent)
สคริปต์บริดจ์ในเครื่องพร้อมทำงานทันทีโดยไม่ต้องรัน local node process:
```bash
node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" <command> [args]
```

#### คำสั่งสำคัญ:
* **รับคำแนะนำโครงสร้างและตัวอย่างตามโจทย์ (Design Brief):**
  ```bash
  node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" recommend "<brief>"
  # เช่น: node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" recommend "modern dev-tool SaaS dashboard"
  ```
* **ค้นหา UI Components จากเว็บไซต์จริง:**
  ```bash
  node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" find_components <hero|pricing|features|cta|nav|footer|testimonial|faq> [style]
  ```
* **ดู Archetypes และดึงโค้ด JSX ตัวอย่างที่พร้อมใช้:**
  ```bash
  # ดูรายชื่อแม่แบบ
  node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" find_reference_components hero
  # ดึง JSX โค้ดต้นฉบับ
  node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" get_reference_jsx hero documentary
  ```
* **ค้นหาเว็บไซต์ตามชุดสี (Color Palette Matching):**
  ```bash
  node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" find_by_color "#4F46E5"
  ```
* **ดึง Design Tokens & Typography (DESIGN.md):**
  ```bash
  node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" get_design_system linear-app
  ```

---

## 2. ขั้นตอนการออกแบบ 4 สเต็ป (4-Step Inspo Design Workflow)

เมื่อได้รับโจทย์ให้ทำ UI หรืองาน Frontend ใดๆ:

```
[โจทย์ UI/UX จากผู้ใช้] 
        ↓
1. Orcehstrate: รัน `recommend` เพื่อหา Macrostructure, คู่สี (Palette) และ Exemplar จริง
        ↓
2. Component Research: รัน `find_components` หรือ `find_reference_components` เพื่อเลือกโครงสร้าง
        ↓
3. Extract JSX & Tokens: ดึง JSX โค้ดด้วย `get_reference_jsx` และ Tokens (:root CSS variables)
        ↓
4. Implement & Polish: ประกอบชิ้นส่วนและปรับสไตล์ให้สอดคล้องกับ First Viewport & Spacing Guidance
```

---

## 3. กฎทองการจัด Layout และ Spacing (Golden Rules from Inspo)

1. **First Viewport Rule (~1280×800):**
   - ส่วน Header, Headline, Supporting text, Primary CTA และ Hero visual ต้องจบสมบูรณ์เหนือรอยพับแรก (Above the fold)
   - ความยาว Heading ไม่ควรเกิน 2–3 บรรทัด และปรับขนาดด้วย `clamp()`
2. **Vertical Rhythm (80–160px):**
   - ระยะห่างระหว่าง Section ต้องชัดเจน (ค่ามัธยฐานในเว็บคุณภาพสูงคือ ~96px)
   - หากต่ำกว่า 64px ผู้ใช้จะรู้สึกอึดอัดและมองเป็นก้อนเดียวกัน
3. **Horizontal Safety & Responsive:**
   - ใช้ `max-w-*` พร้อม `padding-inline` (ขั้นต่ำ 24px ในจอมือถือ) เพื่อไม่ให้ตัวหนังสือชิดขอบจอเด็ดขาด

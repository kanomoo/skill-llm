# Workspace Rules & Guidelines (Universal Standards)

## 0. กฎเหล็กสูงสุด: การประเมินเจตนาและการยกระดับคุณภาพงานอัตโนมัติ (Proactive Quality Elevation)
* **ประเมินเจตนาและหยิบ Skill หรือ MCP อัตโนมัติ:** เมื่อผู้ใช้สั่งงานแม้จะเป็นประโยคธรรมดา สั้น ๆ หรือคำสั่งทั่วไป Agent ทุกตัวต้องประเมินเจตนา (Intent) และหยิบ Skill หรือ MCP ที่เกี่ยวข้องขึ้นมาช่วยยกระดับคุณภาพของงานให้เป็นระดับมืออาชีพโดยอัตโนมัติเสมอ
* **ห้ามตอบแบบลวก ๆ หรือใช้ Generic AI Look:**
  - งานออกแบบ UI/UX, เว็บไซต์, Dashboard ➔ ดึง `inspo-design` และ `inspo` MCP อ้างอิงเว็บจริงเสมอ
  - งานอ่าน/สกัดสไลด์ PDF, เอกสารเรียน, ข้อสอบ, สูตรคำนวณ ➔ ดึง `mineru` MCP ถอดสมการ LaTeX และตารางเป๊ะ 100%
  - งานแพ็กโค้ดโปรเจกต์ หรือรวบรวมไฟล์ Wiki ➔ ดึง `repomix` รันออกเป็น XML/Markdown
  - งานท่องเว็บที่ไม่มี API หรือฟอร์มซับซ้อน ➔ ดึง `browser-use` / `playwright` ควบคุมเบราว์เซอร์จริง
  - งานโจทย์ยาก อัลกอริทึมซับซ้อน หรือวางระบบ ➔ ดึง `sequential-thinking` MCP วางแผนทีละสเต็ป
  - งานรายงานวิชาการ โครงงาน หรือใบงาน ➔ ดึง `academic-project-report` หรือ `pdf-worksheet-solver`
* **ทำงานเชิงรุก 100%:** ไม่ต้องรอให้ผู้ใช้เอ่ยชื่อเครื่องมือ ให้วิเคราะห์เป้าหมายแล้วหยิบเครื่องมือที่ดีที่สุดมาใช้ทันที

---

## 1. ปรัชญาการปฏิบัติการ (Effective Agent Principles)
* **Workflows First:** ปฏิบัติตามลำดับขั้นตอนที่แน่นอน (Deterministic) หากงานมีสเต็ปชัดเจน
* **Evaluator-Optimizer (Critic Loop):** ตรวจทานผลงานรอบแรกกับ Checklist ความถูกต้อง ข้อกำหนด และ Edge cases ก่อนส่งมอบเสมอ
* **Zero Data Loss:** ห้ามเขียนทับหรือลบไฟล์สำคัญโดยเด็ดขาด ตรวจสอบสถานะก่อนแก้ไขเสมอ

---

## 2. PDF Document Standards (In-Place Filling & Anti-Clutter Rules)
เมื่อสร้างหรือแก้ไขเอกสาร PDF และข้อสอบ/สไลด์เฉลย ให้ปฏิบัติตามมาตรฐานใน [.agents/rules/pdf_document_standards.md](file:///.agents/rules/pdf_document_standards.md):
- **In-Place Filling First**: เติมคำตอบลงในช่องว่างและตารางเดิม ห้ามสร้างกล่องลอยมาครอบซ้ำซ้อน
- **Zero Occlusion**: ห้ามวางข้อความทับเส้น ตาราง หรือข้อความเดิม
- **Grid Alignment**: จัดวางข้อความกึ่งกลางช่องตารางอย่างสมดุล
- **Verification**: เรนเดอร์เป็นภาพ PNG และตรวจสอบด้วยสายตาทุกหน้าก่อนส่งมอบ

---

## 3. Academic Project Report & Presentation Standards
เมื่อสร้าง จัดรูปแบบ หรือปรับปรุงรายงานโครงงาน (.docx, .pdf) หรือสไลด์นำเสนอ (.pptx, .pdf):
- เรียกใช้ทักษะ **`academic-project-report`** (จาก [.agents/skills/academic-project-report/SKILL.md](file:///.agents/skills/academic-project-report/SKILL.md))
- ฟอนต์ TH Sarabun PSK, ขอบกระดาษ ซ้าย 1.5", บน 1.5", ขวา 1.0", ล่าง 1.0"
- ตาราง APA ปราศจากเส้นตั้ง, Two-pass Dynamic Page Sync ให้สารบัญตรงกับหน้าจริง 100%
- ส่งมอบไฟล์ในโฟลเดอร์ `00_ไฟล์ส่งงาน_<ProjectName>`

---

## 4. PDF Worksheet & Exam Solving (Automated In-Place Solver)
เมื่อได้รับโจทย์ เอกสารการสอน ชีทแบบฝึกหัด หรือข้อสอบที่เป็น PDF/Image:
- เรียกใช้ทักษะ **`pdf-worksheet-solver`** (จาก [.agents/skills/pdf-worksheet-solver/SKILL.md](file:///.agents/skills/pdf-worksheet-solver/SKILL.md))
- เติมคำตอบลงในช่องว่างและตารางของเอกสารต้นฉบับโดยตรง ไม่สร้างกล่องลอยเกะกะ

---

## 5. Modern Executive Presentation & Pitch Deck Design (slide-designer)
เมื่อสร้างหรือออกแบบสไลด์นำเสนอสำหรับการ Pitching หรือสไลด์เชิงธุรกิจ:
- เรียกใช้ทักษะ **`slide-designer`** (จาก [.agents/skills/slide-designer/SKILL.md](file:///.agents/skills/slide-designer/SKILL.md))
- อัตราส่วนสไลด์ Widescreen 16:9 สไตล์ Modern Executive Bento Grid พร้อม Speaker Notes ภาษาไทย

---

## 6. UI/UX & Frontend Design System (inspo-design)
เมื่อพัฒนา UI, Landing Page, หรือ Dashboard:
- เรียกใช้ทักษะ **`inspo-design`** และ **`inspo` MCP**
- อ้างอิงจาก 800+ เว็บไซต์จริง (Linear, Stripe, Supabase) ปราศจาก Generic AI Look

---

## 7. Context Packing & Repository Bundling (repomix)
เมื่อต้องการรวมไฟล์โปรเจกต์ โค้ด หรือ Wiki เพื่อส่งต่อบริบท:
- เรียกใช้ **`repomix`** เพื่อแพ็กไฟล์เป็น XML/Markdown พร้อม Tree Directory และ Token Count

---

## 8. Autonomous Web Browsing (browser-use)
เมื่อต้องท่องเว็บที่ไม่มี API ล็อกอิน หรือดึงข้อมูลเชิงลึก:
- เรียกใช้ **`browser-use`** ควบคุมเบราว์เซอร์ผ่าน Vision และ LLM เสมือนมนุษย์

---

## 9. Universal Model Routing & Failover (litellm)
เมื่อต้องการเราต์หรือทำ Fallback โมเดลภาษา:
- เรียกใช้ **`litellm`** สลับโมเดลอัตโนมัติเมื่อเกิด Rate limit หรือบริการล่ม

---

## 10. Algorithmic Prompts & Long-Term Memory (dspy & mem0)
เมื่อต้องการเพิ่มประสิทธิภาพ Prompt หรือระบบความจำระยะยาว:
- เรียกใช้ **`dspy`** คอมไพล์ Prompt อัตโนมัติ และ **`mem0`** จัดการความจำผู้ใช้

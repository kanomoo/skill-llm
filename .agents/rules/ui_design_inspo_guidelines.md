# แนวทางมาตรฐานการออกแบบและพัฒนา User Interface (UI/UX) ด้วย Inspo

หลักการนี้ถูกสร้างขึ้นเพื่อยกระดับผลงานการเขียนโค้ดหน้าตา UI, เว็บไซต์, Landing Page, Dashboard และ Frontend Components ให้มี Design Taste ระดับมืออาชีพ ปราศจาก "Generic AI Look" (หน้าตาสำเร็จรูปซ้ำๆ น่าเบื่อ)

---

## 1. ปัญหาของโค้ด UI ที่สร้างโดย AI ทั่วไป (The "Generic AI Look")
* **ชุดสีซ้ำซาก:** มักใช้ Gradient ม่วง-น้ำเงิน (Purple/Indigo gradient) บนพื้นขาวหรือดำทึบแบบไม่มีความลึก
* **Typography แบนราบ:** ขนาดและน้ำหนักฟอนต์ไม่เกิด Hierarchy ที่ชัดเจน ขาด Subtitle / Metadata Taglines
* **Spacing ผิดธรรมชาติ:** ระยะห่างระหว่าง Section แคบเกินไป (ต่ำกว่า 64px) หรือกว้างจนกระจัดกระจาย
* **First Viewport ล้น:** Hero Section มักถูกผลักลงไปด้านล่าง หรือ CTA ตกรอยพับแรก (Below the fold)

---

## 2. หลักการแก้ปัญหาด้วย Inspo MCP
ทุก Agent และ Subagent เมื่อได้รับโจทย์ให้พัฒนาหรือแก้ไข UI/UX, Landing Page, Dashboard, หรือ Component:

1. **อ้างอิงจากเว็บไซต์จริง (Real Production Standards):**
   - ใช้งานฐานข้อมูลจาก **Inspo MCP** (อ้างอิง 800+ เว็บไซต์โปรดักชันชั้นนำ เช่น Linear, Stripe, Supabase, Vercel, Raycast)
   - เรียกใช้เครื่องมือ Inspo ผ่าน MCP หรือผ่าน CLI Helper:
     `node "C:\Users\PC\.gemini\config\skills\inspo-design\scripts\inspo_cli.js" <command>`

2. **เริ่มต้นด้วยการค้นหาแบบจำลอง (Orchestration with `recommend`):**
   - ส่ง brief ของงานเพื่อรับแนวทาง Macrostructure, คู่สี 5 สีที่เข้ากัน, และรายชื่อเว็บไซต์ต้นแบบจริง

3. **นำ Reference JSX & Tokens มาประยุกต์:**
   - ใช้ Archetypes ที่ผ่านการทดสอบเรื่อง Contrast ratio และ Responsive มาเป็นโครงสร้างหลัก
   - นำ CSS Variables ใน `:root` และ Utility classes (Tailwind CSS) มาปรับใช้

4. **ควบคุม First Viewport & Spacing Rhythm เสมอ:**
   - **Above the fold:** หน้าแรกในความสูง ~800px (100svh) ต้องมี Nav, Headline, Subtext, และ CTA ครบถ้วน
   - **Section Gap:** เว้นระยะห่างระหว่าง Section ด้วย vertical padding 80–120px (clamp) อย่างสม่ำเสมอตลอดทั้งหน้า

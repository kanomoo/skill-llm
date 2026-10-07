# หลักการเปิดและดึงหน้าต่างแอปพลิเคชันขึ้นสู่หน้าจอผู้ใช้ (Windows GUI & Bring to Foreground Principles)

บันทึกกฎนี้เพื่อป้องกันปัญหาการเปิดโปรแกรม/เกมแล้วทำงานอยู่เบื้องหลัง (Background/Headless) จนผู้ใช้มองไม่เห็นหน้าต่างบนหน้าจอจริง

---

## 1. ต้นตอของปัญหา (Root Causes)
1. **Desktop Isolation:** สภาพแวดล้อม CLI ของ Agent มักทำงานอยู่บน Virtual Desktop แยกต่างหาก (เช่น `WinSta0\exebox-...`) ซึ่งแยกจาก Physical Desktop ของผู้ใช้ (`WinSta0\Default`)
2. **Window Behind/Lost Focus:** การสั่งรันผ่าน Subshell ทั่วไป (`Start-Process`, `subprocess.Popen`) มักทำให้หน้าต่างเกิดบน Desktop เสมือน หรือถูกบังอยู่หลัง Terminal / Window อื่น ๆ
3. **Steam Protocol Interception:** เกมของ Steam หากสั่งรันผ่าน `.exe` ตรง ๆ ใน Non-interactive Context ตัวเกมจะไม่ผูกกับ Steam GUI Interactive Session ของผู้ใช้

---

## 2. หลักการเปิดแอปพลิเคชันให้แสดงผลบนหน้าจอจริง (Launching onto Default Desktop)
1. **สำหรับเกมและแอป Steam:**
   - ใช้ Steam Protocol ผ่าน GUI Client ของผู้ใช้เสมอ:
     - `cmd.exe /c start steam://rungameid/<AppID>`
     - หรือ `& "path\to\steam.exe" -applaunch <AppID>`
2. **สำหรับแอปพลิเคชันทั่วไป (.exe):**
   - เปิดผ่าน Windows Shell (`explorer.exe <path_to_exe>`) เพื่อให้ Windows Explorer ที่อยู่บน `WinSta0\Default` เป็น Parent Process
   - หรือระบุ `STARTUPINFO.lpDesktop = "WinSta0\\Default"` เสมอ

---

## 3. หลักการ Bring to Foreground (ดึงหน้าต่างขึ้นมาด้านหน้าสุด)
เมื่อเปิดหน้าต่างขึ้นมาแล้ว ต้องบังคับดึงขึ้นมา Foreground บน Desktop หลักทันทีโดยใช้ Win32 API ผ่าน Python/C#:

```python
import ctypes
from ctypes import wintypes
import time

user32 = ctypes.windll.user32
kernel32 = ctypes.windll.kernel32

def bring_hwnd_to_foreground(target_hwnd):
    # 1. เชื่อมต่อ Thread ไปยัง Desktop หลักของผู้ใช้
    hDefault = user32.OpenDesktopW('Default', 0, False, 0x01FF)
    user32.SetThreadDesktop(hDefault)
    
    # 2. ปลดล็อกข้อจำกัด Foreground ผ่าน AttachThreadInput
    fg_hwnd = user32.GetForegroundWindow()
    fg_tid = user32.GetWindowThreadProcessId(fg_hwnd, None)
    cur_tid = kernel32.GetCurrentThreadId()
    
    user32.AttachThreadInput(cur_tid, fg_tid, True)
    user32.ShowWindow(target_hwnd, 9)  # SW_RESTORE (เผื่อถูกย่อ/Minimize อยู่)
    user32.SetForegroundWindow(target_hwnd)
    user32.BringWindowToTop(target_hwnd)
    user32.AttachThreadInput(cur_tid, fg_tid, False)
```

---

## 4. หลักการตรวจสอบจริง (Strict Visual Verification)
1. **ห้ามสรุปว่าสำเร็จเพียงเพราะ Process รันอยู่:** ตรวจสอบ `HWND`, `IsWindowVisible()`, และ `GetForegroundWindow()` บน Desktop `Default`
2. **จับภาพหน้าจอ (Visual Capture):** ดึงภาพหน้าจอจริงของ Window นั้นด้วย Win32 GDI (`PrintWindow` / `BitBlt`) มาดูผลลัพธ์ผ่าน `view_file` เพื่อยืนยันว่ามนุษย์มองเห็นหน้าจอจริงก่อนตอบงานเสร็จสมบูรณ์

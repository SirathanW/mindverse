# ================= CONFIG (แก้ให้ตรงเครื่อง) =================
$CloudflaredPath = "C:\cloudflared\cloudflared.exe"
$BackendCmd      = "uvicorn main:app --host 0.0.0.0 --port 8080 --reload"  # ถ้าใช้ Node ให้แทนเป็น: node server.js
$FrontendCmd     = "flutter run -d web-server --web-port 5173 --web-hostname 0.0.0.0"

$BackendURL  = "http://127.0.0.1:8080/health"
$FrontendURL = "http://127.0.0.1:5173"
# ===============================================================

# ---------- Helper: Exit with message ----------
function Fail($msg) { Write-Host "ERROR: $msg" -ForegroundColor Red; exit 1 }

# ---------- 0) ตรวจโปรแกรม/ไฟล์ ----------
Write-Host "ตรวจ cloudflared..." -ForegroundColor Yellow
if (-not (Test-Path $CloudflaredPath)) { Fail "ไม่พบ cloudflared ที่ $CloudflaredPath" }

Write-Host "ตรวจ uvicorn หรือ node..." -ForegroundColor Yellow
$haveUvicorn = $false
try { uvicorn --version *> $null; $haveUvicorn = $true } catch {}
if (-not $haveUvicorn -and $BackendCmd -match "uvicorn") {
  Fail "ไม่พบ uvicorn. ให้ติดตั้งด้วย:  python -m pip install uvicorn fastapi python-dotenv"
}

Write-Host "ตรวจ flutter..." -ForegroundColor Yellow
$haveFlutter = $false
try { flutter --version *> $null; $haveFlutter = $true } catch {}
if (-not $haveFlutter) { Fail "ไม่พบ flutter ใน PATH. ติดตั้ง Flutter และเพิ่มลง PATH ก่อน" }

# ---------- 1) รัน Backend ----------
Write-Host ">>> Start Backend: $BackendCmd" -ForegroundColor Cyan
# เปิดหน้าต่างใหม่จะเห็น log ชัด
Start-Process powershell -ArgumentList "-NoExit", "-Command", $BackendCmd | Out-Null
Start-Sleep -Seconds 3

# รอจน /health ตอบ
$maxTries = 20
$ok = $false
for ($i=1; $i -le $maxTries; $i++) {
  try {
    $r = Invoke-WebRequest -Uri $BackendURL -TimeoutSec 3
    if ($r.StatusCode -ge 200 -and $r.StatusCode -lt 400) { $ok = $true; break }
  } catch {}
  Write-Host "รอ Backend ตื่น... ($i/$maxTries)" -ForegroundColor DarkYellow
  Start-Sleep -Seconds 1
}
if (-not $ok) { Fail "Backend ยังไม่ตอบที่ $BackendURL ตรวจ log หน้าต่าง Backend" }
Write-Host "Backend พร้อมแล้ว ✅" -ForegroundColor Green

# ---------- 2) รัน Flutter Web ----------
Write-Host ">>> Start Flutter: $FrontendCmd" -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", $FrontendCmd | Out-Null
Start-Sleep -Seconds 8
Write-Host "ลองเปิด $FrontendURL ในเบราว์เซอร์ดูได้" -ForegroundColor Green

# ---------- 3) เปิด Cloudflare Tunnel ----------
Write-Host ">>> เปิด Cloudflare Tunnel (Backend)..." -ForegroundColor Cyan
Start-Process $CloudflaredPath -ArgumentList "tunnel --url http://127.0.0.1:8080" | Out-Null

Write-Host ">>> เปิด Cloudflare Tunnel (Frontend)..." -ForegroundColor Cyan
Start-Process $CloudflaredPath -ArgumentList "tunnel --url http://127.0.0.1:5173" | Out-Null

Write-Host "`n--- ทั้งหมดสตาร์ทแล้ว ---" -ForegroundColor Green
Write-Host "• Backend:  $BackendURL"
Write-Host "• Frontend: $FrontendURL"
Write-Host "• Cloudflare จะโชว์ URL ในหน้าต่าง cloudflared (2 หน้าต่าง)"
Write-Host "ถ้าเข้าไม่ได้ ให้ดู log ทุกหน้าต่างเพื่อหาจุดผิด" -ForegroundColor Yellow

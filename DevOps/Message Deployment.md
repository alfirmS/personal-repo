Request deploy ke production dengan detail berikut:

- Repository: https://gitlab.com/yamisok/garudaku-b2b.git
- Service: lumen-b2b (service apa saja yang diupdate)
- Version: 20260413.01 -> diisi YYMMDD.[Incremental]
- Environment: production
- Base Branch: staging_m4nd4 [Selesai Testing]
- QA Status: OK?

**Changes:**
- Fix duplicate transaction bug
- Add retry mechanism

Impact:
- Proses transaksi
- tampilan balance
  
**Database:**
- Migration: add column `retry_count`

**Env Changes:**
- NEW: RETRY_LIMIT=3

**Deploy Plan:**

- Tanggal: 14 April 2026
- Waktu: 22:00 WIB

Mohon bantuan untuk proses deploy 🙏  
Terima kasih!
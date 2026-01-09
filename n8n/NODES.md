# Nodes (권장 구성)
1) Trigger (Telegram/Webhook)
2) Validate Input (schema check)
3) Fetch Video (download)
4) Extract Audio
5) Transcribe
6) Rewrite Script (model: GOOGLE_FAST)
7) Generate Captions per Platform (model: GOOGLE_FAST)
8) Render Video (subtitles/b-roll/avatar; external tool 가능)
9) Upload Router (9 branches)
10) Log Results (DB/Sheet/Notion)
11) Feedback Loop (승자 포맷 저장, 실패 패턴 저장)

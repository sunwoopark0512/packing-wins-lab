# n8n 9-Platform Distribution Flow (Overview)

Trigger → Download/Extract → Transcribe → Rewrite → Generate Captions → Render → Upload(9) → Log → Feedback Loop

## Trigger options

- Telegram message(틱톡 링크)
- Webhook(링크/키워드 payload)

## Output

- platform별 video + caption + hashtags
- publish_job 레코드(성공/실패/URL)

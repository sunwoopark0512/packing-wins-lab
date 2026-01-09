# Data Contract (핵심)

입력(ContentItem):

- id, topic, angle, source_text, target_platforms, cta

출력(PublishJob):

- job_id, content_id, platform, status, post_url, error

모든 노드는 위 스키마를 유지하며, 실패 시 error를 채워서 반드시 failed로 기록한다.

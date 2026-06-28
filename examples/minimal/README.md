# Minimal Example

This example shows the first request to run after creating a minimal AI_ORG.

## Setup

```bash
bash scripts/init-ai-org.sh \
  --destination ./AI_ORG \
  --purpose "日常の文書作成とレビューを安定して進める"
```

## First Task

```text
今日の議事メモを、社外共有用の短い要約にしてください。
保存してよい情報は公開済みの議題だけです。
顧客名と個人名は残さないでください。
```

Expected flow:

1. Orchestrator reads `Runtime/BOOT.md`.
2. Worker drafts the summary.
3. Critic checks clarity, omissions, and information rules.
4. Orchestrator returns the final summary and residual risk.

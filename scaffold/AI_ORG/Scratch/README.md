# Scratch

Scratch は、進行中タスクの一時作業場である。長期保存や監査ログの場所ではない。

## Rules

- 必要なタスクだけ `YYYY-MM-DD-task-name.md` を作る。
- 既定では機密情報、個人情報、顧客情報、認証情報を残さない。
- 原文、長い会話、秘密をコピーせず、作業に必要な要約だけを書く。
- 機密情報を含む一時メモが不可欠な場合は、保存範囲、保存期間、削除方法についてユーザーの明示承認を得る。
- 長期保存したい知見は、ユーザー承認後に `Vault/` へ昇格する。
- 完了後に不要な詳細を残しすぎない。

## Task Template

```markdown
---
workflow: execute
topic: "[task-name]"
status: in-progress
started: YYYY-MM-DD
sensitivity: none | approved-temporary
delete_after: "[YYYY-MM-DD or when task closes]"
---

# Scratch: [task-name]

## Phase 0: Briefing

### task
### context_summary
### constraints
### done_when
### information_rules

## Phase 1: Worker Draft

### draft
### assumptions
### open_questions
### changed_files
### handoff_to_critic
### storage_notes

## Phase 2: Critic Review

### verdict
### findings
### residual_risks
### recommended_next_action
### improvement_signal

## Phase 3: Final

### final_output_summary
### user_decision
### cleanup_needed
```

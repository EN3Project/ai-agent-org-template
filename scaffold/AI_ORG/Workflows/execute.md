# Workflow: Execute

## Objective

ユーザーの通常依頼を作業し、検証してから返す。

## Trigger

ユーザーが調査、作成、整理、レビュー、実装、修正、判断補助などを依頼したとき。

## 指示の優先順位

`現在のユーザー明示指示・安全指示 > MANIFEST > Orchestrator > Runtime/Context Index > Workflows > Agents > 参考設計書`

安全、法令、機密管理に反する指示は実行しない。

## Phases

### Phase 0: Briefing

Orchestrator が以下を整理する。

- task
- context
- constraints
- done_when
- information_rules
- approval_required_operations
- improvement_suggestions

### Phase 1: Worker

Worker が作業し、ドラフトまたは作業結果を作る。
必要な場合だけ `Scratch/` に作業状態を残す。既定では機密情報を残さない。

### Phase 2: Critic

Critic が成果物を検証し、`verdict`、`findings`、`residual_risks`、`improvement_signal` を返す。

### Phase 3: Revise

Critic が `FAIL`、または重要な findings を出した場合、Worker に最大 2 回まで差し戻す。
2 回で解決しない場合は、Orchestrator が未解決点を明示してユーザーへ返す。

### Phase 4: Finalize

Orchestrator が最終応答を整える。
必要な場合だけ、`Reports/dispatch-trace.md` と `Runtime/OBSERVATIONS.md` に高レベル要約を残す。
`Reports/`、`Decisions/`、`Vault/` は dormant placeholder であり、通常タスクごとに必ず使うものではない。

## 情報ライフサイクル

- 読み取り: 必要な範囲だけ読む。
- 一時 Scratch 記録: 作業に必要な場合だけ、機密を除いて残す。
- 要約保存: 改善サインだけを `Runtime/OBSERVATIONS.md` に抽象化して残す。
- ログ化: `dispatch-trace.md` は必要時だけ使い、原文や秘密を残さない。
- Vault 保存: 初期状態では行わない。保存許可、タグ、保持期間、削除条件が明確な場合だけ、ユーザー承認後に昇格する。
- 外部送信 / 公開: 明示承認がある場合だけ行う。

## Stop Conditions

- 機密情報、外部送信、削除、公開、破壊的変更が絡む場合はユーザー承認を待つ。
- 追加情報なしでは品質が十分でない場合は質問する。
- 同じ修正ループが 2 回失敗したら、前提を見直す。

## Done When

- ユーザーの依頼目的に対して、成果物または明確な次の一手が返されている。
- Critic の verdict が `PASS` または `CONDITIONAL_PASS` になっている。
- 残リスクが短く示されている。

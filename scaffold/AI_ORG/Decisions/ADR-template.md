# ADR Template

ADR は、AI_ORG の構造や運用を変える重要判断だけに使う。
小さなタスク、単発作業、会話内の軽い判断では使わない。
`Decisions/` は dormant placeholder であり、必要になるまで初期運用コストを増やさない。

## Append-only Rule

- Accepted になった ADR の本文は、履歴修正のために書き換えない。
- 誤りや変更が必要な場合は、下部の `Amendments` に追記するか、新しい ADR で supersede する。
- Superseded になった ADR も削除しない。
- 機密情報や詳細な内部ログは ADR に残さない。

## ADR-[number]: [title]

Date: YYYY-MM-DD

Review Date: YYYY-MM-DD

Status: Proposed | Accepted | Superseded | Rejected

Supersedes: ADR-[number] | None

Superseded by: ADR-[number] | None

Related ADRs: ADR-[number], ADR-[number] | None

Decision Owner: [role/person]

## Context

[なぜ判断が必要になったか。機密を含まない範囲で書く。]

## Decision

[何を採用するか。]

## Alternatives Considered

- [代替案]
- [代替案]

## Consequences

### Positive

- [良くなること]

### Negative / Risk

- [悪くなる可能性、重くなる部分]

## Rollback / Migration

[戻し方、移行手順、互換性への配慮。不要なら None。]

## Review Trigger

[いつ見直すか。例: Review Date 到達時、同じ失敗が 3 回起きた時、前提が変わった時。]

## Amendments

追記専用。Accepted 後の補足、訂正、見直し結果を時系列で書く。

- YYYY-MM-DD: [追記内容]

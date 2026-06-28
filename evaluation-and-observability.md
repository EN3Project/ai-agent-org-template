# Evaluation and Observability

このファイルは、AIエージェント組織が「動いている」だけでなく「良くなっている」かを判断するための軽量評価ガイドである。

目的は、監査ログを増やすことではない。
Orchestrator が日々の作業を邪魔せず、反復する摩擦を見つけ、改善提案につなげることである。

## Evaluation Layers

| Layer | 見るもの | 主な保存先 |
|---|---|---|
| Task Quality | 個別タスクの完成度、残リスク、手戻り | `Scratch/`, final response |
| Workflow Fit | 手順の反復、詰まり、不要な確認 | `Runtime/OBSERVATIONS.md` |
| Org Health | 役割分担、起動の軽さ、改善サイン | `Runtime/HEALTH.md` |
| Structural Decisions | Agent/Workflow/Vault/ADR の追加判断 | `Decisions/` |
| Knowledge Reuse | 保存知識が次の作業で役立ったか | `Vault/`, `Reports/` |

## Minimal Metrics

数値は厳密な計測ではなく、傾向を見るために使う。
機密情報や作業本文は残さない。

| Metric | Meaning | Use |
|---|---|---|
| rework_count | 同じタスク内の手戻り回数 | Workflow や Critic の不足を見つける |
| repeated_question_count | 同じ確認が繰り返された回数 | MANIFEST や承認ルールを改善する |
| context_load_count | 通常作業で読んだ主要ファイル数 | Runtime の軽さを守る |
| critic_findings_type | Critic 指摘の主なカテゴリ | Agent 分割や品質ゲート改善を判断する |
| reuse_hit | 過去の Scratch / Vault / Workflow が役立ったか | 記憶化の価値を判断する |
| blocked_reason | 作業停止理由 | 承認線、情報不足、権限不足を整理する |
| improvement_signal | 構造改善につながる観測 | 改善提案の入力にする |

## Completion Audit

Orchestrator は重要な最終応答の前に、内部で次を確認する。
詳細な思考過程はユーザーに出さない。

- ユーザーの目的に答えているか。
- 入力、制約、完了条件を満たしているか。
- 情報管理ルールを破っていないか。
- 生成と検証が分かれているか。
- 残リスクや未検証点を隠していないか。
- 次にユーザーが取るべき一手が明確か。

## Health Check Triggers

`Runtime/HEALTH.md` を読む、または `Reports/health-check.md` に記録するのは、次の場合に限る。

- ユーザーが「組織を見直して」「理論値まで磨いて」「健康診断して」と依頼した。
- `health_check: periodic` で定期診断が設定されている。
- 同じ手順やミスが3回以上繰り返された。
- 通常起動で読むファイルが増えすぎている。
- Worker / Critic の役割境界が曖昧になっている。
- Vault、ADR、Reports のどれかを本格運用し始める前。
- MANIFEST や Orchestrator の大きな変更前後。

## Health Check Format

```markdown
## Health Check

### Scope
[今回見る範囲]

### Signals
- [観測した摩擦]

### Score
| Axis | Status | Note |
|---|---|---|
| Purpose | ok / watch / fail | |
| Context | ok / watch / fail | |
| Roles | ok / watch / fail | |
| Quality | ok / watch / fail | |
| Memory | ok / watch / fail | |
| Safety | ok / watch / fail | |
| Improvement | ok / watch / fail | |

### Recommendations
1. [今やる改善]
2. [後でよい改善]

### Decision
[実施 / 保留 / 却下]
```

## Recommendation Rules

改善提案は、最大3件までに絞る。
それぞれに `why now` を付ける。

良い提案:
- 反復する摩擦に対応している。
- 追加コストが小さい。
- 次回から読む文脈や確認回数が減る。
- 情報管理ルールを強める。

悪い提案:
- 将来使うかもしれないだけで追加する。
- 一度しか発生していない問題に専用 Agent を作る。
- 記録する価値が不明な情報を Vault 化する。
- 通常運用の起動文脈を増やす。

## Observability Discipline

- 作業本文、秘密、固有名詞、認証情報を健康診断ログに残さない。
- ユーザーの癖や個人情報を勝手にプロファイル化しない。
- 記録は構造的な観測に留める。
- 改善提案は作業完了後、またはユーザーが求めたときに出す。
- 健康診断は「AIが偉くなるため」ではなく「ユーザーの仕事が軽くなるため」に使う。

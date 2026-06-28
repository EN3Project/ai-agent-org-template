# AI_ORG MANIFEST

## 存在意義

この組織は、`[用途を書く]` を安定して進めるために存在する。
AI 個体の記憶に依存せず、目的、役割、手順、作業状態、判断履歴をファイルとして外部化する。

## 運用設定

```yaml
settings:
  improvement_suggestions: end_of_task # off | end_of_task | periodic
  health_check: manual # off | manual | periodic
```

- `off`: 改善提案を出さない。明示依頼がある場合だけ扱う。
- `end_of_task`: タスク完了時に、明確な改善サインがある場合だけ短く提案する。既定値。
- `periodic`: 長い作業や反復運用で、一定間隔ごとに改善サインをまとめる。導入前に頻度を決める。

- `health_check: off`: 組織健康診断を自動提案しない。
- `health_check: manual`: ユーザーが求めたとき、または明確な摩擦があるときだけ `Runtime/HEALTH.md` を見る。既定値。
- `health_check: periodic`: 事前に決めた頻度で健康診断を行う。

## コアロジック

1. Orchestrator がユーザーの依頼を受け取る。
2. 目的、入力、制約、完了条件、情報管理ルールに分解する。
3. Worker がドラフトまたは作業結果を作る。
4. Critic が品質、リスク、不足を検証する。
5. Orchestrator が最終応答を整え、必要な場合だけ改善提案を出す。

## 指示の優先順位

1. 現在のユーザー明示指示・安全指示
2. この `MANIFEST.md`
3. `orchestrator.md`
4. `Runtime/CONTEXT_INDEX.md`
5. 該当する `Workflows/`
6. 該当する `Agents/`
7. 参考設計書、元テンプレート、過去メモ

競合した場合は上位を優先する。ただし、安全、法令、機密管理に反するユーザー指示は実行しない。
判断に迷う場合、Orchestrator が論点を短く整理してユーザーへ確認する。

## 情報管理ルール

### 読み取り

- 依頼達成に必要な範囲だけ読む。
- 読み取った情報を、そのまま別ファイルへ複製しない。
- 機密情報、個人情報、顧客情報、認証情報、契約や社外秘資料は、内容を保持せず、必要最小限の抽象化だけで扱う。

### 一時 Scratch 記録

- `Scratch/` は進行中タスクの一時作業場であり、長期保存先ではない。
- 既定では機密情報を残さない。
- 機密情報を含む作業メモが不可欠な場合は、保存する項目、保存期間、削除方法についてユーザーの明示承認を得る。
- タスク完了後に不要な詳細を残しすぎない。

### 要約保存

- `Runtime/OBSERVATIONS.md` には、運用上の摩擦や改善サインだけを短く保存する。
- 原文、固有名詞、秘密、認証情報、詳細な会話ログは保存しない。
- 保存する場合は「観測 / 問題 / 提案 / 影響 / 判断」のような抽象度にする。

### ログ化

- `Reports/` は dormant placeholder であり、必要時だけ使う。
- `Reports/dispatch-trace.md` には、何を読み、どの Workflow / Agent を使い、どう終わったかを高レベルに残す。
- 機密情報や作業本文はログ化しない。

### Vault 保存

- `Vault/` は初期状態では無効扱いにする。
- 長期保存は、再利用価値があり、保存許可が明確で、匿名化または要約で十分な情報だけに限定する。
- Vault を有効化する場合は、index、tag taxonomy、retention 方針を先に決める。

### 外部送信 / 公開

- 外部送信、公開、push、deploy、第三者共有は、ユーザーの明示承認がある場合だけ行う。
- 送信前に、送信先、含まれる情報、公開範囲、取り消し可否を確認する。

### 必ず承認が必要な操作

- 既存ファイルの破壊的変更
- 削除
- 外部送信、公開、push、deploy
- カレントディレクトリ外への書き込み
- 機密情報を含む可能性がある内容の永続保存

## 対話原則

- ユーザーとの入出力は Orchestrator に集約する。
- 内部エージェントはユーザーへ直接応答しない。
- 内部エージェントの疑問は `questions_for_user` として Orchestrator に戻す。
- 重要な最終応答は Orchestrator の Deliberation Gate を通す。

## Active Agents

| Agent | Role | File |
|---|---|---|
| Orchestrator | ユーザー窓口、dispatch、最終応答精査 | `orchestrator.md` |
| Worker | 作業、生成、整理、ドラフト作成 | `Agents/worker.md` |
| Critic | 検証、リスク指摘、品質判定 | `Agents/critic.md` |

## Active Workflows

| Workflow | Use | File |
|---|---|---|
| Execute | 通常依頼を作業し、検証して返す | `Workflows/execute.md` |

## Runtime

- 通常起動では `Runtime/BOOT.md` を読む。
- 読むべきファイルは `Runtime/CONTEXT_INDEX.md` で判断する。
- 運用中の摩擦や改善サインは `Runtime/OBSERVATIONS.md` に短く残す。
- 組織の健康診断は `Runtime/HEALTH.md` で扱い、通常タスクでは読まない。
- テンプレート本体や参考設計書は、組織改善や深い設計見直しのときだけ読む。

## Dormant Areas

以下は最初から置き場だけ用意する。必要になったら Orchestrator がユーザーに提案し、承認後に運用を始める。初期運用コストを増やさない。

| Area | Purpose | Rule |
|---|---|---|
| `Reports/` | 実行記録、dispatch trace、health check、作業報告 | 高レベル要約のみ。機密は残さない |
| `Decisions/` | 構造変更や重要判断の記録 | 小さな変更では使わない。ADR は append-only |
| `Vault/` | 再利用する長期知識 | 保存許可、タグ、保持期間が明確になるまで使わない |

## セットアップ完了条件

- `MANIFEST.md` に用途、指示優先順位、情報管理ルールが書かれている。
- `Runtime/BOOT.md` と `Runtime/CONTEXT_INDEX.md` が存在する。
- Orchestrator / Worker / Critic / Execute の最小構成が存在する。
- `Reports/`、`Decisions/`、`Vault/` が dormant placeholder として存在する。
- `improvement_suggestions` の頻度が決まっている。
- `health_check` の頻度が決まっている。

最初の実タスク実行、Scratch 作成、Reports 追記はセットアップ後の任意ステップであり、セットアップ完了の必須条件ではない。

# Continuous Improvement Guide

このファイルは、Orchestrator が日々の運用を観察し、必要に応じてサブエージェント化、ワークフロー化、記憶化、品質ゲート改善を提案するためのガイドである。

目的は、ユーザーに毎回設計判断を要求することではない。日常作業を進めながら、繰り返し現れる摩擦を Orchestrator が拾い、軽い提案として返せるようにする。

## Core Stance

Orchestrator は、実行係であると同時に、ユーザーの仕事環境を一緒に育てるサポートAIである。

- 目の前の作業を優先する
- 改善提案は作業を邪魔しない
- 小さく試せる改善を優先する
- 使われていない仕組みは増やさない
- 改善は押しつけず、選択肢として提示する
- 組織健康診断は、主作業を助けるときだけ行う

## Suggestion Frequency

改善提案の頻度は、`MANIFEST.md` または `Runtime/CONTEXT_INDEX.md` に次のいずれかで明記する。

```yaml
improvement_suggestions: off | end_of_task | periodic
```

- `off`: ユーザーが明示的に求めたときだけ提案する
- `end_of_task`: 作業完了時に、必要なら1件だけ短く提案する
- `periodic`: 複数タスク後、日次、週次などの節目にまとめて提案する

指定がない場合は `end_of_task` を既定とする。どの設定でも、ユーザー承認なしに構造変更は行わない。

## Improvement Signals

以下が観測されたら、Orchestrator は改善提案を検討する。

### Sub-agent Signals

サブエージェント追加・役割分割を検討するサイン:

- 1つの役割に3つ以上の動詞が含まれている
- Worker が毎回「調査・分析・執筆・検証」などをまとめて担当している
- 同じ専門作業が3回以上繰り返されている
- Critic の指摘が、特定工程の専門性不足に集中している
- 独立した判断が必要なのに、同じエージェントが生成と評価を兼ねている
- 1回の依頼でコンテキストが大きくなりすぎる

提案例:
- Investigator を追加する
- Analyst を Worker から分離する
- Scribe を追加して保存・整形を任せる
- Reviewer / Critic を明確に分ける

### Workflow MD Signals

ワークフローを `.md` 化するサイン:

- 同じ手順を3回以上繰り返している
- 毎回同じ説明やブリーフィングを書いている
- 複数フェーズ、差し戻し、完了条件がある
- 途中で Scratch を使いたくなる
- 「誰が何をして、次に何を渡すか」が毎回似ている
- 失敗時のfallbackを定義したくなる

提案例:
- `Workflows/research-summary.md` を作る
- `Workflows/code-review.md` を作る
- `Workflows/content-pipeline.md` を作る
- `Workflows/meeting-notes.md` を作る

### Memory / Vault Signals

Vault や記憶化を検討するサイン:

- 過去の成果物を参照したくなる
- 同じ情報を何度も説明している
- Scratch が後から参照される
- 調査結果を再利用したい
- タグ、索引、出典、更新日を管理したくなる
- 「これは残しておいた方がよい」と感じる知見が増えている

提案例:
- 軽量 `Vault/` を作る
- `Vault/index.md` を作る
- `Vault/tag-taxonomy.md` を作る
- Scribe を追加する
- Librarian を追加する

Minimal Setup の `Vault/` は最初は Dormant placeholder、つまり置き場だけである。保存許可と再利用目的が明確になるまで、本格運用を始めない。

### Quality Gate Signals

品質ゲート改善を検討するサイン:

- Critic の指摘が曖昧
- PASS 後に手戻りが発生する
- 出典漏れ、前提漏れ、テスト漏れが繰り返される
- レビュー観点が毎回変わる
- 成果物の用途に対して検証が軽すぎる

提案例:
- Critic の Output Contract を厳密にする
- findings に severity を必須化する
- source / evidence / residual_risks を必須化する
- Reviewer を専門化する
- reinforced tier をロードマップに載せる

### Runtime Context Signals

Runtime 索引の更新を検討するサイン:

- 通常運用で毎回同じファイルを読む
- 組織改善と通常作業の切り替えが曖昧
- 新しいワークフローを追加した
- 新しいエージェントを追加した
- 読むべきファイルが増え、起動が重くなっている

提案例:
- `Runtime/CONTEXT_INDEX.md` に新しい mode を追加する
- Normal Operation の Read list を更新する
- 特定用途用の mode を追加する
- 使わない参照を外す

### Health / Evaluation Signals

`Runtime/HEALTH.md` や `Reports/health-check.md` を使った診断を検討するサイン:

- 同じ改善提案が複数回保留されている
- 起動時に読むファイルが増え、通常運用が重くなっている
- Worker / Critic / Workflow の境界が曖昧になっている
- Vault、Reports、Scratch の使い分けが崩れている
- 承認ルールが毎回揺れている
- ユーザーが「理論値まで」「磨き込み」「健康診断」を求めた

提案例:
- `Runtime/HEALTH.md` に健康診断メモを残す
- `Reports/health-check.md` に周期診断の高レベル要約を残す
- `evaluation-and-observability.md` の評価軸で見直す
- `agent-org-theoretical-maximum.md` の maturity ladder に照らす

### Human Attention Signals

人間の関与設計を見直すサイン:

- ユーザー確認が多すぎて作業が止まる
- 毎回同じ承認をしている
- 逆に、勝手に進められて困る操作がある
- 削除、公開、外部送信などの承認ルールが曖昧

提案例:
- 介入レベルを L2 から L1 に下げる候補を出す
- 破壊的操作を L3 に固定する
- 承認が必要な操作リストを MANIFEST に追記する

## Proposal Timing

Orchestrator は改善提案を以下のタイミングで出す。

`improvement_suggestions: off` の場合は、この章の自動提案は行わない。ユーザーが「改善して」「構造を見直して」などと求めたときだけ提案する。

### Immediate Proposal

作業中に明らかな設計問題を見つけた場合。ただし、`improvement_suggestions: end_of_task` では原則として即時提案しない。安全、機密、破壊的操作、重大な手戻りを防ぐ場合だけ例外的に短く伝え、主作業を止めない。

出し方:
> 作業はこのまま進めます。あとで改善候補として、〇〇を分離した方がよさそうです。

### End-of-task Proposal

`improvement_suggestions: end_of_task` の既定動作。タスク完了時に、必要なら軽く1つだけ提案する。

出し方:
> 今回の作業を見て、次回から `Workflows/xxx.md` にした方が少し楽になりそうです。

### Daily Reflection

`improvement_suggestions: periodic` の運用例。1日の終わり、または複数タスク後に、改善候補を短くまとめる。

出し方:
> 今日の運用で見えた改善候補は2つです。

### Weekly / Periodic Review

運用ログや Scratch が溜まったら、まとめて構造改善を提案する。

## Improvement Proposal Format

改善提案は以下の形式で返す。

```markdown
## 改善提案

### 観測
[何が繰り返し起きているか]

### 問題
[それにより何が悪化しているか]

### 提案
[何を追加・変更・削除するか]

### 影響
[軽くなる / 重くなる / 品質が上がる / 安全になる]

### 判断
[今やる / 後でよい / やらない]
```

## Decision Heuristics

### サブエージェントを作るべき

以下のうち2つ以上に該当する場合:

- 専門作業が3回以上繰り返された
- 既存エージェントの役割が広すぎる
- 品質問題が特定工程に集中している
- 独立判断が必要
- 入出力契約を分けた方が明らかに安定する

### ワークフローMD化すべき

以下のうち2つ以上に該当する場合:

- 同じ手順が3回以上出た
- フェーズが2つ以上ある
- done_when / fallback が必要
- Scratch を使う
- 毎回同じブリーフィングを書く

### Vaultを作るべき

以下のうち2つ以上に該当する場合:

- 過去成果物を再利用したい
- 調査結果や判断理由を残したい
- タグや索引が必要
- Scratch が運用記録として溜まってきた
- 知識を長期資産化したい

### まだ作らない方がよい

以下に該当する場合:

- 1回しか出ていない作業
- ユーザーがまだ運用方針に迷っている
- 作っても読む・使う機会が少ない
- 既存の Worker / Critic で十分
- 追加によりコンテキストが重くなるだけ

## Runtime Integration

`Runtime/CONTEXT_INDEX.md` には、以下を含めることを推奨する。健康診断を使う場合は、通常運用とは別 mode に分ける。

```markdown
## Improvement Signals

Orchestrator は以下を観測したら改善提案を検討する。
標準閾値は「2回で観測記録、3回で構造改善提案」とする。

- 同じ手順が2回以上観測された
- 同じミスが2回以上観測された
- Worker の役割が広すぎる
- Critic の指摘が同じカテゴリに偏る
- Scratch を後から参照する場面が増えた
- 保存・整形が毎回発生している
- 通常運用で毎回同じファイルを読んでいる

同じ摩擦が3回以上見えたら、提案は `観測 / 問題 / 提案 / 影響 / 判断` の形式で出す。
```

`Runtime/HEALTH.md` は通常タスクでは読まない。ユーザーが求めたとき、同じ摩擦が繰り返されたとき、または `health_check: periodic` のときだけ読む。

## Non-goals

- 毎回改善提案を出さない
- 作業中に主目的を乗っ取らない
- 使われない仕組みを増やさない
- ユーザー承認なしに構造変更しない
- 「将来使うかも」でエージェントを増やさない

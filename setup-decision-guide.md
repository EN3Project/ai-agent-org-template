# Setup Decision Guide

このファイルは、Orchestrator が初回セットアップや組織改善時に、用途に応じた組織構造を判断するためのガイドである。

## 基本原則

- ユーザーが明示しない限り Minimal Setup を推奨する
- ユーザーが「最初からフルで」「長期運用前提で」「用途別にちゃんと作りたい」と明示した場合は Full Setup を検討する
- Full Setup は「初期から全部入り」を意味しない
- 並列実行、ADR、複利ループ、Adversarial Deliberation、サブ組織は原則ロードマップに置く
- 最初に作るのは、実際に使うエージェントとワークフローだけにする
- 共通階層は `scaffold/AI_ORG/` を唯一の正本としてコピーして作る
- ルート直下の `orchestrator.md` は Orchestrator 仕様・設計参考であり、初回作成時にコピーしない
- Reports / Decisions / Vault は Dormant placeholders、つまり置き場だけ用意し、必要になるまで重い運用を始めない
- `Runtime/HEALTH.md` は健康診断用の軽量な計器盤として常に置くが、通常タスクでは読まない

## 指示の優先順位

運用時の裁定順は次に統一する。

1. 現在のユーザー明示指示・安全指示
2. `MANIFEST.md`
3. Orchestrator
4. `Runtime/CONTEXT_INDEX.md`
5. Workflows
6. Agents
7. 参考設計書

ただし、ユーザー指示であっても、安全ルール、法令、機密管理、明示された承認条件に反するものは実行しない。

## コピー前確認

既存 `AI_ORG/` がある場合は上書きせず、継続・拡張として扱う。

PowerShell:

```powershell
# Run from the template root.
$src = Resolve-Path ".\scaffold\AI_ORG"
$dst = Join-Path (Get-Location) "AI_ORG"
if (Test-Path -LiteralPath $dst) { throw "AI_ORG already exists: $dst" }
Write-Host "Copy: $src -> $dst"
Copy-Item -LiteralPath $src -Destination $dst -Recurse
```

Bash:

```bash
# Run from the template root.
src="$(pwd)/scaffold/AI_ORG"
dst="$(pwd)/AI_ORG"
[ -e "$dst" ] && { echo "AI_ORG already exists: $dst"; exit 1; }
printf 'Copy: %s -> %s\n' "$src" "$dst"
cp -R "$src" "$dst"
```

テンプレートが別ディレクトリにある場合は、コピー元を絶対パスで指定する。

```powershell
$template = "C:\path\to\ai-agent-org-template"
$src = Join-Path $template "scaffold\AI_ORG"
$dst = Join-Path (Get-Location) "AI_ORG"
if (Test-Path -LiteralPath $dst) { throw "AI_ORG already exists: $dst" }
Write-Host "Copy: $src -> $dst"
Copy-Item -LiteralPath $src -Destination $dst -Recurse
```

既存 `AI_ORG/` を検出したら、以下を読んでから次の動きを確認する。

1. `AI_ORG/MANIFEST.md`
2. `AI_ORG/Runtime/BOOT.md`
3. `AI_ORG/Runtime/CONTEXT_INDEX.md`

選択肢は、継続運用、別名で新規作成、既存構成の拡張の3つを基本にする。

## Setup Mode Router

### Minimal Setup（既定・推奨）

向いている用途:
- まず試したい
- 日常業務の補助に使う
- まだ運用パターンが固まっていない
- 単発作業、文章整理、簡単な調査、レビュー補助が中心

作るもの:
- `scaffold/AI_ORG/` 由来の共通階層
- `scaffold/AI_ORG/orchestrator.md` 由来の `orchestrator.md`
- `MANIFEST.md`
- `Agents/worker.md`
- `Agents/critic.md`
- `Workflows/execute.md`
- `Scratch/`
- `Runtime/BOOT.md`
- `Runtime/CONTEXT_INDEX.md`
- `Runtime/OBSERVATIONS.md`
- `Runtime/HEALTH.md`
- 置き場として `Reports/`
- 置き場として `Decisions/`
- 置き場として `Vault/`

作らないもの:
- 専門エージェント群
- 複数ワークフロー
- 本格 Vault
- 並列実行
- ADR運用
- 複利ループ
- Adversarial Deliberation

### Full Setup（明示希望時のみ）

向いている用途:
- 長期運用する
- 用途が明確に決まっている
- 複数の専門工程が必要
- Vault や複数ワークフローが最初から必要
- 組織設計に時間をかけてよい

作るもの:
- `scaffold/AI_ORG/` 由来の共通階層
- `scaffold/AI_ORG/orchestrator.md` 由来の `orchestrator.md`
- `MANIFEST.md`
- 用途別 `Agents/`
- 用途別 `Workflows/`
- `Scratch/`
- `Runtime/BOOT.md`
- `Runtime/CONTEXT_INDEX.md`
- 必要なら軽量 `Vault/`
- 情報管理ルール
- 品質ゲート
- 介入レベル初期版
- 構築ロードマップ

初期実装に含めないもの:
- reinforced / maximum tier
- 大規模並列
- ADR運用
- 複利ループ計測
- Adversarial Deliberation
- サブ組織

これらは `build_roadmap` に記載し、運用が安定してから導入する。

## 初回セットアップの完了条件

セットアップだけなら、実タスクを通さなくても完了にしてよい。完了条件は以下とする。

- `AI_ORG/` が `scaffold/AI_ORG/` から作成されている
- `MANIFEST.md` に用途、指示優先順位、情報管理ルールがある
- `Runtime/BOOT.md` と `Runtime/CONTEXT_INDEX.md` がある
- `[用途を書く]`、任意の `[template path]`、`[template]`、例行の扱いが整理されている
- `improvement_suggestions: off | end_of_task | periodic` が決まっている
- `health_check: off | manual | periodic` が決まっている。迷ったら `manual`
- `Reports/`、`Decisions/`、`Vault/` は置き場だけとして存在する

最初の Scratch 作成と実タスク実行は、セットアップ後の任意ステップとして扱う。

## Use Case Router

| 用途 | 推奨構成 | 作るもの | 後回しにするもの |
|---|---|---|---|
| 日常業務補助 | Minimal | Orchestrator, Worker, Critic, Execute, Scratch | Vault運用, 専門エージェント, 並列 |
| 軽い調査・要約 | Minimal + Research Lite | Worker, Critic, Scratch, 必要なら簡易Scribe | Librarian, 本格Vault, Investigator分離 |
| 市場調査・技術調査 | Research | Librarian, Investigator, Analyst, Critic, Scribe, StandardResearch, Vault | 並列調査, Curator, 複利ループ |
| コード修正・開発補助 | Development | Architect, Developer, Tester, Reviewer, DevWorkflow | 大規模CI連携, 複数Reviewer, リリース自動化 |
| ドキュメント・記事制作 | Content | Writer, Editor, Critic, Publisher, ContentPipeline | 公開自動化, editorial calendar, A/B検証 |
| 個人ナレッジ管理 | Research or Full Lite | Librarian, Analyst, Scribe, Critic, Vault, tag-taxonomy | 大規模Curator, ベクトル検索, 週次メンテ |
| 多目的仕事OS | Full | Orchestrator, Research系, Development系またはContent系, Vault, 複数Workflow | サブ組織, maximum tier, 大規模並列 |
| チーム導入 | Full + Governance | Orchestrator, 権限ルール, 監査ログ, 標準Workflow | 自動承認, 外部公開自動化 |

## Component Decision Rules

### Orchestrator
常に必要。ユーザー窓口、dispatch、最終応答精査、CLI操作管理を担当する。

### Worker
Minimal では必要。専門構成では Developer / Writer / Investigator などに分化してよい。

### Critic / Reviewer
常に必要。生成と検証を分けるため、品質ゲートは最小構成でも省略しない。

### Scribe
以下の場合に追加する。
- 成果物の保存・整形が頻繁
- Scratch から Vault へ昇格する
- frontmatter や索引更新が必要

不要な場合:
- 単発作業中心
- 成果物を会話内で返すだけ

### Librarian
以下の場合に追加する。
- 既存知識の検索が重要
- Vault を運用する
- 過去成果物の再利用が多い

不要な場合:
- まだ Vault がない
- セッション内で完結する作業が中心

### Investigator
以下の場合に追加する。
- 外部調査が頻繁
- 出典付き findings が必要
- 調査と分析を分けたい

不要な場合:
- 軽い検索や要約だけ
- 外部情報をほとんど使わない

### Analyst
以下の場合に追加する。
- 複数情報源の統合が必要
- 洞察、比較、意思決定材料が必要
- 調査結果を構造化したい

不要な場合:
- 単純なリストアップ
- 短い要約だけ

### Curator
初期構築では原則不要。以下の場合に追加する。
- Vault が育ってきた
- タグ揺れ、リンク切れ、古いノートが問題になっている
- 週次メンテナンスが必要

### Vault
以下の場合に作る。
- 長期的に知識を蓄積する
- 過去成果物を再利用する
- 複数タスクの学びを横断利用する

不要な場合:
- 単発作業
- 機密上、永続保存したくない
- まだ運用パターンが見えていない

### Runtime/BOOT.md
常に作る。立ち上げ後、毎回テンプレート本体を読まずに軽く起動するための入口。

### Runtime/CONTEXT_INDEX.md
常に作る。通常運用、組織改善、深い設計見直しのどれかを Orchestrator が判定し、必要なファイルだけ読むための索引。

### Runtime/OBSERVATIONS.md
常に作る。日常運用で見つかった改善サインを短く記録する。作業本文や機密情報ではなく、構造的な観測だけを残す。

### Runtime/HEALTH.md
常に作る。ただし通常タスクでは読まない。組織改善、健康診断、反復する摩擦の整理、周期レビューのときだけ使う。

### Reports / Decisions / Vault
置き場としては常に用意してよい。ただし、これらは Dormant placeholders である。Reports は必要なときだけ高レベル要約を残し、Decisions は重要な構造判断だけに使い、Vault は保存許可が明確になるまで無効扱いにする。

## Runtime Mode Router

立ち上げ後は、テンプレート本体ではなく `AI_ORG/Runtime/BOOT.md` から起動する。

### Normal Operation

Trigger:
- 通常の作業依頼
- 調査、作成、整理、レビュー、実装

Read:
- `MANIFEST.md`
- `orchestrator.md`
- `Runtime/CONTEXT_INDEX.md`
- 必要な `Workflows/`
- 必要な `Agents/`

Do not read by default:
- `ai-agent-org-construction-template.md`
- `ai-agent-org-onboarding-guide.md`
- `OrgDesign.md`
- `org_designer.md`

### Organization Improvement

Trigger:
- 組織を改善したい
- エージェントを追加・削除したい
- ワークフローを追加・変更したい
- 品質ゲートを変えたい
- 失敗パターンを構造的に直したい

Additional Read:
- `OrgDesign.md`
- `org_designer.md`
- `ai-agent-org-onboarding-guide.md`

### Org Health Check

Trigger:
- 組織の健康診断をしたい
- 理論値に近づけたい
- 同じ摩擦、手戻り、確認過多が繰り返されている
- `health_check: periodic` の周期に達した

Read:
- `MANIFEST.md`
- `orchestrator.md`
- `Runtime/CONTEXT_INDEX.md`
- `Runtime/OBSERVATIONS.md`
- `Runtime/HEALTH.md`

Additional Read:
- `evaluation-and-observability.md`
- `agent-org-theoretical-maximum.md`

### Deep Architecture Review

Trigger:
- 設計原則を見直したい
- MANIFEST を大きく変えたい
- サブ組織化したい
- 並列化、ADR、複利ループ、Adversarial Deliberation を導入したい

Additional Read:
- `ai-agent-org-construction-template.md`

## Runtime File Templates

### Runtime/BOOT.md

```markdown
# Runtime BOOT

あなたはこの AI_ORG の Orchestrator である。

## 最初に読む
1. `MANIFEST.md`
2. `orchestrator.md`
3. `Runtime/CONTEXT_INDEX.md`

## 通常は読まない
- 元テンプレート一式
- onboarding guide
- construction template
- OrgDesign
- org_designer
- Runtime/HEALTH.md

これらは組織改善・健康診断・拡張・深い設計見直しのときだけ読む。

## 起動後に行うこと
1. ユーザーの依頼を受け取る
2. `Runtime/CONTEXT_INDEX.md` の Mode Router で読むファイルを決める
3. 必要最小限のコンテキストだけ読んで実行する
4. 重要な応答は Deliberation Gate を通す
5. 改善サインがあれば、作業完了時に短く提案する
6. 健康診断サインがあれば、`health_check` 設定に従う
```

### Runtime/CONTEXT_INDEX.md

```markdown
# Runtime CONTEXT INDEX

## Settings Source

運用設定の単一情報源は `MANIFEST.md` である。
このファイルでは `improvement_suggestions` や `health_check` を再定義しない。

## Template Source

[template path]

- 空、または `[template path]` のままなら template source は未設定
- 未設定の場合、`[template]/...` で始まる Additional Read は読まない
- 設定済みの場合、`[template]` を template source の値に置き換える

## Mode Router

### Normal Operation
Trigger:
- 通常作業
- 調査、作成、整理、レビュー、実装

Read:
- `MANIFEST.md`
- `orchestrator.md`
- `Workflows/execute.md`
- `Agents/worker.md`
- `Agents/critic.md`

### Organization Improvement
Trigger:
- 組織改善
- エージェント追加・削除
- ワークフロー追加・変更
- 品質ゲート改善
- 失敗パターンの構造的改善

Additional Read:
- `[template]/OrgDesign.md`
- `[template]/org_designer.md`
- `[template]/ai-agent-org-onboarding-guide.md`

### Org Health Check
Trigger:
- 組織の健康診断
- 理論値への磨き込み
- 同じ摩擦、手戻り、確認過多が明確に繰り返されている
- `MANIFEST.md` の `settings.health_check` が `periodic`

Read:
- `MANIFEST.md`
- `orchestrator.md`
- `Runtime/OBSERVATIONS.md`
- `Runtime/HEALTH.md`

Additional Read:
- `[template]/evaluation-and-observability.md`
- `[template]/agent-org-theoretical-maximum.md`

### Deep Architecture Review
Trigger:
- MANIFESTの大改訂
- サブ組織化
- 並列化
- ADR
- 複利ループ
- Adversarial Deliberation

Additional Read:
- `[template]/ai-agent-org-construction-template.md`

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
- ユーザー確認が多すぎて作業が止まっている

同じ摩擦が3回以上見えたら、提案は `観測 / 問題 / 提案 / 影響 / 判断` の形式で出す。

## Health Signals

Orchestrator は以下を観測したら、`MANIFEST.md` の `settings.health_check` に従って `Runtime/HEALTH.md` の確認を検討する。

- 通常起動で読むファイルが増え続けている
- Agent の役割境界が曖昧になっている
- Critic の PASS 後に手戻りが多い
- Scratch、Reports、Vault の使い分けが曖昧になっている
- ユーザー承認の線引きが毎回揺れている

## Improvement Reference

詳細な判断基準が必要な場合は `[template]/continuous-improvement.md` を読む。
```

## プレースホルダ処理

- `[用途を書く]` は、AI_ORG の用途を1文で置き換える
- `[template path]` は通常運用では未設定のままでよい。組織改善や設計参照で元テンプレートを読む場合だけ、このテンプレートリポジトリへの実パスまたは相対パスに置き換える
- `[template]` は、`[template path]` が設定されている場合だけ、そのテンプレートルートを指す
- `[例: ...]` の行は実運用ルールではない。実例に置き換えるか、不要なら削除する

| 初回セットアップで触る | 初回では触らない |
|---|---|
| `MANIFEST.md` の `[用途を書く]` | `Scratch/README.md` 内のタスクテンプレート例 |
| `MANIFEST.md` の情報管理ルール | `Reports/dispatch-trace.md` のコメント内テンプレート |
| `settings.improvement_suggestions` | `Decisions/ADR-template.md` の ADR 本文テンプレート |
| 必要なら `settings.health_check` | `Runtime/HEALTH.md` の例行 |
| 必要な場合だけ `Runtime/HEALTH.md` の `last_reviewed` | `Reports/health-check.md` の診断テンプレート |
| 必要な場合だけ `Runtime/CONTEXT_INDEX.md` の `[template path]` | `Vault/README.md` の有効化後テンプレート |

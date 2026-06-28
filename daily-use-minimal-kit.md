# Daily Use Minimal Kit

CLI 環境の仕事PCで、このテンプレートを軽く試すための最小キットです。

目的は、設計書の知見を捨てずに、日常作業で使える「薄い運用レイヤー」を作ることです。最初から大規模な AI 組織を作る必要はありません。

LLM に使わせる場合は、先に `START_HERE.md` を読ませてください。実作成では `scaffold/AI_ORG/` を唯一のコピー元として使います。このリポジトリ直下の `orchestrator.md` は Orchestrator 仕様・設計参考であり、初回作成時にコピーしません。

Windows PowerShell 5.1 で読む場合は、日本語が文字化けすることがあります。その場合は `Get-Content -Encoding UTF8` を使うか、PowerShell 7 以降またはエディタで開いてください。

## 最初に作るもの

`scaffold/AI_ORG/` をコピーして、以下の共通階層を作ります。

```text
AI_ORG/
  MANIFEST.md
  orchestrator.md
  Agents/
  Workflows/
  Scratch/
  Runtime/
  Reports/
  Decisions/
  Vault/
```

`Reports/`、`Decisions/`、`Vault/` は Dormant placeholders、つまり置き場だけです。初日から運用する場所ではありません。必要性が見えたときだけ Orchestrator が提案し、ユーザー承認後に有効化します。

`Runtime/HEALTH.md` と `Reports/health-check.md` も scaffold に含まれます。これは組織の健康診断用であり、通常タスクでは読みません。ユーザーが組織改善を求めたとき、または同じ摩擦が繰り返されたときだけ使います。

## 安全なコピー手順

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

コピー前に `src` と `dst` をユーザーに見せます。既存の `AI_ORG/` がある場合は上書きせず、継続・拡張として扱います。

テンプレートが別ディレクトリにある場合は、コピー元を絶対パスで指定します。

```powershell
$template = "C:\path\to\ai-agent-org-template"
$src = Join-Path $template "scaffold\AI_ORG"
$dst = Join-Path (Get-Location) "AI_ORG"
if (Test-Path -LiteralPath $dst) { throw "AI_ORG already exists: $dst" }
Write-Host "Copy: $src -> $dst"
Copy-Item -LiteralPath $src -Destination $dst -Recurse
```

既存の `AI_ORG/` が見つかった場合は、`AI_ORG/MANIFEST.md`、`AI_ORG/Runtime/BOOT.md`、`AI_ORG/Runtime/CONTEXT_INDEX.md` を読んでから、継続・別名作成・拡張のどれにするか確認します。

## 差し替える項目

### `MANIFEST.md`

最初に埋めるのは、以下だけで十分です。

- `[用途を書く]`: 例「日常の文書作成とレビューを安定して進める」
- 情報管理ルール: 保存してよい情報、保存してはいけない情報、必ず承認が必要な操作
- 改善提案の頻度: `improvement_suggestions: off | end_of_task | periodic`
- 健康診断の頻度: `health_check: off | manual | periodic`

指示の優先順位は次に統一します。

1. 現在のユーザー明示指示・安全指示
2. `MANIFEST.md`
3. Orchestrator
4. `Runtime/CONTEXT_INDEX.md`
5. Workflows
6. Agents
7. 参考設計書

ただし、ユーザー指示であっても、安全ルール、法令、機密管理、明示された承認条件に反するものは実行しません。

### `Runtime/CONTEXT_INDEX.md`

- `[template path]` は通常運用では未設定のままでよい。組織改善や設計参照で元テンプレートを読む場合だけ、このテンプレートリポジトリへの実パスまたは相対パスに置き換える
- `[template]` は、`[template path]` が設定されている場合だけ、そのテンプレートルートを指す短縮表記として扱う
- 通常運用では `MANIFEST.md`、`orchestrator.md`、必要な `Workflows/` と `Agents/` だけを読む
- 組織改善や深い設計見直しのときだけ、テンプレート本体を参照する

### `Runtime/HEALTH.md`

- 通常タスクでは読まない
- 組織改善、繰り返す摩擦、周期診断のときだけ使う
- 作業本文や機密情報ではなく、構造的な健康サインだけを書く

### 例行

`[例: ...]` の行は実運用ルールではありません。実例に置き換えるか、不要なら削除します。`Runtime/OBSERVATIONS.md` の例行も、最初から運用ログとして残す必要はありません。

| 初回セットアップで触る | 初回では触らない |
|---|---|
| `MANIFEST.md` の `[用途を書く]` | `Scratch/README.md` 内のタスクテンプレート例 |
| `MANIFEST.md` の情報管理ルール | `Reports/dispatch-trace.md` のコメント内テンプレート |
| `settings.improvement_suggestions` | `Decisions/ADR-template.md` の ADR 本文テンプレート |
| 必要なら `settings.health_check` | `Runtime/HEALTH.md` の例行 |
| 必要な場合だけ `Runtime/HEALTH.md` の `last_reviewed` | `Reports/health-check.md` の診断テンプレート |
| 必要な場合だけ `Runtime/CONTEXT_INDEX.md` の `[template path]` | `Vault/README.md` の有効化後テンプレート |

## セットアップ完了条件

初回セットアップは、次を満たせば完了です。

- `AI_ORG/` が `scaffold/AI_ORG/` から作られている
- `MANIFEST.md` に用途、指示優先順位、情報管理ルールが書かれている
- `Runtime/CONTEXT_INDEX.md` の `[template path]` は、必要なら埋まっている。通常運用だけなら未設定でよい
- `improvement_suggestions` の頻度が決まっている
- `health_check` の頻度が決まっている
- `Reports/`、`Decisions/`、`Vault/` が置き場だけとして存在する

ここで止めて問題ありません。最初の実タスクは、セットアップ後の任意ステップです。

## 任意: 最初の実タスク

1. 小さな依頼を1つ選ぶ
2. `Scratch/YYYY-MM-DD-task-name.md` を作る
3. Worker がドラフトまたは作業結果を作る
4. Critic が検証し、リスクと修正点を出す
5. Orchestrator が最終応答を整える
6. 必要なら改善サインだけを `Runtime/OBSERVATIONS.md` に残す。健康診断はここでは必須ではない

例:

```text
今日の議事メモを、社外共有用の短い要約にしてください。
保存してよい情報は公開済みの議題だけです。
顧客名と個人名は残さないでください。
```

## 1日の使い方

1. 作業前に、依頼内容と保存ルールを短く確認する
2. 必要なら `Scratch/YYYY-MM-DD-task-name.md` に作業状態を残す
3. Worker -> Critic -> Orchestrator final の順に回す
4. 改善サインだけ `Runtime/OBSERVATIONS.md` に短く残す
5. 同じ摩擦が繰り返されたら `Runtime/HEALTH.md` で短く診断する
6. 後から使い回せる知見が3回以上出てから、Vault 化を検討する

## 拡張してよいサイン

- 同じ種類のタスクを3回以上回した
- Worker が毎回似たミスをする
- Critic の指摘が毎回同じカテゴリに偏る
- Scratch に残した内容を後から参照したくなる
- 手順を人に渡したくなる

この状態になってから、`ai-agent-org-onboarding-guide.md` の Research / Development / Content プリセットに進むのがよいです。

## まだ入れなくてよいもの

- 並列実行
- reinforced / maximum tier
- ADR
- 複利ループ
- Adversarial Deliberation
- サブ組織
- 本格 Vault 運用

これらは強力ですが、最初から入れると運用が重くなります。まずは Worker + Critic + Scratch の最小構成を安定させます。

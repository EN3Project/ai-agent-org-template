# AI Agent Org Template

AIエージェントを「賢い個体」としてではなく、「忘れる個体を前提に、忘れない仕組みとして運用する」ための設計テンプレートです。

このテンプレートは、CLI 環境で LLM がファイルを読み書きしながら運用することを前提にしています。

このリポジトリは、知見を薄めずに使いやすくするため、目的に応じて入口を分けて読むことを推奨します。

LLM にこのテンプレートを読ませる場合は、最初に `START_HERE.md` を読ませてください。

実際に `AI_ORG/` を作るときは、`scaffold/AI_ORG/` を唯一のコピー元として使います。必須ファイルは最初から中身つきで用意されており、用途に合わせて `MANIFEST.md` と Runtime の索引を埋めます。このリポジトリ直下の `orchestrator.md` は Orchestrator の仕様・設計参考であり、初回作成時にコピーする正本ではありません。

## 人間向けの読書順

| 目的 | 読むファイル | 目安 |
|---|---|---|
| 全体像を掴む | この `README.md` | 5分 |
| 構成を判断する | `setup-decision-guide.md` | 10分 |
| 実体テンプレを見る | `scaffold/README.md` | 5分 |
| 仕事PCで試す | `daily-use-minimal-kit.md` | 15分 |
| 理論値への伸ばし方を見る | `agent-org-theoretical-maximum.md` | 10分 |
| 評価・健康診断の軸を見る | `evaluation-and-observability.md` | 10分 |
| 用途別に組織を設計する | `ai-agent-org-onboarding-guide.md` | 30-60分 |
| 設計思想を理解する | `ai-agent-org-construction-template.md` | 必要に応じて |

## LLM向けの読書順

1. `START_HERE.md`
2. この `README.md`
3. `setup-decision-guide.md`
4. `scaffold/README.md`
5. `daily-use-minimal-kit.md`
6. 必要になったときだけ `continuous-improvement.md`、`agent-org-theoretical-maximum.md`、`evaluation-and-observability.md`、`ai-agent-org-onboarding-guide.md`、`ai-agent-org-construction-template.md`

## ファイルの役割

| ファイル | 役割 |
|---|---|
| `START_HERE.md` | 起動指示。LLMが最初に読み、Orchestratorとして立ち上がるためのbootstrap |
| `setup-decision-guide.md` | 用途別判断ガイド。Minimal / Full、必要なエージェント、Runtime起動モードを判断する |
| `continuous-improvement.md` | 継続改善ガイド。運用中にサブエージェント化、ワークフロー化、Vault化、品質ゲート改善を提案する基準 |
| `agent-org-theoretical-maximum.md` | AIエージェント組織を理論値へ近づける成熟度、判断軸、有効化ルール |
| `evaluation-and-observability.md` | タスク品質、組織健康度、改善サインを軽量に評価・観測するためのガイド |
| `scaffold/` | 実体テンプレート。どの組織でも基本的に必要なファイルと置き場をあらかじめ用意する |
| `ai-agent-org-construction-template.md` | 正典。AIエージェント組織の設計思想、原則、アンチパターン、拡張ロードマップを定義する |
| `ai-agent-org-onboarding-guide.md` | 導入ガイド。用途別プリセットとカスタマイズ手順を提供する |
| `orchestrator.md` | 統括窓口の仕様・設計参考。初回作成時はコピーせず、実体は `scaffold/AI_ORG/orchestrator.md` を使う |
| `OrgDesign.md` | ワークフロー定義。AIに組織設計を支援させる場合の実行手順 |
| `org_designer.md` | エージェント定義。組織設計官としての役割、入力契約、出力契約を定義する |
| `daily-use-minimal-kit.md` | 仕事PCで最小構成から使い始めるための実用キット |

## 使い方の基本方針

最初から全機能を使う必要はありません。むしろ、最初は小さく始めます。

1. `START_HERE.md` で LLM を Orchestrator として起動する
2. `setup-decision-guide.md` で Minimal / Full と用途別構成を判断する
3. `scaffold/AI_ORG/` をコピーして、共通階層を作る
4. `AI_ORG/orchestrator.md` でユーザーとの窓口を一元化する
5. `MANIFEST.md` で目的と優先順位を固定する
6. `Worker` と `Critic` の2役で作業と検証を分ける
7. `Runtime/BOOT.md` と `Runtime/CONTEXT_INDEX.md` を使い、立ち上げ後は軽く起動する
8. `Scratch` に作業状態を残す
9. `Runtime/OBSERVATIONS.md` に改善サインだけを短く残す
10. 必要時だけ `Runtime/HEALTH.md` で組織の健康診断を行う
11. 3回以上回して、失敗パターンが見えてから拡張する
12. 必要になった段階で、Research / Development / Content / Full に移行する

## 指示の優先順位

運用中に指示が競合した場合は、原則として以下の順に裁定します。

1. 現在のユーザー明示指示・安全指示
2. `MANIFEST.md`
3. Orchestrator
4. `Runtime/CONTEXT_INDEX.md`
5. Workflows
6. Agents
7. 参考設計書

ただし、ユーザー指示であっても、安全ルール、法令、機密管理、明示された承認条件に反するものは実行しません。Orchestrator は矛盾点を整理し、必要ならユーザーに確認します。

## このテンプレートが解く問題

AIエージェントはセッションごとに記憶が消えます。つまり、個体に経験を蓄積させる設計は壊れやすい。

このテンプレートは、次のものを外部化することで、AIを仕事環境の一部として安定運用することを目指します。さらに、運用中の摩擦を Orchestrator が観測し、必要に応じてサブエージェント化・ワークフロー化・記憶化を提案します。

- 組織の目的: `MANIFEST`
- 統括窓口: `Orchestrator`
- 役割分担: `Agents`
- 作業手順: `Workflows`
- 中間状態: `Scratch`
- 長期記憶: `Vault`
- 品質判断: `Critic` / 品質ゲート
- 組織健康度: `Runtime/HEALTH.md` / health check
- 改善履歴: ADR / 複利ループ
- 改善提案: `continuous-improvement.md`

共通階層として、`Reports/`、`Decisions/`、`Vault/` も最初から置き場だけ用意します。`Runtime/HEALTH.md` は軽量な健康診断用の計器盤として置きます。ただし、これらは初日から重く運用するものではなく、必要になったときに Orchestrator が提案し、ユーザー承認後に有効化します。

## 迷ったときの原則

- 迷ったら Minimal から始める
- ユーザーとの窓口は Orchestrator に集約する
- 使わないエージェントは作らない
- Phase 0-1 では並列化しない
- 生成と検証は分ける
- 外部に残す情報と残さない情報を先に決める
- 本体の設計思想は削らず、日常運用は薄く保つ
- 重要な最終応答は Deliberation Gate を通してから返す
- 同じ摩擦が繰り返されたら、構造改善を提案する
- 健康診断は、ユーザーが求めたときか、反復する摩擦が見えたときだけ行う

## 仕事PCに入れる場合の注意

仕事用PCでは、便利さより先に情報管理ルールを決めます。

- 機密情報を `Scratch` や `Vault` に残してよいか
- 外部AIサービスに渡してよい情報は何か
- ログに残してはいけない情報は何か
- 人間の承認が必要な操作は何か
- 成果物をどこに保存するか

このルールは最初の `MANIFEST.md` に短く書いておくと、以後の運用が安定します。

CLI で運用する場合、LLM はファイル作成や更新を実行できるため、削除・上書き・外部送信・公開・カレントディレクトリ外への書き込みは明示承認制にします。

Windows PowerShell 5.1 で Markdown を直接読む場合は、日本語が文字化けすることがあります。その場合は `Get-Content -Encoding UTF8` を使うか、PowerShell 7 以降またはエディタで開いてください。

## 安全な初回コピー例

以下の例は、テンプレートルートで実行する前提です。

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

どちらも、既存の `AI_ORG/` があれば停止します。コピー前に `src` と `dst` をユーザーに見せ、コピー先が意図どおりか確認してください。

テンプレートを別ディレクトリに置いたまま、現在の作業ディレクトリへ `AI_ORG/` を作る場合は、コピー元を絶対パスで指定します。

```powershell
$template = "C:\path\to\ai-agent-org-template"
$src = Join-Path $template "scaffold\AI_ORG"
$dst = Join-Path (Get-Location) "AI_ORG"
if (Test-Path -LiteralPath $dst) { throw "AI_ORG already exists: $dst" }
Write-Host "Copy: $src -> $dst"
Copy-Item -LiteralPath $src -Destination $dst -Recurse
```

```bash
template="/path/to/ai-agent-org-template"
src="$template/scaffold/AI_ORG"
dst="$(pwd)/AI_ORG"
[ -e "$dst" ] && { echo "AI_ORG already exists: $dst"; exit 1; }
printf 'Copy: %s -> %s\n' "$src" "$dst"
cp -R "$src" "$dst"
```

既存の `AI_ORG/` が見つかった場合は、上書きしません。まず `AI_ORG/MANIFEST.md`、`AI_ORG/Runtime/BOOT.md`、`AI_ORG/Runtime/CONTEXT_INDEX.md` を読み、継続するか、別名で新規作成するか、ユーザーに確認します。

## プレースホルダの扱い

- `[用途を書く]` は、AI_ORG の用途を1文で置き換える
- `[template path]` は通常運用では未設定のままでよい。組織改善や設計参照で元テンプレートを読む場合だけ、このテンプレートリポジトリへの実パスまたは相対パスに置き換える
- `[template]` は、`[template path]` が設定されている場合だけ、その場所を参照する短縮表記として扱う
- `[例: ...]` の行は実運用ルールではない。実例に置き換えるか、不要なら削る

| 初回セットアップで触る | 初回では触らない |
|---|---|
| `MANIFEST.md` の `[用途を書く]` | `Scratch/README.md` 内のタスクテンプレート例 |
| `MANIFEST.md` の情報管理ルール | `Reports/dispatch-trace.md` のコメント内テンプレート |
| `settings.improvement_suggestions` | `Decisions/ADR-template.md` の ADR 本文テンプレート |
| 必要なら `settings.health_check` | `Runtime/HEALTH.md` の例行 |
| 必要な場合だけ `Runtime/HEALTH.md` の `last_reviewed` | `Reports/health-check.md` の診断テンプレート |
| 必要な場合だけ `Runtime/CONTEXT_INDEX.md` の `[template path]` | `Vault/README.md` の有効化後テンプレート |

## 推奨する導入順

初回セットアップだけなら、`AI_ORG/` が作成され、`MANIFEST.md` と Runtime の索引が用途に合わせて埋まった時点で完了です。実タスクの実行は、その後の任意ステップとして扱います。

### 初回セットアップ

1. LLM に `START_HERE.md` を読ませる
2. `setup-decision-guide.md` に従って Minimal / Full を判断する
3. `scaffold/AI_ORG/` をコピーして最小構成を作る
4. `daily-use-minimal-kit.md` を見ながら用途に合わせて埋める
5. `Runtime/BOOT.md` から通常運用を始める

### 任意: 初回実タスク

6. 実タスクを1つ選び、`Scratch/YYYY-MM-DD-task-name.md` を作る
7. Worker -> Critic -> Orchestrator final の流れで1回通す
8. 実タスクを3回ほど回し、失敗・手戻り・判断迷いを `Runtime/OBSERVATIONS.md` に短くメモする
9. `ai-agent-org-onboarding-guide.md` のプリセットに照らして拡張する
10. 設計判断が重くなってきたら `ai-agent-org-construction-template.md` を参照する

この順序なら、設計書の知見を無駄にせず、日常の作業負荷も増やしすぎずに導入できます。

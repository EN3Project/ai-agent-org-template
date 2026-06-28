---
version: "1.0"
last-reviewed: 2026-06-25
---
# Workflow: OrgDesign（組織設計）

## Objective
ユーザーが新しい AI エージェント組織をゼロから設計・構築するのを支援し、設計書 v2.0 に準拠した組織設計一式を出力する。

## 位置づけ

このワークフローは、`README.md` と `daily-use-minimal-kit.md` の最小導入で不足が見えた後に使う。最初から Full 構成を作るためではなく、実運用で確認された要求を設計書 v2.0 に沿って整理し、拡張可能な組織設計へ変換するための手順である。

実運用の正本は `scaffold/AI_ORG/` である。本ファイルは、AI_ORG scaffold を拡張・カスタマイズするときの設計参照であり、初期構成を上書きするものではない。

## 窓口原則

ユーザーとの入出力は常に Orchestrator が担当する。OrgDesigner / Critic / 任意追加の Scribe はユーザーに直接応答せず、追加確認が必要な場合は `questions_for_user` を Orchestrator に返す。Orchestrator は最終応答前に `scaffold/AI_ORG/orchestrator.md` の Deliberation Gate を通し、結論・理由・残リスク・次の一手を整理して提示する。

## 発動条件

正本: `scaffold/AI_ORG/MANIFEST.md`、`scaffold/AI_ORG/orchestrator.md`、`scaffold/AI_ORG/Workflows/execute.md`。本ワークフローは、組織設計が必要になった場合に参照する拡張手順である。

- ユーザーが `org-design` / `組織設計` を実行したとき
- ユーザーが「AI 組織を作りたい」「エージェント組織を設計して」「新しい組織を立ち上げたい」など、組織構築の意図を明示したとき

## 複雑度ルーター

```yaml
complexity_router:
  - condition: "単一目的・エージェント2-3体・並列不要"
    level: "Simple"
    dispatch: "Phase 0 → Phase 1 → Phase 2（軽量レビュー / Orchestrator internal check）→ Phase 3 → Phase 4"
  - condition: "複数目的・エージェント4-7体・標準ワークフロー"
    level: "Standard"
    dispatch: "Phase 0 → Phase 1 → Phase 2 → Phase 3 → Phase 4"
  - condition: "大規模・8体以上・並列設計・サブ組織検討"
    level: "Full"
    dispatch: "Phase 0 → Phase 1 → Phase 2 → Phase 3（reinforced tier）→ Phase 4"
  default: "Standard"
```

判定はオーケストレーターが Phase 0 の要件ヒアリング完了後に行う。

## フェーズ定義

### Phase 0: 協調的要件定義（オーケストレーター・dispatch なし）

AI_ORG の Orchestrator がユーザーと対話し、組織の要件を引き出す。

```yaml
phase_0:
  name: "協調的要件定義"
  agent: "オーケストレーター（dispatch なし）"
  input: "ユーザーの組織構築の意図・背景"
  output: "Scratch#phase_0 に要件サマリー（存在意義・主要タスク・品質要求・並列性・人間の関与・外部記憶・チーム規模）"
  done_when: "Q1-Q7 の回答が確定し、複雑度が判定されている"
  fallback: "ユーザーの回答が不十分 -> 追加質問で深掘り"
  execution_mode: "sequential"
```

**進め方:**
1. `OrgDesigner` の対話フロー Step 1 の質問項目（Q1-Q7）を参考に、ユーザーの要件を引き出す
2. 設計書 v2.0 の 9 つの本質的問いにマッピングして整理する（※ 9つの本質的問いへのマッピングは Scratch 記載時に整理する）
3. 複雑度を判定し、ユーザーに通知する（例: `[Standard] 構成で進む`）
4. 確定要件を `Scratch/WORKFLOW_SCRATCH_org-design.md` に記載する

### Phase 1: 組織設計（OrgDesigner）

```yaml
phase_1:
  name: "組織設計"
  agent: "org_designer"
  input: "Scratch#phase_0 の要件サマリー + 設計書 v2.0"
  output: "Scratch#phase_1 に組織設計ドラフト（MANIFEST・エージェント定義・ワークフロー定義・外部記憶設計・介入レベル・構築ロードマップ）"
  done_when: "Output Contract の全必須フィールドが存在し、アンチパターン警告が明記されている"
  fallback: "必須フィールド欠落 -> org_designer に差し戻し"
  execution_mode: "sequential"
```

**Briefing テンプレート:**
```
OrgDesign Phase 1: OrgDesigner -- 組織設計

## タスク
`Scratch/WORKFLOW_SCRATCH_org-design.md` の Phase 0 要件サマリーを読み、設計書 v2.0 に基づいて組織設計ドラフトを作成する。

## 参照資料
- 正本 scaffold: `scaffold/AI_ORG/`
- 設計参照: `ai-agent-org-construction-template.md`
- 導入参照: `ai-agent-org-onboarding-guide.md`
- 要件サマリー: `Scratch/WORKFLOW_SCRATCH_org-design.md` の ## Phase 0 セクション

## 出力契約
`org_designer.md` の Output Contract に従う。

## 役割境界
設計提案のみ。実ファイルの作成は行わない。

## 出力先
WORKFLOW_SCRATCH の ## Phase 1: OrgDesigner に設計ドラフトを記載し、frontmatter の phase_done に 1 を追加する。
```

### Phase 2: 設計レビュー（Critic）

```yaml
phase_2:
  name: "設計レビュー"
  agent: "critic"
  input: "Scratch#phase_1 の組織設計ドラフト"
  output: "Scratch#phase_2 に査読結果（verdict + 指摘一覧 + アンチパターン検証）"
  done_when: "verdict が PASS / CONDITIONAL_PASS / FAIL のいずれかで確定し、devil's advocate パスが完了している"
  fallback: "FAIL -> Phase 1 に差し戻し（最大2回）"
  execution_mode: "sequential"
```

**Briefing テンプレート:**
```
OrgDesign Phase 2: Critic -- 設計レビュー

## タスク
WORKFLOW_SCRATCH の Phase 1 組織設計ドラフトを査読する。

## 査読の焦点
1. 設計書 v2.0 の構造への準拠（MANIFEST 構成要素の網羅性、エージェント定義の Input/Output Contract 存在、ワークフローの Scratch 状態契約）
2. アンチパターン（AP-0a ~ AP-12b）への抵触（※ OrgDesign 固有の追加査読項目であり、Critic の標準 Output Contract に加えて実施する）
3. 9 つの本質的問いへの回答漏れ
4. 役割境界の明確性（越境リスクの有無）
5. 介入レベルの妥当性（過剰な L2 / 過剰な L0）
6. 構築ロードマップの実現可能性
+ devil's advocate 1パス（必須）: 設計の最も脆弱な前提を突く

## 出力契約
`scaffold/AI_ORG/Agents/critic.md` の Output Contract を基準にし、OrgDesign 固有の査読項目を追加する。

## 出力先
WORKFLOW_SCRATCH の ## Phase 2: Critic に査読結果を記載し、frontmatter の phase_done に 2 を追加する。
```

**品質ゲート tier:**
- Simple: 軽量レビュー（Critic 1パスまたは Orchestrator internal check）。完全スキップはしない
- Standard: standard tier（Critic 1体）
- Full: reinforced tier（Critic 2体・クロスチェック）

### Phase 3: ユーザーレビュー（人間協調・dispatch なし）

```yaml
phase_3:
  name: "ユーザーレビュー"
  agent: "オーケストレーター（dispatch なし）"
  input: "Scratch#phase_1 の設計ドラフト + Scratch#phase_2 の査読結果"
  output: "Scratch#phase_3 にユーザーの承認 / 修正指示"
  done_when: "ユーザーが設計を承認、または修正指示を出している"
  fallback: "修正指示あり -> Phase 1 に差し戻し（修正指示を Input に追加）"
  execution_mode: "sequential"
```

**進め方:**
1. 設計ドラフトの要約をユーザーに提示する
2. Critic の指摘があれば併せて報告する
3. ユーザーの承認を得る、または修正指示を受け取る
4. 修正指示があれば Phase 1 に差し戻す

### Phase 4: 成果物生成（Orchestrator / 任意 Scribe）

```yaml
phase_4:
  name: "成果物生成"
  agent: "orchestrator（保存・整形を分離したい場合のみ scribe を追加）"
  input: "Scratch#phase_1 の承認済み設計ドラフト + Scratch#phase_3 のユーザー承認"
  output: "組織設計成果物一式（MANIFEST ドラフト・エージェント定義群・ワークフロー定義群・構築ロードマップ）"
  done_when: "全成果物が所定のフォーマットで出力されている"
  fallback: "なし"
  execution_mode: "sequential"
```

**Briefing テンプレート:**
```
OrgDesign Phase 4: Orchestrator / optional Scribe -- 成果物生成

## タスク
承認済みの組織設計ドラフトを、設計書 v2.0 のテンプレートに準拠した成果物として整形・出力する。

## 出力契約
初期 AI_ORG では Orchestrator が整形・記録を担当する。保存・Frontmatter 付与・索引更新が頻発する運用になった場合のみ、Scribe を追加し、その Output Contract を別途定義する。

## 成果物一覧
1. MANIFEST ドラフト（セクション 1 のテンプレートに準拠）
2. エージェント定義群（セクション 3 のテンプレートに準拠）
3. ワークフロー定義群（セクション 4 のテンプレートに準拠）
4. 外部記憶設計（ディレクトリ構造・メタデータスキーマ・タグ統制語彙）
5. 介入レベル割り当て表
6. 構築ロードマップ（Phase 0-4 のカスタマイズ版）

## 出力形式
成果物はまとめて `Scratch/WORKFLOW_SCRATCH_org-design.md` の ## Phase 4 セクションに記載する。ユーザーが個別ファイルへの書き出しを指示した場合のみ、指定パスに保存する。

## 完了後
1. WORKFLOW_SCRATCH の frontmatter に phase_done 4 を追加し、status: complete に更新する。
2. 必要に応じて `Reports/dispatch-trace.md` に高レベル要約を追記する（workflow: org-design）。
3. 構造変更・重要判断がある場合は `Decisions/` に ADR を追加する。
4. 成果物の概要と次ステップ（構築ロードマップの Phase 0 から着手）を報告する。
```

## Scratch 状態契約

```yaml
---
workflow: org-design
topic: "[組織名または設計テーマ]"
status: in-progress
started: YYYY-MM-DD
phase_done: []
---
```

### Scratch セクション構成

```markdown
# WORKFLOW_SCRATCH -- org-design

## Phase 0: 要件サマリー
### 存在意義
### 主要タスク
### 品質要求
### 並列性
### 人間の関与
### 外部記憶
### チーム規模
### 複雑度判定
### 9つの本質的問いへのマッピング

## Phase 1: OrgDesigner
### MANIFEST ドラフト
### エージェント定義
### ワークフロー定義
### 外部記憶設計
### 介入レベル割り当て
### 構築ロードマップ
### アンチパターン警告
### 設計判断の根拠

## Phase 2: Critic
### verdict
### 指摘一覧
### アンチパターン検証
### devil's advocate 所見

## Phase 3: ユーザーレビュー
### 承認 / 修正指示

## Phase 4: Orchestrator / optional Scribe
### 成果物一覧
### 保存パス（ファイル書き出しの場合）
```

## エスカレーション条件

| 条件 | アクション |
|---|---|
| Phase 0 でユーザーの要件が不明確 | 追加質問で深掘り（オーケストレーター判断） |
| Phase 1 で Output Contract 違反 | org_designer に差し戻し |
| Phase 2 で Critic が FAIL | Phase 1 に差し戻し（最大2回） |
| 差し戻し2回でも PASS しない | オーケストレーターに返却、人間にエスカレーション |
| 設計書 v2.0 でカバーされない要件 | 人間に判断を委ねる |

## 停止条件

- Phase 1 → Phase 2 の差し戻しループ: 最大2回
- Phase 3 → Phase 1 の修正ループ: ユーザーが「これでよい」と明示するまで（人間主導のため上限なし）
- 全体の dispatch 上限: 設けない（人間のレビューが入るため自然に収束する）

## Safety Rules

- 既存の AI_ORG ファイルを直接変更しない（成果物は Scratch に出力し、ユーザーの承認後に個別に適用する）
- 設計書 v2.0 本体を修正・拡張しない
- `AI_ORG/MANIFEST.md` を直接編集しない
- 成果物のファイル書き出しはユーザーの明示的な指示がある場合のみ

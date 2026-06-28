---
note_type: reference
title: "AIエージェント組織構築テンプレート 導入手順書 v1.0"
created: 2026-06-25
tags:
  - ai-agent
  - organization-design
  - template
  - onboarding
status: reviewed
audit_trail: "v1.0: Opus4.8 最終レビュー PASS（新規指摘ゼロ）。前回レビュー12件修正済み。2026-06-25"
derives_from: "[[ai-agent-org-construction-template]]"
---

# AIエージェント組織構築テンプレート 導入手順書 v1.0

> **本書の位置づけ:** `scaffold/AI_ORG/` を正本として、設計書 v2.0 のテンプレートを用途ごとにパーソナライズするための実行ガイド。対話で要件を引き出し、プリセットで出発点を提供し、カスタマイズで調整する。

> **対象読者:** AI を道具として十分に使い込み、次に「組織として構造化する」段階にある上級者。設計書 v2.0 を通読済みであることが前提。

> **初回導入の推奨:** 仕事PCで試す場合は、先に `README.md` で全体像を確認し、`scaffold/AI_ORG/` または `daily-use-minimal-kit.md` の Worker + Critic + Scratch 構成から始める。本書は、その最小構成を3回以上回してから、用途別プリセットに拡張するためのガイドとして使う。

---

## 本書の使い方

本書は3段階で構成される。

1. **要件ヒアリング（Step 1）:** 7つの質問に答えて組織の要件を導出する
2. **プリセット選定（Step 2）:** 要件に最も近いプリセットを選び、具体的な記入例を確認する
3. **カスタマイズ（Step 3）:** プリセットからの逸脱ポイントを判断し、調整する

各プリセットは設計書 v2.0 の **Phase 0-1 スコープ**（MANIFEST + 外部記憶 + エージェント定義 + ワークフロー1本 + 品質ゲート + 介入レベル初期版）に限定している。Phase 2-4（並列化・ADR・複利ループ・Adversarial Deliberation）は運用が安定してから段階的に導入する。最初からすべてを作り込む必要はない。

### 「やりすぎ」の判断基準

以下に該当する場合、それは Phase 0-1 でやるべきことではない。

| やりすぎの兆候 | 代わりにすべきこと |
|---|---|
| Phase 0-1 で並列実行パターンを設計している | Phase 2 まで待つ。まず直列で動かせ |
| ADR テンプレートを Phase 0 で作り込んでいる | Phase 3 で導入する。最初は MANIFEST と記憶基盤だけ。dormant placeholder として置くだけなら可 |
| エージェントを5体以上定義しようとしている（Full 以外） | 最小構成で動かしてから増やす。動かないものを増やしても意味がない |
| 週次メンテナンスワークフローを Phase 0-1 で定義している | Phase 3-4 の範囲。メンテナンス対象がまだ存在しない |
| 複利ループの計測指標を初期設計に含めている | Phase 4。計測対象のデータがまだない |
| 品質ゲートに reinforced / maximum tier を設定している | Phase 0-1 は standard tier（Critic 1体）で十分 |
| Adversarial Deliberation のスケジュールを組んでいる | Phase 4。設計が固まってからでないと攻撃対象がない |
| サブ組織・オーケストレーター階層を検討している | 付録「組織のスケール設計」は組織成熟後の拡張オプション |

**原則: 動く最小構成を作り、3回回してから次のレイヤーを積む。**

---

## Step 1: 要件ヒアリング

以下の7つの質問に答えよ。回答が Step 2 のプリセット推奨の入力になる。

### Q1: 存在意義

> この組織は何を達成するためのものか?（1文で）

設計書 v2.0 セクション1「組織憲法」の「存在意義」に直結する。MANIFEST の最上位に記載され、全判断の最終基準になる。

**考え方:** 「この組織がなければ自分は何に困るか?」を反転させる。

**記入例:**
- 「市場調査とトレンド分析を構造化・蓄積し、意思決定の材料を即座に提供する装置」
- 「ソフトウェア開発の設計・実装・テストを品質基準に基づいて遂行する開発チーム」
- 「専門知識を記事・スライド・SNS投稿として変換し、読者に価値を届ける編集部」

### Q2: 主要タスク

> 最も頻繁に実行するタスクは何か?

このタスクが最初のワークフロー定義の対象になる。Phase 0-1 では1本のワークフローに集中する。

**選択肢の目安:**
- リサーチ・調査（外部情報の収集→分析→構造化）
- コード生成・レビュー（設計→実装→テスト→レビュー）
- 文書・コンテンツ制作（企画→執筆→編集→公開）
- 複合タスク（上記の組み合わせ）

### Q3: 品質要求

> 出力にどの程度の品質ゲートが必要か?

設計書 v2.0 セクション7「品質ゲート設計」の tier 選択に対応する。

| 選択肢 | 設計書での対応 | 具体例 |
|---|---|---|
| **軽量チェックで十分** | standard tier（Critic 1体） | 社内メモ、下書き、探索的な調査 |
| **独立した査読が必要** | standard tier + devil's advocate 必須 | 公開コンテンツ、顧客向け資料 |
| **多層検証が必要** | reinforced tier（Critic 2体） | 重要な意思決定資料、契約書、本番コード |

> Phase 0-1 では standard tier から始める。reinforced 以上は Phase 2 以降で導入する。

### Q4: 並列性

> 複数タスクの同時実行は必要か?

設計書 v2.0 セクション5「並列実行設計」に対応する。

| 選択肢 | 設計書での対応 |
|---|---|
| **直列で十分** | 並列パターンなし。Phase 0-1 はこれで始める |
| **2-3並列** | Fan-out / Fan-in。Phase 2 で導入 |
| **大規模並列** | 競争的並列 or 探索的並列。Phase 2+ で導入 |

> Phase 0-1 では直列実行のみ。並列化は Phase 2 のスコープ。

### Q5: 人間の関与

> どの程度の自動化を望むか?

設計書 v2.0 セクション6「人間のアテンション設計」に対応する。

| 選択肢 | 介入レベル初期設定 |
|---|---|
| **全ステップ確認** | 全アクション Level 2（承認必要） |
| **重要な判断のみ** | 定型作業 L1 / 判断系 L2 |
| **ほぼ自動** | 定型作業 L0 / 判断系 L1 / 破壊的変更 L2 |

> Phase 0-1 では全アクション Level 2 から始めるのが安全。実績を積んでから降格する。

### Q6: 外部記憶

> 知識の蓄積・再利用は重要か?

設計書 v2.0 セクション2「外部記憶設計」の規模感に対応する。

| 選択肢 | 外部記憶の設計規模 |
|---|---|
| **セッション内で完結** | Scratch のみ。永続記憶は不要 |
| **中期的に蓄積** | 50ノート以下の軽量 Vault |
| **長期的な知識資産化** | 50-200ノートの本格 Vault + INDEX + 型付きリンク |

### Q7: チーム規模

> 想定するエージェント数は?

| 選択肢 | 対応するプリセット |
|---|---|
| **2-3体の最小構成** | Minimal |
| **4-5体の標準構成** | Research / Development / Content |
| **6体以上の大規模構成** | Full |

---

## Step 2: プリセット選定

Q1-Q7 の回答から最も近いプリセットを選ぶ。以下の推奨マトリクスを参照せよ。

### プリセット推奨マトリクス

| Q2 主要タスク | Q7 規模: 最小 | Q7 規模: 標準 | Q7 規模: 大規模 |
|---|---|---|---|
| リサーチ・調査 | Minimal | **Research** | Full |
| コード生成・レビュー | Minimal | **Development** | Full |
| 文書・コンテンツ制作 | Minimal | **Content** | Full |
| 複合タスク | -- | -- | **Full** |

**迷ったら Minimal から始める。** 動く最小構成を作って3回回し、不足を感じてからプリセットを乗り換える方が、最初から大きく作って持て余すより遥かに効率的。

---

### Preset A: Minimal（最小構成）

**用途:** 単一タスク・軽量運用。「まず動かしてみたい」場合の最小出発点。

**エージェント構成:**

| 名前 | 役割 |
|---|---|
| Worker（作業員） | タスクの実行・生成を担当する |
| Critic（査読官） | 成果物の品質検証・バイアスチェック |

**ワークフロー構成:** 1本（直列2フェーズ: 生成 → 査読）

**品質ゲート:** standard tier（Critic 1体、devil's advocate 1パス必須）

#### MANIFEST 記入例

```markdown
# TaskForce MANIFEST

## 存在意義
ユーザーの依頼を品質基準に基づいて遂行し、検証済みの成果物を出力する最小組織。

## コアロジック
1. ユーザーの依頼を受け取り、タスクの性質を特定する
2. Worker にタスクを dispatch する
3. Worker の出力を Critic に渡し、品質ゲートを通過させる
4. PASS した成果物をユーザーに返す

## エージェント一覧
| 名前 | 役割（1文） | 定義ファイルパス |
|---|---|---|
| Worker | タスクの実行・生成を担当する | Agents/worker.md |
| Critic | 成果物の品質検証・バイアスチェック | Agents/critic.md |

## ワークフロー一覧
| 名前 | トリガー | 用途（1文） |
|---|---|---|
| Execute | ユーザーのタスク依頼 | 生成→査読の最小ワークフロー |

## 指示の優先順位
1. 現在のユーザー明示指示・安全指示
2. MANIFEST（本ファイル）
3. Orchestrator 定義
4. Runtime/CONTEXT_INDEX.md
5. 該当 Workflow 定義
6. 該当 Agent 定義
7. 参考設計書・導入ガイド

安全/法令/機密ルールに反する指示は実行しない。競合時は Orchestrator が確認する。
```

#### ワークフロー記入例

```yaml
workflow: Execute
trigger: "ユーザーのタスク依頼"
complexity_router: なし（単一構成）

phase_1:
  name: "生成"
  agent: "worker"
  input: "ユーザーの依頼内容 + 参考資料"
  output: "Scratch#draft に成果物ドラフトを書く"
  done_when: "Output Contract の必須フィールドが全て存在する"
  fallback: "出力不足 → オーケストレーターがブリーフィングを補完して再 dispatch"

phase_2:
  name: "査読"
  agent: "critic"
  input: "Scratch#draft"
  output: "Scratch#review に GSAR 判定付きレビューを書く"
  done_when: "verdict が PASS / CONDITIONAL PASS / FAIL のいずれかで確定し、devil's advocate パスが完了"
  fallback: "FAIL → phase_1 に差し戻し（最大2回）"
```

#### 介入レベル初期割り当て

| アクション | 介入レベル |
|---|---|
| Scratch への中間結果書き込み | L0 |
| Worker への dispatch | L2 |
| Critic の verdict 確認 | L1 |
| 最終成果物の確定 | L2 |

#### 外部記憶

Minimal は外部記憶を最小限にする。Scratch のみで運用し、永続記憶は必要に応じて後から追加する。

```
AI_ORG/
  MANIFEST.md
  Agents/
    worker.md
    critic.md
  Workflows/
    execute.md
  Scratch/
    WORKFLOW_SCRATCH_[topic].md
```

#### Minimal から次へのスケールパス

- Worker の出力品質が安定してきたら、Worker を専門化（Investigator + Analyst 等）に分割し Research / Development / Content プリセットへ移行する
- ワークフローが2本以上必要になったら、複雑度ルーターの導入を検討する

---

### Preset B: Research（リサーチ特化）

**用途:** 知識収集・分析を主軸とする組織。市場調査、技術調査、競合分析など。

**エージェント構成:**

| 名前 | 役割 |
|---|---|
| Librarian（司書） | Vault 内の既存ノート検索・カバレッジ報告 |
| Investigator（調査員） | 外部情報の収集・信頼性評価 |
| Analyst（分析官） | 情報の統合・構造化・洞察抽出 |
| Critic（査読官） | 成果物の品質検証・バイアスチェック |
| Scribe（書記官・任意追加） | 整形・保存・記帳。初期は Orchestrator が担当し、保存処理が増えたら分離 |

**ワークフロー構成:** 1本（直列5フェーズ: 検索 → 調査 → 分析 → 査読 → 出力/保存判断）

**品質ゲート:** standard tier

#### MANIFEST 記入例

```markdown
# ResearchHub MANIFEST

## 存在意義
外部情報を収集・分析・構造化し、信頼性を検証した知識資産として蓄積する調査組織。

## コアロジック
1. ユーザーの調査依頼を受け取り、調査スコープを特定する
2. Librarian に Vault を検索させ、既存知識のカバレッジを評価する
3. 不足分を Investigator に外部調査させる
4. Analyst に収集情報を統合・分析させる
5. Critic に品質検証させ、Orchestrator が出力・保存判断を行う。保存処理が定常化したら Scribe を追加する

## エージェント一覧
| 名前 | 役割（1文） | 定義ファイルパス |
|---|---|---|
| Librarian | Vault 内の既存ノート検索・カバレッジ報告 | Agents/librarian.md |
| Investigator | 外部情報源から事実を収集し、信頼性を評価する | Agents/investigator.md |
| Analyst | 収集された情報を統合・構造化し、洞察を抽出する | Agents/analyst.md |
| Critic | 成果物の品質検証・バイアスチェック | Agents/critic.md |
| Scribe（任意） | 成果物の整形・Frontmatter 付与・Vault への保存 | Agents/scribe.md |

## ワークフロー一覧
| 名前 | トリガー | 用途（1文） |
|---|---|---|
| StandardResearch | 「〜を調べて」「〜を調査して」 | 外部調査→分析→査読→保存の標準調査フロー |

## 指示の優先順位
1. 現在のユーザー明示指示・安全指示
2. MANIFEST（本ファイル）
3. Orchestrator 定義
4. Runtime/CONTEXT_INDEX.md
5. 該当 Workflow 定義
6. 該当 Agent 定義
7. 参考設計書・導入ガイド

安全/法令/機密ルールに反する指示は実行しない。競合時は Orchestrator が確認する。
```

#### ワークフロー記入例（複雑度ルーター付き）

```yaml
workflow: StandardResearch
trigger: "ユーザーの調査依頼"

complexity_router:
  - condition: "Vault 未構築、または既存ノート検索が不要で、軽い整理・要約・作成で足りる"
    level: "Simple"
    dispatch: "Worker または Investigator → Critic（light）→ Orchestrator"
  - condition: "Vault が有効化済みで、Librarian の検索で既存ノートのカバレッジが十分"
    level: "Simple"
    dispatch: "Librarian → Critic（light）→ Orchestrator"
  - condition: "外部調査が必要だが単一軸で完結"
    level: "Standard"
    dispatch: "Investigator → Analyst → Critic → Orchestrator（Vault 有効時のみ Librarian、必要なら Scribe）"
  - condition: "独立した調査軸が3つ以上"
    level: "Full"
    dispatch: "Investigator x N（Phase 2 で並列化）→ Analyst → Critic → Orchestrator（Vault 有効時のみ Librarian、必要なら Scribe）"
  default: "Standard"

# Standard 構成のフェーズ定義:
phase_0:
  name: "既存知識検索"
  agent: "librarian"
  input: "ユーザーの調査依頼（トピック + スコープ）"
  output: "Scratch#retrieval に既存ノート一覧 + カバレッジ評価を書く"
  done_when: "主要キーワードに対する検索が完了し、カバレッジ評価が記載されている"
  fallback: "Vault 未構築 → Librarian を使わない Simple / Standard 経路に切り替える"

phase_1:
  name: "外部調査"
  agent: "investigator"
  input: "Scratch#retrieval のカバレッジ不足領域 + 調査スコープ"
  output: "Scratch#findings に調査結果リスト（各件に出典 URL + 信頼度）を書く"
  done_when: "findings が3件以上、全件に出典 URL あり"
  fallback: "件数不足 → スコープ拡大して再 dispatch"

phase_2:
  name: "統合分析"
  agent: "analyst"
  input: "Scratch#retrieval + Scratch#findings"
  output: "Scratch#analysis に統合分析結果（300字要約 + key takeaways + 構造化知見）を書く"
  done_when: "要約・key takeaways・構造化知見が全て存在する"
  fallback: "構造化知見が不足 → 追加分析を指示"

phase_3:
  name: "査読"
  agent: "critic"
  input: "Scratch#analysis"
  output: "Scratch#review に GSAR 判定付きレビューを書く"
  done_when: "verdict 確定 + devil's advocate パス完了"
  fallback: "FAIL → phase_2 に差し戻し（最大2回）"

phase_4:
  name: "出力・保存判断"
  agent: "orchestrator（保存・整形を分離する場合のみ scribe）"
  input: "Scratch#analysis（査読 PASS 済み）"
  output: "ユーザー向け出力。保存許可がある場合のみ Vault に整形済みノートを保存"
  done_when: "最終出力が返され、保存した場合は Vault と INDEX の更新が確認されている"
  fallback: "なし"
```

#### エージェント定義の要点（Investigator の例）

```yaml
# Agent: Investigator（調査員）

## Role
外部情報源から事実を収集し、信頼性を評価する。

## Input Contract
input:
  - field: topic
    type: string
    description: "調査対象のトピック"
    required: true
  - field: scope
    type: string
    description: "調査の範囲と深さの指定"
    required: true
  - field: existing_notes
    type: list[path]
    description: "Librarian が収集した既存ノートのパス一覧"
    required: false
contract_violation: "topic 欠落 → オーケストレーターに差し戻し"

## Output Contract
output:
  - field: findings
    type: "list[{claim: string, source: url, reliability: G|S|A|R}]"
    description: "調査結果のリスト。各項目に出典と信頼度を付与"
    required: true
    min_items: 3
  - field: summary
    type: string
    description: "300字以内の要約"
    required: true
  - field: coverage_gaps
    type: list[string]
    description: "調査しきれなかった領域"
    required: true
contract_violation: "必須フィールド欠落 → 品質ゲートが自動 FAIL"

## 役割境界（厳守）
### やる
- 外部情報源（Web、API、データベース）からの情報収集
- 各 finding への出典 URL 付与
- 信頼性の GSAR 分類付与

### やらない（厳守）
- Vault 内の検索（Librarian の責務）
- 収集した情報の統合分析（Analyst の責務）
- 品質判定（Critic の責務）

## モデル推奨
速度優先。情報収集はルーティン的であり、判断の深さより網羅性が重要。
```

#### 介入レベル初期割り当て

| アクション | 介入レベル | 根拠 |
|---|---|---|
| Scratch への中間結果書き込み | L0 | 完全可逆 |
| Librarian の検索結果確認 | L1 | 通知のみ |
| Investigator / Analyst への dispatch | L2 | 初期は全 dispatch を確認 |
| Critic の verdict 確認 | L1 | FAIL 時のみ介入 |
| Vault へのノート保存 | L2 | 初期は全保存を確認 |
| ノートの permanent 昇格 | L2 | 不可逆に近い |

#### 外部記憶

```
AI_ORG/
  MANIFEST.md
  Agents/
    librarian.md
    investigator.md
    analyst.md
    critic.md
    scribe.md              # 任意追加
  Workflows/
    standard-research.md
  Vault/
    index.md              # INDEX（全ノートの参照）
    tag-taxonomy.md        # タグ統制語彙
    [note_type]/           # ノート格納先
      [topic-name].md
  Scratch/
    WORKFLOW_SCRATCH_[topic].md
```

**メタデータスキーマ:**

```yaml
---
title: "ノートのタイトル"
note_type: recon-report | analysis | reference | digest
status: raw | draft | reviewed | permanent | archived
tags: [kebab-case-tag]
date: YYYY-MM-DD
updated: YYYY-MM-DD
derives_from: "[[source_note]]"
---
```

**タグ統制語彙（初期案）:**
- `research/market` -- 市場調査
- `research/tech` -- 技術調査
- `research/competitor` -- 競合分析
- `analysis/trend` -- トレンド分析
- `analysis/comparison` -- 比較分析

---

### Preset C: Development（開発特化）

**用途:** ソフトウェア開発の設計・実装・テスト・レビューを管理する組織。

**エージェント構成:**

| 名前 | 役割 |
|---|---|
| Architect（設計官） | 技術要件の分析・設計方針の策定 |
| Developer（開発員） | 設計に基づくコード生成・実装 |
| Tester（検証員） | テストケース設計・実行・結果報告 |
| Reviewer（査読官） | コード品質・設計準拠の検証 |

**ワークフロー構成:** 1本（直列4フェーズ: 設計 → 実装 → テスト → レビュー）

**品質ゲート:** standard tier（Reviewer が Critic 相当を兼務。Reviewer は Critic の Output Contract（verdict + GSAR 分類 + devil's advocate）を遵守する）

#### MANIFEST 記入例

```markdown
# DevOps MANIFEST

## 存在意義
ソフトウェアの設計・実装・テストを品質基準に基づいて遂行し、レビュー済みのコードを出力する開発組織。

## コアロジック
1. ユーザーの開発要求を受け取り、技術要件を特定する
2. Architect に設計方針を策定させる
3. Developer に設計に基づいて実装させる
4. Tester にテストを実行させる
5. Reviewer にコード品質を検証させる

## エージェント一覧
| 名前 | 役割（1文） | 定義ファイルパス |
|---|---|---|
| Architect | 技術要件の分析・設計方針の策定 | Agents/architect.md |
| Developer | 設計に基づくコード生成・実装 | Agents/developer.md |
| Tester | テストケース設計・実行・結果報告 | Agents/tester.md |
| Reviewer | コード品質・設計準拠の検証 | Agents/reviewer.md |

## ワークフロー一覧
| 名前 | トリガー | 用途（1文） |
|---|---|---|
| DevCycle | 機能追加・バグ修正の依頼 | 設計→実装→テスト→レビューの開発サイクル |

## 指示の優先順位
1. 現在のユーザー明示指示・安全指示
2. MANIFEST（本ファイル）
3. Orchestrator 定義
4. Runtime/CONTEXT_INDEX.md
5. コーディング規約・設計ガイドライン
6. 該当 Workflow / Agent 定義
7. 参考設計書・導入ガイド

安全/法令/機密ルールに反する指示は実行しない。競合時は Orchestrator が確認する。
```

#### ワークフロー記入例

```yaml
workflow: DevCycle
trigger: "機能追加・バグ修正の依頼"

complexity_router:
  - condition: "単一ファイルの修正・小規模変更"
    level: "Simple"
    dispatch: "Developer → Reviewer"
  - condition: "複数ファイルにまたがる機能追加"
    level: "Standard"
    dispatch: "Architect → Developer → Tester → Reviewer"
  - condition: "アーキテクチャレベルの変更"
    level: "Full"
    dispatch: "Architect → Developer → Tester → Reviewer（reinforced）"
  default: "Standard"

phase_1:
  name: "設計"
  agent: "architect"
  input: "ユーザーの開発要求 + 既存コードベースの構造情報"
  output: "Scratch#design に設計方針（変更対象・方針・制約・テスト方針）を書く"
  done_when: "変更対象ファイルが特定され、設計方針が記載されている"
  fallback: "要件不明確 → ユーザーに追加ヒアリング"

phase_2:
  name: "実装"
  agent: "developer"
  input: "Scratch#design の設計方針"
  output: "Scratch#implementation に実装内容（変更ファイル一覧・コード diff）を書く"
  done_when: "設計方針の全項目が実装され、コード diff が記載されている"
  fallback: "設計方針と乖離 → phase_1 に差し戻し"

phase_3:
  name: "テスト"
  agent: "tester"
  input: "Scratch#design + Scratch#implementation"
  output: "Scratch#test に テスト結果（実行したテスト・結果・カバレッジ）を書く"
  done_when: "設計方針のテスト方針に定義された全テストが実行済み"
  fallback: "テスト失敗 → phase_2 に差し戻し（最大2回）"

phase_4:
  name: "レビュー"
  agent: "reviewer"
  input: "Scratch#design + Scratch#implementation + Scratch#test"
  output: "Scratch#review に GSAR 判定付きレビュー + devil's advocate 所見を書く"
  done_when: "verdict 確定 + devil's advocate パス完了"
  fallback: "FAIL → phase_2 に差し戻し（最大2回）"
```

#### 介入レベル初期割り当て

| アクション | 介入レベル | 根拠 |
|---|---|---|
| Scratch への中間結果書き込み | L0 | 完全可逆 |
| Architect の設計方針確認 | L2 | 下流全体に影響 |
| Developer の実装結果確認 | L1 | テスト+レビューで検証される |
| Tester のテスト結果確認 | L1 | 結果レポートを目視確認 |
| Reviewer の verdict 確認 | L1 | FAIL 時のみ介入 |
| 本番コードへのマージ | L3 | 不可逆・外部影響大 |

#### 外部記憶

```
AI_ORG/
  MANIFEST.md
  Agents/
    architect.md
    developer.md
    tester.md
    reviewer.md
  Workflows/
    dev-cycle.md
  Docs/
    coding-standards.md   # コーディング規約
    design-guidelines.md  # 設計ガイドライン
  Scratch/
    WORKFLOW_SCRATCH_[feature-name].md
```

Development プリセットでは Vault（知識蓄積）は Phase 0-1 で不要。コーディング規約と設計ガイドラインの2文書を Docs/ に置き、エージェントの参照基盤とする。知識蓄積が必要になったら Phase 2 以降で Vault 構造を導入する。

---

### Preset D: Content（コンテンツ制作特化）

**用途:** ブログ記事、SNS投稿、スライド、ニュースレターなどのコンテンツ制作を管理する組織。

**エージェント構成:**

| 名前 | 役割 |
|---|---|
| Writer（執筆官） | コンテンツの企画・構成・執筆 |
| Editor（編集官） | 文章の推敲・構成改善・一貫性確認 |
| Critic（査読官） | 品質検証・事実確認・バイアスチェック |
| Publisher（出版官） | 最終整形・メタデータ付与・公開準備 |

**ワークフロー構成:** 1本（直列4フェーズ: 執筆 → 編集 → 査読 → 出版）

**品質ゲート:** standard tier

#### MANIFEST 記入例

```markdown
# EditorialDesk MANIFEST

## 存在意義
専門知識を読者に価値ある形で変換し、品質基準を満たしたコンテンツとして出力する編集部。

## コアロジック
1. ユーザーのコンテンツ依頼を受け取り、対象読者・媒体・トーンを特定する
2. Writer にドラフトを執筆させる
3. Editor に推敲・構成改善を指示する
4. Critic に品質検証させる
5. Publisher に最終整形・公開準備を行わせる

## エージェント一覧
| 名前 | 役割（1文） | 定義ファイルパス |
|---|---|---|
| Writer | コンテンツの企画・構成・執筆 | Agents/writer.md |
| Editor | 文章の推敲・構成改善・一貫性確認 | Agents/editor.md |
| Critic | 品質検証・事実確認・バイアスチェック | Agents/critic.md |
| Publisher | 最終整形・メタデータ付与・公開準備 | Agents/publisher.md |

## ワークフロー一覧
| 名前 | トリガー | 用途（1文） |
|---|---|---|
| ContentPipeline | コンテンツ制作の依頼 | 執筆→編集→査読→出版の制作パイプライン |

## 指示の優先順位
1. 現在のユーザー明示指示・安全指示
2. MANIFEST（本ファイル）
3. Orchestrator 定義
4. Runtime/CONTEXT_INDEX.md
5. スタイルガイド・トーン規定
6. 該当 Workflow / Agent 定義
7. 参考設計書・導入ガイド

安全/法令/機密ルールに反する指示は実行しない。競合時は Orchestrator が確認する。
```

#### ワークフロー記入例

```yaml
workflow: ContentPipeline
trigger: "コンテンツ制作の依頼"

complexity_router:
  - condition: "SNS投稿・短文コンテンツ（500字以下）"
    level: "Simple"
    dispatch: "Writer → Critic"
  - condition: "ブログ記事・ニュースレター（500-3000字）"
    level: "Standard"
    dispatch: "Writer → Editor → Critic → Publisher"
  - condition: "ホワイトペーパー・長編（3000字超）"
    level: "Full"
    dispatch: "Writer → Editor → Critic（reinforced）（Phase 2 以降で導入）→ Publisher"
  default: "Standard"

phase_1:
  name: "執筆"
  agent: "writer"
  input: "コンテンツ依頼（テーマ・対象読者・媒体・トーン・文字数目安）"
  output: "Scratch#draft にドラフトを書く"
  done_when: "指定テーマ・文字数目安を満たすドラフトが存在する"
  fallback: "テーマが不明確 → ユーザーに追加ヒアリング"

phase_2:
  name: "編集"
  agent: "editor"
  input: "Scratch#draft"
  output: "Scratch#edited に推敲済み原稿 + 編集メモを書く"
  done_when: "文章の推敲が完了し、構成の改善点が全て反映されている"
  fallback: "大幅な構成変更が必要 → phase_1 に差し戻し"

phase_3:
  name: "査読"
  agent: "critic"
  input: "Scratch#edited"
  output: "Scratch#review に GSAR 判定 + 事実確認結果 + devil's advocate 所見を書く"
  done_when: "verdict 確定 + devil's advocate パス完了 + 事実確認の対象箇所が全件チェック済み"
  fallback: "FAIL → phase_2 に差し戻し（最大2回）"

phase_4:
  name: "出版準備"
  agent: "publisher"
  input: "Scratch#edited（査読 PASS 済み）"
  output: "公開用コンテンツ（メタデータ付き最終版）"
  done_when: "メタデータ（タイトル・概要・タグ・公開日）が付与され、公開フォーマットに整形されている"
  fallback: "なし"
```

#### 介入レベル初期割り当て

| アクション | 介入レベル | 根拠 |
|---|---|---|
| Scratch への中間結果書き込み | L0 | 完全可逆 |
| Writer のドラフト確認 | L1 | Editor+Critic で検証される |
| Editor の推敲結果確認 | L1 | 目視確認で十分 |
| Critic の verdict 確認 | L1 | FAIL 時のみ介入 |
| 公開（Publish） | L3 | 不可逆・外部影響大 |

#### 外部記憶

```
AI_ORG/
  MANIFEST.md
  Agents/
    writer.md
    editor.md
    critic.md
    publisher.md
  Workflows/
    content-pipeline.md
  Docs/
    style-guide.md       # スタイルガイド（トーン・表記ルール）
  Vault/
    index.md
    tag-taxonomy.md
    published/           # 公開済みコンテンツのアーカイブ
    drafts/              # 未公開ドラフト
  Scratch/
    WORKFLOW_SCRATCH_[content-title].md
```

**タグ統制語彙（初期案）:**
- `content/blog` -- ブログ記事
- `content/social` -- SNS投稿
- `content/newsletter` -- ニュースレター
- `content/whitepaper` -- ホワイトペーパー
- `topic/[subject]` -- 記事のトピック

---

### Preset E: Full（多目的・大規模）

**用途:** リサーチ・開発・コンテンツ制作を横断する多目的組織、または単一領域でも8体以上のエージェントが必要な大規模運用。

**エージェント構成:**

| 名前 | 役割 |
|---|---|
| Librarian（司書） | Vault 内の既存ノート検索・カバレッジ報告 |
| Investigator（調査員） | 外部情報の収集・信頼性評価 |
| Analyst（分析官） | 情報の統合・構造化・洞察抽出 |
| Critic（査読官） | 品質検証・バイアスチェック |
| Scribe（書記官・任意追加） | 整形・保存・記帳。初期は Orchestrator が担当し、保存処理が増えたら分離 |
| Curator（学芸員） | Vault 全体の健全性維持 |
| + 用途に応じた追加エージェント | Developer / Writer / Architect 等 |

**ワークフロー構成:** 複数本（主要タスクごとに1本 + 複雑度ルーターで dispatch 切り替え）

**品質ゲート:** standard tier（Phase 2 以降で reinforced に拡張）

#### MANIFEST 記入例

```markdown
# KnowledgeHub MANIFEST

## 存在意義
個人の知識資産を構造化・圧縮し、再利用可能な形で蓄積する知識管理組織。調査・分析・制作の全工程を品質基準に基づいて遂行する。

## コアロジック
1. ユーザーの要求を受け取り、意図を特定する（調査? 分析? 制作?）
2. タスクの性質に応じて適切なワークフローとエージェント構成を選定する
3. 品質ゲートを通過した成果物を Vault に蓄積し、知識資産として管理する

## エージェント一覧
| 名前 | 役割（1文） | 定義ファイルパス |
|---|---|---|
| Librarian | Vault 内の既存ノート検索・カバレッジ報告 | Agents/librarian.md |
| Investigator | 外部情報源から事実を収集し、信頼性を評価する | Agents/investigator.md |
| Analyst | 収集された情報を統合・構造化し、洞察を抽出する | Agents/analyst.md |
| Critic | 成果物の品質検証・バイアスチェック | Agents/critic.md |
| Scribe（任意） | 成果物の整形・Frontmatter 付与・Vault への保存 | Agents/scribe.md |
| Curator | Vault 全体の健全性維持（タグ揺れ・リンク切れ・放置ノート検出） | Agents/curator.md |

## ワークフロー一覧
| 名前 | トリガー | 用途（1文） |
|---|---|---|
| StandardResearch | 「〜を調べて」 | 調査→分析→査読→保存の標準調査フロー |
| QuickLookup | 「〜はどうなってる?」 | Vault 内検索のみの軽量クエリ |
| WeeklyMaintenance | 週次（曜日固定） | Vault の健全性チェック・prune・メトリクス集計 |

## 指示の優先順位
1. 現在のユーザー明示指示・安全指示
2. MANIFEST（本ファイル）
3. Orchestrator 定義
4. Runtime/CONTEXT_INDEX.md
5. 該当 Workflow 定義
6. 該当 Agent 定義
7. 参考設計書・導入ガイド

安全/法令/機密ルールに反する指示は実行しない。競合時は Orchestrator が確認する。
```

#### Full の注意事項

Full プリセットは Phase 0-1 のスコープを超える要素を含む。以下の順序で段階的に構築すること。

**Phase 0-1 で構築するもの:**
- MANIFEST
- 外部記憶（Vault ディレクトリ構造 + メタデータスキーマ + タグ統制語彙）
- エージェント定義 5体（Librarian, Investigator, Analyst, Critic, Curator）。Scribe は保存・整形を分離したくなった時点で追加
- ワークフロー 1本（StandardResearch の Standard 構成のみ）
- 品質ゲート standard tier
- 介入レベル初期版（全アクション L2）

**Phase 2 以降で追加するもの:**
- 追加ワークフロー（QuickLookup, WeeklyMaintenance）
- 並列実行パターン（StandardResearch の Full 構成）
- 介入レベルの動的委譲
- ADR 運用
- 複利ループ計測
- Adversarial Deliberation

#### 介入レベル初期割り当て

| アクション | 介入レベル | 根拠 |
|---|---|---|
| Scratch への中間結果書き込み | L0 | 完全可逆 |
| Librarian の検索結果 | L1 | 低リスク |
| Investigator / Analyst への dispatch | L2 | 初期は全 dispatch を確認 |
| Critic の verdict 確認 | L1 | FAIL 時のみ介入 |
| Vault へのノート保存 | L2 | 初期は全保存を確認 |
| ノートの permanent 昇格 | L2 | 不可逆に近い |
| Vault のディレクトリ構造変更 | L3 | 組織全体に影響 |
| MANIFEST の更新 | L3 | 不可逆に近い |

#### 外部記憶

```
AI_ORG/
  MANIFEST.md
  Agents/
    librarian.md
    investigator.md
    analyst.md
    critic.md
    scribe.md              # 任意追加
    curator.md
  Workflows/
    standard-research.md
    quick-lookup.md        # Phase 2 で追加
    weekly-maintenance.md  # Phase 3 で追加
  Vault/
    index.md
    tag-taxonomy.md
    reference/             # 参照ノート
    report/                # 調査レポート
    digest/                # 要約・ダイジェスト
    permanent/             # 永続知識資産
    archive/               # アーカイブ済み
  Decisions/               # ADR（Phase 3 で追加）
  Reports/
    dispatch-trace.md      # 実行トレース（Phase 3 で追加）
  Scratch/
    WORKFLOW_SCRATCH_[topic].md
```

---

## Step 3: カスタマイズ

プリセットを土台に、以下の観点でカスタマイズする。

### 3.1 エージェントの調整

#### 追加すべき場合

- 既存エージェントの役割が広すぎて「何でも屋」になっている兆候がある
  - **兆候:** 1体のエージェントの Role が「A して B して C する」と3つ以上の動詞を含む
  - **対処:** 役割を分割し、各エージェントの Role を1文にする
- 特定の専門性が必要なタスクが出現した
  - **例:** Research プリセットにコード分析が必要になった → Developer を追加

#### 削除すべき場合

- エージェントが常にスキップされている
  - **兆候:** ワークフロー実行時に毎回 Simple 構成に降格し、当該エージェントが呼ばれない
  - **対処:** ワークフローから当該フェーズを削除し、エージェント定義をアーカイブ

#### やりすぎの境界

- Phase 0-1 でエージェントを5体以上定義するのは Minimal / Research / Development / Content プリセットでは過剰
- 「将来使うかもしれない」エージェントは定義しない。使う時に作る

### 3.2 ワークフローの調整

#### フェーズの追加

- 品質要求が高い場合、査読フェーズを前段に移動して「早期チェック」を追加できる
  - **例:** Developer の実装前に Architect の設計を Reviewer がチェック

#### フェーズの削除

- 品質要求が低い場合、Editor フェーズを省略して Writer → Critic の2フェーズにできる
- 外部調査が不要な場合、Investigator フェーズをスキップして Librarian → Analyst にできる

#### 複雑度ルーターのカスタマイズ

- Simple / Standard / Full の判定条件は組織の実態に合わせて調整する
- **記入例:** Research プリセットの Standard ↔ Full の境界を「独立した調査軸3つ以上」から「2つ以上」に変更する

### 3.3 品質ゲートの調整

| 調整 | Phase 0-1 でやるか | 備考 |
|---|---|---|
| Critic の Output Contract を自組織用にカスタマイズ | する | verdict + GSAR + devil's advocate は維持 |
| reinforced tier（Critic 2体）の導入 | **しない** | Phase 2 以降 |
| maximum tier（メタ Critic）の導入 | **しない** | Phase 4 以降 |
| 品質ゲートのスキップ | **しない** | standard tier の Critic は最低限 |

### 3.4 介入レベルの調整

Phase 0-1 は「全アクション Level 2」から始めて実績を積む。降格の手順:

1. 3回連続で問題なく完了したアクションを Level 2 → Level 1 に降格候補にする
2. 人間が明示的に降格を承認する
3. Level 1 で5回連続成功したら Level 0 への降格を検討する

**降格してはいけないもの（Phase を問わず L2 以上を維持）:**
- MANIFEST の更新
- Vault のディレクトリ構造変更
- ノートの permanent 昇格
- 外部への情報送信

### 3.5 外部記憶の調整

- Q6 で「セッション内で完結」と答えた場合、Vault 構造は不要。Scratch のみで運用する。
- タグ統制語彙は5-10個から始める。使いながら追加する。初期に完璧な語彙を作ろうとしない。
- INDEX のフォーマットは設計書 v2.0 セクション8.1『INDEX 破損 > INDEX のフォーマット仕様』に従う。

---

## 付録: 設計書 v2.0 のセクション対応表

本手順書の各要素が設計書 v2.0 のどのセクションに対応するかの参照表。

| 本手順書の要素 | 設計書 v2.0 の対応セクション |
|---|---|
| MANIFEST | セクション 1: 組織憲法 |
| 外部記憶（Vault 構造・メタデータ・タグ） | セクション 2: 外部記憶設計 |
| エージェント定義・Input/Output Contract | セクション 3: エージェント定義と情報伝達 |
| ワークフロー定義・複雑度ルーター・Scratch | セクション 4: ワークフロー定義 |
| 並列パターン（Phase 2 以降） | セクション 5: 並列実行設計 |
| 介入レベル | セクション 6: 人間のアテンション設計 |
| 品質ゲート・GSAR・devil's advocate | セクション 7: 品質ゲート設計 |
| 障害回復（Phase 3 以降） | セクション 8: 障害回復設計 |
| ADR（Phase 3 以降） | セクション 9: ADR |
| 記憶管理・prune・promote（Phase 3 以降） | セクション 10: 記憶管理 |
| 複利ループ（Phase 4 以降） | セクション 11: 複利ループ設計 |
| Adversarial Deliberation（Phase 4 以降） | セクション 12: Adversarial Deliberation Protocol |

## 付録: 9つの本質的問いとプリセットの対応

設計書 v2.0 が定義する9つの本質的問いに対して、各プリセットがどう回答するかの一覧。

| # | 問い | Minimal | Research | Development | Content | Full |
|---|---|---|---|---|---|---|
| 1 | 誰が何をし、何をしないか | Worker + Critic の2体制 | 5体の専門分化 | 4体の開発工程分化 | 4体の制作工程分化 | 6体+ の多目的構成 |
| 2 | どう伝えるか | Scratch 1ファイル | Scratch + Vault | Scratch + Docs | Scratch + Docs + Vault | Scratch + Vault + Docs |
| 3 | 良いかどうか誰が判断するか | Critic 1体 | Critic 1体 | Reviewer 1体 | Critic 1体 | Critic 1体（Phase 2+ で reinforced） |
| 4 | 何を決め、なぜそうしたか | Phase 3 で ADR 導入 | Phase 3 で ADR 導入 | Phase 3 で ADR 導入 | Phase 3 で ADR 導入 | Phase 3 で ADR 導入 |
| 5 | 記憶は信頼できるか | Scratch のみ | Vault + INDEX | Docs 2文書 | Vault + INDEX | Vault + INDEX + Docs |
| 6 | いつ・誰が・どの基準で止めるか | ループ最大2回 | ループ最大2回 | ループ最大2回 | ループ最大2回 | ループ最大2回 |
| 7 | 回すほど賢くなるか | Phase 4 で計測開始 | Phase 4 で計測開始 | Phase 4 で計測開始 | Phase 4 で計測開始 | Phase 4 で計測開始 |
| 8 | 並列性をどう活かすか | 不要 | Phase 2 で導入 | Phase 2 で導入 | Phase 2 で導入 | Phase 2 で導入 |
| 9 | 人間がボトルネックにならないか | 初期は L2 寄り（定型操作 L0-L1 / 判断系 L2） | 初期は L2 寄り（定型操作 L0-L1 / 判断系 L2） | 初期は L2 寄り（定型操作 L0-L1 / 判断系 L2） | 初期は L2 寄り（定型操作 L0-L1 / 判断系 L2） | 初期は L2 寄り（定型操作 L0-L1 / 判断系 L2） |

## 付録: 構築チェックリスト

プリセット選定後、以下の順序で構築する。

### Phase 0: 基盤

- [ ] MANIFEST.md を作成した（存在意義・コアロジック・エージェント一覧・ワークフロー一覧・指示優先順位）
- [ ] ディレクトリ構造を作成した
- [ ] メタデータスキーマを定義した（frontmatter の正本）
- [ ] タグ統制語彙を定義した（5-10個から開始）
- [ ] MANIFEST テスト: 新規エージェントに MANIFEST のみ渡し、組織の目的を正しく説明できることを確認した（3回中2回 PASS）

### Phase 1: 最小運用

- [ ] エージェント定義ファイルを作成した（各エージェントに Role / Input Contract / Output Contract / 役割境界）
- [ ] ワークフロー定義ファイルを作成した（1本目）
- [ ] 品質ゲートを定義した（Critic の Output Contract: verdict + GSAR + devil's advocate）
- [ ] 介入レベル割り当て表を作成した（全アクション L2 から開始）
- [ ] ワークフローを3回通しで実行し、品質ゲートが毎回機能することを確認した

### Phase 0-1 完了の判定基準

以下の全てを満たすとき、Phase 0-1 は完了。

1. MANIFEST テストに合格している
2. ワークフローが3回連続で品質ゲートを通過している
3. 全エージェントの Input/Output Contract が実運用で機能している（契約違反による差し戻しが仕組みとして動いている）
4. 介入レベル L2 で人間が全アクションを確認し、品質に問題がないことを確認している

**次のステップ:** Phase 0-1 が安定したら、設計書 v2.0 の「付録: 構築ロードマップ」の Phase 2 に進む。

---

## 付録: OrgDesign ワークフローとの関係

本手順書はユーザーが自力で組織を構築する場合のガイドである。AI エージェントに組織設計を支援させる場合は、`OrgDesign` ワークフロー（`Workflows/OrgDesign.md`）を使用する。

- **OrgDesign ワークフローの Phase 0（協調的要件定義）** が本手順書の Step 1 に対応する
- **OrgDesign ワークフローの Phase 1（組織設計）** が本手順書の Step 2 + Step 3 に対応する
- **OrgDesign エージェント（`Agents/org_designer.md`）** は本手順書のプリセット定義と同一の5プリセット（Minimal / Research / Development / Content / Full）を使用する

OrgDesign ワークフローでは OrgDesigner が対話的に要件をヒアリングし、プリセット推奨とカスタマイズ支援を行う。本手順書はその対話の背景知識として参照される。

---

*本手順書は設計書 v2.0 に基づいて作成された導入ガイドであり、設計書本体の用語・構造を参照している。設計書 v2.0 の変更時は本手順書の整合性も確認すること。*

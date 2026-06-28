# Agent Org Theoretical Maximum

このファイルは、AIエージェント組織を「限りなく理論値」に近づけるための判断軸である。
ここでいう理論値は、エージェント数を増やすことではない。
目的、判断、作業、検証、記憶、改善を、必要最小限の文脈で正しく回し続けることを指す。

## Core Definition

理論値に近い AI 組織は、次の性質を持つ。

- ユーザーの意図を Orchestrator が安定して受け止める。
- 目的、制約、完了条件、情報管理が `MANIFEST.md` に固定されている。
- 生成役と検証役が分離され、成果物の弱点が返答前に見つかる。
- 通常起動では読む文脈が軽く、必要時だけ深い設計書を読む。
- 日々の摩擦が `Runtime/OBSERVATIONS.md` や `Runtime/HEALTH.md` に残り、次の改善に接続される。
- 保存してよい情報と保存してはいけない情報が分かれている。
- 仕組みを増やす判断が、便利さではなく反復・失敗・再利用価値に基づく。

## Theoretical Axes

| Axis | 理論値に近い状態 | 失敗サイン |
|---|---|---|
| Purpose | 迷った判断が存在意義に戻れる | タスクごとに目的がぶれる |
| Ingress | ユーザー窓口が Orchestrator に集約される | 内部 Agent が直接ユーザー対応する |
| Context | 通常起動が軽く、深い文脈は遅延ロードされる | 毎回すべての設計書を読む |
| Roles | 役割が入力・出力・完了条件で分かれる | Worker が調査、生成、検証、保存を全部持つ |
| Quality | Critic が用途別の観点で検証する | PASS 後の手戻りが多い |
| Memory | Scratch、Reports、Vault が用途別に分かれる | すべてをログ化する、または何も残らない |
| Improvement | 反復する摩擦が改善提案に変わる | 同じ説明、同じミス、同じ確認が続く |
| Safety | 不可逆操作と機密保存に承認線がある | 便利さで保存・公開・削除が曖昧になる |
| Observability | 組織の状態を短く診断できる | うまく動いているか主観でしか分からない |

## Maturity Ladder

### L0: Bootstrap

- `AI_ORG/` が存在する。
- `MANIFEST.md`、`orchestrator.md`、`Runtime/BOOT.md` がある。
- Worker / Critic / Execute が存在する。

Goal:
- まず動く。

### L1: Reliable Minimal

- 情報管理ルールがある。
- Deliberation Gate が重要応答に使われる。
- 改善サインを `Runtime/OBSERVATIONS.md` に残せる。

Goal:
- 日常業務で壊れずに使える。

### L2: Crystallized Workflow

- 3回以上繰り返した手順が `Workflows/` に切り出されている。
- Agent の役割が広すぎる場合に分割されている。
- Critic の観点が用途別に明確になっている。

Goal:
- 同じ仕事を前より少ない説明で回せる。

### L3: Memory and Evals

- 保存許可済みの長期知識だけが `Vault/` に入る。
- `Runtime/HEALTH.md` で組織の摩擦、再利用、手戻りを観測する。
- `Reports/health-check.md` で周期的な診断を残せる。

Goal:
- 経験が次の判断に反映される。

### L4: Governed Autonomy

- 承認レベル、公開ルール、外部送信ルールが明確。
- 重要な構造変更は ADR と外部レビューで検証される。
- 人間の確認負荷と AI の自律範囲が継続的に調整される。

Goal:
- 任せられる範囲が広がっても危険にならない。

### L5: Compound Organization

- 複数の Workflow、Agent、Vault、Review が相互に学習する。
- 組織の改善が、作業後の小さな提案として自然に返る。
- 重い設計レビューは必要時だけ起動される。

Goal:
- ユーザーと Orchestrator が、仕事環境そのものを一緒に育て続ける。

## Activation Rules

理論値に近づける機能は、最初から全部入れない。
以下の条件を満たすときだけ有効化する。

| Add | Trigger |
|---|---|
| New Agent | 同じ専門作業が3回以上出た、または既存 Agent の役割が広すぎる |
| New Workflow | 同じ手順、入力、完了条件が3回以上出た |
| Vault | 保存許可済みで、再利用価値がある知識が増えた |
| ADR | 構造変更が複数ファイルに及ぶ、または撤回コストが高い |
| Health Check | 手戻り、確認過多、重い起動、品質ばらつきが見えた |
| External Review | MANIFEST 更新、Agent/Workflow 追加、公開前の重要成果物 |
| Parallel / Sub-org | 単一 Orchestrator の文脈・責務が明確に限界を超えた |

## Anti-goals

- 理論値を理由に初期セットアップを重くしない。
- 使われていない Agent を増やさない。
- すべてを記録しない。
- すべてをレビューしない。
- 内部思考の詳細を外に出さない。
- ユーザー承認なしに保存、公開、削除、外部送信をしない。

## Practical Rule

迷ったら、次の順で判断する。

1. いまの作業は壊れているか。
2. 同じ摩擦が繰り返されているか。
3. 仕組みにすると次回の文脈量が減るか。
4. 仕組みを増やしても安全・情報管理が崩れないか。
5. ユーザーの作業体験が軽くなるか。

5つのうち3つ以上が yes なら改善候補にする。
それ以外は `Runtime/OBSERVATIONS.md` に観測だけ残し、まだ構造変更しない。

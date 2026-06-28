# Runtime HEALTH

このファイルは、AI_ORG の健康診断メモである。
通常タスクでは読まない。
ユーザーが組織改善を求めたとき、または `settings.health_check` が `periodic` のときだけ使う。

## Settings

```yaml
health_check: manual # off | manual | periodic
last_reviewed: null
```

- `off`: 健康診断を自動提案しない。
- `manual`: ユーザーが求めたとき、または明確な改善サインがあるときだけ見る。既定値。
- `periodic`: 事前に決めた頻度で、短い健康診断を行う。

## Health Axes

| Axis | OK | Watch |
|---|---|---|
| Purpose | 判断が `MANIFEST.md` に戻れる | 目的説明が毎回ぶれる |
| Context | 通常起動で読むファイルが少ない | 毎回参考設計書まで読んでいる |
| Roles | Worker / Critic の責務が分かれている | 1役が調査、生成、検証、保存を持ちすぎる |
| Quality | Critic の指摘が具体的 | PASS 後の手戻りが多い |
| Memory | Scratch / Reports / Vault が使い分けられる | すべて残す、または何も残らない |
| Safety | 承認線と情報管理が明確 | 保存、削除、公開の判断が曖昧 |
| Improvement | 摩擦が提案に変わる | 同じミスや確認が続く |

## Recent Signals

| Date | Signal | Axis | Count | Action |
|---|---|---|---|---|
| [例: 2026-01-01] | [同じ確認が繰り返された] | Safety | 3 | [MANIFEST更新を提案] |

例行は実運用ルールではない。運用開始時に削除または実例に置き換える。

## Health Check Notes

```markdown
### YYYY-MM-DD

Scope:

Signals:
- 

Recommendation:
- 

Decision:
- 
```

## Promotion Rules

- 同じ Signal が2回出たら、`Runtime/OBSERVATIONS.md` に抽象化して残す。
- 同じ Signal が3回以上出たら、改善提案を検討する。
- 役割追加、Workflow 追加、Vault 有効化、ADR 記録はユーザー承認後に行う。
- 機密情報、作業本文、個人情報、認証情報はこのファイルに残さない。

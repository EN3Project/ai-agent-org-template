# Health Check Report

このファイルは dormant placeholder である。
通常運用では使わない。
ユーザーが組織診断を求めた場合、または `Runtime/HEALTH.md` で周期診断が有効化された場合だけ使う。

## Report Template

```markdown
## YYYY-MM-DD Health Check

### Scope
[今回診断した範囲]

### Inputs
- `MANIFEST.md`
- `orchestrator.md`
- `Runtime/CONTEXT_INDEX.md`
- `Runtime/OBSERVATIONS.md`
- `Runtime/HEALTH.md`

### Findings
| Axis | Status | Finding |
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

## Logging Rules

- 作業本文や機密情報は残さない。
- 個別ユーザーの人格評価やプロファイルを残さない。
- 改善提案は最大3件に絞る。
- 構造変更はユーザー承認後に実施する。

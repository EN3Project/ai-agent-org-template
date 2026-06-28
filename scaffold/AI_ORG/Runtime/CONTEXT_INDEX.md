# Runtime CONTEXT INDEX

## Template Source

この AI_ORG を作成した元テンプレート、参考設計書、補助資料の場所を書く。

```text
[template path]
```

## `[template]` 置換ルール

- 上のコードブロックが空、または `[template path]` のままなら、template source は未設定とみなす。
- 未設定の場合、`[template]/...` で始まる Additional Read は読まない。通常運用は scaffold 内のファイルだけで続行する。
- 参考設計書が必要な依頼で template source が未設定なら、Orchestrator はユーザーに場所を確認する。
- 設定済みの場合、各 `[template]/...` の先頭 `[template]` を template source の値に置き換える。
- template source の末尾に `/` または `\` がある場合は、区切り文字を重複させない。
- 置換後のファイルが存在しない場合は、推測で別ファイルを読まず「参照不可」として扱う。
- 参考設計書は優先順位の最下位であり、`MANIFEST.md` や現在のユーザー指示を上書きしない。

## Mode Router

### Normal Operation

Trigger:

- 通常作業
- 調査、作成、整理、レビュー、実装、修正

Read:

- `MANIFEST.md`
- `orchestrator.md`
- `Workflows/execute.md`
- `Agents/worker.md`
- `Agents/critic.md`

### Organization Improvement

Trigger:

- 組織改善
- エージェント追加、削除、分割
- ワークフロー追加、変更
- 品質ゲート改善
- 失敗パターンの構造的改善

Additional Read:

- `[template]/continuous-improvement.md`
- `[template]/OrgDesign.md`
- `[template]/org_designer.md`
- `[template]/ai-agent-org-onboarding-guide.md`

### Org Health Check

Trigger:

- 組織の健康診断
- 理論値への磨き込み
- 同じ摩擦、手戻り、確認過多が繰り返されている
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

- `MANIFEST.md` の大改訂
- サブ組織化
- 並列化
- ADR
- 複利ループ
- Adversarial Deliberation

Additional Read:

- `[template]/ai-agent-org-construction-template.md`

## Improvement Signals

Orchestrator は以下を観測したら、`Runtime/OBSERVATIONS.md` に抽象化して短く記録し、改善提案を検討する。
提案頻度は `MANIFEST.md` の `settings.improvement_suggestions` に従う。未設定時は `end_of_task` とみなす。

- 同じ手順が 3 回以上繰り返された。
- 同じミスが 2 回以上起きた。
- Worker の役割が広すぎる。
- Critic の指摘が同じカテゴリに偏る。
- Scratch を後から参照する場面が増えた。
- 保存、整形、索引更新が毎回発生している。
- 通常運用で毎回同じファイルを読んでいる。
- ユーザー確認が多すぎて作業が止まっている。

改善提案は `観測 / 問題 / 提案 / 影響 / 判断` の形で短く出す。

## Health Signals

Orchestrator は以下を観測したら、`settings.health_check` に従って `Runtime/HEALTH.md` の確認を検討する。

- 通常起動で読むファイルが増え続けている。
- Agent の役割境界が曖昧になっている。
- Critic の PASS 後に手戻りが多い。
- Scratch、Reports、Vault の使い分けが曖昧になっている。
- ユーザー承認の線引きが毎回揺れている。
- 改善提案が複数回保留され、構造負債になっている。

## Dormant Areas

- `Reports/`: 実行記録が必要になったら使う。初期運用では必須ではない。
- `Decisions/`: 構造変更や重要判断が必要になったら使う。ADR は append-only。
- `Vault/`: 保存許可、タグ、保持期間が明確になったら使う。初期状態では無効扱い。

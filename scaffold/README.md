# Scaffold

このディレクトリは、AI エージェント組織を新しいプロジェクトへ導入するときにコピーする初期テンプレートである。
LLM は初回セットアップ時、ユーザーの明示承認後に `scaffold/AI_ORG/` を目的の場所へコピーし、`MANIFEST.md` と Runtime ファイルのプレースホルダを用途に合わせて埋める。

## 方針

- 最初は小さく始める。通常運用に必要な最小ファイルだけを読む。
- 指示の優先順位は全ファイルで統一する: `現在のユーザー明示指示・安全指示 > MANIFEST > Orchestrator > Runtime/Context Index > Workflows > Agents > 参考設計書`。
- 安全、法令、機密管理に反するユーザー指示は実行しない。
- 読み取り、一時 Scratch 記録、要約保存、ログ化、外部送信/公開を分けて扱う。
- 既定では機密情報を `Scratch/`、`Reports/`、`Vault/` に残さない。必要な場合は、保存範囲と期間についてユーザーの明示承認を得る。
- `Reports/`、`Decisions/`、`Vault/` は dormant placeholder であり、必要になるまで初期運用コストを増やさない。
- 通常起動では `Runtime/BOOT.md` から入り、テンプレート本体や参考設計書は必要時だけ読む。
- 組織の健康診断は `Runtime/HEALTH.md` で扱い、通常タスクでは読まない。
- ユーザーとの窓口は常に Orchestrator に集約する。

## プレースホルダ

- `[用途を書く]`: この AI_ORG を何のために使うかを書く。
- `[template path]`: 参考設計書や元テンプレートの場所。未設定のままでも通常運用できる。
- `[template]/...`: `Runtime/CONTEXT_INDEX.md` だけで使う参照表現。`[template path]` が設定されている場合だけ置換して読む。

## 構成

```text
AI_ORG/
  MANIFEST.md
  orchestrator.md
  Agents/
    worker.md
    critic.md
  Workflows/
    execute.md
  Runtime/
    BOOT.md
    CONTEXT_INDEX.md
    OBSERVATIONS.md
    HEALTH.md
  Scratch/
    README.md
  Reports/
    dispatch-trace.md
    health-check.md
  Decisions/
    ADR-template.md
  Vault/
    README.md
```

## 運用上の注意

`Reports`、`Decisions`、`Vault` は「あったほうがよい置き場」であり、初日から必ず運用する義務ではない。
特に `Vault` は長期保存領域なので、保存してよい情報、タグ、保持期間、削除条件を決めるまで無効扱いにする。

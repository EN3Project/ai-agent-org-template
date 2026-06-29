# Data Policy

このファイルは、AI_ORG を仕事PCや実プロジェクトに入れる前に決める情報管理ルールの最小基準である。
各 `AI_ORG/MANIFEST.md` の情報管理ルールが最終的な運用ルールになる。

## Default Stance

- 読む情報は依頼達成に必要な範囲に限定する。
- 既定では、機密情報、個人情報、顧客情報、認証情報、契約情報、社外秘資料を `Scratch/`、`Reports/`、`Vault/` に残さない。
- 保存が必要な場合は、保存先、保存期間、削除条件、匿名化の有無をユーザーが明示する。
- 外部送信、公開、push、deploy、第三者共有は明示承認がある場合だけ行う。

## Storage Areas

| Area | Use | Default |
|---|---|---|
| `Scratch/` | 進行中タスクの一時作業状態 | 機密を残さない |
| `Runtime/OBSERVATIONS.md` | 抽象化した改善サイン | 原文や固有名詞を残さない |
| `Reports/` | 必要時の高レベル実行記録 | dormant placeholder |
| `Decisions/` | 構造変更や重要判断 | 小さな変更では使わない |
| `Vault/` | 再利用する長期知識 | 保存許可が明確になるまで無効 |

## Git Tracking Policy

生成された `AI_ORG/` を既存リポジトリに置く場合、初期状態では runtime state を Git 管理しない。
`scaffold/AI_ORG/.gitignore` は `Scratch/`、`Reports/`、`Vault/` の中身を無視し、ディレクトリ説明やテンプレートだけを残す。

`Runtime/OBSERVATIONS.md` は、原文や固有名詞を含まない抽象化した改善サインだけを書く前提で Git 管理してよい。
ただし、プロジェクトの情報管理ルールが厳しい場合は、各 `AI_ORG/MANIFEST.md` で保存可否を明示する。

## Approval Required

- 既存ファイルの破壊的変更
- 削除
- カレントディレクトリ外への書き込み
- 外部送信、公開、push、deploy
- 機密情報を含む可能性がある内容の永続保存
- 依存関係追加、ライセンス影響、本番環境に影響する操作

## Redaction Examples

Bad:

```text
顧客A社の契約番号 XXX-123 と担当者名を Scratch に保存した。
```

Good:

```text
契約関連の固有情報を含むため、作業メモは保存しない。改善サインのみ記録する。
```

Bad:

```text
API_KEY=... をテストログとして Reports に残す。
```

Good:

```text
認証情報が必要な検証は未実行。ユーザー承認と安全な実行環境が必要。
```

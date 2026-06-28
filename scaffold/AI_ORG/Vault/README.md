# Vault

Vault は、後から再利用する長期知識の保存場所である。
初期状態では無効扱いにする。必要になるまで運用コストを増やさない。

## Default

Vault は dormant placeholder である。
ユーザーが保存してよい情報を明示し、Orchestrator が `MANIFEST.md` に保存ルールを反映してから使う。

## 有効化条件

Vault を使う前に、少なくとも以下を決める。

1. 保存してよい情報の種類
2. 保存してはいけない情報の種類
3. index の形式
4. tag taxonomy
5. retention 方針
6. レビュー日と削除条件

## Store

- 再利用価値が高い一般化済みの知見
- 何度も使う手順
- 公開可能、または保存許可済みの成果物要約
- ユーザーが明示的に残したいと言った情報

## Do Not Store

- 認証情報
- 個人情報
- 顧客情報
- 社外秘や契約上保存できない情報
- 一時的な作業本文
- 保存許可が曖昧な情報

## Index 方針

有効化する場合は、`Vault/index.md` などに軽い索引を作る。

推奨項目:

| Field | Meaning |
|---|---|
| id | 一意な識別子 |
| title | 短い名前 |
| tags | 検索用タグ |
| source_task | 由来タスク。機密を含まない要約にする |
| created | 作成日 |
| sensitivity | `public`, `internal-approved`, `sanitized` |
| retention | `short`, `seasonal`, `long` |
| review_date | 見直し日 |

## Tag Taxonomy

最初は軽く始める。増やしすぎない。

- `domain/[name]`
- `workflow/[name]`
- `agent/[name]`
- `decision/[topic]`
- `artifact/[type]`
- `risk/[type]`
- `status/[active|deprecated]`

## Retention 方針

- `short`: 近い将来だけ使う。タスク完了後または 30 日以内に見直す。
- `seasonal`: 数か月単位で再利用する。90 日程度で見直す。
- `long`: 継続的に使う基本知識。半年ごとに見直す。

保持期限を過ぎたもの、出所や保存許可が不明なもの、機密の疑いがあるものは削除または匿名化を検討する。

## Promotion Rule

`Scratch/` から `Vault/` に昇格する前に、Orchestrator は以下を確認する。

1. 後から再利用する価値があるか。
2. 保存してよい情報か。
3. 要約や匿名化で十分か。
4. どのタグで検索できるようにするか。
5. retention と review date は何か。
6. ユーザーの明示承認があるか。

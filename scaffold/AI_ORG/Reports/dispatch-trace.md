# Dispatch Trace

このファイルは、Orchestrator がどのように依頼を処理したかを高レベルで残すための dormant placeholder である。
初期運用で毎回記録する必要はない。反復改善や軽い監査に役立つ場合だけ使う。

## Rules

- 詳細な内部思考過程を書かない。
- 機密情報、個人情報、顧客情報、認証情報、作業本文をそのまま残さない。
- 何を読み、どの Workflow / Agent を使い、どう終わったかだけを短く書く。
- 将来の複利ループに使えるよう、所要時間、手戻り回数、判定、改善シグナルを軽く残す。

## Log

| Date | Request Summary | Workflow | Agents | duration_sec | rework_count | verdict | improvement_signal | Notes |
|---|---|---|---|---:|---:|---|---|---|

<!--
TEMPLATE ROW: 使用時はこのコメント内の例をコピーし、角括弧を実値に置き換える。実データに見えないよう、このコメントブロック自体はログとして数えない。
| YYYY-MM-DD | [機密を含まない短い要約] | execute | Worker, Critic | [seconds] | [count] | PASS | [none or short signal] | [短い補足] |
-->

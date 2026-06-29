# Daily Use Minimal Kit

CLI 環境の仕事PCで、このテンプレートを軽く試すための最小キットです。

セットアップ手順、プレースホルダの扱い、完了条件は `README.md` を参照してください。

## 1日の使い方

1. 作業前に、依頼内容と保存ルールを短く確認する
2. 必要なら `Scratch/YYYY-MM-DD-task-name.md` に作業状態を残す
3. Worker -> Critic -> Orchestrator final の順に回す
4. 改善サインだけ `Runtime/OBSERVATIONS.md` に短く残す
5. 同じ摩擦が繰り返されたら `Runtime/HEALTH.md` で短く診断する
6. 後から使い回せる知見が3回以上出てから、Vault 化を検討する

## 最初の実タスク例

```text
今日の議事メモを、社外共有用の短い要約にしてください。
保存してよい情報は公開済みの議題だけです。
顧客名と個人名は残さないでください。
```

## 拡張してよいサイン

- 同じ種類のタスクを3回以上回した
- Worker が毎回似たミスをする
- Critic の指摘が毎回同じカテゴリに偏る
- Scratch に残した内容を後から参照したくなる
- 手順を人に渡したくなる

この状態になってから、`ai-agent-org-onboarding-guide.md` の Research / Development / Content プリセットに進むのがよいです。

## まだ入れなくてよいもの

- 並列実行
- reinforced / maximum tier
- ADR
- 複利ループ
- Adversarial Deliberation
- サブ組織
- 本格 Vault 運用

これらは強力ですが、最初から入れると運用が重くなります。まずは Worker + Critic + Scratch の最小構成を安定させます。

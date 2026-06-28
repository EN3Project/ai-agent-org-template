# Presets

Presets are optional overlays applied after copying `scaffold/AI_ORG/`.

Available preset:

| Preset | Use | Path |
|---|---|---|
| Development | AI-driven software development with Architect, Developer, Tester, Reviewer, and DevCycle | `presets/development/` |

Initialize with:

```bash
bash scripts/init-ai-org.sh --preset development --destination ./AI_ORG --purpose "既存コードベースの開発補助"
```

or:

```powershell
.\scripts\init-ai-org.ps1 -Preset development -Destination .\AI_ORG -Purpose "既存コードベースの開発補助"
```

Research and Content presets are currently described in `ai-agent-org-onboarding-guide.md` and can be materialized later when repeated use justifies them.

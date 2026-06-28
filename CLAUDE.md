# CLAUDE.md

You are an AI Agent Org **BUILDER** for this template factory.

This directory is a TEMPLATE FACTORY that creates AI agent organizations.
It is NOT itself a running organization. Do not behave as an org instance here.
Your job is to construct one or more new `AI_ORG/` instances from `scaffold/AI_ORG/`.

## Startup

1. Read `START_HERE.md`. It is your construction bootstrap.
2. Read `README.md` only if you need the human-facing overview.
3. Follow the Setup Mode Router in `START_HERE.md` (Minimal / Full).

## Build behavior

- Ask the user the construction questions: purpose, where to create the org, Minimal vs Full, and what info may/may not be stored.
- Copy `scaffold/AI_ORG/` to the user-specified destination as the new org's base.
- Fill the new org's `MANIFEST.md` placeholder `[用途を書く]` with the agreed purpose. Keep this factory's scaffold placeholders unchanged.
- You may build multiple orgs into multiple destinations from this single factory.
- Reference design docs (`ai-agent-org-construction-template.md`, etc.) only when the user asks to design or extend an org.

## Do NOT

- Do not instantiate an `AI_ORG/` at this factory root.
- Do not edit files inside this factory (the template itself) unless the user explicitly asks to improve the template.
- Do not overwrite an existing `AI_ORG/` at the destination — stop and ask.
- No deletion, external send, publish, push/deploy, or writing outside the agreed destination without explicit approval.

## Safety / environment

- Show the copy source and destination before writing, and confirm with the user.
- On Windows PowerShell, read markdown as UTF-8 to avoid mojibake.

## Goal

Turn this one factory into as many durable, separate `AI_ORG/` instances as the user needs.

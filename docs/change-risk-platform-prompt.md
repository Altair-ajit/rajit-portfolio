# Build prompt: Change-Risk Assessment Platform (LLM-assisted ITSM change scoring)

> Paste everything below the line into your coding agent. It builds a generic, vendor-neutral
> productization of a common enterprise pattern — LLM-assisted risk scoring for IT change tickets,
> integrated with ServiceNow and other ITSM systems. Fill in the `<<PLACEHOLDER>>` tokens where you
> can; otherwise leave them and the agent stubs the seam. It must run in a self-contained demo mode
> with synthetic data and no external credentials.

---

## ⚠️ Confidentiality & scope guardrail (read first)
Build a **generic, vendor-neutral product**. Do **not** reference any specific company, client, or
engagement; do not use any real organizational data, personas, internal metrics, ticket contents, or
proprietary figures. Use **synthetic/sample data only**. This is a productization of a widely-known
pattern (LLM-assisted change-risk scoring for ITSM), not a reproduction of any client's deliverable.
If asked to import real data, refuse and use the synthetic dataset instead.

## Role & goal
Build a deployable web platform that scores the risk of IT **change requests (RFCs)**. It uses an LLM
to extract structured signals from the free-text fields of a change ticket, blends them with
historical change/incident data into a **transparent, weighted 0–100 risk score**, retrieves similar
past tickets, and flags **HIGH-RISK** changes for mandatory collaborative review. It integrates with
**ServiceNow** (and other ITSM tools) via pluggable adapters, and ships a **demo mode** that runs on
synthetic tickets with no external credentials. Production-grade, explainable, and auditable.

## Background (the generic problem this solves)
In enterprise IT change management, RFCs pass through a Change Advisory Board (CAB) and approval
groups before implementation. Risk is often captured by a **single subjective field** (e.g. "has
this change succeeded before? 1 / 3 / 5 points"), which is oversimplified, easy to game, and widely
ignored — so genuinely risky changes slip through and cause unplanned outages. The product's job is a
risk score that is **accurate, meaningful, explainable, and hard to manipulate** because it is
grounded in the ticket's actual content and in historical outcomes — not a self-reported number.

## Core features
1. **Ticket ingestion** — pull change records from ServiceNow; pluggable adapters for Jira Service
   Management and a generic CSV/JSON import; plus manual entry. **Demo mode** loads a synthetic set.
2. **LLM feature extraction** — from the raw text fields (Description, Pre-Implementation/
   implementation plan, Post-Implementation/validation plan, Backout plan, affected systems), the LLM
   returns **categorical signals**: `risk`, `impact`, `complexity` ∈ {None, Low, Medium, High,
   Extreme}; and `thoroughness_risk_impact`, `thoroughness_plans` (pre/post/backout) on the same
   scale. Categorical → numeric mapping: **None=0, Low=25, Medium=50, High=75, Extreme=100**.
3. **Historical signals** — from a change+incident history store: a **History** score (how similar
   past changes fared), **Downtime**, and **Duration**. Use vector similarity to retrieve the most
   similar prior tickets and base History on their outcomes.
4. **Weighted risk score (0–100)** — deterministic blend of the signals, with **two weighting
   profiles** chosen by whether enough similar history exists (≥ `MIN_HISTORY` similar records):

   | Component | With enough history | Without enough history |
   |---|---|---|
   | History | 30 | 10 |
   | Downtime | 5 | 5 |
   | Duration | 5 | 5 |
   | LLM thoroughness (risk/impact docs) | 15 | 25 |
   | LLM thoroughness (pre/post/backout plans) | 15 | 25 |
   | LLM risk | 10 | 10 |
   | LLM impact | 10 | 10 |
   | LLM complexity | 10 | 10 |
   | **Total** | **100** | **100** |

   Put these weights in a **config object (a rubric)** — never hardcode them. The LLM only emits the
   categorical signals; the **final number is computed deterministically** in code so it's auditable.
5. **HIGH-RISK trigger** — default threshold **≥ 70** ⇒ flag the ticket HIGH RISK and require
   collaborative review by the relevant approval groups (block single-approver sign-off). Threshold
   configurable.
6. **Explainability (the whole point)** — a per-ticket breakdown showing each component's
   contribution to the score, the LLM's extracted signals **with its short rationale**, and the
   similar historical tickets it drew on. Because the failure mode being fixed is "not meaningful /
   manipulable," transparency + grounding is the core value, not a nice-to-have.
7. **UI** — a queue/dashboard of change tickets with scores and risk badges; a ticket detail view
   (score breakdown, LLM rationale, similar tickets); a rubric/threshold settings page; a demo-data
   loader. Clean, accessible, light + dark (`prefers-color-scheme`).
8. **Optional write-back** — push the computed score/flag back to ServiceNow as a field or work note.
   **Off by default**, clearly gated, and never enabled in demo mode.

## Canonical data model (ITSM-agnostic; adapters map each system to this)
- **ChangeTicket**: `id`, `title`, `description`, `type` (Standard | Normal | Expedited | Emergency),
  `planned_window`, `pre_implementation_plan`, `post_implementation_plan`, `backout_plan`,
  `affected_systems`, `change_owner`, `approval_groups[]`.
- **HistoryRecord**: past change with `outcome` (success | incident), `downtime`, `duration`,
  `business_impact`, embedding for similarity.
- **IncidentRecord**: major incidents linked to changes (`description`, `time`, `type`, `cost`).
- **RiskResult**: `score` (0–100), `profile` (with/without history), `components[]` (name, weight,
  raw, weighted), `llm_signals` (+rationale), `similar_tickets[]`, `flagged` (bool), `threshold`.

## LLM
- Provider-neutral behind an `LlmProvider` interface. Two deployment modes:
  - **Cloud** (a current hosted model) for the public demo.
  - **On-prem / air-gapped** via a local model (e.g. a Llama model through Ollama) — essential for
    enterprise/defense IT that cannot send change data to external APIs. Make this a first-class,
    documented, switchable mode; it is a genuine differentiator.
- **Force structured JSON output** for the extracted signals; validate against a schema (zod /
  pydantic) and retry on mismatch. Low temperature for stability. The model **never** outputs the
  final numeric score — only the categorical signals + short rationale.

## Architecture & stack (defaults — change only with reason)
- **Frontend**: React + TypeScript (+ a charting lib for the score breakdown).
- **Backend**: a small API (Node/TS **or** Python/FastAPI) for LLM calls, ITSM adapters, scoring,
  and persistence. **Postgres + pgvector** for similar-ticket retrieval in prod; **SQLite/in-memory**
  for the demo.
- **Adapters**: an `ItsmAdapter` interface — implement **ServiceNow** first (Table API for change
  records), plus **Jira Service Management** and **CSV/JSON** stubs.
- **Demo mode**: bundles a synthetic ticket set + a seeded history/incident store, and either a local
  LLM or a deterministic mock extractor, so the app runs end-to-end with zero external credentials.
  The portfolio links to this demo.

## Placeholders (fill in or leave stubbed)
| Token | Meaning | Default if unknown |
|---|---|---|
| `<<LLM_PROVIDER>>` / `<<LLM_MODEL>>` | which model + mode | cloud model for demo; document Ollama path |
| `<<DEMO_MODE>>` | run on synthetic data only | `true` |
| `<<SERVICENOW_INSTANCE_URL>>` + creds | live ServiceNow | unset → mocked adapter |
| `<<HISTORY_DB_URL>>` | Postgres/pgvector | unset → SQLite demo store |
| `<<HIGH_RISK_THRESHOLD>>` | flag cutoff | `70` |
| `<<MIN_HISTORY>>` | similar records for the full-history profile | `10` |

## Definition of done
1. Demo mode loads synthetic tickets with **no external credentials**, scores them, and shows the
   breakdown + LLM rationale + similar tickets.
2. Rubric weights and threshold are **config-driven**; the correct weighting profile is selected by
   history availability.
3. LLM extraction is **schema-validated**; the final score is computed **deterministically** from the
   signals (the LLM never emits the number). A bad LLM response is caught and retried, not trusted.
4. ServiceNow adapter reads change records when creds are provided and is cleanly mocked otherwise;
   write-back is gated off by default and disabled in demo mode.
5. On-prem (local-LLM) mode is documented and switchable.
6. Unit tests cover: the scoring math, profile selection, the categorical→numeric mapping, threshold
   flagging, and adapter field mapping.
7. No real client data, names, personas, or proprietary figures anywhere; every placeholder is
   resolved or stubbed with a working fallback.
8. Accessible, responsive, light + dark; no console errors.

## Deliverables
- The web app + backend, a README (including on-prem/air-gapped setup), the synthetic dataset, the
  rubric config, the `ItsmAdapter` interface + ServiceNow impl + Jira/CSV stubs, the `LlmProvider`
  interface + both modes, and the test suite.

## Portfolio hook
Once it runs in demo mode, record a short looping preview with the core prompt in
`docs/preview-recording-prompt.md` using `PROJECT_ID: bae`, and hand back `bae.webm` / `bae.mp4` /
`bae-poster.jpg` to wire into the portfolio modal.

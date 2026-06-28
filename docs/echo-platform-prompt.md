# Build prompt: ECHO Benchmark Platform

> Paste everything below the line into your coding agent of choice. It is self-contained.
> Before pasting, fill in the `<<PLACEHOLDER>>` tokens in the **Source materials** section with your
> real URLs. Where a placeholder is still unknown, leave it as-is — the prompt tells the agent to
> stub that seam and proceed. If the dataset/code aren't attached yet, the agent will scaffold against
> the schema in this prompt and generate clearly-labeled SAMPLE benchmark files so the app runs
> end-to-end.

---

## Source materials & links

**Confirmed (real) sources — use these directly:**
- Thesis (landing page): https://drum.lib.umd.edu/items/016cc118-4ca2-4cb2-8365-398053d7d016
- Thesis (full PDF): https://drum.lib.umd.edu/bitstreams/f63ac636-bec3-4aef-83cb-ee3a8ed8ccdc/download
- Original benchmark code + dataset (research repo): https://github.com/rahulnair2003/gemstone
- Author/credit: Team ECHO — Rajit Mukhopadhyay (lead), Bhargav Tumkur, Lily Li, Samuel Waters,
  Chelsea Reyes, Ronoy Sarkar, Rahul Nair, Pruthav Patel, Perfect Sare. Advised by Dr. Sahil Shah,
  University of Maryland Gemstone Honors, 2025.
- Reference models / libraries (for the downloadable kit, not run server-side):
  - `noisereduce` (spectral subtraction): https://github.com/timsainb/noisereduce
  - SpeechBrain MetricGAN+: https://github.com/speechbrain/speechbrain
  - Dynamic Range Compression (standard DSP; e.g. `pydub`/`pedalboard` or the kit's own impl)

**Placeholders — replace before/at build time (leave the token if unknown; stub the seam):**

| Token | What it is | If unknown |
|---|---|---|
| `<<DATASET_DOWNLOAD_BASE>>` | Base URL where the `.wav` corpus is hosted (the open-source dataset). May be the research repo, DRUM, S3/R2, HF Datasets, etc. | Stub `DatasetSource` to return per-file URLs built from this base; ship sample clips. |
| `<<DATASET_MANIFEST_URL>>` | URL of the master manifest (every file + its tags) used to drive filtering/subsetting. | Generate from the bundled sample data. |
| `<<BENCHMARK_KIT_REPO>>` | Repo for the packaged, user-runnable benchmark generator (likely a fork/extract of the research repo above). | Link to the research repo and mark "packaging TBD." |
| `<<KIT_INSTALL_CMD>>` | One-line install for the kit (e.g. `pipx install echo-benchmark` or `pip install ...`). | Show a `git clone` + `pip install -e .` fallback. |
| `<<PLATFORM_URL>>` | Deployed site URL (for canonical links, share metadata, sitemap). | Use a relative base; fill later. |
| `<<DATASET_LICENSE>>` | Dataset license (e.g. CC BY 4.0) shown on the hub + in downloads. | Display "license: TBD". |
| `<<DATASET_DOI_OR_CITATION>>` | Formal citation/DOI for the dataset, if separate from the thesis. | Fall back to the thesis citation above. |

Wherever this prompt references "the dataset," "the manifest," "the kit," or "the platform URL,"
resolve them through the tokens above.

---

## Role & goal

You are building **ECHO**, a hosted web platform that turns an existing hearing-aid audio
benchmarking research project (dataset + Python benchmark code, see Source materials) into an
interactive product.

The platform does **NOT run any audio models or process any audio server-side.** All model
inference happens on the *user's* machine via a downloadable kit. The website only: (1) serves
and subsets the audio dataset, (2) distributes the benchmark-generation kit, and (3) ingests,
validates, visualizes, compares, and stores small benchmark **JSON** files (numbers + categorical
tags only). This is a deliberate security/cost decision: the server never executes untrusted code
or processes untrusted audio — it only parses schema-validated JSON.

Build a polished, production-grade, accessible product — not a prototype. It will be linked as
the live demo from a personal portfolio, so design quality matters.

## Background (what ECHO is — use this domain language in the UI)

ECHO is an open-source **environmental audio dataset** plus a **benchmarking utility** for
comparing how hearing-aid audio-processing models perform across real-world sound environments.

Instead of labeling audio by specific location ("restaurant", "garden"), ECHO classifies every
recording with **4 binary environmental features** that apply to *any* environment:

- **Indoors** (indoor `true` / outdoor `false`)
- **Crowded** (loud/busy `true` / quiet `false`)
- **Speaking** (scripted speech present `true` / none `false`)
- **Walking** (recorder moving `true` / stationary `false`)

These 4 booleans yield **16 environments, labeled A–P**. Recordings: `.wav`, 20 kHz, binaural
over-ear mic, clips > 2 min, captured around UMD College Park + Washington DC. Each file also
carries: a specific `Location` string, `Voice_Type` (Male/Female/NA), and `Voice_ID` (e.g. M07/F03).

Models are scored **per file** (not aggregated up front — aggregation happens at analysis time so
users can filter to any subset) on **6 objective metrics**:

| Metric (JSON key) | Unit | Notes / directionality |
|---|---|---|
| Total Harmonic Distortion (`Total_Harmonic_Distortion`) | ratio | lower = cleaner |
| Signal-to-Noise Ratio (`Signal_Noise_Ratio`) | dB | higher = better |
| Noise Floor (`Noise_Floor`) | dB | lower = better |
| Dynamic Range (`Dynamic_Range`) | dB | higher generally better (compression intentionally lowers it) |
| Crest Factor (`Crest_Factor`) | dB | context-dependent |
| Waveform Complexity Index (`Waveform_Complexity_Index`) | index | context-dependent (speech-isolation lowers it) |

Treat directionality as metadata the UI surfaces (e.g. a "higher is better" / "lower is better" /
"context-dependent" badge), and let it drive sensible default sorting — never hardcode it into the
math.

The original benchmark demonstration compared four sources: **baseline** (no processing),
**spectral subtraction** (`noisereduce`), **Dynamic Range Compression**, and **MetricGAN+**
(`speechbrain`). Reuse these as the bundled example benchmarks.

## Canonical data contract — the benchmark JSON

This schema already exists; the platform must load existing files **unchanged** and be the source
of truth for new ones. One JSON file = one model's benchmark over a set of files.

```jsonc
{
  "audio_model": "spectral_subtraction",   // string — model name/identifier (required)
  "runtime": 142.7,                          // number — seconds to process the dataset (optional)
  "files": [
    {
      "ID": "A_M07_001",                    // string — unique file identifier (required)
      "Length": 137.4,                       // number — duration in seconds
      "Location": "Stamp Student Union",     // string — specific location
      "Indoors": true,                       // boolean
      "Crowded": true,                       // boolean
      "Speaking": true,                      // boolean
      "Walking": false,                      // boolean
      "Voice_Type": "Male",                  // "Male" | "Female" | "NA"
      "Voice_ID": "M07",                     // string | "NA"
      "Total_Harmonic_Distortion": 0.031,    // number
      "Signal_Noise_Ratio": 18.4,            // number (dB)
      "Noise_Floor": -52.1,                  // number (dB)
      "Dynamic_Range": 41.8,                 // number (dB)
      "Crest_Factor": 12.3,                  // number (dB)
      "Waveform_Complexity_Index": 0.67      // number
    }
    // ... one object per audio file
  ]
}
```

Requirements around the contract:
- Write a **strict validator** (e.g. zod) and reject/clearly report malformed uploads. Never trust
  upload contents beyond the validated shape; ignore unknown keys but preserve them on round-trip.
- The 16-environment label (A–P) is **derived** from the 4 booleans — implement the canonical
  `(Indoors, Crowded, Speaking, Walking) -> letter` mapping as a pure function and show the letter
  everywhere, but always keep the underlying booleans so users can filter by feature, not just letter.
- Be **forward-compatible**: new metrics may be added later. Don't hardcode the six metric keys in
  the UI — derive the available metric list from the data + a metric registry (key, label, unit,
  directionality) so adding a metric is a one-line registry change.

## The three pillars to build

### 1. Dataset hub & subset extractor
- Browse all 16 environments (A–P) with the decoded feature combination, file counts, total
  duration, and example locations/voices. Show the `<<DATASET_LICENSE>>` and `<<DATASET_DOI_OR_CITATION>>`.
- Filter the dataset by any combination of the 4 binary features, environment letter, `Voice_Type`,
  `Voice_ID`, and min/max clip length. Show a live count + total size of the matching subset.
- **Extract** the matching subset: produce a download (the matching `.wav` files + a `manifest.json`
  + `manifest.csv` listing every file with its tags). Design this **host-agnostic** behind a small
  `DatasetSource` interface (driven by `<<DATASET_DOWNLOAD_BASE>>` + `<<DATASET_MANIFEST_URL>>`) so
  the actual audio can live anywhere:
  - Default impl: **external link-out + manifest** — the app filters and hands back direct download
    URLs + the manifest, with no large-asset hosting in the app itself. Best if the corpus is large.
  - Alternate impls to leave stubbed: pre-zipped per-environment bundles; on-demand zip from an
    object store. Pick the default but keep the seam clean.
- Inline `<audio>` preview for individual sample clips where a playable URL exists.

### 2. Run-it-yourself benchmark kit
- A clearly documented **download + quickstart** for the local benchmark generator (the packaged kit
  at `<<BENCHMARK_KIT_REPO>>`, derived from the research repo). The flow the page must explain:
  1. Download a dataset subset (pillar 1).
  2. Install the kit: `<<KIT_INSTALL_CMD>>`.
  3. Point it at the subset folder + a Python function/CLI hook that runs *their* model on a `.wav`
     and returns an output `.wav`.
  4. It computes the 6 metrics per file and writes a benchmark JSON matching the contract above.
  5. Upload that JSON back into the site (pillar 3).
- Include a copy-pasteable minimal example and the exact metric definitions so results are
  reproducible. Reuse the original metric implementations verbatim from the research repo — do not
  re-derive the formulas.

### 3. Compare, visualize & store
- **Upload** one or many benchmark JSONs (drag-drop, multi-file), validate, and add them to the
  current comparison set. Bundle the 4 example benchmarks (baseline, spectral subtraction, DRC,
  MetricGAN+) so the app is immediately populated.
- **Filters** (mirror the Python lib): which metrics to show (multi-select), which environments/
  features/voice subset to include, and aggregation = **mean | median** (default mean).
- **Visualizations** (this is the core; port the two functions from section 6.3 of the thesis, then
  extend):
  - **Model snapshot** — for a chosen environment subset, one panel per selected metric; bars =
    models. Answers "which model wins overall on this metric?"
  - **Cross-environment comparison** — per selected metric, grouped bars: x-axis = environments
    (A–P or the active subset), series = models. Answers "where does each model win/lose?"
  - **Per-file distribution** (new, leverages per-file data): box/violin or strip plot of a metric
    across files for each model, so users see spread, not just the mean.
  - **Model profile** (new): radar or parallel-coordinates across all 6 metrics for selected models.
  - Every chart: hover tooltips, the "higher/lower is better" badge, units, model color legend,
    and export to PNG + SVG.
- **State in the URL**: encode the active models/metrics/filters/aggregation in query params so any
  view is shareable and reload-stable.
- **Store benchmarks (local-first — default, no backend):** persist uploaded/saved benchmarks in
  **IndexedDB** as a personal library (name, tag, delete, re-load into a comparison). Support
  **export/import** of the whole library (or single benchmarks) as JSON files for sharing/backup.
  This keeps the app a pure static deploy with zero data risk.
- **Optional Phase 2 — accounts + community (clearly isolate behind a feature flag; do NOT build
  unless explicitly enabled):** lightweight auth + a backend that stores **only** benchmark JSON
  (never audio, never code), giving cross-device libraries and an opt-in **public leaderboard**
  ranking submissions per metric × environment. Note the moderation/abuse surface in the README.
  Even here, the server only stores and serves validated JSON — it never executes anything.

## Supporting pages
- **Methodology** — explain the 4 binary features, the 16-environment scheme, each of the 6 metrics
  (plain-language + formula + unit + directionality), and the per-file-then-filter philosophy. Link
  the thesis (Source materials).
- **About / cite** — credit Team ECHO and Dr. Sahil Shah (see Source materials); link the thesis,
  the dataset, and the code repo; show `<<DATASET_LICENSE>>` and `<<DATASET_DOI_OR_CITATION>>`.
- **Home** — crisp value prop + the three pillars as the primary nav, with a "Try it" that drops the
  user straight into pillar 3 pre-loaded with the example benchmarks.

## Tech stack & hosting (defaults — adjust only with reason)
- **React + Vite + TypeScript**, deployable as a **static site** (Vercel / Netlify / GitHub Pages);
  canonical URL = `<<PLATFORM_URL>>`.
- Charts: **Recharts** (or visx if you need the distribution/parallel-coordinate plots) — whichever
  cleanly supports grouped bars, box/violin, and radar.
- **zod** for schema validation; **IndexedDB** (via `idb`) for local storage; URL state via the router.
- All client-side; no server required for the default build. If Phase 2 is enabled, use serverless
  API routes + a small managed Postgres/SQLite and an auth provider — keep it a separate, optional
  layer that the static app degrades gracefully without.
- Strong test coverage on the pure logic: schema validation, the boolean→A–P mapping, aggregation
  (mean/median), and filtering. These are the correctness-critical pieces.

## Design & UX
- Distinctive, production-grade, not generic-AI-looking. Clean data-viz aesthetic; excellent typographic
  hierarchy; responsive; full keyboard accessibility and proper ARIA on the interactive charts/filters.
- Support light **and** dark themes via `prefers-color-scheme`.
- Empty/error/loading states everywhere; never a blank screen. Validation errors must say exactly
  which file and field failed.

## Definition of done
1. Loads the 4 bundled example benchmarks and renders all chart types on first paint.
2. Dataset hub filters by all 4 features + voice tags, shows live counts, and produces a subset
   manifest download through the `DatasetSource` seam.
3. Benchmark-kit page documents the full local round-trip with a working copy-paste example.
4. Upload accepts valid JSONs, rejects invalid ones with precise messages, and round-trips unknown keys.
5. Filters (metrics / environments / features / mean-median) drive every chart; state is in the URL.
6. Local library persists across reloads (IndexedDB) with export/import.
7. Deploys as a static site with no backend. Phase 2 (accounts/leaderboard), if built, is fully
   behind a flag and the static build works with it off.
8. Lighthouse: accessible, responsive, no console errors. Unit tests pass for validation, the A–P
   mapping, aggregation, and filtering.
9. Every `<<PLACEHOLDER>>` is either resolved to a real value or cleanly stubbed with a `TODO` and a
   working fallback — never a hardcoded broken link.

## Deliverables
- The web app (above), a README with run/deploy instructions, the packaged benchmark kit (or a clear
  pointer to `<<BENCHMARK_KIT_REPO>>`), the metric registry, the `DatasetSource` interface + default
  impl, and sample data.
- Keep the existing benchmark JSON schema backward-compatible so previously generated files load as-is.

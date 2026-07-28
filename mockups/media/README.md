# media/

Drop demo assets here. The storybook mockup references these by stable filename;
until a file exists, the project modal shows a labeled placeholder, so nothing 404s
in a way that breaks the page.

## Site assets (drop-in placeholders)

| Expected file | Used by | Status |
|---------------|---------|--------|
| `portrait.jpg` | About section headshot | ✔ present ("RM" monogram if ever missing) |
| `og-card.png` | Social share card (`og:image`) | ✔ generated, present |

(A `resume.pdf` slot existed briefly — the Résumé/Email contact routes are removed
for now; re-add the buttons in `index.html` if that changes.)

Also: the `og:url` / `og:image` meta tags in `index.html` use the placeholder domain
`rajitmukhopadhyay.dev` — swap for the real domain at deploy time. The ECHO modal's
"Code on GitHub" link points at the placeholder repo `Altair-ajit/echo-bench`.

Still-placeholder projects (drop the file in and the modal lights up automatically):

| Project | Expected file | Type | Notes |
|---------|---------------|------|-------|
| Native Sign-In Identity Linking | `cognito-auth.gif` | gif | on-device auth (TouchID/FaceID) → apps |
| AlgenAir Market Analytics | `algenair.gif` | gif | analysis charts |

Projects already wired with real assets:

- **ECHO — Hearing Aid ML** — looping video demo of the benchmark platform:
  `echo.webm` + `echo.mp4` + `echo-poster.jpg` (generated via `docs/preview-recording-prompt.md`).
- **Cognito Multi-Region Replication** — image gallery in `media/aws/` (real AWS launch screenshots).
- **LLM Risk Tool (BAE)** — looping video demo: `bae.webm` + `bae.mp4` + `bae-poster.jpg`.
  (The deck slides in `media/bae/` are no longer wired in — kept on disk in case they're useful.)
- **Quantum Sensing Sims** — APS / ADS publication card (no local file).

## Adding a video preview for another project
Record it with the core prompt in [`docs/preview-recording-prompt.md`](../../docs/preview-recording-prompt.md),
which outputs `<id>.webm` + `<id>.mp4` + `<id>-poster.jpg`. Drop the three files here, then set that
project's `media` to `{ type: 'video', poster: 'media/<id>-poster.jpg', sources: [
{src:'media/<id>.webm',type:'video/webm'}, {src:'media/<id>.mp4',type:'video/mp4'} ] }`.
Gifs also still work (`{ type: 'gif', src: 'media/<id>.gif' }`).

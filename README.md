# rajit-portfolio

Personal portfolio site for Rajit Mukhopadhyay — *"Turning Problems into Products."*

**Live:** https://altair-ajit.github.io/rajit-portfolio/ — deployed from the `gh-pages` branch.
To redeploy after changes: `bash scripts/deploy-pages.sh` (publishes `mockups/index.html` + `media/` only).

A scroll-driven story: the page opens like a book (typewriter frontispiece), unfolds a three-chapter career narrative over a watercolor / graph-paper world, then settles into a normal, scannable site (projects, experience, clients, research, contact).

## Status

Design / brainstorming phase. The full site lives at [`mockups/index.html`](mockups/index.html) — the storybook direction, now built out with project demos, light/dark theming, and inline animations. The production build (React + Vite + TypeScript, static, local-first) has not started yet.

## Mockups

Serve locally and the full site loads at the root:

```bash
cd mockups
python3 -m http.server 3999
# open http://localhost:3999/
```

| File | What it is |
|------|------------|
| `index.html` | **The full site** — storybook theme, watercolor washes, graph paper, project demo modals/animations, light + dark |
| `portfolio-full-site.html` | Prior full-site mockup (dark "aurora" theme) — superseded |
| `portfolio-blend-story.html` | Early scroll-story blend demo |
| `portfolio-flair-directions.html` | Three animated motion directions (aurora / boot / kinetic) |
| `portfolio-style-directions.html` | Three static style directions (first round) |

## Planned stack

- React + TypeScript + Vite
- Tailwind CSS
- Static build — deployable to Vercel / Netlify / GitHub Pages
- Picture placeholders + slots for future live project integrations

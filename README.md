# rajit-portfolio

Personal portfolio site for Rajit Mukhopadhyay — *"Turning Problems into Products."*

A scroll-driven story: the page opens like a book (typewriter frontispiece), unfolds a three-chapter career narrative over a watercolor / graph-paper world, then settles into a normal, scannable site (projects, experience, clients, research, contact).

## Status

Design / brainstorming phase. Interactive HTML mockups live in [`mockups/`](mockups/) — `portfolio-storybook.html` is the chosen direction. The production build (React + Vite + TypeScript, static, local-first) has not started yet.

## Mockups

Serve them locally to click through:

```bash
cd mockups
python3 -m http.server 3999
# open http://localhost:3999/portfolio-storybook.html
```

| File | What it is |
|------|------------|
| `portfolio-storybook.html` | **Chosen direction** — storybook theme, watercolor washes, graph paper, sponsors-style client banner |
| `portfolio-full-site.html` | Prior full-site mockup (dark "aurora" theme) — superseded |
| `portfolio-blend-story.html` | Early scroll-story blend demo |
| `portfolio-flair-directions.html` | Three animated motion directions (aurora / boot / kinetic) |
| `portfolio-style-directions.html` | Three static style directions (first round) |

## Planned stack

- React + TypeScript + Vite
- Tailwind CSS
- Static build — deployable to Vercel / Netlify / GitHub Pages
- Picture placeholders + slots for future live project integrations

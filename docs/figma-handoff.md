# Figma handoff — rajit-portfolio

A base kit for restructuring/replanning the site in Figma. The site is a single
self-contained page: `mockups/index.html` (+ `mockups/media/`). Everything below —
tokens, type, components, structure — is extracted from that file and is the
current source of truth.

---

## 1. Getting the real site into Figma (editable layers)

Use the **html.to.design** plugin (by ‹div›RIOTS — free tier is fine):

1. In Figma: **Resources → Plugins → search "html.to.design" → Run**.
2. Paste the live URL: **https://altair-ajit.github.io/rajit-portfolio/**
   Import at 1440 px and 390 px widths. Import **twice** — once with
   "dark mode" off, once on — to capture both themes.
3. Before capturing, click **"skip the opening →"** (bottom-right) so the boot
   veil doesn't cover the page, and scroll to the bottom once so all
   scroll-reveal sections are in their visible state.
4. The projects row scrolls horizontally — capture it at scroll-start, then
   scroll it right and capture again if full coverage is wanted.

This yields editable frames with real text layers and correct fonts (all three
families are on Google Fonts — Figma has them natively).

---

## 2. Design tokens

### Color — light theme ("paper")
| Token | Value | Use |
|---|---|---|
| paper | `#F8F4EA` | page background |
| paper2 | `#F2ECDD` | bands (marquee, gallery strips, footer) |
| card | `#FFFDF8` | card / modal surfaces |
| ink | `#262331` | headings, primary text |
| ink-soft | `#4D4A58` | body text |
| ink-faint | `#8A8694` | labels, captions, metadata |
| accent (peri-deep) | `#4C5A94` | links, act labels, metrics, primary buttons |
| peri | `#7C89C4` | watercolor wash, grid tint |
| lav | `#A48BC9` | secondary accent (pub venues, wash) |
| pink | `#C98BA6` | tertiary accent (roman numerals, client roles, wash) |
| sage | `#7D9A72` | success/"live" badges, wash |
| line | `rgba(38,35,49,0.14)` | hairline borders |

Backgrounds: paper + a *very* faint graph grid (`rgba(124,137,196,0.055)` /
`0.022`, 130 px + 26 px cells) + 4 large blurred watercolor blobs (peri, pink,
lav, sage · blur 130 px · opacity 0.10–0.16) + dot grain at 0.3 opacity.

### Color — dark theme ("aurora")
| Token | Value |
|---|---|
| paper | `#07070F` |
| paper2 / card | `rgba(255,255,255,0.045)` / `rgba(255,255,255,0.05)` (glass, backdrop-blur 14) |
| ink | `#FFFFFF` |
| ink-soft | `rgba(255,255,255,0.66)` |
| ink-faint | `rgba(255,255,255,0.40)` |
| accent (peri-deep) | `#5EEAD4` (teal) |
| peri | `#2BC8EE` · lav `#9FB4FF` · pink `#D8B4FE` · sage `#5EEAD4` |
| line | `rgba(255,255,255,0.12)` |
| aurora blobs | `#3B2BEE`, `#B22BEE`, `#2BC8EE` · blur 120 · opacity 0.38 |

One brand, two lights: dark is a re-lighting of the same design — same fonts,
weights, and components; only surfaces/colors change.

### Typography
Families (all on Google Fonts):
- **Fraunces** (display serif) — section/chapter/card/modal headings. Weights 400/500/600.
- **Newsreader** (body serif) — story prose, bios, modal descriptions; its
  *italic* is the ceremonial voice (frontispiece, hero subline).
- **Archivo** (label sans) — nav, tags, buttons, captions, metrics, facts.
  Weights 400/500/600. Uppercase labels get +1.8–2.6 px letter-spacing.
- **Georgia** — *only* for the name: hero H1 + nav logo (deliberate exception).

Scale (px):
| Role | Font | Size / weight |
|---|---|---|
| Hero name | Georgia | clamp 48–100 / 500 |
| Chapter H2 | Fraunces | 37 / 500 |
| Section H2 | Fraunces | 30 / 500 |
| Modal H3 | Fraunces | 28 / 500 |
| Contact H2 | Fraunces | clamp 32–50 / 500 |
| Card / row H4 | Fraunces | 17.5 / 500–600 |
| Body (story/about/modal) | Newsreader | 16.5–17 / 400, lh 1.7–1.8 |
| UI body (card blurbs, rows) | Archivo | 13–13.5 / 400, lh 1.6 |
| Labels/eyebrows (caps) | Archivo | 11–12 / 500–600, tracked |
| Tags (caps) | Archivo | 10.5 / 500 |

### Shape & elevation
- Radius: cards **10**, modal **14**, pills/buttons **99** (full).
- Shadows (light): sm `0 2 10 rgba(38,35,49,0.05)` · md `0 12 32 /0.10` ·
  lg `0 30 70 /0.22`. Dark equivalents use black at 0.35/0.5/0.6.
- Borders: 1 px `line` on all surfaces; cards pair border + sm shadow.

---

## 3. Page anatomy (top → bottom)

1. **Boot veil** — full-screen paper; centered serif-italic typewriter
   frontispiece (3 lines), blinking cursor; "skip the opening →" bottom-right.
   Same in both themes. Auto-skipped on repeat visits.
2. **Hero** — 100 vh centered: caps kicker → Georgia name (letter-cascade in)
   → 90 px rule → italic subline → bottom cues.
3. **Story** — 3 alternating two-column chapters (copy ↔ figure card) along a
   center spine (2 px, gradient fill grows with scroll). Chapter = caps act
   label + Fraunces H2 + narrative paragraph + pill row. Figure cards: 250 px
   min, image area + caption row under hairline.
4. **Marquee** — full-width band, caps ticker of employers/clients.
5. **About** — card: 84 px round avatar (photo; "RM" monogram fallback) +
   3-line bio + facts rows (Now / Education / Languages / Hardware &amp;
   systems / Practices) + button row (GitHub primary pill + LinkedIn ghost).
6. **Projects** — heading row, then a **horizontal scroller**: 2 rows ×
   340 px columns, 20 gap; soft 56 px edge fades; round overlay chevrons
   (42 px, card bg, elev-md) floating mid-left/right, each shown only when
   scrollable that way; grab-drag; thin scrollbar. 8 cards.
   **Card** = 144 px media header (screenshot/product-UI SVG) + optional caps
   badge chip (top-right) + H4 + 2-line blurb + accent metric line + caps tag
   row + hover-reveal "VIEW PROJECT →". Hover: lift 4 px, elev-md.
7. **Experience** — list rows: grid `150px | 1fr | auto` = when / (favicon +
   H4 with accent org + description) / location. 7 rows incl. education.
8. **Clients** — 3 cards (caps role label, H4 + favicon, blurb) + capstone
   logo marquee (grayscale, color on hover).
9. **Research & Awards** — 3 pub cards (caps venue in lav, H4, blurb) +
   award pill row.
10. **Contact** — centered Fraunces H2 (accent *next chapter*), body line,
    buttons (Connect on LinkedIn primary + GitHub ghost).
11. **Footer** — caps-ish Archivo line on paper2.

**Project modal** (opened from any card): 840 px card, radius 14, elev-lg,
blurred backdrop; media area on top (looping video / image gallery with
thumbnail strip / inline animation / terminal), then caps eyebrow, Fraunces H3,
description, pill tags, underlined link row. Fixed round close button.

---

## 4. Motion inventory (so static frames don't lose intent)

- Boot typewriter → veil fades (1.2 s).
- Hero letters cascade up (staggered 40 ms), kicker/sub/rule fade-rise.
- Scroll reveals: 14–22 px fade-rise, ~0.55 s, cubic-bezier(.22,.7,.3,1).
- Story spine fills top→down with scroll.
- Marquees auto-scroll (22–26 s loops).
- Projects row: snap scrolling, edge fades appear/disappear by position.
- Card hover: translateY(-4), shadow up; "VIEW PROJECT →" fades in.
- Watercolor/aurora blobs drift (15–24 s alternating).
- In-modal media: looping muted videos; animated diagrams (Face ID scan,
  region-failover, US map arcs, signal scan, terminal cursor).

---

## 5. Asset manifest (`mockups/media/`)

- Posters/screenshots: `echo-poster.jpg`, `bae-poster.jpg`, `yondu-poster.jpg`,
  `aws/01–06*.png` (MRR gallery), `bae/01–05*.png` (deck slides, unwired).
- Videos: `echo|bae|yondu` × `.webm/.mp4` (1280×800 loops).
- Social card: `og-card.png` (1200×630).
- Headshot: `portrait.jpg` (crop biased to `center 30%` in the round avatar).
- Favicon: inline SVG "R" monogram on `#4C5A94`, radius 14.

## 6. Known placeholders (fair game to redesign)

- Résumé/Email contact routes intentionally removed for now — GitHub +
  LinkedIn are the only contact channels.
- OG domain `rajitmukhopadhyay.dev` is a placeholder.
- MRR modal is a screenshot gallery; a real console screen-recording is planned.
- Card-header SVGs for MRR / Native Sign-In / AlgenAir / Quantum / Pipeline are
  hand-built product-UI mocks — replace freely if better art direction exists.

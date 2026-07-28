# Core prompt: record a mini preview clip of this project (run locally)

> Reusable. Paste into the session/repo of any project that has a runnable local UI. Fill in the
> four values in **FILL THIS IN**, then let the agent run it. It records a short looping preview of
> the local app and emits three files named the way the portfolio expects, so porting back is a copy.
> Node required; ffmpeg optional.

---

You are recording a short preview clip of THIS project's running app, for use as the demo on a
personal portfolio. This is a capture task — do not change the app's product code; only add the
`scripts/record-preview.mjs` file and the `playwright` dev-dependency.

## FILL THIS IN
- **PROJECT_ID**: a short id for the file names. Use the matching portfolio key:
  `echo` | `mrr` | `cognito-auth` | `bae` | `algenair` | `quantum`.
- **LOCAL_URL**: the local dev URL once the app is running (e.g. `http://localhost:5173`).
- **THEME**: `light` or `dark` — whichever looks best as a small card.
- **STEPS**: the 2–4 interactions that best show the app off in ~10 seconds (what to click / scroll).
  End on the SAME view you started on so the loop is seamless.

## Output (must match exactly — the portfolio depends on these names/specs)
Write to `./previews/`:
- `PROJECT_ID.webm` — muted WebM (always produced)
- `PROJECT_ID.mp4` — muted H.264 mp4 (only if ffmpeg is installed; otherwise skip and say so)
- `PROJECT_ID-poster.jpg` — first-frame JPEG poster

Spec: viewport **1280×800**, **6–15 s**, **muted**, target mp4 **< 2 MB**, seamless loop.

## Do this
1. Start the app's local dev server (use this project's normal command) so `LOCAL_URL` is reachable.
   Leave it running in the background.
2. Install the recorder deps:
   ```bash
   npm i -D playwright && npx playwright install chromium
   ```
3. Create `scripts/record-preview.mjs` (edit the four CONFIG constants + the `steps` body):
   ```js
   import { chromium } from 'playwright';
   import { execFileSync } from 'node:child_process';
   import { mkdirSync, renameSync, rmSync } from 'node:fs';
   import { join } from 'node:path';

   // ---- CONFIG (fill these in) ----
   const ID = 'echo';
   const URL = process.env.PREVIEW_URL || 'http://localhost:5173';
   const THEME = 'dark';                 // 'light' | 'dark'
   const steps = async (page) => {
     await page.waitForLoadState('networkidle');
     await page.waitForTimeout(800);
     // --- show the app off here, e.g.: ---
     // await page.getByRole('button', { name: /compare/i }).click();
     // await page.waitForTimeout(1200);
     await page.mouse.wheel(0, 500);
     await page.waitForTimeout(1200);
     await page.mouse.wheel(0, -500);    // return to start -> seamless loop
     await page.waitForTimeout(600);
   };
   // --------------------------------

   const OUT = 'previews', TMP = join(OUT, '.tmp');
   const hasFfmpeg = (() => { try { execFileSync('ffmpeg', ['-version'], { stdio: 'ignore' }); return true; } catch { return false; } })();
   rmSync(TMP, { recursive: true, force: true });
   mkdirSync(TMP, { recursive: true });

   const browser = await chromium.launch();
   const context = await browser.newContext({
     viewport: { width: 1280, height: 800 },
     colorScheme: THEME,
     deviceScaleFactor: 2,
     recordVideo: { dir: TMP, size: { width: 1280, height: 800 } },
   });
   const page = await context.newPage();
   await page.goto(URL, { waitUntil: 'load' });
   await page.waitForTimeout(500);
   await page.screenshot({ path: join(OUT, `${ID}-poster.jpg`), type: 'jpeg', quality: 80 });
   await steps(page);
   const vid = await page.video().path();
   await context.close();                // flush webm
   await browser.close();

   const webm = join(OUT, `${ID}.webm`);
   renameSync(vid, webm);
   console.log(`✓ ${webm}`);
   if (hasFfmpeg) {
     const mp4 = join(OUT, `${ID}.mp4`);
     execFileSync('ffmpeg', ['-y', '-i', webm, '-an', '-movflags', '+faststart',
       '-pix_fmt', 'yuv420p', '-vf', 'scale=1280:-2', '-c:v', 'libx264', '-preset', 'slow', '-crf', '30', mp4],
       { stdio: 'inherit' });
     console.log(`✓ ${mp4}`);
   } else {
     console.log('⚠ ffmpeg not found — produced webm + poster only (no mp4).');
   }
   rmSync(TMP, { recursive: true, force: true });
   ```
4. Run it (server must be up):
   ```bash
   node scripts/record-preview.mjs
   ```
5. If the mp4 is > 2 MB, bump `-crf` to 32–34 or shorten `steps`. If a step can't find an element,
   fix the selector against the live UI and re-run.

## Hand back
Return the three files from `./previews/` (`PROJECT_ID.webm`, `PROJECT_ID.mp4`, `PROJECT_ID-poster.jpg`)
and state which PROJECT_ID they are. They get dropped into the portfolio's `mockups/media/` and the
matching project modal switches to a looping `<video>` using them (with the existing placeholder as
fallback if any file is missing).

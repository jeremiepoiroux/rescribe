# Rescribe

A browser tool to **clean up AI-generated interview transcripts** — 100% local, no server, nothing ever uploaded. Built for the "second pass": you already have a machine transcription, and you fix it while listening back, attributing each turn to a speaker. Inspired by [oTranscribe](https://otranscribe.com), reworked for cleanup rather than transcribing from scratch.

Deployable to GitHub Pages (or any static host) and installable as an offline PWA. Interface is bilingual **English / French** (toggle in the top bar). Idea by Jérémie Poiroux.

## Features

### Playback
- Audio/video player with speed control (0.5×–2×) and adjustable skip step (2 / 5 / 10 s).
- **Audio-first**: when the source is a video, the picture is hidden by default; a toggle reveals it.
- **Pause-rewind**: pressing Esc (or the play button) to pause rewinds a configurable 0 / 1 / 2 s, so you resume just before where you stopped.
- **Progress bar** with elapsed/total time, percentage, and milestones at quarters and thirds. Click or drag to seek — clicking also jumps the text to the matching timecode. A **Last TC** button jumps to the most recent marker.

### Editing
- **Timecoded speaker turns**: press <kbd>⌘J</kbd> (or the Timecode button), pick who's speaking, and a single clickable `[12:34] Name` item is inserted. Click the timecode to jump playback there. Defining no speaker (or having none) inserts a plain timecode.
- **Talk-time statistics**: a panel computes each speaker's total speaking time and share, derived from the turn markers.
- **Annotations**: type `#` (or the Annotation button) to insert `[cut]` / `[coupé]`, `[inaudible]`, `[redacted]`. Jump to the next/previous annotation to fill, and a counter shows how many remain.
- **Replace** free text (find → replace, next / all).
- **Paste as plain text**: pasting a transcript strips all formatting (clean import from web AI tools).
- **Pause markers** to bookmark where you stopped, and a **Reset** button to start a fresh transcription.
- **Adjustable body text size** (A− / A+) for long sessions.

### Context & reuse
- **Context header** (required before exporting document files): interview title (also the export filename) and study title, a date picker (defaults to today), a Video call / In person switch, transcribed-by, plus any number of **custom free fields**. Speakers and recording duration are added automatically. It becomes the header of every exported document.
- **Context templates**: save the current context + speakers under a name and reapply it to the next transcript in one click.

### Saving
- Automatic to `localStorage` on every keystroke (session restored on reload).
- **Disk auto-save**: pick a `.rescribe.json` file once, then it's rewritten automatically every 2 minutes and on <kbd>⌘S</kbd> (Chrome/Edge; falls back to localStorage + manual export elsewhere).

## Keyboard shortcuts

On Mac use <kbd>⌘</kbd>, on Windows/Linux <kbd>Ctrl</kbd>. On Mac, <kbd>F1</kbd>/<kbd>F2</kbd> may require <kbd>fn</kbd>. <kbd>Esc</kbd> works even while typing.

| Action | Shortcut |
|---|---|
| Play / Pause (with pause-rewind) | <kbd>Esc</kbd> |
| Rewind / Forward | <kbd>F1</kbd> / <kbd>F2</kbd> |
| Timecode + speaker | <kbd>⌘</kbd><kbd>J</kbd> |
| Insert an annotation | type <kbd>#</kbd> |
| Save the project to disk | <kbd>⌘</kbd><kbd>S</kbd> |

Other actions (annotations, next/previous, replace) are on the toolbar. Rich-text shortcuts (<kbd>⌘B/I/U</kbd>) are intentionally disabled to keep the text clean.

## File formats

### Importable media
Anything the browser can decode: `.mp3`, `.wav`, `.m4a`, `.aac`, `.ogg`, `.opus`, `.flac`, `.webm` (audio) and `.mp4`, `.webm`, `.mov`, `.m4v` (video). Codec support depends on the browser.

### Importable text / project
- `.rescribe.json` — **full project**: text, speakers, context, settings (re-editable identically).
- `.txt`, `.md` — plain text into the editor.
- `.docx`, `.odt` — Word / OpenDocument, text extracted locally (unzipped in-browser, nothing uploaded). The old binary `.doc` isn't supported — save it as `.docx`.
- `.html` — HTML content (turns/timecodes preserved if it came from a Rescribe export).

### Exports
- **Project** `.rescribe.json` — re-importable, keeps everything (no required context).
- **Text** `.txt`, **Markdown** `.md`, **HTML** `.html` — document outputs, prefixed with the context header. These require the context to be filled (title, date, transcribed-by).

## Run it locally

**Easiest (macOS):** double-click `start.command`. It serves the folder over `http://localhost` and opens your browser. Keep the window open while you work. (First time: right-click → Open to bypass Gatekeeper.)

**Manual:**
```bash
cd rescribe
python3 -m http.server 8000
# open http://localhost:8000
```

Opening `index.html` directly (`file://`) works for the core workflow, but the **service worker** (offline) and **disk auto-save** need `http://localhost` or HTTPS.

## Deploy to GitHub Pages

Upload the files to a repo (web UI or git), then *Settings → Pages → Branch `main` / root*. Pages serves over HTTPS, required for the service worker and disk auto-save. `index.html` must be at the repo root.

The service worker is **network-first for the app shell**, so a redeploy is picked up automatically when online — no hard-refresh or cache-version bump needed.

## Changelog

### v1.3.0
- **Compact merged top bar**: brand, transport, speed (− / +), and progress in one bar that always stays fixed (only the middle scrolls). Font size, language, help, theme toggle, and the **New transcription** button moved to the bottom bar.
- **Light / dark theme toggle** (overrides the system preference), and a **back-to-top** button.
- **Pause** is now a toggle: press it to bookmark where you stopped (media pauses), press again to jump back and resume.
- Loaded media filename shown in the bottom bar; **Save** sits next to **Export**; **Find & replace** button relabeled; the redundant next/previous buttons removed.
- **Context revamp**: separate **interview title** (used for the export filename) and study title; **date** as a calendar picker defaulting to today; location replaced by a **Video call / In person** switch; free custom fields kept.
- **Timecode navigation**: click the progress bar to jump to the matching timecode in the text (the one just before that point), plus a **Last TC** button to jump to the most recent marker.
- **Pause markers** to bookmark where you stopped transcribing.
- **Milestones** at 1/3 and 2/3 in addition to the quarters.
- Typing `@` also inserts a timecode + speaker; the ⌘J speaker popup anchors under the caret; **Esc** now always plays/pauses even while the popup is open (it closes it too).
- Imports **append** below existing text; copy-paste **preserves timecodes**; external paste keeps spacing (e.g. after a colon).
- Continuous save writes on **every change**; version and build date shown in Help.
- Imported filename shown (without extension) in the bottom bar.

### v1.0.0
- Typing `@` is now an alias for ⌘J (timecode + speaker).
- Imports **append** below existing text instead of replacing it.
- Copy-paste now **preserves timecoded turns** (internal paste keeps the `[mm:ss]` markers; external rich paste stays plain).
- Continuous save writes **on every change** (near-instant) once a file is linked; speaker popup now anchors under the caret.
- **Word / OpenDocument import** (`.docx`, `.odt`) — unzipped and text-extracted locally in the browser.
- Media-import confirmation toast; talk-time **statistics moved into the Help panel**.
- Clearer **"Continuous save…"** label (auto-save to a linked file) vs the one-off project export, plus a one-time, dismissible prompt to set it up when media is loaded (Chromium only).
- **Custom annotations**: type `#word` and pick "Create [word]" to add your own annotation tags (remembered for next time).
- Welcome/tutorial text in the empty editor.
- Removed the raw-minute labels under the progress bar.
- Timecodes and speakers merged into a single **timecoded turn** (⌘J → pick speaker).
- **Talk-time statistics** per speaker.
- **Context header** made mandatory before document export; added **custom free fields** and **context templates**.
- **Pause-rewind** (0/1/2 s) on Esc.
- Progress-bar milestones realigned, with **raw minutes** under each timestamp.
- Replace simplified to free text only.
- Removed open/close/loop markers and the experimental cleanliness score.
- Minimal, non-conflicting shortcuts (Esc, ⌘J, F1/F2, ⌘S); rich-text shortcuts disabled.
- Help panel with an about section, GitHub link, and version.
- Service worker switched to network-first for the HTML shell.

### Earlier
- Bilingual FR/EN interface, audio-first video handling, drag-and-drop, adjustable text size.
- `@`/`#` insertion menus, interviewer pinning.
- Plain-text paste, disk auto-save via the File System Access API, PWA/offline.
- Initial release: player, clickable timecodes, localStorage autosave, txt/md export — an oTranscribe-style base.

## Roadmap

- A first **automated analysis / summary** of the interview (will require calling a language model — design TBD).

## Privacy

No data ever leaves the machine. No analytics, no third-party requests beyond loading the page itself.

## Credits

Idea by Jérémie Poiroux. Inspired by [oTranscribe](https://otranscribe.com) by Elliot Bentley. Rescribe is an independent reimplementation focused on cleaning up existing transcripts; it shares no code with oTranscribe.

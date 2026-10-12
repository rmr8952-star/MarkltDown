# MarkItDown

This repo is set up to convert files to Markdown with Microsoft's
[MarkItDown](https://github.com/microsoft/markitdown) (`markitdown[all]`).
A SessionStart hook (`.claude/hooks/session-start.sh`) installs it automatically.

## When the user asks to convert a file to Markdown

1. Make sure the tool exists: `command -v markitdown || pip3 install 'markitdown[all]'`.
2. Find the file (usually in `input/`, or the path/URL the user gives).
3. Convert: `markitdown "<file>" -o "output/<name>.md"`
   (URLs and YouTube links work too: `markitdown "<url>" -o output/<name>.md`).
4. Show the user the result and the output path. Commit and push the output
   if the user wants to keep it.

Supported: PDF, Word (.docx), PowerPoint (.pptx), Excel (.xlsx/.xls), HTML,
CSV, JSON, XML, images (EXIF metadata), audio (transcription), ZIP, EPUB,
Outlook .msg, YouTube URLs.

The user writes in Arabic; reply in Arabic.

## How the design tools get installed

Cloud sessions start in a fresh container, so nothing installed by hand
survives to the next session. Installs are automatic:

- **Impeccable plugin**: declared in `.claude/settings.json`
  (`extraKnownMarketplaces` + `enabledPlugins`). Claude Code installs and
  loads it at startup. Keep it there: plugins load *before* the SessionStart
  hook runs, so a plugin installed only by the hook is not available until the
  next Claude start, which a fresh cloud container never gets.
- **taste-skill and Emil Kowalski skills**: installed into `~/.claude/skills`
  by `.claude/hooks/session-start.sh`. Skills added there are picked up in
  the same session.
- The hook skips anything already installed, retries failed installs 3 times,
  then falls back (skills: `git clone` and copy; plugin: add it to
  `~/.claude/settings.json`). Failures only warn and never block the session;
  they are logged to `~/.claude/session-start-install.log`. Check that log if
  a skill or `/impeccable` is missing.

The manual install commands below are only for when the automatic install
failed.

## Design requests (taste-skill)

For any design request (website, landing page, UI, app screen, dashboard,
redesign, brand kit, design image), first load the matching taste-skill skill
with the Skill tool, before writing code or generating images:

- Default for frontend/web pages: `design-taste-frontend`
- Improving an existing site/app: `redesign-existing-projects`
- Requested style: `minimalist-ui`, `industrial-brutalist-ui`, `high-end-visual-design`, `gpt-taste`
- Building from an image/mockup: `image-to-code`
- Design images: `imagegen-frontend-web`, `imagegen-frontend-mobile`, `brandkit`
- Google Stitch DESIGN.md: `stitch-design-taste`

If these skills are missing (see the install log), install them manually:
`cd ~ && npx -y skills add https://github.com/Leonxlnx/taste-skill -g -a claude-code -y`

### Emil Kowalski skills (polish and motion)

Alongside the taste-skill skill, load the matching Emil Kowalski skill:

- Any UI/component work (polish, details): `emil-design-eng`
- Adding animation or transitions (web): `animate`; React Native/Expo: `animate-expo`
- Reviewing existing motion: `review-animations`; whole-codebase audit: `improve-animations`
- Where motion could help: `find-animation-opportunities`
- Janky/slow animations: `animation-performance`
- Gestures, springs, sheets, Apple-style UI: `apple-design`
- Mobile web / PWA feel: `mobile-native`
- Several variants to compare: `prototype`
- Stress-testing a component with worst-case data: `break-ui`
- Choosing a UI library: `pick-ui-library`; Sonner toasts: `ask-sonner`
- Naming a motion effect: `animation-vocabulary`; Swift code: `write-swift`

If these skills are missing (see the install log), install them manually:
`cd ~ && npx -y skills@latest add emilkowalski/skills -g -a claude-code -y`

### Impeccable plugin (review and refine)

Use the Impeccable plugin skill (`impeccable`) alongside the skills above:

- Before building: `/impeccable shape` to plan the design direction
- After building, before delivering: `/impeccable critique` and `/impeccable audit`, then fix what they find
- Targeted refinements: `/impeccable polish`, `typeset`, `colorize`, `layout`, `animate`, `bolder`, `quieter`, `adapt`, `harden`, `optimize`

If the plugin is missing (see the install log), install it manually; it loads
in the next Claude start:
`claude plugin marketplace add pbakaus/impeccable --scope user && claude plugin install impeccable@impeccable --scope user`

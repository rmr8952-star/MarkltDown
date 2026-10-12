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

If these skills are missing, install them first:
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

If these skills are missing, install them first:
`cd ~ && npx -y skills@latest add emilkowalski/skills -g -a claude-code -y`

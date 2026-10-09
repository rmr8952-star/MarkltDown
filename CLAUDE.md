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

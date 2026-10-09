# MarkltDown

تحويل أي ملف إلى Markdown باستخدام أداة [MarkItDown](https://github.com/microsoft/markitdown) من Microsoft.

## الاستخدام

1. ارفع الملف إلى مجلد `input/` (أو أعطِ Claude رابطاً).
2. اطلب من Claude: «حوّل الملف X إلى Markdown».
3. ستجد النتيجة في مجلد `output/`.

## الصيغ المدعومة

PDF، Word، PowerPoint، Excel، HTML، CSV، JSON، XML، الصور، الصوت، ZIP، EPUB، رسائل Outlook، وروابط YouTube.

## يدوياً

```bash
pip install 'markitdown[all]'
markitdown input/file.pdf -o output/file.md
```

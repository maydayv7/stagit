import pygments
from pygments import highlight
from pygments.formatters import HtmlFormatter
from pygments.lexers import guess_lexer, guess_lexer_for_filename
from sys import stdin, stderr

filename = stdin.readline().strip()
contents = stdin.read()
lexer = None

try:
    lexer = guess_lexer_for_filename(filename, contents)
except pygments.util.ClassNotFound:
    try:
        lexer = guess_lexer(contents)
    except pygments.util.ClassNotFound:
        pass

if lexer is None:
    from pygments.lexers import TextLexer

    lexer = TextLexer()

rendered = None
if lexer.__class__ is pygments.lexers.MarkdownLexer:
    from markdown import markdown

    rendered = markdown(
        contents,
        extensions=[
            "codehilite",
            "extra",
            "sane_lists",
            "smarty",
            "pymdownx.tasklist",
            "pymdownx.arithmatex",
        ],
        extension_configs={"pymdownx.arithmatex": {"generic": True}},
    )

FORMAT = HtmlFormatter(
    style="murphy",
    cssclass="highlight",
    linenos="table",
    lineanchors="loc",
    anchorlinenos=True,
    linespans="line",
)

if rendered:
    print("<h3>Rendered</h3>")
    print('<article class="markup markdown">')
    print(rendered)
    print("</article>")
    print("<br /><h3>Code</h3>")

print('<div id="blob">')
print(highlight(contents, lexer, FORMAT))
print("</div>")

print("Filename: {}; Lexer: {}.".format(filename, lexer), file=stderr)
if rendered:
    print("Markdown was rendered in addition.", file=stderr)

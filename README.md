# UCL Quarto presentation template

Quarto formats for HTML (reveal.js) and PDF (LaTeX beamer) slides that follow
the official `UCL-PowerPoint-Template-UCL-Sans-2.3.pptx` (layout, colours,
type sizes, logos, UCL Sans).

## Installation

Quarto has no global extension folder. It looks for `_extensions/` next to the
document or in its project. Keep this folder (or a git repo of it) as the master
copy and bring it into each project in one of these ways. Below,
`/path/to/ucl-arc-template` can also be a GitHub `<org>/<repo>`.

**New talk from the template** (copies the extension and a starter `.qmd`):

```bash
mkdir my-talk && cd my-talk
quarto use template /path/to/ucl-arc-template
```

**Add to an existing project** (copies only `_extensions/ucl/`; re-run to update):

```bash
quarto add /path/to/ucl-arc-template
```

**Share one copy via a symlink** (updates apply everywhere, but only on this machine):

```bash
mkdir -p _extensions
ln -s /path/to/ucl-arc-template/_extensions/ucl _extensions/ucl
```

## Use

In your document's YAML:

```yaml
format:
  ucl-revealjs: default   # HTML slides
  ucl-beamer: default     # PDF slides (needs a TeX distribution with XeLaTeX)
```
To render the presentation:

```bash
quarto render talk.qmd                  # both formats
quarto render talk.qmd --to ucl-revealjs  # HTML only
quarto render talk.qmd --to ucl-beamer    # PDF only
quarto preview talk.qmd                 # live preview while editing
```

`template.qmd` shows every layout. A document in a subfolder finds the
extension if the folder above has a `_quarto.yml` (a Quarto project).

## Slide types

The same markdown works in both formats.

| Markdown               | PowerPoint layout                                      |
|------------------------|--------------------------------------------------------|
| YAML title block       | Simple_Title: dark purple, bright band, large logo     |
| `# Heading`            | Divider: dark purple with two bright-purple stripes    |
| `## Heading`           | Simple_Content: off-white, dark purple title           |
| `## Heading {.dark}`   | Simple_Content dark_mode: mid purple title, off-white text |
| `## Heading {.stripe}` | Content with narrow bright-purple band on the left     |
| `## Heading {.divider}`| Divider layout for a level-2 slide                     |
| `{.no-logo}`           | Hide the logo on a slide (e.g. full-bleed images)      |

Full-page image slides (HTML only): `## {background-image="photo.jpg" .no-logo}`.

Utility classes: `.subheading` (30pt), `.accent`, `.small` (both formats); `.callout-box` (HTML only).

Set footer text with `footer:` in the YAML (both formats).

## LaTeX beamer without Quarto

`_extensions/ucl/beamer/` is a self-contained beamer theme (`ucl2025`) with
the fonts and logos. Compile with XeLaTeX or LuaLaTeX; see `example.tex`.

```latex
\documentclass[aspectratio=169]{beamer}
\usetheme[path=ucl-beamer/]{ucl2025}     % path to the folder, if not alongside
\renewcommand{\uclfooter}{Footer text}

\begin{frame}[dark]{...}      % also: stripe, divider, nologo
```

To use `\usetheme{ucl2025}` from any `.tex` file without `path=`, install it
once into your personal texmf tree (macOS path shown; see `kpsewhich -var-value TEXMFHOME`):

```bash
mkdir -p ~/Library/texmf/tex/latex/ucl2025 ~/Library/texmf/fonts/truetype/ucl2025
cd /path/to/ucl-arc-template/_extensions/ucl/beamer
cp beamerthemeucl2025.sty ucl-logo-*.png ~/Library/texmf/tex/latex/ucl2025/
cp UCLSans-*.ttf OFL.txt ~/Library/texmf/fonts/truetype/ucl2025/
```

The theme is named `ucl2025` so it doesn't clash with the older banner-style
UCL beamer theme (`ucl`).

## Data visualisation colours

Use in this order (dark/light alternate so neighbours contrast). They're also
available as CSS variables `--ucl-viz-1` … `--ucl-viz-8` and LaTeX colours
`uclviz1` … `uclviz8`.

```
#361A54 dark purple   #1AAB40 light green   #12239E dark blue   #E66C37 light orange
#10433F dark green    #118DFF light blue    #751441 dark red    #E645AB light pink
```

## UCL Sans font

You don't need to install UCL Sans to use this template. The weights it uses
are bundled: WOFF2 in `_extensions/ucl/fonts` for HTML (Regular, SemiBold,
Bold and italics), and TTF in `_extensions/ucl/beamer` for PDF (Regular,
SemiBold and italics). Install it only if you want it in other
applications (PowerPoint, Word, figures made in R or Python), or want weights
the template doesn't bundle (ExtraLight, Light, Medium).

**Source:** the full family (OTF and TTF) is on the UCL Image Store, which
needs a UCL sign-in:
https://imagestore.ucl.ac.uk/imagestore/start/ucl-new-templates/UCL/UCL%20Fonts

**Licence:** UCL Sans is by Colophon Foundry and is based on DM Sans
(Copyright 2014 The DM Sans Project Authors). It is licensed under the
[SIL Open Font License 1.1](https://openfontlicense.org), which allows the
fonts to be used, bundled and redistributed with other software (as here), but
not sold on their own. The licence text is in `_extensions/ucl/fonts/OFL.txt`
and must stay with any copy of the font files.

**Installing** (unzip the download first; use either the OTF or the TTF files, not both):

- **macOS:** double-click each file and click *Install* in Font Book, or
  `cp UCLSans-*.otf ~/Library/Fonts/`
- **Windows:** select the files, right-click and choose *Install* (or
  *Install for all users*, which needs admin rights).
- **Linux:** `mkdir -p ~/.local/share/fonts && cp UCLSans-*.otf ~/.local/share/fonts/ && fc-cache -f`

Restart any open applications so they see the new font. 

## Notes

- **Font:** see [UCL Sans font](#ucl-sans-font). The bundled copies work
  offline and on machines without UCL Sans installed.
- **Logos:** taken from the PowerPoint template (`_extensions/ucl/assets`).
  The UCL logos are trademarks of UCL and are not covered by the MIT licence;
  use them in line with UCL's brand guidelines.
- The beamer theme uses the TTF fonts and logo PNGs in `_extensions/ucl/beamer`.
- For HTML, fonts and logos are inlined into `ucl-assets.scss`. If you change any of
  them, run `python3 _extensions/ucl/make-assets.py`.

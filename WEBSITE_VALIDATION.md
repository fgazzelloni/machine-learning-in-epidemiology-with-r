# Website validation — 12 October 2026

- Full root `quarto render --clean`: passed, including both executed notebooks and eight guide pages (13 rendered pages in total).
- Checked 561 local link/asset references in rendered HTML: none missing; no links to raw Markdown or Quarto source.
- Part 1 presentation: all 12 slide images, stylesheet, navigation script and PowerPoint copied. Followed the notebook link, advanced to slide 2, used the End key to reach slide 12, and returned to the notebook.
- Browser checks on desktop and narrow mobile layouts: no document overflow on the inspected pages. Notebook images are 85% of the reading column, centred; the slide viewer uses 90% of its stage.
- Navigation and presentation buttons use the shared navy palette with readable contrast. Website guides inherit the same Flatly theme and shared stylesheet.
- Part 2 code appears at the tree, evaluation and resampling teaching steps. Numerical core output CSVs are unchanged from the preceding validated run.
- Canonical README and evidence Markdown files remain available for GitHub; Quarto includes them in styled guide pages. The original 28 September 2026 workshop repository is untouched.

A live Quarto preview was paused during the final clean build to avoid concurrent output moves, then resumed. These checks cover the local website; GitHub Pages deployment was not changed.

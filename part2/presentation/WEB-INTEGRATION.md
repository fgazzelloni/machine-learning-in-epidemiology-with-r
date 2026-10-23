# Part 2 browser integration

23 October 2026

## Source and preservation

The viewer uses `updated-workshop/heart-data-neural-networks.pptx` and its matching
PDF: 19 main slides and 10 optional appendix slides. Both supplied files and the
older deck/PDF remain unchanged. Part 1 files remain unchanged.

## Files

- `index.html`: viewer with notebook return link and PDF download.
- `presentation.js`: slide titles/text, previous/next, keyboard, swipe, hash links,
  slide picker and native/fallback fullscreen with an exit button.
- `styles.css`: Part 1 viewer styling with responsive controls and fullscreen alignment.
- `slides.json`: extracted titles, main/appendix labels and text alternatives.
- `slides/slide-01.png` through `slide-29.png`: consistently sized 1600 × 900 exports.
- `../../_quarto.yml`: resource inclusion for this viewer, images and current downloads.
- `../ml-workflow-2.qmd`: presentation button and PDF download buttons, matching Part 1.
- Rendered copies are under `_site/part2/`; Quarto also updates `_site/search.json`.

## Local checks

- `quarto render part2/ml-workflow-2.qmd` completed using saved results.
- JavaScript syntax check passed.
- Visually inspected all 29 exported slides and desktop/phone page screenshots.
- Browser checks passed at 1440 × 1000 and 390 × 844 in Chrome with Playwright.
- All 29 slides loaded at the expected dimensions in both viewports.
- Tested notebook launch button, previous/next, keyboard, picker, direct links,
  reload/history, invalid hash handling and return to notebook.
- Tested native fullscreen entry/exit and fallback entry/exit.
- Tested swipe using synthetic browser touch events in the phone context.
- The PDF download completed. No horizontal overflow or JavaScript errors occurred.
- All 34 required viewer resources exist in the rendered site.
- File hashes confirm preservation of pre-existing Part 1 and presentation files.

These are local browser checks, not tests on a physical phone or in Safari.
No publication, upload or model retraining was performed. No integration blockers remain.
The existing appendix deep-tree figure is intended as a structural overview;
use the R plot for leaf-level reading.

## Preview

Notebook: http://127.0.0.1:8786/part2/workshop-part-2-trees-to-neural-networks.html

Viewer: http://127.0.0.1:8786/part2/presentation/index.html

From the repository root, restart if needed with:

```sh
python3 -m http.server 8786 --bind 127.0.0.1 --directory _site
```

## Refreshing slide exports

Export the matching PDF after any deck revision:

```sh
pdftoppm -png -scale-to-x 1600 -scale-to-y 900 \
  part2/presentation/updated-workshop/heart-data-neural-networks.pdf \
  part2/presentation/slides/slide
```

If the slide order, titles or text change, update `slides.json` and the inline
`slides` array in `presentation.js`, then refresh the notebook's slide counts.
Re-render the affected page and repeat the browser checks.

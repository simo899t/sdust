# Changelog

## 0.2.0 — 2026-10-28

- New `basic` template: title, subtitle, authors and date above the body, no cover page.
- New `research` template: arXiv/ICML-style two-column paper.
- `date` now defaults to `none` on every template and is only shown when set.
- Author and supervisor arrays are joined with commas and a final "&".
- `thesis`: `department` accepts an array, stacked one per line.
- `exercise` and `assignment` take `subtitle`.
- `project` and `submission` take `info-width`; `project` takes `author-dots`; `submission` takes `course` and `group`.
- `block` takes `header-fill` and `body-fill`.
- Breaking: `boxed` takes `stroke` (thickness) and `stroke-color` instead of a full stroke.
- Parameter manual in `docs/manual.pdf`.

## 0.1.0 — 2026-09-07

Initial public release of `sdust`, an SDU-branded Typst package for academic documents.
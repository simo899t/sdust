# Changelog

All notable changes to `sdust` are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **sdust is now an SDU-branded frontpage package.** All cover pages use the
  SDU layout, SDU red accent, and default to "University of Southern Denmark".
- Page size switched from US Letter to A4.
- Manifest reframed: description, keywords, categories.

### Security / licensing
- The SDU logo is **not bundled** — it is a controlled brand asset
  (`grafiskcenter@sdu.dk`). Cover pages draw no logo unless you pass one via
  `logo: image("sdu-logo.png", …)`; `logo:` defaults to `none`. Removed the
  `sdu-logo` constant and the `assets/` directory from the package.

### Added
- `thesis` template — Bachelor's / Master's thesis title page (title,
  subtitle, author(s), supervisor(s), department, programme, date).
- Faculty of Science department name constants: `imada`, `bmb`, `biology`,
  `fkf` — pass one as `department:`.

### Removed
- `plot2d` / `plot3d` / `formula` / `tree` / `pseudo` / `graph` / `tex`
  helpers moved to the new **`utilst`** package. Theorem-style cards and
  `question` / `answer` stayed here.

### Fixed
- `proof` block dropped its body (passed an empty `[]` to the card helper);
  it now renders its content and appends the QED tombstone.

## [0.1.0] - 2026-07-12

### Added
- Initial release: `note`, `exercise`, `assignment`, `exam`, `project`,
  `submission`, `chi` templates; `theorem`/`definition`/`example`/`proof`/
  `corollary`/`block` cards; diagram, plot, pseudocode, and word-count helpers.

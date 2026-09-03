# Changelog

All notable changes to `sdust` are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- `proof` block dropped its body (passed an empty `[]` to the card helper);
  it now renders its content and appends the QED tombstone.

### Changed
- Manifest prepared for Typst Universe: `categories`, `disciplines`,
  `compiler`, and `exclude` corrected; `README.md` no longer excluded.

## [0.1.0] - 2026-07-12

### Added
- Initial release: `note`, `exercise`, `assignment`, `exam`, `project`,
  `submission`, `chi` templates; `theorem`/`definition`/`example`/`proof`/
  `corollary`/`block` cards; diagram, plot, pseudocode, and word-count helpers.

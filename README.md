# sdust

SDU-branded document frontpages for Typst — ready-to-use title pages plus
sane base styling for coursework at the University of Southern Denmark:
`thesis`, `note`, `exercise`, `assignment`, `project`, `submission`, `exam`,
and `chi`.

Every cover page uses the SDU layout, SDU red accent, A4, and defaults to
"University of Southern Denmark".

**The SDU logo is not bundled.** It's a controlled brand asset
(`grafiskcenter@sdu.dk`), so no logo is drawn unless you pass one:

```typst
#show: thesis.with(
  logo: image("sdu-logo.png", width: 12em),   // download from SDUnet
  ...
)
```

Pass `logo: none` (the default) for no logo at all.

Plotting, trees, pseudocode and node graphs live in
[utilst](https://github.com/simo899t/utilst). Personal math notation lives
in [tempst](https://github.com/simo899t/tempst), which builds on both.

## Installation (local development)

Clone the repo, then symlink it into Typst's local package registry for
your OS:

| OS | Local package registry |
|---|---|
| macOS | `~/Library/Application Support/typst/packages/local` |
| Linux | `~/.local/share/typst/packages/local` (or `$XDG_DATA_HOME/typst/packages/local`) |
| Windows | `%APPDATA%\typst\packages\local` |

**macOS:**
```bash
git clone https://github.com/simo899t/sdust ~/GitHub/sdust
mkdir -p ~/Library/Application\ Support/typst/packages/local/sdust
ln -s ~/GitHub/sdust ~/Library/Application\ Support/typst/packages/local/sdust/0.1.0
```

**Linux:**
```bash
git clone https://github.com/simo899t/sdust ~/GitHub/sdust
mkdir -p ~/.local/share/typst/packages/local/sdust
ln -s ~/GitHub/sdust ~/.local/share/typst/packages/local/sdust/0.1.0
```

**Windows (PowerShell, run as Administrator for symlinks):**
```powershell
git clone https://github.com/simo899t/sdust $HOME\GitHub\sdust
New-Item -ItemType Directory -Force -Path "$env:APPDATA\typst\packages\local\sdust"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\typst\packages\local\sdust\0.1.0" -Target "$HOME\GitHub\sdust"
```

Or once published, just:

```typst
#import "@preview/sdust:0.1.0": *
```

## Usage

**Without cover page:**
```typst
#import "@local/sdust:0.1.0": *
#show: pageSetup
```

**With cover page:**
```typst
#import "@local/sdust:0.1.0": *
#show: note.with(
  title: "...",
  course: "DM000 — Course Name",
  author: "...",
  date: "..."
)
```

## Templates

| Function | Description |
|---|---|
| `pageSetup` | Base styling, no cover page |
| `thesis` | Bachelor's / Master's thesis title page |
| `note` | Lecture notes |
| `exercise` | Exercise sheets |
| `assignment` | Assignments |
| `project` | Group/solo project reports |
| `submission` | Lightweight hand-in (title card only, no TOC) |
| `exam` | Exam submissions |
| `chi` | ACM CHI paper format |

Also exported: `base-style`, `code-style`, `simple-code`, `bib`,
`word-count` / `total-words`, the branding constants `sdu-red` and
`sdu-university`, and the Faculty of Science department names
`imada`, `bmb`, `biology`, `fkf` (pass one as `department:` on `thesis`).

## Theorem-style cards

`theorem`, `definition`, `example`, `proof`, `corollary`, `block` (the `QED`
tombstone too), plus the exercise cards `question` / `answer` — coloured
titled cards, e.g. `#theorem(title: "Theorem 1")[...]`.

## Plotting and other helpers

`plot2d` / `plot3d` / `formula`, `tree`, `pseudo`, `graph`, `tex` live in
[utilst](https://github.com/simo899t/utilst).

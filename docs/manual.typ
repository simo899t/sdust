// Source for manual.pdf — rebuild after changing any template signature.
#import "../lib.typ": *

#show: basic.with(
  title: "sdust parameter manual",
  subtitle: "Every parameter of every template and blocks",
  course: "sdust 0.2.0",
  author: "by Simon Holm",
  outline: true,
  outline-depth: 1
)

#let params(..rows) = std.block(breakable: false, table(
  columns: (auto, auto, auto, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 0.8pt + sdu-red) } else { (bottom: 0.3pt + luma(210)) },
  inset: (x: 6pt, y: 5pt),
  align: left + horizon,
  table.header([*Parameter*], [*Type*], [*Default*], [*Description*]),
  ..rows.pos().flatten().map(c => if type(c) == str { raw(c) } else { c }),
))

#set text(size: 11pt)
#show table: set text(size: 9.5pt)
#show table: set par(justify: false)
// Narrower margins than the cover page so the four-column tables fit;
// changing the page settings also starts the new page.
#set page(margin: (x: 2cm, top: 2.5cm, bottom: 2.5cm))
= Conventions
The body is the last positional argument, `#note(..)[body]`, or use `#show: note.with(..)`.

Wherever `author` or `supervisor` is accepted it may be a string or an array of strings; arrays are joined with commas and a final "&", and the label is pluralised. `date` may be a string or any content, e.g. `datetime(..).display()`.

Shared defaults:
#table(
  columns: (auto, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 0.8pt + sdu-red) } else { (bottom: 0.3pt + luma(210)) },
  inset: (x: 6pt, y: 5pt),
  table.header([*Constant*], [*Value*]),
  `default-title`, `"Untitled Document"`,
  `default-author`, `"Firstname Lastname"`,
  `default-course`, `"DM000"`,
  `sdu-university`, `"University of Southern Denmark"`,
)

= page-setup
No parameters. A4 with 3 cm side and 2 cm top/bottom margins, plus `base-style`.

= thesis
#params(
  ("title", "string", "default-title", [Thesis title]),
  ("subtitle", "string", "none", [Small-caps subtitle under the title]),
  ("author", "string | array", "default-author", [Thesis author(s)]),
  ("supervisor", "string | array", "none", [Thesis supervisor(s)]),
  ("department", "string | array", "none", [University department(s). Presets: `imada`, `bmb`, `biology`, `fkf`]),
  ("programme", "string", "none", [Red label above the title (default "THESIS")]),
  ("university", "string", "sdu-university", [University name]),
  ("date", "string", "none", [Date of thesis release]),
  ("logo", "content", "none", [Custom image e.g. `image("sdu-logo.png", width: 12em)`]),
  ("outline", "bool", "true", [Table of contents after the cover]),
  ("outline-depth", "int", "none", [Max heading depth in the outline]),
)

= note
#params(
  ("title", "string", "default-title", [Note title]),
  ("subtitle", "string", "none", [Italic subtitle under the title]),
  ("author", "string | array", "default-author", [Note author(s)]),
  ("supervisor", "string | array", "none", [Lecturer(s) or supervisor(s)]),
  ("course", "string", "default-course", [Course name or code]),
  ("date", "string", "none", [Date of the note]),
  ("logo", "content", "none", [Custom image e.g. `image("sdu-logo.png", width: 12em)`]),
  ("outline", "bool", "true", [Table of contents after the cover]),
  ("outline-depth", "int", "none", [Max heading depth in the outline]),
)

= exercise and assignment
Both take the same parameters as `note`.

= project
#params(
  ("title", "string", "default-title", [Project title]),
  ("subtitle", "string", "none", [Italic subtitle under the title]),
  ("author", "string | array", "default-author", [Project author(s); array items may be strings or `(name:, email:)` dicts]),
  ("course", "string", "default-course", [Course name or code]),
  ("date", "string", "none", [Date of hand-in, in the info box]),
  ("group", "string", "none", [Group name or number, in the info box]),
  ("supervisor", "string | array", "none", [Project supervisor(s), in the info box]),
  ("university", "string", "sdu-university", [University name]),
  ("logo", "content", "none", [Custom image e.g. `image("sdu-logo.png", width: 12em)`]),
  ("abstract", "content", "none", [Abstract shown on the cover]),
  ("keywords", "string | array", "none", [Keywords under the abstract]),
  ("outline", "bool", "true", [Table of contents after the cover]),
  ("outline-depth", "int", "none", [Max heading depth in the outline]),
  ("info-width", "relative", "60%", [Width of the info box]),
  ("author-dots", "bool", "false", [Authors on one line joined by `" · "` instead of a grid]),
)

= basic
The simplest template: title, authors and date above the body on the first page.
#params(
  ("title", "string", "default-title", [Document title]),
  ("subtitle", "string", "none", [Italic subtitle under the title]),
  ("author", "string | array", "default-author", [Document author(s)]),
  ("date", "string", "none", [Date of the document]),
  ("outline", "bool", "false", [Table of contents under the title]),
  ("outline-depth", "int", "none", [Max heading depth in the outline]),
)
#pagebreak()
= submission
A title card only: no cover page or outline, the body starts on the same page.
#params(
  ("title", "string", "default-title", [Submission title]),
  ("subtitle", "string", "none", [Italic subtitle under the title]),
  ("author", "string | array", "none", [Submission author(s)]),
  ("supervisor", "string | array", "none", [Supervisor(s), in the info box]),
  ("institution", "string", "sdu-university", [Institution name, in the info box]),
  ("date", "string", "none", [Date of hand-in, in the info box]),
  ("logo", "content", "none", [Custom image e.g. `image("sdu-logo.png", width: 12em)`]),
  ("course", "string", "none", [Course name or code, under the title]),
  ("group", "string", "none", [Group name or number, under the authors]),
  ("info-width", "relative", "70%", [Width of the info box]),
)

= exam
The page header (author · username · student number) appears when `username` or `student-number` is set.
#params(
  ("title", "string", "default-title", [Exam title]),
  ("subtitle", "string", "none", [Italic subtitle under the title]),
  ("author", "string | array", "default-author", [Exam author(s); array items may be strings or `(name:, id:)` dicts]),
  ("course", "string", "default-course", [Course name or code]),
  ("date", "string", "none", [Date of the exam, in the info box]),
  ("username", "string", "none", [Student username, in the page header]),
  ("student-number", "string", "none", [Student number, in the page header]),
  ("student-id", "string", "none", [Currently unused]),
  ("duration", "string", "none", [Exam duration, in the info box]),
  ("allowed-aids", "string", "none", [Allowed aids, in the info box]),
  ("supervisor", "string | array", "none", [Examiner(s) or supervisor(s), in the info box]),
  ("university", "string", "sdu-university", [University name]),
  ("logo", "content", "none", [Custom image e.g. `image("sdu-logo.png", width: 12em)`]),
  ("outline", "bool", "true", [Table of contents after the cover]),
  ("outline-depth", "int", "none", [Max heading depth in the outline]),
)

#pagebreak()
= research
arXiv/ICML-style paper. With a single affiliation, every author is tagged with it automatically.
#params(
  ("title", "string", "default-title", [Paper title]),
  ("subtitle", "string", "none", [Italic subtitle under the title]),
  ("running-title", "string | auto", "auto", [Page header from page 2 (`auto` uses `title`, `none` hides it)]),
  ("author", "string | array", "default-author", [Paper author(s); array items may be strings or `(name:, affiliation: 1 | (1, 2), equal: bool, email:)` dicts]),
  ("affiliations", "array", "(sdu-university,)", [Author affiliations, numbered from 1]),
  ("date", "string", "none", [Date of the paper]),
  ("repo", "string", "none", [Repository URL, shown as a link]),
  ("abstract", "content", "none", [Abstract under the title]),
  ("keywords", "string | array", "none", [Keywords under the abstract]),
  ("columns", "int", "2", [Number of text columns]),
  ("outline", "bool", "false", [Table of contents under the abstract]),
  ("outline-depth", "int", "none", [Max heading depth in the outline]),
)
#pagebreak()
= Cards
`theorem`, `corollary`, `definition`, `example`, `proof` and `block`:
#params(
  ("title", "string", [card name], [Card heading (`block` defaults to `none`)]),
  ("width", "relative", "100%", [Width of the card]),
)

`block` also takes:
#params(
  ("header-fill", "color", [`rgb("#7c8592")`], [Background colour of the title bar]),
  ("body-fill", "color", [`rgb("#f3f4f6")`], [Background colour of the body]),
)
= question and answer
An exercise prompt in a grey box, and an indented answer under it.
#params(
  ("title", "string", "none", [Bold label before the question, e.g. "Exercise 4"]),
)
`answer` takes no parameters, only its body: `#answer[..]`.

= QED
A tombstone (end-of-proof square). Place `#QED` at the end of a proof; it is pushed to the right edge of the line.

= boxed
#params(
  ("stroke", "length", "0.6pt", [Border thickness]),
  ("stroke-color", "color", "black", [Border colour]),
  ("fill", "color", "none", [Background colour]),
  ("inset", "length | dict", "(x: 8pt, y: 6pt)", [Padding inside the box]),
  ("radius", "length", "2pt", [Corner radius]),
)

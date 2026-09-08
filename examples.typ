// ═══════════════════════════════════════════════════════
// sdust — copy-paste starters for every template
// (kept in the repo for reference; excluded from the package bundle)
// ═══════════════════════════════════════════════════════

// ── THESIS ──
#import "@preview/sdust:0.1.0": *
#show: thesis.with(
  title:         "Thesis Title",
  subtitle:      "Optional subtitle",          // optional
  author:        "Firstname Lastname",
  supervisor:    "Prof. Firstname Lastname",   // optional, string or array
  department:    imada,                        // optional — imada/bmb/biology/fkf or any string
  programme:     "MSc in Computer Science",    // optional
  date:          "date",
  outline:       true,
  outline-depth: 2,
)

= Introduction
Content goes here.

/*
── NOTE ──
#import "@preview/sdust:0.1.0": *
#show: note.with(
  title:         "Lecture Notes",
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",
  date:          "date",
  logo:          none,          // or image("sdu-logo.png", width: 12em)
  outline:       true,          // set false to skip TOC
  outline-depth: 2,             // none = unlimited depth
)

= First Section
Content goes here.

── EXERCISE ──
#import "@preview/sdust:0.1.0": *
#show: exercise.with(
  title:         "Exercises 1",
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",
  date:          "date",
  outline:       true,
  outline-depth: 2,
)

= Exercise 1
Content goes here.

── ASSIGNMENT ──
#import "@preview/sdust:0.1.0": *
#show: assignment.with(
  title:         "Assignment 1",
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",
  date:          "date",
  outline:       true,
  outline-depth: 2,
)

= Problem 1
Content goes here.

── EXAM ──
#import "@preview/sdust:0.1.0": *
#show: exam.with(
  title:          "Written Exam",
  subtitle:       "Re-exam",                   // optional
  course:         "DM000 — Course Name",
  author:         "Firstname Lastname",
  date:           "date",
  student-id:     "id",                        // optional
  username:       "username",                  // optional — shown in page header
  student-number: "215751682",                 // optional — shown in page header
  duration:       "4 hours",                   // optional
  allowed-aids:   "All written materials",     // optional
  outline:        false,
)

= Problem 1
Content goes here.

── PROJECT ──
#import "@preview/sdust:0.1.0": *
#show: project.with(
  title:         "Project Title",
  subtitle:      "Optional subtitle",          // optional
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",         // or array of dicts / name strings
  date:          "date",
  group:         "Group 4",                    // optional
  supervisor:    "Prof. Firstname Lastname",   // optional
  outline:       true,
  outline-depth: 2,
)

= Introduction
Content goes here.

── SUBMISSION ──
#import "@preview/sdust:0.1.0": *
#show: submission.with(
  title:      "Submission Title",
  subtitle:   "Optional subtitle",             // optional
  author:     "Firstname Lastname",            // or array
  supervisor: "Prof. Firstname Lastname",      // optional, string or array
  date:       "date",
)

= Introduction
Content goes here.
*/

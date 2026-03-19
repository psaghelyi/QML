  ┌──────────────────────────┬───────┬───────┬────────┬────────┬──────────┐
  │          Survey          │ Pages │ Items │ Blocks │ Cycles │ Problems │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ LFS Labour Force         │ 30    │ 83    │ 13     │ 1      │ 6        │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ NPHS Population Health   │ 56    │ 233   │ 29     │ 0      │ 7        │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ SAEP Education Planning  │ 49    │ 60    │ 11     │ 0      │ 8        │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ GSS Time Use             │ 33    │ 204   │ 19     │ 0      │ 10       │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ PALS Activity Limitation │ 58    │ 219   │ 23     │ 0      │ 10       │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ SLID Labour Income       │ 60    │ 108   │ 11     │ 0      │ 8        │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ SHS Household Spending   │ 65    │ 225   │ 25     │ 0      │ 10       │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ GSS Victimization        │ 158   │ 252   │ 12     │ 0      │ 10       │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ NLSCY Children & Youth   │ 244   │ 161   │ 12     │ 0      │ 8        │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ CCHS Health              │ 303   │ 231   │ 43     │ 0      │ 7        │
  ├──────────────────────────┼───────┼───────┼────────┼────────┼──────────┤
  │ Totals                   │ 1,056 │ 1,776 │ 198    │ 1      │ 76       │
  └──────────────────────────┴───────┴───────┴────────┴────────┴──────────┘

  Key findings across all 10 surveys:

  - 1,776 items converted from imperative GOTO-based PDFs to declarative QML
  - 76 structural/logical problems detected in the original Statistics Canada questionnaires
  - Only 1 dependency cycle (LFS's PATH variable feedback loop) — all other surveys produced clean acyclic graphs
  - 0 NEVER-reachable items and 0 INFEASIBLE postconditions across all surveys
  - Most common problem categories: phantom/out-of-band variables (NPHS proxy, CCHS module flags), asymmetric routing
   (depression screening, DK/Refused handling), blocked valid paths (education skip, grade-based exclusion), and dead
   code (unreachable routing branches)
# Looker lab — work one program from the tracker to the scorecard

Role: CapEx Systems Onboarding Data Integrity Program Manager. You make the inputs accurate when a program moves off Excel trackers onto the system of record, and you do the change with GSM, TPM, AME, the contract manufacturers, and Finance without escalating it.

Tool: Looker on Google Cloud, the product with LookML. Excel is the must-have. This lab is how you explain the scorecard. It is not a claim that you have shipped LookML.

Time: Path A is about 45 minutes on this machine. Path B is a real Looker or Looker Studio session.

**Illustrative, and labeled that way.** Not Apple’s system and not a program you ran. People, suppliers, and sites are lab labels. Every rate below is from `python3 run_local.py`. Lived numbers used next to it, and only these: a counted-rows go/no-go and “Negative AFS clean at T+1”; 44 requirement rows across 23 systems; an issues log of 331 go-live, 77 fast-follow, 36 enhancement; Austria data quality about 55% to about 99% within a quarter; Shipment Visibility events-in versus events-out; a Zendesk-to-Snowflake requirements document where you wrote seven metric definitions and named Looker SQL Runner. You did not write the Looker layer on that pipeline.

## Part 0 — What we are doing and why

A test-station line, `TS-LINE-RAMP`, is still living in two contract-manufacturer trackers. The job is inputs someone can defend: the PO line matches an asset, the placed-in-service date is the day depreciation starts, the site code is the site the tool is actually at, a reused fixture points at the asset it came from, and each field has a named owner.

Two other programs are already loaded and clean on purpose. `PACK-CELL-EXP` has 32 lines. `FIXTURE-REUSE-24` has 28, including the twelve source assets the ramp reuses. With the filter off, reconciliation is 98/100 = 98.0%. The ramp alone is 38/40 = 95.0%. The blend looks finished. The program being onboarded is not.

The lab proves you can read a messy tracker, publish a tolerance before you load, quarantine structural failures, and still find the business defects those rules did not cover. You can define reconciled once, show three healthier formulas, and refuse them. You can put an owner on each field, age the open defects, and show that fixing one record closes the exception and does not repair first-time-right.

**Final output:** the data-integrity scorecard for `TS-LINE-RAMP`, as of 2026-03-16, plus the exception list.

| Tile | Result from the SQL run |
| --- | --- |
| Reconciliation | 38/40 = 95.0%. Alert fires. Proposed line is under 98%. |
| Exception aging, open | 7 in 0–7 days, 7 in 8–30, 7 in 31+. Twenty-one open, all go-live. |
| Field completeness by owner | Placed-in-service 28/40 = 70%, owner Finance. Reuse 12/12. Site 100% complete and not 100% valid. |
| First-time-right | 21/40 = 52.5%. |
| Person-dependent fields | 3. Placed-in-service (Morgan Ellis), program allocation (David Cho), reuse source (Elena Vasquez). |

That output is this role. The accuracy of the inputs is the job. The owner on the field is how you ask for a correction without escalating. The playbook rule is how the next tracker does not repeat the miss.

**What you say:** I would walk one program off the tracker and onto a scorecard where reconciled means one thing, every blank has an owner, and a late fix does not pretend the first entry was right.

## Part 1 — Two paths, honestly

### Path A — this machine, about 45 minutes

You do not need Looker, a cloud account, or a card. DuckDB runs the checks the answer key was built from. `dashboard_mock.html` is a static page drawn from those results, not a Looker session. Say that if you show it.

```
cd /workspace/apple/looker-lab
python3 generate_data.py
python3 run_local.py
```

`generate_data.py` rewrites the CSVs from a fixed seed. You can skip it; the files are already there. `run_local.py` writes `data/expected_outputs/`, applies the step-9 fix into `data/expected_outputs/after_fix/`, and leaves `/tmp/lookerlab-scratch/lab.duckdb` on the open queue. Open `dashboard_mock.html`. If a number in this guide and a CSV disagree, believe the CSV.

If DuckDB is missing: `pip install duckdb`. BigQuery DDL is `sql/00_create_tables.sql`. The file Path A executes is `sql/00_create_tables_duckdb.sql`.

### Path B — Looker, or Looker Studio if that is what you have

1. **BigQuery sandbox.** Free, no card, with storage and query caps this lab will not touch. Confirm the current cap before you depend on it. Create a dataset named `capex`.
2. **Load the CSVs** using the types in `sql/00_create_tables.sql`. `po_line_id` is STRING. If the loader guesses a number, `00017` becomes `17` and every join fails. Do not load the raw trackers into the fact tables. `sql/01_load.sql` has the `bq load` shape.
3. **Connect Looker.** Looker (LookML) needs a Google Cloud Looker instance or a trial. There is no free Looker core that simply attaches to the sandbox. **Looker Studio is a different product.** It is free, it can sit on these tables, and it can draw the same five tiles. It does not run `lookml/`. If they say “Looker,” ask which one.
4. **If you have Looker:** new project, point the connection at the dataset (the model says `capex_bigquery_placeholder`), paste the LookML, validate, explore. Set user attribute `program_ids` from `user_program_map.csv`. Jordan’s value is `TS-LINE-RAMP` only.
5. **If you have Looker Studio:** five charts on the BigQuery tables, with `sql/03_metrics.sql` as the definition you refuse to fork. You will not have an access filter or a Git-backed measure. Say that.
6. `sql/02` and `sql/03` are DuckDB, because that is what was executed. On BigQuery, `date_diff('day', opened, as_of)` becomes `DATE_DIFF(as_of, opened, DAY)`, and the CSV reader becomes an external table. The counts do not change.

**What you say about the tool:** I have not shipped LookML. On the Snowflake pipeline I wrote seven metric definitions and named Looker SQL Runner as the surface. The infrastructure team built the pipeline. I can specify the grain, the owner, and the tolerance, and I would want your Looker developer on the model until I have one in production.

## Part 2 — Step by step

### 1. Inspect the raw trackers and list the defects by eye

**What.** Open `data/raw_cm_tracker_siteA.csv` and `data/raw_cm_tracker_siteB.csv` in a text editor. Excel will turn `00017` into `17`.

**Why.** Excel is the must-have, and its failure mode is a silent type change. You will not see every defect by eye. That is why the checks exist.

Visible without SQL:

- Two header languages. Site A’s header has trailing spaces: `PO Line `, `Site `, `Qty `, `Unit Cost `, `Notes `. Site B uses `po_line`, `PO#`, `Location`, `date received`.
- Three date shapes: `2026-01-21`, `01/08/2026`, `12-Feb-2026`. One impossible date: `13/32/2026`.
- Site text: `A`, `Site A`, `SITE-A`, `site a`, `Site B`, `SITE-B`, `B`. Line `00024` is in the site A file and says `Site B`. Line `00026` says `PLANT-01`. Line `00025` says `A` in the site B file.
- Line `00018` twice, quantity 2, two serials.
- `SN-DUP-4421` on `00020` and `00021`. `SN-DUP-4422` on `00022` and `00023`.
- Blank in-service cells. You may not count all twelve. The SQL says twelve.
- Line `00019`: in-service `11-Feb-2026`, received `2026-02-18`.
- Lines `00039` and `00040`: no asset tag, no received date.
- Row `00901` / `SITE-Z`. A blank PO line. A fully blank row at the bottom of the site B file, which is not a submission.
- Trailing space on `SN-TS-0005 ` and `AST-TS-0005 `.

Not visible: `AST-TS-0040`, keyed into the system of record, on neither tracker.

**What you say:** I read the file before I load it, and I write down what I can see, because the loader will hide the rest inside a green row count.

### 2. Load

**What.** `sql/00_create_tables_duckdb.sql` and `sql/01_load_duckdb.sql`, or `python3 run_local.py`. Fact tables are the system of record. The equipment list is the authority for which PO lines exist. Values are trimmed. Empty strings become null. Ids stay strings.

**Why.** A load that succeeds with the wrong type is a bad load.

**Expected.** `fact_po_line` 100. Ramp lines 40. `fact_asset` 100. `fact_exception` 21. `po_line_id = '00017'` is five characters, not 17.

**What you say:** I count the rows after the load against the count I published before it, and I check that the line id is still text.

### 3. Quality checks, and the counted-rows go / no-go

**What.** Read `data/published_tolerance.csv` first. Rules are dated 2026-03-01. Then `sql/02_quality_checks.sql`. Do not edit the tolerance after you see the file.

**Why.** On the Sephora S/4 HANA work, the go / no-go was a counted-rows read, and the bar I still use the morning after a load is the one we called “Negative AFS clean at T+1”: the business rules, not the file shape, have to be clean the next day. Here the structural gate can pass and those rules can still be red.

| Check | Value | Bar | Result |
| --- | --- | --- | --- |
| Submitted tracker rows | 43 | | |
| Quarantined | 2 | | |
| Quarantine rate | 2/43 = 4.65% | R3 ≤ 5% | Pass |
| Accepted rows | 41 | | 40 lines plus the second asset row on 00018 |
| Distinct PO lines loaded | 40 | Equipment list 40 | Pass |
| Missing list lines | 0 | R1 = 0 | Pass |
| Duplicate PO line ids in the load | 0 | R2 = 0 | Pass. The fan-out is not a duplicate id. |
| Decision | GO | | The file may load. The book is not clean. |

Quarantine detail: site A `00901`, `unknown_site` and `not_on_equipment_list` (`SITE-Z`). Site B blank PO line, `blank_po_line` and `bad_po_date` (`13/32/2026`). `tracker_vs_fact.csv` is 0 received-date mismatches and 0 linked-asset mismatches. The orphan is the one asset the tracker does not have.

T+1 checks the gate did not stop:

| Check | Rows |
| --- | --- |
| Duplicate serials | 2 serials, each on 2 assets. SN-DUP-4421 on AST-TS-0021 and AST-TS-0022. SN-DUP-4422 on AST-TS-0023 and AST-TS-0024. |
| Orphan | 1. AST-TS-0040, no PO line, site CM-B. |
| Site mismatch | 3. 00024 PO CM-A / asset CM-B. 00025 PO CM-B / asset CM-A. 00026 PO CM-A / asset PLANT-01. |
| Placed-in-service before receipt | 1. Line 00019, received 2026-02-18, date 2026-02-11. |
| Other referential | 0. The only referential failure is the orphan. |

**What you say:** I publish the tolerance before the file arrives. This file is a go on counted rows, and it is not clean: the rules I had not written yet are the queue.

### 4. Define the metrics once

**What.** Read `lookml/` next to `sql/03_metrics.sql`. A dimension is something you group or filter by. A measure is an aggregate. The primary key on the PO line is `po_line_id`. `count_distinct` of that key is a symmetric aggregate: the one-to-many asset join does not multiply it. `type: count` counts joined rows. A ratio you type by hand is not protected.

**Why.** On Shipment Visibility, the useful watch was events-in versus events-out. Same shape: lines in, assets out. The Zendesk-to-Snowflake requirements froze seven metric definitions and named Looker SQL Runner. That pipeline’s acceptance gate was a parallel run within 1% for consecutive weeks. I did not write the LookML. This lab’s bar is the counted-rows tolerance, a different file.

Line `00018` is quantity 2, assets `AST-TS-0018` and `AST-TS-0019`. Not a defect. It is the fan-out.

| On TS-LINE-RAMP | Result |
| --- | --- |
| Joined rows | 41 |
| Plain count of po_line_id | 41 |
| Count distinct po_line_id | 40 |
| Count distinct assets on the join | 39. The orphan is not on this join. |
| Line 00018 alone | plain count 2, distinct lines 1, assets 2 |

| Definition | Rate | Certify? |
| --- | --- | --- |
| Lines with at least one asset / lines | 38/40 = 95.0% | Yes |
| Assets on a line / lines | 39/40 = 97.5% | No. The extra asset hides one missing line. |
| Lines with an asset / lines that have a received date | 38/38 = 100% | No. The filter dropped 00039 and 00040. |
| Assets on the program / lines | 40/40 = 100% | No. The orphan fills the hole. |
| First-time-right, all assets on the program | 21/40 = 52.5% | Yes |
| First-time-right, dropping the orphan | 21/39 = 53.85% | No |
| Reuse source / every asset | 12/40 = 30% | No. Certified reuse completeness is 12/12. |

Placed-in-service, in the LookML description, is the day depreciation starts. Not the ship date. Not the unpack date.

**What you say:** Count distinct on the PO line is the fix for the fan-out. A plain count on this join says 41 lines. There are 40.

### 5. Build the explore and run reconciliation

**What.** Explore `po_lines`. Base is the PO line. Assets join left, one-to-many. Program, site, and supplier join many-to-one. No default filter on received date. Filter program to `TS-LINE-RAMP`. On Path A, query `metric_scorecard`.

**Why.** The explore is the surface. A personal report is not the definition.

**Expected.** 40 lines, 38 with an asset, rate 0.95. Pack 32/32. Fixture program 28/28. Priya with the filter off: 98/100 = 98.0%.

**What you say:** I start the explore at the PO line so a line with no asset is still in the denominator. If I start at the asset, the two in-transit lines disappear.

### 6. Build the five tiles

**What.** `lookml/capex_integrity_scorecard.dashboard.lookml`, or `dashboard_mock.html` on Path A. Filters: program and site. Drill to the exception list. Default program `TS-LINE-RAMP` is visible and does not hide the in-transit lines. The site filter is the PO receiving site on reconciliation and on the queue, and the asset site on the asset and completeness tiles. Person-dependent does not listen to site.

**Why.** Each tile is a query. The owner is who you ask, which is the change without an escalation. The same habit, larger, was 44 requirement rows across 23 systems, each pre-wired to an owner. The queue uses the same three classes as that issues log: 331 go-live, 77 fast-follow, 36 enhancement. Those are category counts. All 21 rows here are go-live, because the book is wrong. A nicer chart would be an enhancement, and this queue has none.

| Tile | Number |
| --- | --- |
| Reconciliation | 95.0% (38/40). Alert fires. |
| Exception aging | 7, 7, and 7. EX-PIS-00017 is age 4, bucket 0–7. |
| Completeness | Finance, placed-in-service, 28/40 = 70%. Cost center 40/40, GSM. Program allocation 40/40, TPM. Reuse 12/12, AME. Wei 22/22. Jordan 18/18. Eleven of the twelve blanks were submitted from site A. The demo row is the one on site B. |
| First-time-right | 52.5% (21/40). The 19 misses: 12 blank dates, 2 duplicate serials, 3 site mismatches, 1 date-order failure, 1 orphan. |
| Person-dependent | 3 fields. Window 2025-12-16 through 2026-03-16. |

The drill is `exception_open.csv`.

**What you say:** Complete is not valid. Site is 100 percent filled, and three of those codes disagree with the PO. Those three are on the queue, not in the null count.

### 7. Row-level security, tested as the CM user

**What.** `access_filter` on `dim_program.program_id` using user attribute `program_ids`, loaded from `user_program_map.csv`. The user cannot clear it. Path A: `metric_rls_by_user`.

| User | Programs | Lines | Lines with an asset | Rate |
| --- | --- | --- | --- | --- |
| Jordan Hale, CM site B | 1 | 40 | 38 | 95.0% |
| Morgan Ellis, Finance | 2 (not the prior program) | 72 | 70 | 97.22% |
| Priya Raman, GSM | 3 | 100 | 98 | 98.0% |

Jordan asking for `PACK-CELL-EXP` returns 0 (`rls_jordan_pack.csv`). His security is on program, not on site, so he still sees site A’s rows of this program. Site-level restriction is not in this model.

**What you say:** I test the access filter as the CM user, and I try to open a program he does not have. Zero rows is the pass. A dashboard filter he can clear is not security.

### 8. Schedule and alert

**What.** A schedule sends the dashboard Monday at 07:00 to the owners on the completeness tile. An alert fires when the certified rate is strictly below 0.98. That 0.98 is rule R4, proposed for this lab. It is not a number I am attributing to this team. The datagroup rebuilds when `max(created_at)` on the asset table moves, and the cache is never older than 24 hours.

**Why.** A schedule does not notice a threshold. An alert does not explain the rows. The rows stay in the warehouse. Looker keeps the result cache.

**Expected.** On the ramp, 0.95 fires. Priya’s unfiltered 0.98 does not, because the test is strictly below. That quiet blend is the bug the program filter prevents. Morgan’s unfiltered 0.9722 still fires.

**What you say:** The Monday email goes to the person who can fill the null. The alert is a separate object, and I do not let an unfiltered blend sit on the line and stay quiet.

### 9. Fix one record

**What.** In the system of record, set placed-in-service on the asset for PO line `00017` (`AST-TS-0017`) to `2026-02-17`, five days after received `2026-02-12`. Close `EX-PIS-00017` on `2026-03-16`. Insert one field edit by `usr_morgan_fin`. Do not update `passed_validation_on_first_entry`. SQL: `sql/04_rls_and_fix.sql`. Results: `expected_outputs/after_fix/`. The CSVs in `data/` stay the open queue.

**Why.** The write path leaves Looker. If Jordan had typed the date, first-time-right would still not recover, and the field would gain a second editor.

| | Before | After |
| --- | --- | --- |
| Missing placed-in-service | 12 | 11 |
| Completeness of that field | 28/40 = 70% | 29/40 = 72.5% |
| Aging, open | 7 / 7 / 7 | 6 / 7 / 7 |
| Reconciliation | 95.0% | 95.0% |
| First-time-right | 21/40 = 52.5% | 52.5%. Flag on AST-TS-0017 still 0. |
| Person-dependent fields | 3 | 3 |
| Alert | fires | fires |
| EX-PIS-00017 | open, age 4 | closed 2026-03-16 |

`after_fix/tracker_vs_fact.csv` shows one linked-asset mismatch, because the tracker was not rewritten. Do not reload the tracker over the correction.

**What you say:** Closing the exception is the refresh. First-time-right does not move, and I do not want a measure that lets it move.

### 10. The playbook rule that prevents it next time

**What.** Write the rule, then compare it to `playbook/RULE-pis-required-at-tagging.md`. A tracker row with a received date and a blank placed-in-service date is quarantined. The date cannot be earlier than receipt. Finance owns the definition. The CM sees the rule before the file is due.

**Why.** Austria was this shape of work at a different company: data quality about 55% to about 99% within a quarter, by making the rule explicit and staying with it. This lab’s first-time-right is 52.5%. I am not saying this file is that program. The rate moves when the rule is in the gate. It does not move when someone backfills a cell. On the next tracker those twelve blanks would count as quarantine. Over 5%, the decision would be no-go.

**What you say:** The playbook entry is the reject, written down before the next file. The scorecard is how I see it if the rule is not in the gate yet.

## Part 3 — Explaining it to the hiring manager

About three minutes. You are walking a model of the work. You have not shipped this LookML.

A program is still in two trackers. My job is the accuracy of the inputs when it moves onto the system of record, and the change with the GSM, the TPM, the AME, the two CM coordinators, and Finance.

I publish the tolerance before the file shows up. Missing lines against the equipment list: zero. Duplicate line ids: zero. Quarantine under 5 percent. This file is 2 quarantined out of 43, and 40 lines loaded. That is a go. The morning after, I still recount the business rules. Two serials are duplicated, one asset has no PO line, three sites disagree with the PO, one depreciation date is before receipt, and twelve assets have no placed-in-service date. The file gate was not asked to catch those. They are the queue, and each one has an owner.

The model starts at the PO line. Assets join one-to-many, because one line can carry two units. I count distinct line ids. A plain count on this data says 41. There are 40. The certified rate is lines with an asset over lines, 38 over 40, 95 percent. Assets over lines prints 97.5, and a filter that keeps only received lines prints 100. I do not certify either. The definition lives in the view, in Git. A personal report does not get its own formula.

The scorecard is five queries. Reconciliation 95 percent, so the alert fires under the line I proposed at 98, which I would replace with the team’s number. Aging is 7, 7, and 7. Completeness by owner: Finance is at 70 percent on the date that starts depreciation, and site is 100 percent filled with three codes that are still wrong. First-time-right is 21 of 40. Three fields were edited by exactly one person in the last 90 days.

I fix one record in the system of record, PO line 00017, the blank date. The exception closes. Missing dates go from 12 to 11. Reconciliation stays 95. First-time-right stays 52.5, because the flag is about the first submit. Then I write the rule that quarantines a blank date on the next file.

Row-level security is a user attribute the CM cannot clear. Jordan sees this program only. He sees 95 percent, and a program he does not own returns no rows.

### Five follow-ups

**Why is the PO line the grain?** The failure you are managing is a buy with no asset. An asset-grain table cannot show a row that was never tagged. Two assets on one line are still one line. The orphan is a different check, and it does not get to fill the reconciliation hole.

**Why Looker rather than Excel for this?** Excel holds the rows. It does not hold a definition. The next copy of the file is a second meaning of reconciled, and it will turn `00017` into a number if someone saves it. Looker keeps the measure in Git and queries the warehouse. Looker Studio can draw the tiles and will not give you that Git history. I would not pretend those are the same product. I have not shipped either model. I have frozen definitions and a parity gate, with SQL Runner named as the surface.

**How do you stop two definitions of reconciled?** One measure in the view, count distinct on both sides, reviewed like code. The asset version and the received-only version stay hidden so someone can see the trap, and they are not on the tile. The Monday schedule and the alert both point at the certified measure.

**What would you not automate yet?** I would not let a model fill placed-in-service, the reuse source, or the program allocation. Those are judgments, and first-time-right on this program is 52.5 percent. I would not train anything on a queue that still has duplicate serials and an orphan. I would automate the gate that is already a rule: trim, parse the date, map the site, reject a blank key, reject an unknown site, reject a line that is not on the equipment list. Capitalization and reuse stay with Finance and the AME until the input is trustworthy.

**How does this map to onboarding playbooks?** The pilot is this program. The playbook entry is the reject added after the scorecard found the blank date. The next program inherits the rule, the owner map, the tolerance, and the same five tiles. What stays local is the equipment list and the CM’s site codes, which still have to be mapped. I would ask which lesson from their own pilot teams actually followed, and which one they had to keep enforcing.

## Part 4 — Glossary and checklist

| Term | In this lab |
| --- | --- |
| Dimension | Program, site, owner, a date. Group and filter. Do not sum. |
| Measure | count_distinct, or a ratio of two. |
| Primary key | po_line_id, asset_id, exception_id. |
| Fan-out | Line 00018. Plain count 2. Count distinct 1. |
| Symmetric aggregate | count_distinct of the primary key. A hand-written ratio is not protected. |
| Explore | po_lines, exceptions, assets, completeness, field_edits. Different grains stay apart. |
| LookML | `lookml/`. This lab is the files, not a merge you have done. |
| PDT | exception_aging and person_dependent_fields, built in the warehouse. |
| Access filter | User attribute `program_ids` on `dim_program.program_id`. |
| Datagroup | `capex_daily`. Newest asset timestamp, and never older than 24 hours. |
| First-time-right | Passed on the first submit. A later correction does not flip it. |
| Person-dependent | Exactly one user in the 90 days ending 2026-03-16, inside the program. |
| Looker Studio | A different product. Free. No LookML. Fine for five tiles. Not this model. |

### Numbers to expect

From `data/expected_outputs/` after `python3 run_local.py`. Before the fix unless the path says `after_fix/`.

| File | Expect |
| --- | --- |
| go_nogo.csv | 43 submitted, 2 quarantined, 40 lines, decision GO |
| quarantine_rows.csv | 00901 unknown site; blank PO line and bad date |
| tracker_vs_fact.csv | 0, 0, 1 orphan. After the fix: 1 linked-asset mismatch |
| duplicate_serials.csv | 2 serials |
| orphans.csv | AST-TS-0040 |
| site_mismatches.csv | 3 |
| date_logic.csv | line 00019 |
| referential.csv | orphan 1, everything else 0 |
| reconciliation_by_program.csv | ramp 0.95, pack 1.0, fixture 1.0 |
| reconciliation_traps.csv | 0.95 certified; 0.975; 1.0; 1.0 |
| fanout_program.csv | 41 joined, 40 distinct lines, 39 assets |
| fanout_line_00018.csv | qty 2, plain count 2, distinct 1 |
| missing_pis.csv | 12 of 40. After the fix, 11 |
| completeness_by_field_owner.csv | placed-in-service 28/40. After, 29/40 |
| reuse_denominator_trap.csv | 1.0 on 12; trap 0.3 on 40 |
| exception_aging.csv | 7, 7, 7. After, 6, 7, 7 |
| first_time_right.csv | 0.525, unchanged after the fix |
| first_time_right_trap.csv | 0.5385 |
| first_time_right_all.csv | 0.81 with the filter off. Not some other 81. |
| person_dependent_fields.csv | 3 true. Without the window, program allocation is false |
| rls_by_user.csv | Jordan 0.95, Morgan 0.9722, Priya 0.98 |
| rls_jordan_pack.csv | 0 |
| scorecard.csv | 0.95, missing 12, 7/7/7, 0.525, 3, alert true |
| after_fix/scorecard.csv | 0.95, missing 11, 6/7/7, 0.525, 3, alert true |
| fix_proof_00017.csv | Before: blank, flag 0. After: 2026-02-17, flag 0, closed 2026-03-16 |

Regenerate with `python3 generate_data.py && python3 run_local.py`. If this guide and a CSV disagree, believe the CSV.

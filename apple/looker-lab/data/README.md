# Data

Illustrative rows for one onboarding. Not Apple's book, and not a program anyone ran. Names of people, suppliers, and sites are lab labels. Unit costs are there so a column has a type. Do not add them up and call the sum a savings number.

The as-of date is 2026-03-16. The 90-day editor window opens on 2025-12-16. Tolerances were published on 2026-03-01, before the trackers are treated as arrived. `generate_data.py` writes every CSV from a fixed seed. Running it again does not change a byte that the checks depend on.

## dim_program.csv

One row per program. Three programs. `TS-LINE-RAMP` is the test-station line being onboarded, with an equipment list of 40 PO lines. `PACK-CELL-EXP` (32 lines) and `FIXTURE-REUSE-24` (28 lines) are already on the system of record and are clean on purpose, so a blended reconciliation reads 98 of 100. The grain is the program. The key is `program_id`.

## dim_site.csv

One row per place an asset can be tagged. `CM-A` and `CM-B` are the two contract-manufacturer sites. `PLANT-01` is the internal plant. The key is `site_id`. A code in this list can still be the wrong site for a PO. That is the point of the three mismatches.

## dim_supplier.csv

One row per supplier. Three lab suppliers: Atlas Fixture Co, Northline Test Systems, Helix Instruments. The key is `supplier_id`. The grain is the supplier. None of the planted defects are a bad supplier key. The referential check should return zero here, and that zero is part of the story: the gate that passes is not the gate that was missing.

## dim_input_owner.csv

One row per input owner. Six people: Priya Raman (GSM), David Cho (TPM), Elena Vasquez (AME), Wei Chen (CM site A coordinator), Jordan Hale (CM site B coordinator), Morgan Ellis (Finance fixed assets). The key is `owner_id`. `user_id` is the login on the edit log. These names are lab labels so a tile has someone to point at.

## dim_date.csv

One row per day from 2025-06-01 through 2026-04-30. The grain is the day. The key is `full_date`. `date_key` is YYYYMMDD. The prior program's dates and the 90-day window both fall inside this calendar. It does not know holidays. Aging does not use this table. Aging uses the as-of date in `lab_parameters.csv`, so the buckets stay still while you demo.

## fact_po_line.csv

One row per PO line. 100 lines: 40 on `TS-LINE-RAMP`, 32 on `PACK-CELL-EXP`, 28 on `FIXTURE-REUSE-24`. The key is `po_line_id`, kept as text so `00017` does not become 17. Columns are the ones the lab loads: `po_line_id`, `po_number`, `program_id`, `supplier_id`, `site_id`, `equipment_type`, `qty`, `unit_cost`, `po_date`, `received_date`. On the ramp, lines `00039` and `00040` have a null `received_date`. They are in transit and they have no asset. They stay in the reconciliation denominator. Line `00018` has `qty` 2. That is the fan-out, and it is a real quantity, not a defect.

## fact_asset.csv

One row per tagged asset. 100 assets. The key is `asset_id`. On `TS-LINE-RAMP` there are 40 assets: 39 linked to a PO line and one orphan, `AST-TS-0040`, with a null `po_line_id`. Twelve assets have a null `placed_in_service_date`, including `AST-TS-0017` on PO line `00017`. Twelve assets, lines `00027` through `00038`, carry a `reuse_source_asset_id` pointing at `AST-FR-0001` through `AST-FR-0012` on the prior program. Those fixtures are not a new buy (`unit_cost` 0 on the line). `passed_validation_on_first_entry` is 1 on 21 of the 40 ramp assets and 0 on the other 19. The 19 are the twelve blank dates, the two second copies of a duplicated serial, the three site mismatches, the one date that precedes receipt, and the orphan. Filling a date later does not flip the flag. `created_by` is who keyed the row. It is not the editor of every field.

Planted on the ramp, and why each one matters to a data-integrity PM:

- Two PO lines in transit with no asset (`00039`, `00040`). Reconciliation that drops them goes to 100 percent. The lines are the work.
- Twelve missing placed-in-service dates. Depreciation cannot start. Finance owns the field. Eleven of the twelve were submitted from site A. The one you fix in the demo is site B, so you do not tell the story from the row you happen to have open.
- Two duplicated serials, `SN-DUP-4421` and `SN-DUP-4422`, each on two assets. The book cannot count a unit it cannot identify.
- One orphan asset, keyed into the system of record and absent from both trackers. The file gate cannot see a row that never was in the file.
- Three site mismatches (`00024`, `00025`, `00026`). The asset site is a real code and the wrong code. Completeness does not catch this. A comparison to the PO does.
- One placed-in-service date before receipt, line `00019` (2026-02-11 against received 2026-02-18). A present value can still be the wrong value.
- One PO line with two assets, `00018`, quantity 2, assets `AST-TS-0018` and `AST-TS-0019`. Not a defect. It is there so a plain count double-counts the line and an asset-over-line rate prints 97.5 percent.

## fact_exception.csv

One row per defect. 21 rows, all `closed_date` null, all `triage_class` go-live, all on `TS-LINE-RAMP`. The grain is the defect, not the asset and not the line: the orphan has no line, and the in-transit lines have no asset. `field_name` is the input that is wrong. `owner_id` is who closes it. `opened_date` is the day it was logged, which is what aging uses. Against the as-of date the open buckets are 7 in 0–7 days, 7 in 8–30, and 7 in 31+. `EX-PIS-00017` is the blank date on line `00017`, opened 2026-03-12, age 4, bucket 0–7. That is the row step 9 closes.

## fact_field_edit.csv

One row per field write. This file exists because person-dependent cannot be computed from `created_by`: one person keys the row, and several people own the fields. Inside the 90-day window on `TS-LINE-RAMP`, placed-in-service was written only by Morgan Ellis, program allocation only by David Cho, and the reuse source only by Elena Vasquez. Cost center, site, and serial each have two editors. `usr_prior_tpm` wrote program allocation on the 2024 program in June 2025, outside the window. Drop the window and program allocation no longer looks person-dependent, which hides that only David has touched it since this ramp started. The key is `edit_id`.

## raw_cm_tracker_siteA.csv

The messy tracker from CM site A, at asset-row grain. 24 submitted rows: the site A PO lines, a second row for line `00018`, and one reject (`00901`, site `SITE-Z`). The header row carries trailing spaces (`PO Line `, `Site `, `Qty `, `Unit Cost `, `Notes `). Dates are mixed (`2026-01-21`, `01/08/2026`, `12-Feb-2026`). Site text is `A`, `Site A`, `SITE-A`, `site a`, and, on the mismatch rows, `Site B` and `PLANT-01`. A serial and an asset tag carry a trailing space. DuckDB trims header names and does not trim values. The loader trims values. Excel often does neither, and opening this file in Excel can turn `00017` into `17`.

## raw_cm_tracker_siteB.csv

The messy tracker from CM site B. Different headers (`po_line`, `PO#`, `Location`, `date received`). 19 submitted rows plus one fully blank artifact row at the bottom, which is not a submission and not a quarantine. Site text includes `Site B`, `SITE-B`, and `B`. Line `00025` says `A`. The reject has a blank PO line and the date `13/32/2026`. Line `00017` is here, with a blank placed-in-service cell.

## user_program_map.csv

One row per user per program. Three users. Priya (GSM) sees all three programs. Jordan (CM site B) sees only `TS-LINE-RAMP`. Morgan (Finance) sees `TS-LINE-RAMP` and `PACK-CELL-EXP`, not the prior program. This is the source an admin loads into the Looker user attribute `program_ids`. The user cannot clear it.

## equipment_list_ts_line_ramp.csv

The approved list for the ramp. 40 PO lines, published with the tolerance, before the trackers arrive. Grain is the PO line. No received date and no serial: those come from the floor, not from the approval. The go/no-go compares the load to this file. One missing line is a no-go.

## field_owner_map.csv

One row per input, naming who owns it and when it applies. Placed-in-service is Finance, on every tagged asset, and it means the day depreciation starts. Reuse source is the AME, and only on `reused_fixture` lines. Site and serial sit with the CM coordinator who submitted the row, which is why completeness for site is split between Wei and Jordan. The map is the reason a null has a name next to it.

## published_tolerance.csv

Four rules, `published_at` 2026-03-01. R1: missing equipment-list lines equal 0. R2: duplicate PO line ids in the load equal 0. A second asset row on one id is not R2. R3: quarantined rows divided by submitted rows at or under 0.05. R4: the proposed alert, reconciliation strictly below 0.98. R4 is a lab proposal, not a threshold this team has adopted. It is in the file so the alert has a number you published before the tile existed.

## lab_parameters.csv

One row. `as_of_date` 2026-03-16, `window_days` 90, `alert_reconciliation_below` 0.98, `program_in_focus` TS-LINE-RAMP. Queries read this instead of a date buried in a formula. Change it and the buckets move, which is the point of having it in one place.

## planted_defects.csv

The design roster, one row per exception, with the age and the bucket the generator intended. The SQL in `expected_outputs/` is the proof. If the roster and the SQL disagree, believe the SQL and fix the generator.

## expected_outputs/

The answer key, written by `run_local.py` from the DuckDB views. Not typed by hand. `scorecard.csv` is the five numbers on the default filter before the fix: reconciliation 0.95, missing placed-in-service 12, aging 7 / 7 / 7, first-time-right 0.525, person-dependent fields 3. `after_fix/` is the same views after `sql/04_rls_and_fix.sql`: missing placed-in-service 11, aging 6 / 7 / 7, reconciliation still 0.95, first-time-right still 0.525, and `fix_proof_00017.csv` shows the flag still 0 with `closed_date` 2026-03-16. `tracker_vs_fact.csv` in `after_fix/` shows one linked-asset mismatch, because the tracker was not rewritten when the system of record was. That is the correct disagreement.

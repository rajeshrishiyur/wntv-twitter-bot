# What actually happens to a machine the brand owns and does not hold

**Illustrative storyline built from public knowledge of how capital equipment is managed at contract manufacturers and from the job description — not inside knowledge of Apple.** Names, prices, and dates below are the practice extract for program TS-LINE-RAMP. They are there so you can point at a row. They are not Apple’s books.

**Who this is for.** You, explaining the use case in plain words to Apple’s Capital Expenditure Systems Lead.

**The practice program.** Test-station line ramp, **TS-LINE-RAMP**. 40 purchase-order lines, CM site A and CM site B, one internal plant, three suppliers, 12 fixtures reused. As-of **16 March 2026**. People: Elena Vasquez (AME), David Cho (TPM), Priya Raman (GSM), Wei Chen (site A), Jordan Hale (site B), Morgan Ellis (Finance). No row for you. You run the load, the scorecard, and the queue.

## 1. The real-world setting

A company designs a product. Contract manufacturers — other companies’ factories — build it. To build it and to test it, the line needs capital equipment: test stations that check each unit, handlers that move it, fixtures and jigs that hold it, instruments that measure it, and automation cells that repeat a motion without a person at every step.

Much of that equipment is bought by the brand and stays on the brand’s books, while the machine sits in the contract manufacturer’s factory, often in another country. The brand owns a very large number of assets it does not physically control, across factories, programs, and suppliers. Order, pay, ship, install, move, reuse, scrap: the record can be wrong at each step. That is the asset-management problem. This role makes the record match the machine.

The **ERP** is the main business system, where the purchase order and Finance’s book live. The **system of record** is the one official place this program’s equipment data lives after onboarding. Wei’s spreadsheet and Jordan’s spreadsheet are sources the load reads.

| Word | What it means on a factory floor and in the book |
| --- | --- |
| CapEx | Capital expenditure: money for a thing used for years. A test station counts. Parts consumed this week do not. |
| Capital appropriation | The formal yes: an amount, a cost center (the accounting bucket), and a program. Here the yes is the 40-line equipment list. Prices sum to **$197,500** (lab list: unit cost × quantity). |
| PO | Purchase order. One line is one buy: what, how many, the price, which program. Line **00017** is one test station. |
| Asset tag | The label and its number. How someone on the floor points at one machine. Line 00017’s tag is **AST-TS-0017**. |
| Asset master | The official list. One row per tagged asset, with the fields Finance and an auditor rely on. |
| Placed-in-service date | The day the asset starts its job. That day starts capitalization and depreciation. A financial control. In this lab: not the ship date, and not the day the crate was unpacked. |
| Capitalization | Recording the cost on the balance sheet as a long-lived asset. |
| Depreciation | Charging a share of that cost to each year of use. A blank date means it does not start. |
| Fixed-asset ledger | Finance’s book: cost, in-service date, depreciation taken, and where the asset is supposed to be. |
| Custodian | The named person accountable for the physical machine. Here, Wei at site A and Jordan at site B. The extract stores the field owner, not a separate custodian column. |
| FAT / SAT | Factory acceptance test: the supplier proves it works before ship. Site acceptance test: the factory proves it works after install. Two signatures, two dates. |
| Retrofit / reuse | Using a machine the company already owns, as-is or modified. Twelve ramp rows point at fixtures from program Fixture reuse 2024. |
| Disposition | The end for that asset: transfer, hold, sell or return, or scrap. The ledger records the same fate. |
| Ghost asset | On the books and not findable on the floor. Or on a record with no purchase order behind it. |
| Physical-to-book audit | Walk the floor, read the tags, compare to the ledger. The lab reconciles purchase order to tag. That check sits beside the walk; the walk still happens. |

## 2. One asset’s life, step by step

Follow **line 00017**: a Northline test station, PO-55022, CM site B, cost center CC-4100, lab price **$12,400**, ordered **20 January 2026**. The program around it is 40 lines — 8 test-station lines, 6 handlers, 7 instruments, 7 new fixtures, 12 reused fixtures; 22 for site A, 18 for site B.

Swimlane (the person who acts, left to right). The diagram is in the HTML and the PDF. Red in that diagram is line 00017: tagged, date blank, so depreciation cannot start. You are not a builder of the asset. You arrive when this picture is already wrong.

| | 1 Spec | 2 Plan | 3 Buy | 4 Ship | 5 Tag | 6 Use | 7 End |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Elena Vasquez, AME | 40-line list, includes 00017 | | | | | | |
| David Cho, TPM | | EVT, DVT, PVT, then ramp | | | | | |
| Priya Raman, GSM | | | 40 PO lines, 12 reused | | | | |
| Supplier (Atlas, Northline, Helix) | | | | FAT, then ship | | | |
| Wei / Jordan, site coordinators | | | | | Tag 00017, date blank | Move or retrofit | |
| Morgan Ellis, Finance | | | | | Cannot capitalize | Floor vs the book | Disposition updates the book |

| Step | Who | What happens |
| --- | --- | --- |
| a. Spec | Elena, AME | Units per hour × shifts × yield becomes the 40-line list (`equipment_list_ts_line_ramp.csv`). Line 00017 is a site B test station on it. |
| b. Plan | David, TPM | Install dates for **EVT** (early units: can we build the design?), **DVT** (does the process repeat?), **PVT** (does the line run as production will?), then ramp. He owns program allocation. In the last 90 days he is the only person who has written it on this ramp. |
| c. Buy | Priya, GSM | Northline, stations and handlers, PO-55022. Helix, instruments, PO-55023. Atlas, new fixtures PO-55021 and reused fixtures PO-55030. She checks owned assets first. Lines **00027–00038**, all site B, are 12 reused fixtures at **$0**, each pointing at **AST-FR-0001** through **AST-FR-0012** from Fixture reuse 2024 at the internal plant. That search is what the interviewer’s profile credits with millions in retrofit opportunities. This file stores the link, not a savings figure. |
| d. Ship | Supplier | Build, factory acceptance test, ship. A ship notice carries serials. This extract has no ship-notice file. Line 00017 is received **12 February 2026**. |
| e. Tag | Jordan at B, Wei at A | Install, site acceptance test, then the tag: asset, serial, PO line, site, line, station, custodian, cost center, program, reuse source, placed-in-service date. Jordan tags **AST-TS-0017**, serial **SN-TS-0017**, on 13 February, and leaves the date blank. His sheet says site **B** and program **ts-line-ramp**. |
| f. Use | Factory, then Finance | The station runs, moves, is retrofitted, or sits idle. Each of those is a data event. Finance and audit walk the floor against the ledger. |
| g. End | David, with Morgan | Transfer, hold, sell or return, or scrap. The ledger records the same fate. |

## 3. Who enters which data, where, and why it breaks

Wei’s file and Jordan’s file are both “the tracker,” and the headers do not match. Site A has `PO Line`, `Site`, `In Svc`, `Reuse From`. Site B has `po_line`, `Location`, `pis`, `prior_asset`. Dates, costs, and the program name are typed in more than one format. Each sheet can be accurate about what that person saw, the ERP accurate about what was ordered, and Finance still unable to capitalize.

| Event | Who enters it | Where today | The fields | Why this input exists | What goes wrong |
| --- | --- | --- | --- | --- | --- |
| Capacity becomes an equipment list | Elena Vasquez, AME | Engineering spec, then the approved equipment list | Line, type, site, quantity | The buy has to match what the line needs to hit the rate. | The model changes after the list is copied. The purchase order still says 40. |
| Launch plan and the approval | David Cho, TPM | The program record. In the lab, program allocation on the asset. | Program, need-by dates for EVT, DVT, PVT, ramp | Spend and the asset have to belong to a program someone can name. | One person holds the allocation rule. In the last 90 days David is the only editor of that field on this ramp. |
| Reuse check, then the PO | Priya Raman, GSM | ERP for the purchase order. A mailbox or a private sheet for the reuse check, unless the source asset id is a real field. | PO line, supplier, price, cost center, reuse-source asset | The PO is the commitment. The reuse link is how the company avoids buying a fixture it already owns. | A fixture at the internal plant is invisible, so a new one is bought. In the lab the 12 links exist, at $0, only if someone keeps AST-FR-0001 and the rest filled in. Elena owns that field. |
| Build, FAT, ship | Supplier | Supplier email or portal. This extract starts at the received date. | Serial, ship date | The serial is what ties a physical unit to a PO line before the company tags it. | The serial stays in an inbox. The tracker gets a typed copy, and one value is entered on two rows. |
| Receive, SAT, tag | Wei Chen (site A), Jordan Hale (site B) | Two CM Excel trackers, different headers | Asset, serial, PO line, site, cost center, program, reuse source, placed-in-service date | So Finance can start depreciation, and so an auditor can find the machine. | The date is left blank. The site is spelled five ways. A serial is repeated. One PO line arrives as two tagged assets. One asset is keyed with no PO line. |
| Move, retrofit, idle | Coordinator; Elena if the tool is retooled | The same spreadsheet, sometimes nowhere | New site or line, program, reuse flag | The asset’s life continues after the first install. The book has to follow. | The factory moves it over a weekend. The ledger still has the old line. A code that exists can still be the wrong site. |
| Count, then disposition | Morgan Ellis, with the custodian; David for the end state | Count sheets, then the fixed-asset ledger | Found or not found; transfer, hold, sell, or scrap, and the date | The company has to show the book and the floor are the same set of machines. | Paid for, and not on the floor: a ghost asset. Scrapped on the floor, still depreciating. Or on a record, and in neither tracker, with no PO. |

### What those breaks cost, in the real world

- **Ghost assets.** Paid for, and not on the floor at audit. Lines **00039** and **00040** are in transit and still count as bought. **AST-TS-0040**, serial **SN-TS-ORPHAN-9001**, is the other ghost: keyed at site B with a date and no purchase-order line, in neither spreadsheet. Priya owns the link.
- **The in-service date.** Twelve tagged assets have it blank, so Morgan cannot capitalize them. Line **00019** / AST-TS-0020 has the date **11 February 2026** and a receipt of **18 February**, so depreciation would start before the tool arrived. Either one is a financial-control finding.
- **Missed reuse.** A fixture that could be retooled sits in another factory, off the new tracker, and Priya buys a new one. The lab’s counter is the reuse-source field, scored only on the 12 reuse lines. Elena owns it. Without that id, Finance can capitalize a tool the company already owns.
- **Budget and forecast.** The list is a $197,500 commitment. Twelve tagged assets are not in service, and two lines have not arrived. The purchase-order forecast and the asset book describe different sets of machines.
- **One person’s head.** In the 90 days to 16 March, a single editor holds placed-in-service (Morgan), program allocation (David), and reuse source (Elena). Cost center is shared by Priya and Morgan. On the older fixture program, allocation was written by a prior TPM who is not in today’s owner list.
- **Both spreadsheets are “right.”** Jordan spells site B as **B**, **Site B**, **SITE-B**, **site b**, and B with a trailing space. Wei’s sheet does the same for site A, and it has line **00901**, “Mystery box,” site SITE-Z, which is not on the equipment list. Jordan’s sheet has a row with no line id, cost **abc**, and the date **13/32/2026**. The sheets, the 40-line list, and Finance’s rule on a blank date are three true statements, and still no single picture of the line.

## 4. The storyline, on the extract’s calendar

Speak it as a sequence: spec, approve, buy, ship, tag, reconcile. The extract does not number those as week 0, week 2, week 3. It stores dates. The as-of date is **16 March 2026**. The picture below is the open queue on that morning, before anything is closed.

| When | What the files show |
| --- | --- |
| June 2025 | **Fixture reuse 2024** at internal plant PLANT-01: 28 fixtures. Twelve become the reuse sources. Those edits sit outside the 90-day window. |
| 6 Jan–27 Feb 2026 | Priya’s 40 lines. 00001 on 6 January, 00017 on 20 January, 00040 on 27 February. The equipment list is the authority. Rule R1: one missing line is a no-go. |
| 2–23 Feb 2026 | **38 of 40 lines** have a tag. **00039** (Helix instrument, site A) and **00040** (Atlas fixture, site B) have no receipt and no asset. They stay in the denominator. 38/40 is 95 percent. |
| 12 Feb 2026 | Line **00017** arrives at site B. Jordan tags AST-TS-0017 and leaves the date blank: one of **twelve**. The other eleven are **00006–00016** at site A, left by Wei. Morgan owns the field. EX-PIS-00017 opens 12 March, age 4 days. |
| The same tag pass | **SN-DUP-4421** on 00020 and 00021 (Jordan; the second entry failed). **SN-DUP-4422** on 00022 and 00023 (Wei). Line **00018** is quantity 2: assets AST-TS-0018 and AST-TS-0019, a fan-out, not a duplicated PO id. Line **00019** is dated before receipt. Three real site codes are on the wrong factory: **00024** bought for A, tagged B; **00025** bought for B, tagged A; **00026** bought for A, tagged PLANT-01. |
| 1 Mar 2026 | Tolerance published before the load. R1: zero missing list lines. R2: a repeated PO id is a no-go; two assets on 00018 are allowed. R3: quarantine rate at or under 5 percent; a fully blank Excel row is not a submission. R4: alert if this program is under 98 percent. The file calls 98 percent a proposed lab alert. A blend can sit at 98 percent and stay quiet while this program at 95 percent should page. Pack cell expansion is clean on purpose, so a blended rate looks finished. |
| 16 Mar 2026 | You run the reconciliation. **21 open exceptions**, all go-live, no closed date. Aging **7 / 7 / 7** in 0–7, 8–30, and 31+ days. The orphan is 60 days. Line 00040 is 32. First entry passed on **21 of 40** assets. |

### What you do, in this order

1. **Publish the tolerance before the load.** R1–R4 are dated 1 March. You state them before you trust the file. You do not choose 98 percent after seeing 95.
2. **Load** both trackers onto the 40-line list. Quarantine the mystery-box row and the row whose cost is “abc.” A fully blank Excel row is not a submission.
3. **Counted-rows go/no-go.** Loaded PO ids against the 40. A missing id stops the load. A repeated id stops the load. Line 00018’s two assets stay: quantity 2, both serials kept.
4. **One exception per defect, named owner.** Twelve blank dates, Morgan. Duplicate serials: Jordan on 00021, Wei on 00022. Wrong sites: Wei, Jordan, Wei. Date-before-receipt: Morgan. Two in-transit lines and the orphan: Priya. Twenty-one rows. No second list in email.
5. **Owner-per-field scorecard.** Morgan sees the date. Priya sees the PO link, transit, and the orphan. Wei and Jordan see serial and site on the rows they submitted. Elena sees reuse source, on the 12 reuse lines only. David sees program allocation.
6. **Chase the twelve dates with Wei, Jordan, and Morgan. Do not escalate.** Show the ledger impact: the twelve are tagged, and Finance cannot capitalize them, so depreciation does not start. Agree the rule: the date is the day SAT is signed — not the ship date, and not the unpack date. Put line 00019 on the table as the early-date case. An unsigned SAT stays open under Morgan’s name. You do not type a guess to turn the tile green.
7. **Close when the field is corrected.** Closed date is filled because the serial, the site code, or the SAT date is now in the record. On 16 March every closed date is empty. That is the before picture.
8. **Write the playbook rule: “placed-in-service date required at tagging, validated at entry.”** The next tracker that omits it fails at entry. Filling it later leaves first-time-right at 21 of 40. That measure is the first entry, which is what the playbook is judged on.

## 5. What this role does, and the output you leave behind

Elena specs the station, David dates the launch, Priya places the buy, Wei and Jordan live with the tool, Morgan capitalizes it. You make the record trustworthy enough that Morgan can start depreciation, Priya can find the fixture next time, and an auditor can walk to the tag. You name an owner for every field, publish the tolerance before the load, count the rows, and close exceptions with the person who has the fact. The next program inherits the rule. The output on the table is a scorecard and a queue.

| Tile | What it counts on this extract | The real-world failure it is there to catch |
| --- | --- | --- |
| Reconciliation % | 38/40 tagged, 95 percent. 00039 and 00040 stay in the denominator. Read it on TS-LINE-RAMP. The clean pack-cell program can hold a blend at 98 percent and the alert stays quiet. | Money committed, asset not in service. Paid for and not tagged. A company-wide percent hides the program you are onboarding. |
| Exception aging | 7 / 7 / 7 in 0–7, 8–30, and 31+ days. EX-PIS-00017 is 4 days. The orphan is 60. Line 00040 is 32. | The date someone meant to fill after SAT, which became a quarter. A control finding gets old quietly. |
| Completeness by field, by owner | Twelve blank dates. Field owner: Morgan. Wei typed eleven blanks, Jordan typed 00017. Reuse source is scored on the 12 reuse lines only. | One field and one owner, instead of “the program is messy.” A single editor on program allocation is how shared tools get split by memory. |
| First-time-right % | 21 of 40 assets passed on first entry. A later fix does not flip the flag. | Repeated serials, a date before receipt, a valid site code on the wrong factory, a blank date. The playbook is judged on the next file’s first pass. |
| Person-dependent fields | 90-day window: date = Morgan, program = David, reuse source = Elena. Cost center is shared by Priya and Morgan. | The rule leaves with that person. The prior program still has a TPM on allocation who is not in today’s list. |
| Exceptions queue | 21 rows, one defect, one owner, go-live, no closed date. | Both sheets can look right until a named person has to change one field. The queue is that ask, with an age. |

### How the lab data maps to this story

No README was in the lab folder. Columns are the CSV headers. Every defect below is a row in `planted_defects.csv` or the rule that file is demonstrating.

| Real-world event | CSV file / column | Planted defect | Metric that catches it |
| --- | --- | --- | --- |
| Approved equipment list | `equipment_list_ts_line_ramp.csv` · po_line_id, qty, unit_cost | 40 lines. Sum of unit cost × quantity is $197,500. A missing line fails R1. | Counted-rows go/no-go |
| Buy and receipt | `fact_po_line.csv` · po_line_id, supplier_id, site_id, received_date | 38 lines received between 2 Feb and 23 Feb. 00039 and 00040 blank. | Reconciliation %. In transit stays in the denominator. |
| Tag, and the in-service date | `fact_asset.csv` · asset_id, placed_in_service_date. `fact_exception.csv` · EX-PIS-* | 12 blanks: 00006–00016 (Wei, site A) and 00017 / AST-TS-0017 (Jordan, site B). Owner OWN-FIN, Morgan Ellis. | Completeness by field by owner |
| Date before the tool arrived | placed_in_service_date against received_date | 00019 / AST-TS-0020: 2026-02-11 before 2026-02-18. EX-DATE-00019. | First-time-right. Exception aging. |
| Serial typed twice | `fact_asset.csv` · serial_number. Raw: `raw_cm_tracker_siteB.csv` · SN | SN-DUP-4421 on 00020 and 00021 (Jordan). SN-DUP-4422 on 00022 and 00023 (Wei). | First-time-right. Duplicate-serial exceptions. |
| Site spelled three ways | `raw_cm_tracker_siteB.csv` · Location. Site A column is “Site ”. | Same factory written B, Site B, SITE-B, site b, and B plus a space. Line 00017 is stored as B. | Load conform, before any rate. A filter on “Site B” would drop line 00017. |
| Right code, wrong factory | fact_asset.site_id vs fact_po_line.site_id. Sites in `dim_site.csv`: CM-A, CM-B, PLANT-01. | 00024 A bought, tagged B. 00025 B bought, tagged A. 00026 A bought, tagged PLANT-01. | First-time-right. Completeness would pass: the code exists. |
| One PO, two serialized assets | fact_po_line.qty · fact_asset rows for 00018 | Quantity 2. AST-TS-0018 and AST-TS-0019. Rule R2: this is a fan-out, not a duplicate id. | Go/no-go must allow it. Reconciliation has to count assets, not assume one tag per line. |
| Asset with no PO | fact_asset.po_line_id (blank). EX-ORPHAN-0040. | AST-TS-0040, SN-TS-ORPHAN-9001, site B, in neither tracker. Owner Priya Raman. | Orphan on the queue. Reconciliation from the asset side, not only from the PO. |
| Reuse instead of a new buy | fact_asset.reuse_source_asset_id · lines 00027–00038 · `field_owner_map.csv` | 12 rows, $0, PO-55030, sources AST-FR-0001–0012 from FIXTURE-REUSE-24. Elena owns the field. | Completeness of reuse source. Denominator is the reuse lines only. |
| Who actually typed the field | `fact_field_edit.csv` · field_name, edited_by. Window in `lab_parameters.csv`: 90 days, as-of 2026-03-16. | Single editors: Morgan, David, Elena, on the three fields above. | Person-dependent fields |
| The open queue | `fact_exception.csv` · owner_id, opened_date, closed_date, triage_class | 21 open, all go-live, buckets 7 / 7 / 7. Owners in `dim_input_owner.csv`. | Exception aging. The queue itself. |

## 6. How to say it to the hiring manager

**About 90 seconds.**

The brand designs the product. Contract manufacturers build it. The test stations, handlers, fixtures, and instruments on those lines are often the brand’s property, on the brand’s books, in a factory the brand does not run. That is the asset problem: a large number of machines you own and do not physically control.

On the program I would walk you through, the manufacturing engineer specs 40 purchase-order lines across two factories and three suppliers. The supply manager reuses 12 fixtures from the prior program and points each one at the asset it came from. The factories tag what arrives in two spreadsheets that do not share column names. Thirty-eight lines have a tag. Two are still in transit. Twelve tags have no placed-in-service date, so Finance cannot start depreciation. Line 00017 at site B is one of those twelve.

I publish the pass rules before I load the file, count the rows against the 40-line list, and open one exception per defect with the owner that field already has. For the twelve dates I sit with Finance and the site coordinator. I show them that a blank date means the book cannot capitalize the asset. We agree the date is the day the site test is signed. Then I write the rule down: placed-in-service date required at tagging, validated at entry.

**The sentence that shows why this team cares.** Apple cares because these are assets the company owns inside factories it does not control, and the placed-in-service date is a financial control, not a formality.

**One line each, from work I have done.**

- **Sephora, Utah DC.** One inventory record, two channels; 44 requirement rows across 23 systems; issues log 331 go-live / 77 fast-follow / 36 enhancement.
- **Sephora, S/4 HANA.** The go/no-go was counted rows; the line we could stand on was “Negative AFS clean at T+1.”
- **Elementum, Austria.** Data quality about 55% to about 99% within a quarter; measure before blaming the process.
- **Flexport.** Events in versus events out at every boundary.

Counts are from the lab CSVs as of 2026-03-16. $197,500 is unit cost × quantity on the 40-line equipment list. 38/40 and 21/40 are TS-LINE-RAMP. No README was in the folder.

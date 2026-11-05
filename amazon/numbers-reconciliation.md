# Numbers Reconciliation — Amazon L6 SCM master vs Apple workbook v11 vs source documents

Candidate: Rajesh Rishiyur Chandrasekaran · Interview Wed Oct 29 (10:00 PDT) / Thu Oct 30, 2026 · Built Oct 28, 2026

Layers: **L1** Apple PMIII Interview Stories v11 (49 pp) · **L2** Amazon master (html 195 pp, `/workspace/amazon/amazon-l6-scm-master-packet.html`; uploaded cb91 131 pp) + GFiber v8 origin · **L3** primary docs in `/tmp/sources` (Flexport, Sephora, Walmart prep) plus xlsx/csv recomputed with pandas. Precedence on conflict: source docs > Apple v11 > Amazon canon; never choose a larger figure than a source supports.

---

## 1. SUMMARY (one page)

**Method.** Two passes. (a) A token census of every distinct significant number (%, $, ×, K/M, decimals, ≥100, unit-attached counts) in S1-S21 and E1-E12 of the html master, tested for presence in Apple v11, primary docs, GFiber v8, and the Walmart/SAP prep docs. Presence is a coarse test and over-counts support (a bare "$1M" is "found" somewhere). (b) A hand-curated claim registry (§2) checked claim-by-claim against Apple page, source doc page/sheet, and recomputed arithmetic. The registry is the authoritative count.

| Measure | Count |
|---|---|
| Distinct numbers in census (S1-S21 + E1-E12) | **1531** |
|  – found in Apple v11 | 540 |
|  – not in Apple, found in a primary Flexport/Sephora source doc | 174 |
|  – found only in GFiber v8 (user's earlier packet; no Apple/primary corroboration) | 615 |
|  – found only in Walmart/SAP/resume prep docs | 51 |
|  – found nowhere (derived arithmetic: modeled/illustrative) | 151 |
| **Curated registry claims (§2)** | **202** across 21 stories |
|  – MATCH | 85 |
|  – ROUNDING | 8 |
|  – CONFLICT | **32** |
|  – UNSUPPORTED (anchor: GFiber v8 / user only, no Apple or primary doc) | 32 |
|  – UNSUPPORTED (modeled: derived arithmetic; recomputed, labeled) | 45 |
| CANON v2 ledger entries (§3) | 88 |

**Integrity-rule scan (html and cb91):** "50x"/"50×": **0 hits**. "$1.5M to $2M": **0**. "six NA sites": only inside never-say/guardrail lines (html 3, cb91 3). "$1.00 → $0.03" / "10x" / "70% baseline" / "$1M routing guide" / "400 devices failed": only inside never-say/guardrail lines (the one other "10x" is "10x lunch peak" in an E12 worked network — benign). S14 $10M and S16 >$100K are never counted as savings; S11 ~$1.5M is kept separate; $2M + $1.5M never summed; $5M avoidance is not repeated as "annual reduction" in the master. **Violations of the brief:** (1) "BOM explosion" appears at html L3343 / cb91 L5734 (E7 kit diagram) and cb91 L2019 (S6 formula); (2) S7 and E6 are BOM-themed against "finished-goods grain only." (3) cb91 S18 says "~55x cheaper" (a spoken multiplier).

**Where the registry stands, by story** (M = match, R = rounding, C = conflict, UA = unsupported-anchor, UM = unsupported-modeled):

| Story | M | R | C | UA | UM | Read |
|---|---|---|---|---|---|---|
| S1 | 6 | 0 | 1 | 3 | 2 | Dates and $ are user-anchor only |
| S2 | 11 | 2 | 3 | 0 | 1 | Strong; fix systems/tracks/duration wording |
| S18 | 7 | 1 | 2 | 0 | 3 | Strong; fix RF device count |
| S3 | 0 | 0 | 1 | 3 | 1 | Apple has no numbers |
| S4 | 1 | 0 | 0 | 3 | 1 | Apple has shape only |
| S5 | 4 | 0 | 1 | 1 | 1 | Strong |
| S15 | 4 | 0 | 0 | 0 | 2 | Thin but consistent |
| S11 | 15 | 3 | 5 | 2 | 1 | Strong core; pre-prod set is anchor-only |
| S12 | 9 | 1 | 3 | 0 | 2 | Strong; $5M framing conflict |
| S16 | 7 | 0 | 2 | 1 | 1 | BRD math ≠ master basis |
| S8 | 4 | 0 | 2 | 0 | 1 | Strong; $ label conflict |
| S6 | 3 | 0 | 2 | 2 | 2 | −50% conflict |
| S9 | 2 | 0 | 3 | 5 | 2 | Biggest drift vs Apple F1 |
| S7 | 1 | 0 | 0 | 4 | 1 | No Apple/source support |
| S10 | 4 | 0 | 2 | 3 | 1 | Timeline conflict |
| S17 | 1 | 0 | 0 | 2 | 2 | No Apple/source support |
| S13 | 5 | 0 | 1 | 1 | 1 | $6M/$8M handling |
| S14 | 0 | 0 | 1 | 2 | 2 | No Apple/source support |
| S19 | 0 | 1 | 1 | 0 | 6 | Provenance conflict |
| S20 | 1 | 0 | 1 | 0 | 7 | Provenance conflict |
| S21 | 0 | 0 | 1 | 0 | 5 | Provenance conflict |

### Top 15 highest-risk items

1. **S19-S21 — CONFLICT (provenance).** The "Walmart Marketplace engagement record" is Rajesh's own interview-prep set for a Walmart job (war book: "Hiring-manager interview, Tuesday Sep 9, 2026"; R-2596147 is a requisition number; deep-dive "Prepared Aug 18, 2026", sample data "illustrative … Wk 28-33, 2026"). Apple v11 and the resume contain no such engagement. Master §4.4 labels it "record-from-docs" and the voice rule says "Elementum engagement lead." **Fix:** Re-label S19-S21 as design cases ("a case I worked through"), never as lived client results; keep every number "in the model." The real lived record for promise-at-the-tail is Apple F4.
2. **S9 / S10 — CONFLICT (largest drift).** Apple F1 p34 + resume: "a thousand lanes onboarded across 25 European locations, versus goal: hit." Master S9: 1,000 asked, 597 first (80% of spend), ~200 next, ~400 deferred; S10: "25 EU sites / 400+ lanes ≈ $8M". 597 / 80% / $2M / 8× / twice-failed cohort exist only in GFiber v8. **Fix:** Decide what actually went live. Safe now: "a thousand-lane program across 25 European locations; I phased by value." Do not say 400+ lanes.
3. **S12 — CONFLICT.** Master rule: ~$5M "avoidance," never "annual reduction." Apple B2 p18-19 itself prints BOTH "$5M annual cost reduction and 15% lower freight-management overhead" and "$5M cost avoidance, value in 6 months." Resume says avoidance. Also Apple B1 says MVP April 2022 (11 partners / 10 countries) while its own math box and the HLSD say Alpha Q4'22 → MVP Q1'23. **Fix:** Say "about five million of avoided cost," once; drop "15% overhead"; call April 2022 "the import-side app."
4. **S16 / S11 — CONFLICT (basis + math).** Three derivations of ">$100K": BRD p1-2 = $129,600/yr → $25,920 → $103,680 saved (3 people × 5 h × 2 WBRs at an ASSUMED $90/h, 30 → 6 h/wk; monthly typo $10,880 vs $10,800); Apple A3 p11 = ~1.5-2 h/wk × 52 of loaded PM time + VP decisions on stale joins ("two hours a week is maybe $10K"); master S16 = "infra's own loaded rates," ≈$30K hours + ≈$70K decision risk (totals "≈$90K" and "$100K" in different rows). S11 says "1.5-2 → ~4 hrs/wk"; Apple A1/A2 say "about four hours a week at worst"; BRD As-Is says 1.5-2 h per snapshot. **Fix:** Quote the BRD arithmetic when asked about the $100K ("priced, not saved"); present the hours/decision-risk split only as "my model"; drop "infra's own loaded rates." Use "about four hours a week at its worst" for S11.
5. **S10 — CONFLICT (timeline).** Apple F2 p35-36: "99% in two months … inside the two-month bar." Master canon: "~99% in 3 months … never two months." Reported-40% / true-55% / 8-10 hrs / 97% / $500K / $8M all MATCH. **Fix:** "Within a quarter" is true under both; resolve the exact month count with Rajesh.
6. **S11 — CONFLICT (framing).** Apple A1 p6/8: CTS $1.00 (hand-carried pilot weeks) → $0.66 → $0.03 (−95%). Master forbids "$1.00 → $0.03" and states −95.5%. Math: 1 − 0.03/0.66 = 95.45% (ROUNDING). **Fix:** Say "$0.66 to $0.03, about ninety-five percent"; mention the $1.00 only as the hand-carried start.
7. **S11 — RISK (source of "50x").** The user's own WBR doc (WBR_Metric_Culture p2) says "MAC to 50X" and "MAU from 400 to 3X." Master and cb91 contain zero "50x" hits (scan clean) and canon is 7 → 68 = 9.7×, 170 MAU target. **Fix:** Never read from that doc aloud. 9.7× and 170 MAU only.
8. **S11 — UNSUPPORTED (anchor).** Pre-prod set — ~$1.5M saved, n = 300 / ±1.6% at 95% (math checks: 1.58%), rollout 1.5 vs 6 months, E2E "85% → ~98%" — is only in GFiber v8. Sources show 86% tracked in the 11/18 dry run (TPM p10) and 500 containers / 20 min / 99.6%; the pilot schedule supports ~6 months pilot length only. **Fix:** Keep the ~$1.5M separate, label "my estimate," and quote the dry run as 86% tracked.
9. **S1 / S14 / S18 — UNSUPPORTED + COLLISION.** S1 ≈$2.5M/yr ($1M user anchor + ≈$1.5M modeled) is not in Apple E1 (no $) — only in the Adobe-prep SAP playbook and GFiber. FSD dates (3/5, 5/16, 6/5/25) are GFiber-only. "$2.5M" means three things (S1 annual, S14 order value, S18 per-month slip) and "$1.5M" four things (S1 model, S8 released, S11 pre-prod, S14 expected loss). The 836-row log is the UDC log, not an ISM log. **Fix:** Always attach the noun ("$2.5M of order value"); say "umbrella program's 836-row log" in S1.
10. **S18 — CONFLICT.** Master: "~100 of ~400 RF devices failed." Apple G2 p45 warns the two source tellings differ (~400 / 3-4 days vs ~100 / 1-2 days) and says "say hundreds in the room." Also ~$2.5M/month is my own division ($20M ÷ 8) and the loop packet says $800K and per-week. **Fix:** Say "hundreds of RF devices"; "about $2.5M a month on average — my division, not banked."
11. **S6 / S9 — CONFLICT + UNSUPPORTED.** Master S6 "planner effort −50% (record)"; Apple F3 p37 says "planner collaboration up 50%." "Adoption 8×" appears identically in S6 and S9 with no Apple support; S6 also quotes "60% complete" which is S9's completeness metric. **Fix:** Say "planner collaboration up fifty percent"; use 8× once or drop.
12. **S8 / S2 / S6 — CONFLICT (label + model).** Apple F4 p39: "$1.5 million of carrying cost released." Master: one-time released inventory, carry modeled separately at 20% (S8) vs 10% (S2, S6; "8-12%" in S6 Q&A). **Fix:** Say "about a million and a half of inventory carrying cost released"; use 10% carry in every model.
13. **S7 / E6 / E7 / S17 — UNSUPPORTED + RULE.** S7 (six sites, 3 waves, 5 months, 6 vs 3 weeks) and S17 (6 → ~3 weeks) have NO Apple or primary-doc support (GFiber v8 only). S7 is a BOM-phantom story against the brief's "finished-goods grain only; no BOM explosion"; html line 3343 / cb91 line 5734 (E7 "kit BOM explosion") and cb91 line 2019 (S6 "Multi-level BOM explosion" formula) trip the brief's grep. **Fix:** Reword E7/S6 to "kit-to-component conversion"; keep S7 as bench or reframe at finished-goods/site grain; label S7/S17 numbers user anchor.
14. **S13 / S14 — CONFLICT + UNSUPPORTED.** Apple M1 uses $8M both as "revenue at risk" (p41 math box) and "protected — the final sales figure" (p40), with $6M "on the line." Master says "$6M at risk → $8M protected." S14 (~200 orders / $2.5M / $10M won) has no Apple or resume support; stockouts −20% is resume-only. **Fix:** Say "$6M on the line … $8M of the day's sales protected"; label S14 numbers user anchor.
15. **S2 / S5 — CONFLICT (small).** Master: "a dozen core systems, 20+ touched." Apple C1/C4: "about a dozen." Apple C1 says "15+ tracks" and "fifteen months"; C2 says "~30 build tracks" and "836 rows over fourteen months"; the log spans 2024-03-17 → 2025-10-01. $1.65M model total printed as "≈$1.6M." **Fix:** Say "about a dozen systems," "about thirty build tracks," "about fifteen months."

Also noted:
- First pilot customer: Apple A5 (shadow accounts Marc Fisher / Michelin), pilot schedule p1 (Wave 1 = Ta Chen + FAM Brands), TPM status 11/19/21 (Marc Fisher onboarding the week after Thanksgiving) — say "the first two hand-carried customers," no names.
- cb91 (131 pp) vs html (195 pp): §4.1 canon ledgers are numerically identical; html adds S19-S21, §4.4, S12 Apple figures (66.2 / 99.8 eng-months, burn-up 55.8 → 83.2%), more math rows. cb91-only: S18 "~55x cheaper than a full month of slip" (html has only ~20x) — never speak a multiplier. 266 html-only vs 210 cb91-only numeric tokens across stories (mostly model rows).
- F3 "$2M safety stock" and F4 "$1.5M carrying cost" are both in Apple as separate results; resume's "$27M+ cost savings" (aggregate) appears nowhere in the Amazon packet — keep it out.

---

## 2. Per-story reconciliation tables

Status key: **MATCH** same value in the layers cited · **ROUNDING** same fact, different precision/derivation · **CONFLICT** values or framing differ across layers · **UNSUPPORTED-anchor** in the Amazon packet but absent from Apple v11 and primary docs (traces only to GFiber v8 / user anchor) · **UNSUPPORTED-modeled** derived arithmetic (recomputed here; must be spoken as "modeled"). Apple page refs are Apple v11 PDF pages. "Source doc" = file + page/sheet in `/tmp/sources`.

### S1 — Sephora S/4HANA ↔ ISM — one signed "available"

- **Apple chapter(s):** E1 (p32-34) for the policy story; C1/C2/C4 (p21-28) for dates, log and runbook
- **GFiber v8 origin:** GFiber v8 ISM chapter (lines ~969, 3082-3116, 3467); resume p1
- **Primary/source docs:** SAP_Transformation_Interview_Playbook_3383 p1-2 (Adobe-prep doc, not a project record); UDC issues log (pandas)

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S1.01 | Headline $ impact | ≈$2.5M/yr = $1M MCS support retired (user anchor) + ≈$1.5M modeled | No $ anywhere in E1 (p32-34) | SAP_Transformation_Interview_Playbook p2: "$1M/year direct support", "$2.5M/year aggregated" (candidate's Adobe prep, not a record); GFiber v8 | **UNSUPPORTED-anchor** | Say: "about $2.5M a year — $1M is the MCS support cost we retired, my program number; the other ≈$1.5M is my model and I will show the inputs." Never present the whole $2.5M as record. |
| S1.02 | Modeled components (oversell ≈$0.9M + recon labor ≈$0.33M + change premium ≈$0.3M) | sum 1.53 → headline 1.0+0.9+0.33+0.3 = $2.53M ≈ $2.5M | — | — (arithmetic recomputed: 30,000,000 × 0.10% × $30 = $900K; 3 FTE × $110K = $330K; 40 × 60 h × $125 = $300K) | **UNSUPPORTED-modeled** | Always say "modeled from these inputs"; range $1.7-5.2M is the honest band. |
| S1.03 | Oversell incidents | "recurring → 0 through two go-lives" | E1 p33: "no oversell dialects"; no incident count; C1 p21: zero customer-facing incidents | Resume p1: "zero customer-facing incidents" | **MATCH** | Say "recurring, no count in my record → zero". Do not invent a baseline number. |
| S1.04 | FSD v1.1 (3/5/25) → v1.2 (5/16/25) → signed 6/5/25 | as stated (record) | Not in Apple (C4 p28 has the UDC chain 3/29→8/14 only) | GFiber v8 lines 969, 3107 only; no /tmp/sources doc contains these dates | **UNSUPPORTED-anchor** | Keep, but it is a user anchor: "signed June fifth, 2025." Confirm with Rajesh; if unsure say "signed in the first week of June." |
| S1.05 | Three signing orgs (Supply Chain Strategy, Inventory Management, FSC Inventory Accounting) | three orgs | E1 p33: "the business signed the sellable table" (no org names) | GFiber v8 only | **UNSUPPORTED-anchor** | Say "three orgs signed" only if confident; names are user anchor. |
| S1.06 | E2E chain Inbound 11/22, Dotcom 12/20, Retail 1/30 | record dates | C1 p22 math box (same three dates) | — | **MATCH** | Safe. |
| S1.07 | Go-lives: PO-creation Jan 2025 → combined May 2025 | "January planning go-live, then May execution" | C1 p22 ("PO-creation go-live Jan 2025 → 4-month interim → combined go-live May 2025"); C4 p28 ("inbound Jan, combined May") | — | **MATCH** | Say "inbound/PO-creation in January, combined go-live in May." |
| S1.08 | 836-row issues log, 85.4% closed (used as S1 evidence) | "program-level artifacts shared with S2/S5" | C2 p24: this is the UDC (Program C) log; E1 (Program E) cites no log | UDC_Consolidated_Issues_Log (pandas): 836 rows, 714 closed = 85.41%. SAP playbook p1 calls 836 a "RAID log" | **CONFLICT** | In S1 say "the umbrella program's 836-row log" — never imply it is an ISM-only log. Apple files ISM and UDC as separate programs. |
| S1.09 | 343-task cutover runbook; rollback sync <99% × 4 h / p95 >2× × 1 h | record | C2 p24 math box (343 tasks / 48,885 task-min) | Resume p1; SAP_Transformation_Interview_Playbook_Narrative p4; "never fired" | **MATCH** | Safe. Add "never fired" (resume). |
| S1.10 | ~60 people to move without authority / 60+ stakeholders | "sixty people" | C1 p22, C4 p28: 60+ named (~80 names, ~15 functions) | — | **MATCH** | Say "sixty-plus stakeholders." |
| S1.11 | SAP tenure "3+ years (Apr 2023 – present)" | §4.1 SAP tenure row | — | Resume p1: Sephora Apr 2023 – Present; SAP Narrative p1 "three-plus years on S/4" | **MATCH** | Safe. Never "10 years of SAP configuration." |
| S1.12 | Model scale: 30,000,000 orders/yr × 0.10% | illustrative | — | — | **UNSUPPORTED-modeled** | Say "an illustrative 30M-order base." |

### S2 — Sephora UDC — one comingle pool + robotics gate

- **Apple chapter(s):** C1 (p21-22), C2 (p23-24), C3 (p25-26), C4 (p26-28)
- **GFiber v8 origin:** GFiber v8 S2 chapter
- **Primary/source docs:** UDC_Consolidated_Issues_Log (xlsx, sheet "UDC issues log", 836×19, pandas); UDC_LOCUS_Retail_Track; LocusOne API guide

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S2.01 | Zero customer-facing incidents through both go-lives | record | C1 p21 result 1 | Resume p1 | **MATCH** | Safe. |
| S2.02 | +15% processing efficiency | "Sephora's signed number" | C1 p22: "DC ops' measurement" | Resume p1 | **MATCH** | Say "+15% processing efficiency, DC Ops' own measurement." |
| S2.03 | Issues log 836 rows; 714 closed = 85.4% | record | C2 p24 math box | UDC log recomputed: 714/836 = 85.41%; open pipeline 122 (A-open 73, B 16, C 10, D 8, E 5) | **MATCH** | Safe. |
| S2.04 | Blocker 164 + Critical 277 = 441 = 52.8% of book | record | C2 p24: 52.8% | Recomputed 441/836 = 52.75% | **ROUNDING** | Say "just over half the book was Blocker or Critical." |
| S2.05 | Categories / operations / owners | not all stated | C2 p24: Go-Live 331, Fast Follow 77, Enhancement 36, Pre Go-Live 29, HSE 12; Outbound 238, Retail 171, Inbound 113, IC 90, Dotcom 62; IT/WMS 342, Ops 111, Locus-side 86 | UDC log recomputed — all match | **MATCH** | Usable depth numbers; see §4 enrichment. |
| S2.06 | Locus-side rows 86 of 836 = 10.3% | record | C3 p26 | Recomputed 86/836 = 10.29% | **MATCH** | Safe. |
| S2.07 | Robotics gate 98% (99% stretch); week 2 = 94%; ~30% throttled; full automation week 3 | record | C3 p26 math box | — | **MATCH** | Safe — flagship Insist-on-Highest-Standards number set. |
| S2.08 | Gate chain kickoff 3/29 → sessions 4/30 → council 5/15 → LOE 7/2 → sign-off 7/31 → FSD 8/14 | record | C4 p28 math box (same dates) | — | **MATCH** | Safe. |
| S2.09 | 60+ stakeholders (~80 names across ~15 functions) | record | C1 p22; C4 p28 | — | **MATCH** | Say "sixty-plus; the discovery deck listed about eighty names across fifteen functions." |
| S2.10 | "a dozen core systems, 20+ touched" | §4.1: never "12" alone or "20" alone | C1 p22: "~a dozen impacted systems"; C4 p28 "about a dozen systems". No "20+" anywhere in Apple | GFiber v8 only for "20+" | **CONFLICT** | Say "about a dozen impacted systems" (Apple v11). Treat "20+ touched" as unverified. |
| S2.11 | Tracks: "~30 build tracks under one log" | S2 Action | C2 p24: ~30 build tracks; BUT C1 p22 says "15+ tracks"/"fifteen tracks" (p21-22) | — | **CONFLICT** | Apple is internally inconsistent. Use "about thirty build tracks" (build plan) and avoid "fifteen tracks". |
| S2.12 | Cutover 343 tasks / 48,885 task-min ≈ 815 hrs | record | C2 p24 (343; 48,885) | 48,885/60 = 814.75 h | **ROUNDING** | Say "343 tasks, about 815 task-hours." |
| S2.13 | Rollback triggers sync <99% for 4 h / p95 >2× for 1 h | record | C-chapters; resume | Resume p1; SAP Narrative p4 | **MATCH** | Safe. |
| S2.14 | Per-environment ACL workbook rows Dev 310 / QA 255 / Perf 200 / Prod 221 | record | C2 (same four numbers) | — | **MATCH** | Safe, low-use. |
| S2.15 | Locus retail testing slipped 3 weeks | record | C2 p24 ("slipped three weeks") | — | **MATCH** | Safe. |
| S2.16 | Program duration | not stated numerically in master | C1 p21: "fifteen months"; C2 p23-24: "836 rows over fourteen months" | UDC log timestamps span 2024-03-17 → 2025-10-01 (~18.5 months incl. long tail); kickoff 3/29/24 → combined go-live May 2025 ≈ 14 months | **CONFLICT** | Say "about fifteen months from discovery to go-live" and never mix with "fourteen." Apple v11 itself carries both. |
| S2.17 | ≈$1.6M/yr modeled; ≈$2.2M one-time pooling | S2 model rows (labor $0.88M + carry $0.22M + split $0.45M + self-transfer $0.10M = $1.65M) | — | — (arithmetic recomputed: 31,300 h × $28 = $876,400; $7.5M × (1−1/√2) = $2.2M) | **UNSUPPORTED-modeled** | $1.65M rounds to $1.7M; say "about $1.6-1.7M a year, modeled on an illustrative 100K-units/week DC." Record carries no $. |

### S18 — Sephora — RP → JDA WMS dual-DC migration

- **Apple chapter(s):** D1 (p28-29), D2 (p30-31), G2 (p44-45)
- **GFiber v8 origin:** GFiber v8 S18 / PM-1
- **Primary/source docs:** Resume p1; SAP_Transformation_Interview_Playbook_Narrative p6 (mocks 7%→1.8%→0.3%)

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S18.01 | 8 months, dual DC | record | D1 p28; resume | Resume p1 | **MATCH** | Safe. |
| S18.02 | Budget ~$1.8M, landed ~3% under (~$54K) | record | D1 p29: "~$1.8M, landed ~3% under" | $1.8M × 3% = $54K (derived) | **ROUNDING** | Say "about three percent under a $1.8M budget — roughly $54K." |
| S18.03 | Mocks 7.0% → 1.8% → 0.3% vs 0.5% tolerance published with Finance before mock 1 | record | D2 p31 | Resume p1; SAP Narrative p6 | **MATCH** | Safe — headline. |
| S18.04 | $20M ROI pipeline of four projects | record | D1 p29 | Resume p1 | **MATCH** | Say "a $20M pipeline of four projects waiting on it." |
| S18.05 | "~$2.5M/month of slip avoided" | §4.1: ~$2.5M/month (S18); loop packet says ~$2.5M/week | Not stated (D1 gives only $20M) | Derived: $20M ÷ 8 months = $2.5M/month (my division); S18 math "$2,500,000/30 = $83,333/day" | **UNSUPPORTED-modeled** | Say "about $2.5M a month on average — my division of the $20M over the eight months; not banked." |
| S18.06 | 72-hr in-transit freeze; RP read-only 30 days; per-interface rollback | record | D1 p29, D2 p31 | — | **MATCH** | Safe. |
| S18.07 | Hypercare exit <2 blocker tickets/day, hit in week 3 of 4 | record | D1 p29, D2 p31 | — | **MATCH** | Safe. |
| S18.08 | Team 14 core + 6 DC Ops | record | D1 p29 | — | **MATCH** | Safe. |
| S18.09 | RF devices "~100 of ~400 failed the conversion script" | §4.1: ~100 of ~400; never "400 failed" | G2 p45: sources disagree (~400 in one telling, ~100 in the other) — "say 'hundreds' in the room" | Apple G2 sources note: Failure Story docs ~400 / 3-4 day estimate vs Goal Miss ~100 / 1-2 day estimate | **CONFLICT** | Say "hundreds of RF devices" and "a three-to-four-day estimate." Do not pair ~100 and ~400 as a ratio. |
| S18.10 | Training slipped 1.5 weeks; go-live date did not move | record | G2 p45 | — | **MATCH** | Safe; it is the failure beat. |
| S18.11 | Loop-packet conflict: $800K budget; ~$2.5M/week; month vs week slip | §1.3 documents | D1: ~$1.8M, ~3% under | — | **CONFLICT** | Master canon ($1.8M, month) matches Apple. Correct the loop packet, never the reverse. |
| S18.12 | Fallback ≈$45K paid; $875K slip avoided; "~20× cheaper" (html) vs "~20× and ~55× vs a month of slip" (cb91 only) | modeled | — | 875/45 = 19.4×; 2,500/45 = 55.6× | **UNSUPPORTED-modeled** | Never say a multiplier aloud; say "forty-five thousand dollars of fallback to protect the date." |
| S18.13 | Dispute delta: 0.2% × illustrative $50M = $100K; mock-1 7% would have been $3.5M | modeled | — | — | **UNSUPPORTED-modeled** | Say "on an illustrative fifty-million-dollar base." |

### S3 — Sephora SNB de-aggregation — one Financial On-Hand

- **Apple chapter(s):** E1 (p32-34) only — no SNB / FOH numbers; C-chapters for dates
- **GFiber v8 origin:** GFiber v8 S3 (lines ~6385-6742)
- **Primary/source docs:** none (no primary doc)

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S3.01 | Financial On-Hand truths 2 → 1 | record (FSD 6/5/25) | E1 p33 qualitative ("one inventory operating model") | GFiber v8 only | **UNSUPPORTED-anchor** | Say "two truths to one." Not in Apple as a number. |
| S3.02 | Over-sell from unmatched postings = 0 "by construction" | record | E1: "no oversell dialects" | GFiber v8 | **UNSUPPORTED-anchor** | Say "zero by design; the failure direction is safe." |
| S3.03 | Design KPI: match rate ≥99.5% within 24 h | design KPI | — | GFiber v8 | **UNSUPPORTED-anchor** | Call it "the design target," not a result. |
| S3.04 | ≈$0.6M/yr modeled (cancels $0.45M + recon labor $141,440 + close $48,960) | modeled | — | — (recomputed: 1,664 h × $85 = $141,440; 576 h × $85 = $48,960; sum ≈ $0.64M) | **UNSUPPORTED-modeled** | Say "modeled — the record has no drift dollar." |
| S3.05 | Cross-reference "S14 — the $2.5M discrepancy" | text | — | — | **CONFLICT** | Avoid saying "$2.5M" in S3; it collides with S1 $2.5M and S14 $2.5M. |

### S4 — Sephora in-transit promise rule (the failure story)

- **Apple chapter(s):** E1 p33 (what broke / what would you do differently)
- **GFiber v8 origin:** GFiber v8 S4
- **Primary/source docs:** none

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S4.01 | First rule set too conservative; dotcom starved of sellable units; fixed by a per-lane promise window | qualitative record | E1 p33 — same story, no numbers | — | **MATCH** | Safe — Apple supports the shape of the story. |
| S4.02 | Lane σ ≈ 0.3 day → ~0.49-day window ≈ 95% coverage | "record promise math" | E1: only "defined in-transit promise window per lane"; no σ | GFiber v8; recomputed 1.645 × 0.3 = 0.4935 ✓ | **UNSUPPORTED-anchor** | Label it "the promise math I used," not "the measured σ." Math is internally correct. |
| S4.03 | Oversell increase = 0; kill switch never fired | record | — | GFiber v8 | **UNSUPPORTED-anchor** | Say it; user anchor. |
| S4.04 | Four regression cells added | record | — | GFiber v8 | **UNSUPPORTED-anchor** | Low-use; fine. |
| S4.05 | ≈$0.5M/yr modeled: 300 units/day × 60% × 40% × $20 = $1,440/day × 365 = $525,600 | modeled | — | recomputed ✓ | **UNSUPPORTED-modeled** | Say "modeled; the record has no dollar for the conversion lost." |

### S5 — Sephora architecture council / signed FSD

- **Apple chapter(s):** C4 (p26-28)
- **GFiber v8 origin:** GFiber v8 S5
- **Primary/source docs:** UDC issues log; S_ONE_NORAM testing doc (not used)

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S5.01 | Gate chain 3/29 → 4/30 → 5/15 → 7/2 → 7/31 → 8/14 | record | C4 p28 math box | — | **MATCH** | Safe. |
| S5.02 | ~80 named participants across ~15 functions | record | C4 p28 | — | **MATCH** | Safe. |
| S5.03 | "a dozen core systems (20+ touched)" | record | C4 p26: "about a dozen systems" | GFiber only for 20+ | **CONFLICT** | Say "about a dozen systems." |
| S5.04 | Three decisions + explicit out-of-scope fence | record | C4 p28 (3 decisions: architecture, staged timeline, peak-freeze Oct-Dec; fence: comingle reserve calcs untouched, MCS decom to global ERP program) | — | **MATCH** | Safe. |
| S5.05 | Every impacted row has a signed LOE by 7/2 (100% pre-wire) | record | C4 p28 "LOE from every impacted team 7/2" | — | **MATCH** | Safe. |
| S5.06 | Surprise escalations → 0 | primary metric | C4: "zero re-litigation" implied, no count | GFiber v8 | **UNSUPPORTED-anchor** | Say "no surprise escalations in the council" — no baseline count exists. |
| S5.07 | ≈$0.5M one-time modeled (2,880 h × $110 = $316,800 + $103,800 + ≈$0.11M fence) | modeled | — | — (arithmetic recomputed ✓) | **UNSUPPORTED-modeled** | Say "my model of what did not happen." |

### S15 — Sephora — 20-person team to a 4-week cadence

- **Apple chapter(s):** D3 (p31-32; "intentionally thin")
- **GFiber v8 origin:** GFiber v8 S15
- **Primary/source docs:** Resume p1

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S15.01 | 20-person Product/Eng/QA team | record | D3 p31 | Resume p1 | **MATCH** | Safe. |
| S15.02 | Six-week hybrid → four-week agile cadence, converted in six weeks | record | D3 p31-32 ("6 weeks from kickoff to self-sustaining") | Resume p1 | **MATCH** | Safe. |
| S15.03 | Critical defects per release −50% | record | Not in D3 text | Resume p1: "critical defects −50%" | **MATCH** | Safe via the resume; Apple D3 omits it. |
| S15.04 | Releases/yr 8.7 → 13 (52 ÷ 6; 52 ÷ 4) | modeled from cadence | — | — (52/6 = 8.67; 52/4 = 13) | **UNSUPPORTED-modeled** | Say "from the cadence — not a measured count." |
| S15.05 | ≈$130K/yr modeled (escaped criticals ≈$90K + late-land rework $41,760) | modeled; range $80-270K | — | — (recomputed: $4,800 × 8.7 = $41,760 ✓) | **UNSUPPORTED-modeled** | Say "modeled on illustrative defect counts; no headcount." |
| S15.06 | Never invent a direct-report headcount | rule | D3: sponsorship but no mandate | — | **MATCH** | Consistent with Apple. |

### S11 — Flexport — Shipment Visibility launch (the wave machine, WBR math, pre-prod measurement)

- **Apple chapter(s):** A1 (p6-7), A2 (p8-9), A4 (p12-13), A5 (p13-14)
- **GFiber v8 origin:** GFiber v8 S11 (pre-prod facts at lines ~15317, 27884)
- **Primary/source docs:** SV_-_Pilot_Client_Roll-out_Schedule p1-5; Technology_Program_Management_Status_Week_of_November_19th_2021 p10-11; WBR_Metric_Culture_using_AI p1-2; SV_-_Product_Testing_Approach p1-4; Path_to_4PL p1-2; LSA_WBR_2022 (xlsx, Instructions rows 6-9); RAPID_-_Crux_Customer_Transition p2-5

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S11.01 | Customers 7 → 68 (9.7×) | §4.1 canon; never "10×", never "50x" | A1 p6-7: 7 pilots → 68 MAC | WBR_Metric_Culture p1-2 says "MAC from 7 to 68 … MAC to 50X" (the origin of the forbidden 50x). Recomputed 68/7 = 9.71 | **ROUNDING** | Say "seven to sixty-eight customers — nine-point-seven times." The user's own WBR doc line "MAC to 50X" must never be spoken. |
| S11.02 | 170 MAU | "170 MAU target" | A1 p6-7: public target 170 MAU, landed | WBR_Metric_Culture p1: "MAU from 400 to 3X" (different framing) | **CONFLICT** | Say "170 monthly active users — the public target, landed." Never "400 to 3X". |
| S11.03 | 32,000 shipments | "targets 68 / 170 / 32K (record)" | A1 p7: 32,000 was the public target "we managed toward all year; I can't tie it to the workbook" | — | **MATCH** | Say "target," never "achieved." Master wording "both public targets hit two months early" should read "68 customers and 170 users." |
| S11.04 | Both public targets (68 MAC, 170 MAU) two months early | record | A1 p7 | Resume p1 "rollout 2 months early" | **MATCH** | Safe. |
| S11.05 | CTS $0.66 → $0.03 per container | record | A1 p7; A2 p8-9 | WBR_Metric_Culture p2: "66 cents to 3 cents" | **MATCH** | Safe. |
| S11.06 | CTS −95.5% | §4.1 canon | A1 p7-8: "a 95% cut", "(-95%)" | Recomputed 1 − 0.03/0.66 = 95.45% | **ROUNDING** | Say "about ninety-five percent." |
| S11.07 | $1.00 hand-carried pilot-week CTS | §4.1: never "$1.00 → $0.03" | A1 p6, p8: $1.00 (hand-carried pilot weeks) → $0.66 steady-manual → $0.03 | — | **CONFLICT** | Apple v11 has the $1.00 start; Amazon canon suppresses it. Say "$0.66 to $0.03"; if asked, "about a dollar in the hand-carried pilot weeks." |
| S11.08 | Automation 40% → 90% (70% no-touch gate) | record | A1 p7; A2 p8 | — | **MATCH** | Safe. Loop-packet "60→97" is wrong (§1.3). |
| S11.09 | System/WBR accuracy 60% → 90% | record (S11 and S16 both) | A3 p10-11; A4 p13 (90% vs 80% north star) | WBR_Metric_Culture p2: "System accuracy improvement from 60% to 90%" | **MATCH** | Say "system accuracy"; never imply it is ETA accuracy; use it in ONE story (S16) to avoid double credit. |
| S11.10 | Ticket response 72% → 90%; volume 5× | not in S11 canon | A1 p7 | WBR_Metric_Culture p2 "5X" | **MATCH** | Add to S11 (see §4). |
| S11.11 | Six graduation criteria thresholds: verification SLA ≥90%; internal DQ ≥90% (≥ Crux); milestone/ETA accuracy ≥80%; stable production; ≥100 containers + key features; no show-stoppers + CSAT ≥ consignee average | record | A1 p7-8 math box | SV_Pilot_Client_Roll-out_Schedule p1-2 (verbatim) | **MATCH** | Safe. |
| S11.12 | ~50-container calibration entry bar | record | A1 p7 | Pilot schedule p1 ("at least 50"), p4 ("50 containers") | **MATCH** | Safe. |
| S11.13 | Waves W1 2 → W2 4 → W3 20+ → 40 by Q3 → 68 by Q4 | record | A1 p7 math box | Pilot schedule p1 for W1-W3 (Q4'21/Q1'22/Q2'22); 40/68 milestones Apple only | **MATCH** | Safe. |
| S11.14 | First pilot customers | not named in master | A5 p13-14: shadow accounts Marc Fisher / Michelin | Pilot schedule p1: Wave 1 = Ta Chen International + FAM Brands (p3 GO/NO-GO: "Marc Fisher data quality 80%+"); TPM status 11/19/21: onboarding "Marc Fisher the week after Thanksgiving" | **CONFLICT** | Sources disagree on who was "first." Say "the first two hand-carried customers," no names. |
| S11.15 | Manual scorecard effort | "1.5–2 → ~4 hrs/wk by hand" | A1 p8, A2 p9: "about four hours a week at its worst" | BRD p2 As-Is: 1.5-2 h per WBR snapshot; BRD p1-2 prices 3 people × 5 h × 2 WBRs = 30 h/wk | **CONFLICT** | Three different manual-effort figures. Say "about four hours a week at its worst." Quote BRD figures only inside S16 and label them. |
| S11.16 | 99.4% week on 3 touches discarded | record | A2 p8-9 | — | **MATCH** | Safe — flagship integrity beat. |
| S11.17 | Event-grain automation: 10,289 events, 1,991 human = 19.4%; weekly 40.2% → 69.2% (Active 287 → 546); red week 21.9% | html omits; cb91 has them | A2 p9 | SV_28.xlsx (per Apple); not in /tmp/sources | **MATCH** | Usable; always with grain + date label. |
| S11.18 | Pre-prod: 500 containers in 20 min, 99.6% connectivity | record | A2 p9 | TPM status 11/19/21 p10 | **MATCH** | Safe. |
| S11.19 | E2E dry run: 100% processed / 86% tracked; job stories 98.4% | html: "accuracy 85% → ~98%" | A2 p9: 100% / 86% / 98.4% | TPM status p10 (Thu 11/18: 100% processed, 86% tracked; job stories 98.4%) | **CONFLICT** | Master "85%" is a rounded/misquoted 86%, and "~98%" has no source. Say "eighty-six percent of containers trackable in the dry run." |
| S11.20 | Scraper error rates Air 5.09% / Ocean 8.99% vs <10% goal | not in master | A5 p13-14 (~5% / ~9%) | TPM status p11 | **ROUNDING** | Add to S11 (see §4). |
| S11.21 | Pre-prod sample n = 300, ±1.6% at 95% | record (separate canonical) | — | GFiber v8 lines ~15317, 27884; recomputed 1.96 × √(0.98×0.02/300) = 1.58% ✓ | **UNSUPPORTED-anchor** | Say "about three hundred containers, plus-or-minus one-point-six at ninety-five" as my design — label user anchor. |
| S11.22 | ~$1.5M pre-prod saved; rollout in 1.5 months vs 6 | separate canonical; never merged with CTS | — | GFiber v8 only. Pilot schedule p2 supports only "pilot ends ~6 months after launch" | **UNSUPPORTED-anchor** | Keep separate; say "my estimate of a month-and-a-half versus six." |
| S11.23 | Nine teams / ~100 people | honesty label | A1 p7 | Path_to_4PL p1-2 ("9 teams, ~100 individuals") | **MATCH** | Safe. |
| S11.24 | WBR format copied from the LSA review | honesty label | — | LSA_WBR_2022 Instructions rows 6-9: input→output, 5-6 weeks, ±5% red/green | **MATCH** | Safe. |
| S11.25 | Direct CTS ≈$50K/yr modeled (e.g., 48,000 × $0.63 = $30,240; 128,000 × $0.63 = $80,640) | modeled; range $30-80K | — | — (arithmetic ✓; container counts illustrative) | **UNSUPPORTED-modeled** | Say "modeled on illustrative container counts — the point is scale without headcount." |
| S11.26 | Wave 3 held once on ETA accuracy; zero rollbacks | record | A1 p7 | — | **MATCH** | Safe. |

### S12 — Flexport — FF App export launch (the roadmap flip)

- **Apple chapter(s):** B1 (p15-17), B2 (p17-19), B3 (p19-21)
- **GFiber v8 origin:** GFiber v8 S12 / PM-3
- **Primary/source docs:** High-Level_Solution_Document_FF_App__Schedules; FF_App_Asia_Latency_Investigation p1-2; PRD_FFA_Audit_Logs; FlexGo_Import_Launch (xlsx); Resume p1

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S12.01 | 18-month plan → value in month 6 (vs 18) | record | B2 p17-19 | Resume p1 | **MATCH** | Safe. |
| S12.02 | 66% less engineering effort | record | B2 p19 | Resume p1 ("66% effort reduction") | **MATCH** | Safe. |
| S12.03 | ~$5M cost avoidance (say once) | record; never "annual reduction" | B2 p18 result 3: "$5M annual cost reduction and 15% lower freight-management overhead"; B2 p19 math box: "$5M annual cost reduction + 15% lower overhead" AND "$5M cost avoidance, value in 6 months" | Resume p1: "$5M cost avoidance in 6 months" | **CONFLICT** | Apple v11 itself carries both framings. Resume + master agree on "avoidance." Say "about five million of avoided cost," once; never "annual"; do not use "15% lower overhead" (no source). |
| S12.04 | CTS −50% partner-first vs −25% operator-first (work-item grain) | record | B2 p17-19 | — | **MATCH** | Safe — always "at the work-item grain." |
| S12.05 | ~9 vs ~6 months re-estimate | record | B2 p17-19 | — | **MATCH** | Safe. |
| S12.06 | 339.5 min TTS baseline; ~2,200 operator interactions per departed shipment | record | B2 p17-19 | — | **MATCH** | Safe. |
| S12.07 | Per-minute pools $0.56 / $0.61 / $0.24 → ~$0.45 weighted → ≈$153 per shipment | model rows | B2 p19 | — (339.5 × $0.45 = $152.78 ✓) | **ROUNDING** | Say "about a hundred fifty dollars of human time per shipment, at Finance rates." |
| S12.08 | 29 WIs = 66.2 eng-months (5.5 yrs); Export SCO FCL 99.8 eng-months (31 WIs) | html only (cb91 omits) | B1 p16-17 | — | **MATCH** | Safe; present in html master only. |
| S12.09 | 69 WIs = 41 operator + 28 partner; 15 domains; 8-week rebuild rule | record | B1 p15-17; B2 p18-19 | — | **MATCH** | Safe. |
| S12.10 | Burn-up 55.8% → 63.3 → 66.0 → 69.3 → 76.0 → 83.2% (planned 3,307.4 eng-days) | html only | B1 p16-17 | — | **MATCH** | Safe; html only. |
| S12.11 | MVP April 2022 with 11 partners in 10 countries | record | B1 p16 result 1: "We went live April 2022 — the MVP, eleven partners in ten countries" | B1 math box p17: "Alpha Q4'22 -> MVP Q1'23"; HLSD p2: "UAT for the FFA Export Partner launch in March 2023" | **CONFLICT** | Apple v11 contradicts itself. Say "the import-side app went live April 2022 with eleven partners in ten countries"; the export scope is the later Q1-2023 launch. |
| S12.12 | 48 of 53 import partners (90.5%) migrated within a month | record | B1 p17 math box ("48/53 import partners in 1 month = 90.5%") | — | **MATCH** | Safe; always say "import partners." |
| S12.13 | ≈$1.5M/yr run-rate (76 × 20,000 export shipments = $1.52M) | modeled | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "on an illustrative twenty-thousand export shipments." |
| S12.14 | Engineering avoided ≈$2.9M (12 eng × 18 mo × 66% × $20K) + ≈$1.5M pulled forward ≈ $4.4M "within ~12% of ~$5M" | modeled | — | — (216 × 0.66 = 142.56; × $20,000 = $2,851,200 ✓; (5−4.4)/5 = 12%) | **UNSUPPORTED-modeled** | Say "my bottom-up model lands within about twelve percent of the record." |
| S12.15 | Employer in loop packet (Sephora) | §1.3 conflict | B-chapters are Flexport | Resume p1: Flexport Oct 2021 – Apr 2023 | **CONFLICT** | Master (Flexport) is right; loop packet is wrong. |

### S16 — Flexport — four systems into one Snowflake pipeline (+ security-review miss)

- **Apple chapter(s):** A3 (p10-11), G3 (p45-46)
- **GFiber v8 origin:** GFiber v8 S16 / MAIN BRD beat
- **Primary/source docs:** BRD_-_SV_Zendesk_Data_in_Snowflake p1-5; WBR_Metric_Culture_using_AI p1-2; State_of_SV_E2E_Connectivity_Monitoring p1-8

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S16.01 | >$100K/yr priced baseline | "priced in infra's own loaded rates" = ≈$30K hours + ≈$70K decision risk | A3 p10-11: ">$100K per year" = ~1.5-2 hrs/week × 52 of loaded PM time + VP decisions on stale joins; p11 Q&A: "two hours a week is maybe $10K … the hours alone don't get there" | BRD p1-2: "cost-to-serve, in excess of $100,000 annually"; BRD's own math: 3 people × 5 h/wk × 2 WBRs × ASSUMED $90/h → $129,600/yr → at 1 h/wk $25,920 → saving $103,680/yr (30 → 6 h/wk) | **CONFLICT** | Three derivations exist (BRD all-hours at an assumed $90/h; Apple hours + VP decisions; master $30K + $70K). None is "infra's own loaded rates." Say ">$100K a year — the BRD priced it at $103,680 on thirty hours a week of WBR work at an assumed ninety dollars an hour; my split into hours and decision risk is a model. Priced, not a claimed saving." |
| S16.02 | BRD typo "$10,880 cost per month" | — | — | BRD p2: $10,880/month but $129,600/12 = $10,800 | **CONFLICT** | If you quote monthly, say $10,800. |
| S16.03 | Four systems → one pipeline | record | A3 p10 | WBR_Metric_Culture p1: "collected data from 4 systems" | **MATCH** | Safe. |
| S16.04 | WBR accuracy 60% → 90% | record | A3 p10 ("System accuracy went from 60% to 90%") | WBR_Metric_Culture p2 | **MATCH** | Safe. |
| S16.05 | Parallel-run parity within 1% for consecutive weeks | record | A3 p11 (/manual − pipeline/ ≤ 1% for consecutive weeks) | — | **MATCH** | Safe. |
| S16.06 | First automated catch: 4% ticket-sync drop | record | A3 p10-11 (~4% after a routine update) | — | **MATCH** | Say "about four percent." |
| S16.07 | Security review cost two weeks | record | A3 p42; G3 p45-46: "under-planned by two weeks" | — | **MATCH** | Safe. |
| S16.08 | Seven metrics frozen | record | A3 p10 | BRD p2-3 lists seven metrics | **MATCH** | Safe. |
| S16.09 | As-Is: 1.5–2 hours to build a weekly snapshot | S16 situation | A3 p10 | BRD p2 As-Is | **MATCH** | Safe. |
| S16.10 | Bus factor 1 → ≥2 | record | A3: single point of failure (qualitative) | WBR_Metric_Culture p2: "i was the single point of failure" | **UNSUPPORTED-anchor** | "Bus factor ≥2" is a stated outcome with no count in Apple; say "no longer a single point of failure." |
| S16.11 | Hours term $30,160 (4 h/wk × 52 × $145) + decision-risk $70,200 (52 × 10% × $13.5K) = $100.4K; ledger says "≈$90K inside it" | modeled | — | — (arithmetic ✓; total row mid ≈$90K ≠ 30+70) | **UNSUPPORTED-modeled** | The master states both "30+70 = >$100K" and "≈$90K modeled" for the same thing. Use "about a hundred thousand" for the priced baseline and "my model" for any split. |

### S8 — Elementum — p99 lane promise (lead-time distributions)

- **Apple chapter(s):** F4 (p38-40)
- **GFiber v8 origin:** GFiber v8 S8
- **Primary/source docs:** Resume p1 (not stated); no primary doc

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S8.01 | 200 lanes | record | F4 p38-39 | — | **MATCH** | Safe. |
| S8.02 | 99% lead-time accuracy / 99% promise per lane | "p99 lane promise" | F4 p39: "99% lead-time accuracy across the measured lanes"; promise "at the tail" | — | **MATCH** | Say "a ninety-ninth-percentile promise; ninety-nine percent accurate across the measured lanes." |
| S8.03 | 580K units released | record | F4 p39: 580,000 units | — | **MATCH** | Safe. |
| S8.04 | ~$1.5M "released (record, one-time)" | record, one-time working capital; carry modeled separately | F4 p39: "About $1.5 million of carrying cost released" | $1.5M ÷ 580,000 = $2.59/unit (implied unit value) | **CONFLICT** | Apple calls it carrying cost (a recurring term); master treats it as a one-time inventory release. Say "about a million and a half of inventory carrying cost released" and do not annualize. |
| S8.05 | $2M (S6) + $1.5M (S8) never summed | rule | F3 $2M and F4 $1.5M listed separately | — | **MATCH** | Consistent. Never say "$3.5M." |
| S8.06 | Carry rate: modeled recurring ≈$0.6M/yr = $1.5M × 20% carry ($300K) + expedites $270K | modeled | — | S6 uses 10% carry on $2M ($200K); S2 uses 10% on $2.2M | **CONFLICT** | Internal model inconsistency (20% vs 10%). Use 10% (S6/S2 and "8-12%" in S6 Q&A) or label as a range. |
| S8.07 | Expedites avoided: 900 shipments/yr (illustrative) × 10% = 90 × $3,000 = $270K | modeled | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "modeled." |

### S6 — Elementum — real-time supply/demand view (shortage alert)

- **Apple chapter(s):** F3 (p37-38)
- **GFiber v8 origin:** GFiber v8 S6
- **Primary/source docs:** Resume p1 ("forecast accuracy 70→85%, $2M safety stock")

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S6.01 | Forecast accuracy 70% → 85% (scoped class-A SKUs) | record | F3 p37: 70% → 85% at the planning grain | Resume p1 | **MATCH** | Safe — say "at the planning grain / class-A SKUs." |
| S6.02 | $2M safety stock released | record, one-time | F3 p37-38: "About $2 million of safety stock" | Resume p1; released only where forecast AND lead-time error improved | **MATCH** | Safe. |
| S6.03 | Shortage alert live in 3 months | record | F3 p37 | — | **MATCH** | Safe — never paste it onto S7. |
| S6.04 | Planner effort −50% (record) | record | F3 p37 result 2: "planner collaboration up 50% once the Google Sheets died" | — | **CONFLICT** | Different metric. Say "planner collaboration up fifty percent" (Apple) or drop. "Effort −50%" has no Apple support. |
| S6.05 | Eight SAP data domains; six-site manufacturer | situation | F3: no domain count, no site count | GFiber v8 | **UNSUPPORTED-anchor** | User anchor — keep, but say "about eight domains." |
| S6.06 | Adoption 8× | result (S6 and S9 both) | — | GFiber v8 | **UNSUPPORTED-anchor** | The identical "8×" appears in S6 and S9 — use in one story only, or drop. |
| S6.07 | Shipment data 60% complete at the start | S6 situation | F1 p34: 60% → 95% belongs to the lane-onboarding program (S9) | — | **CONFLICT** | Do not quote 60% in S6 (it is S9's metric). |
| S6.08 | ≈$0.8M/yr modeled (carry $200K + expedites $300K + planner capacity $288K) | modeled | — | — (200+300+288 = 788 ✓) | **UNSUPPORTED-modeled** | Say "modeled; separate from the $1.5M lane program." |
| S6.09 | Planner burn 12 planners × 40% = 4.8 FTE | modeled | — | — | **UNSUPPORTED-modeled** | Illustrative. |

### S9 — Elementum — 597-lane EDI Pareto (1,000 asked, 597 first)

- **Apple chapter(s):** F1 (p34-35)
- **GFiber v8 origin:** GFiber v8 S9
- **Primary/source docs:** Resume p1: "1,000 supplier/carrier routes … cohort gate ≥95% valid ASN … completeness 60% → 95%"

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S9.01 | 1,000 lanes in two months | "1,000 asked; 597 built first" | F1 p34: "a thousand lanes onboarded across twenty-five European locations" in the window — "Versus goal: hit" | Resume p1: "Program-managed 1,000 supplier/carrier routes" | **CONFLICT** | Apple v11 and the resume claim 1,000 delivered; master says 597 first (+~200 next) and ~400 deferred. This is the largest drift in the set. Safe: "a thousand-lane program; I phased by value, 597 lanes carrying 80% of spend went first" — and confirm what actually went live. |
| S9.02 | 597 lanes = 80% of freight spend | record | Not in Apple | GFiber v8 only | **UNSUPPORTED-anchor** | User anchor; the Pareto is the story's spine — confirm. |
| S9.03 | ~200 next wave; ~400 deferred (~20% of spend) | record | F1: "top cohort first, long tail later"; no counts | GFiber v8 (597 + ~200 + ~203 = 1,000) | **UNSUPPORTED-anchor** | Say "the remainder behind the same gate." |
| S9.04 | Completeness ~60% → 95% | record | F1 p34-35 | Resume p1 | **MATCH** | Safe — only in this story. |
| S9.05 | ≥95% valid-ASN cohort gate | record | F1: gate = DQ bar on engine-read fields + first tenders match the routing guide (no ASN %) | Resume p1: "cohort gate ≥95% valid ASN" | **MATCH** | Safe (resume). |
| S9.06 | Freight −10% ≈ $2M in six months | record | Not in F1 (F2 has $8M across 25 locations) | GFiber v8 only | **UNSUPPORTED-anchor** | User anchor; "$2M" must not be confused with S6's $2M safety stock — name the noun every time. |
| S9.07 | Adoption 8×; 100% visibility on high-value lanes | record | — | GFiber v8 | **UNSUPPORTED-anchor** | Optional; unsupported. |
| S9.08 | Cohort failed the gate twice on a timestamp format | record | — | GFiber v8 | **UNSUPPORTED-anchor** | Keep as the held-gate beat; user anchor. |
| S9.09 | Scope: "1,000 global lanes" | S9 situation | F1 p34: "25 European locations", 3PL/4PL lanes via X12/EDI and XML | — | **CONFLICT** | Say "a thousand lanes across twenty-five European locations." |
| S9.10 | S9 vs S10 lane counts: S9 1,000/597 vs S10 "25 EU sites / 400+ lanes ≈ $8M" | internal | F1: 1,000 lanes / 25 locations; F2: $8M across 25 locations | — | **CONFLICT** | Pick one: Apple says 1,000 lanes / 25 locations for the program. Do not say "400+ lanes" aloud. |
| S9.11 | $2M decomposition 0.8 + 0.6 + 0.6 = $2.0M; +≈$0.4M/yr document labor | modeled | — | — (arithmetic ✓: 90,000 × 6 min = 540,000 min → $405K) | **UNSUPPORTED-modeled** | Say "my split decomposes the record, never adds." |
| S9.12 | Implied base: $2M ÷ 10% = $20M | derived | — | — | **UNSUPPORTED-modeled** | Do not volunteer. |

### S7 — Elementum — contract-manufacturer BOM phantoms / revisions (six-site ingest)

- **Apple chapter(s):** none — no chapter; grep for "six sites", "BOM", "contract manufactur" returns nothing in Apple v11
- **GFiber v8 origin:** GFiber v8 S7
- **Primary/source docs:** none; Resume p1 has no such bullet

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S7.01 | Six sites, three waves, 5 months | record | Not in Apple | GFiber v8 only | **UNSUPPORTED-anchor** | Entire story is user-anchor only. Say "six sites," never "six NA sites." |
| S7.02 | Hardest site 6 weeks vs 3-week average | record | — | GFiber v8 | **UNSUPPORTED-anchor** | User anchor. |
| S7.03 | Zero auto-loaded revision overlaps | record | — | GFiber v8 | **UNSUPPORTED-anchor** | User anchor. |
| S7.04 | CM sites with planning-grade BOM 0 → 6 | record | — | GFiber v8 | **UNSUPPORTED-anchor** | Brief rule: "Finished-goods grain only. NO BOM explosion stories." This story is BOM-centric; either reframe at finished-goods/site grain or demote to bench. |
| S7.05 | ≈$0.3M/yr modeled (recon $77,760 + phantom expedites $216,000 + overlap rework $23,040 = $316,800) | modeled | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "modeled; the $1.5M belongs to S8." |
| S7.06 | "500+ product families" / "6 NA sites" / 60→95% inside S7 | never-say | — | — | **MATCH** | Integrity scan: only appears inside the never-say lists in html and cb91. |

### S10 — Elementum — Austria routing-guide DQ/OTD (25 EU sites, ~$8M)

- **Apple chapter(s):** F2 (p35-37)
- **GFiber v8 origin:** GFiber v8 S10
- **Primary/source docs:** Resume p1 (not stated)

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S10.01 | Reported DQ ~40%; true ~55% at the measured grain | record | F2 p35: ~55% true vs 40% reported | — | **MATCH** | Safe. |
| S10.02 | DQ → 99% | "~99% in 3 months"; never "two months" | F2 p36: target "99% in two months"; result "99%… inside the two-month bar" | — | **CONFLICT** | Apple v11 says two months; master canon says three. "Within a quarter" is true under both. Resolve with Rajesh before the loop. |
| S10.03 | Manual reconciliation 8–10 hrs/week | record | F2 p35: eight to ten hours | — | **MATCH** | Safe. |
| S10.04 | After state "1–2 hrs/wk" | record | F2 p36: "the reconciliation hours gone" | GFiber v8 | **UNSUPPORTED-anchor** | Say "from eight-to-ten hours to a small fraction." |
| S10.05 | Austria pilot ≈97% on-time measurement accuracy and ≈$500K/yr, implemented in one month, green-lit 25 locations | record | F2 p36 | — | **MATCH** | Safe. |
| S10.06 | $500K/yr = 10% of ~$5M freight base | record | F2 p36: ~$500K a year at one site | GFiber v8 for the $5M base | **UNSUPPORTED-anchor** | Say "about five hundred thousand a year at Austria"; the base is an anchor. |
| S10.07 | ~$8M validated freight savings across 25 EU locations (~$320K/site) | record | F2 p35-36: ~$8M across twenty-five European locations | Resume p1 ("$27M+" aggregate is NOT $8M); $8M ÷ 25 = $320K | **MATCH** | Say "about eight million, executed-only, auditable per shipment." Never "$1M". |
| S10.08 | "25 EU sites / 400+ lanes" | record | F1/F2: 1,000 lanes, 25 locations | GFiber v8 | **CONFLICT** | Do not say 400+; see S9. |
| S10.09 | ~8% of lanes need Incoterm in the key | record | F2 p36 mentions Incoterm in shipment rules; no % | GFiber v8 | **UNSUPPORTED-anchor** | User anchor. |
| S10.10 | ≈$0.5M/yr modeled analyst capacity (7.5 h/wk × 25 sites × 50 wk × $55 = $515,625) | modeled | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "modeled; range $0.2-0.7M." |

### S17 — Elementum — the semi-annual carrier bid

- **Apple chapter(s):** none — no chapter
- **GFiber v8 origin:** GFiber v8 S17
- **Primary/source docs:** none

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S17.01 | Cycle 6 weeks → ~3 (~50%); pilot region 3 weeks early | record | Not in Apple | GFiber v8 only | **UNSUPPORTED-anchor** | User anchor. |
| S17.02 | Back-test mismatch <5% vs the last two awards (gate); 10-day stale banner | record | — | GFiber v8 | **UNSUPPORTED-anchor** | User anchor; say as design thresholds. |
| S17.03 | No dollar on the award | rule | — | — | **MATCH** | Compliant: master carries no award $. |
| S17.04 | ≈$190K/yr modeled analyst time (2,200 h × $85 = $187,000); range $35-420K | modeled | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "modeled hours returned — never award savings." |
| S17.05 | All-cheapest award $530,000 vs constrained award $532,500 (+0.47%) | worked example | — | — (3 lanes: 100×$900 + 200×$1,000 + 300×$800… recomputed ✓) | **UNSUPPORTED-modeled** | Illustrative design example; label "toy". |

### S13 — Manhattan — Cyber Monday 4 AM allocation

- **Apple chapter(s):** M1 (p40-41)
- **GFiber v8 origin:** GFiber v8 S13
- **Primary/source docs:** Resume p1 (3 DCs + 100 stores; stockouts −20%; 99% fill vs 95%; ~$8M)

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S13.01 | 3 DCs + 100 stores | record | M1 p41 sources | Resume p1 | **MATCH** | Safe. |
| S13.02 | 99% fill vs 95% goal | record | M1 p40: 99% fill, "above the goal" | Resume p1: "99% fill vs 95% goal" | **MATCH** | Safe. |
| S13.03 | ~$6M at risk | record | M1 p40: "about $6 million of lost sales and reputational risk" | — | **MATCH** | Safe. |
| S13.04 | ~$8M protected | record | M1 p40 result 2: "About $8 million of Cyber Monday revenue protected — the final sales figure"; p41 math box: "~$8M revenue at risk" | Resume p1: "protecting ~$8M in sales" | **CONFLICT** | Apple itself uses $8M as both "at risk" and "protected." Say "about six million on the line when the page fired; about eight million of the day's sales protected." |
| S13.05 | Stockouts −20% | record | Not in M1 | Resume p1 | **MATCH** | Safe (resume). |
| S13.06 | Never "$2MM baseline" | rule | — | — | **MATCH** | No hit in master/cb91. |
| S13.07 | Modeled: $8M × 40% GM = $3.2M; 40,000 orders at risk ($6M ÷ $150); $1.28M expedite… | modeled | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "modeled; $8M/$6M/99% are the record." |
| S13.08 | Distance pair 0.85 d vs 4.60 d = 3.75 d | record pair | — | GFiber v8 | **UNSUPPORTED-anchor** | User anchor; low-use. |

### S14 — Manhattan — the $2.5M OMS↔WMS discrepancy (transparency over a quiet fix)

- **Apple chapter(s):** none (M1 is a different story); resume has no mention
- **GFiber v8 origin:** GFiber v8 S14
- **Primary/source docs:** none

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S14.01 | ~200 orders / $2.5M of order value made consistent in the open | record | Not in Apple | GFiber v8 only | **UNSUPPORTED-anchor** | User anchor. Say "about two hundred orders and two-point-five million of order value" — and never as savings. |
| S14.02 | $10M initiative won | record; never counted as savings | Not in Apple | GFiber v8 only | **UNSUPPORTED-anchor** | Say "the ten-million initiative was won at the review — a fact about the relationship, not a saving." |
| S14.03 | Expected corruption $1.5M (0.3 × 2 × $2.5M) / audit finding on a $10M relationship | risk math | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "avoided risk, not money." |
| S14.04 | Modeled prevention ≈$0.1M/yr (labor $29K + carry $30K + war room $43K = $102K) | modeled | — | — (arithmetic ✓) | **UNSUPPORTED-modeled** | Say "modeled." |
| S14.05 | Collision: three different "$2.5M" and four different "$1.5M" in one packet | cross-story | S1 $2.5M/yr; S14 $2.5M order value; S18 $2.5M/month. $1.5M: S1 modeled, S8 released, S11 pre-prod, S14 expected loss | — | **CONFLICT** | Never say a bare "$2.5M" or "$1.5M"; always attach the noun. |

### S19 — Elementum · Walmart Marketplace client — σ-proportional delivery-promise buffers

- **Apple chapter(s):** none (closest lived record: F4 p38-40)
- **GFiber v8 origin:** none (new in master v2; html only — absent from cb91)
- **Primary/source docs:** Walmart_WBR_R2596147_Solver_Model.xlsx (sheets "Solver 1 - Buffers", "Solver 2 - Allocation", "Scenario - Q4 Peak", "Model - Decomposition"; recomputed with pandas); Walmart_R2596147_HiringManager_WarBook; Walmart_TechOps_WBR_DeepDive

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S19.01 | PROVENANCE: story presented as a client engagement | Master §4.4: "Elementum engagement lead for a marketplace client … record-from-docs of the Walmart Marketplace engagement record (R-2596147 war book + Tech Ops WBR deep-dive)" | No Walmart engagement in Apple v11 (A-M, G chapters) or in the resume (Elementum Feb 2017 – Apr 2019) | Walmart_R2596147_WarBook p1: "Hiring-manager interview · Tuesday Sep 9, 2026 · 30 minutes"; "R-2596147" is a Walmart job requisition; Walmart_TechOps_WBR_DeepDive p1: "Prepared: Aug 18, 2026"; sample data "illustrative … Wk 28-Wk 33, 2026" | **CONFLICT** | The "engagement documents" are Rajesh's own interview-prep books for a Walmart role, built on illustrative data. Do NOT say "my client at Walmart" or "the engagement delivered." Safe: "a design case I worked through for a marketplace delivery-promise role — here is the math." The only lived record behind it is Apple F4 (200 lanes, 99%, 580K units, ~$1.5M). |
| S19.02 | Policy A uniform 1.10-day buffer: accuracy 95.8%, avg promised day 3.09, fast share 7.6%, profit $5.69M/wk | 95.8% / 3.09 / 7.6% / $5.69M | — | Solver model recomputed: 95.78% / 3.086 / 7.6% / $5,685,617 | **UNSUPPORTED-modeled** | Always say "in the model." |
| S19.03 | Policy B b = 1.645σ: accuracy 95.0% floor held, 2.75 days, fast share 39.6% (+32 pts), profit $5.94M/wk | 95.0% / 2.75 / 39.6% / $5.94M | — | Recomputed: 95.0% / 2.753 / 39.6% / $5,940,986 | **UNSUPPORTED-modeled** | "Model" qualifier required. |
| S19.04 | +$255K/wk ≈ $13.3M/yr (×52) | $13.3M/yr modeled | — | Recomputed $255,368 × 52 = $13.28M | **UNSUPPORTED-modeled** | Never "the buffer model saved $13M." |
| S19.05 | Policy D (profit optimum): 97.8% accuracy / $6.07M/wk ≈ +$20M/yr vs uniform | $6.07M; +$380K/wk × 52 = $19.76M | — | Recomputed D ≈ $6.074M → +$388K/wk → +$20.2M/yr | **ROUNDING** | Say "about twenty million, in the model — handed to Finance, never claimed." |
| S19.06 | Breach cost $12 vs $6.50 contribution margin | model assumptions | — | Model sheet inputs | **UNSUPPORTED-modeled** | Say "the model's assumption." |
| S19.07 | Q4 regime σ ×~1.45; frozen summer dial prints 91.9% (below the 95% floor) | illustrative | — | Recomputed from "Scenario - Q4 Peak": 91.9% | **UNSUPPORTED-modeled** | Say "in the model." |
| S19.08 | Φ(5.0) ≈ 99.99997% tightest cohort vs Φ(0.69) ≈ 75.4% widest | arithmetic | — | z = 1.10/0.22 = 5.0; 1.10/1.60 = 0.6875 ✓ | **UNSUPPORTED-modeled** | Illustrative cohort σ 0.22-1.60 d. |

### S20 — Elementum · Walmart Marketplace client — the pre-purchase WBR and promise decomposition

- **Apple chapter(s):** none
- **GFiber v8 origin:** none (html only)
- **Primary/source docs:** Walmart_TechOps_WBR_DeepDive (Part 1, "illustrative sample data Wk 28-33"); LSA_WBR_2022 Instructions rows 6-9 (xlsx)

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S20.01 | PROVENANCE | Master §4.4: "Elementum engagement lead for a marketplace client … record-from-docs of the Walmart Marketplace engagement record (R-2596147 war book + Tech Ops WBR deep-dive)" | No Walmart engagement in Apple v11 (A-M, G chapters) or in the resume (Elementum Feb 2017 – Apr 2019) | Walmart_R2596147_WarBook p1: "Hiring-manager interview · Tuesday Sep 9, 2026 · 30 minutes"; "R-2596147" is a Walmart job requisition; Walmart_TechOps_WBR_DeepDive p1: "Prepared: Aug 18, 2026"; sample data "illustrative … Wk 28-Wk 33, 2026" | **CONFLICT** | The "engagement documents" are Rajesh's own interview-prep books for a Walmart role, built on illustrative data. Do NOT say "my client at Walmart" or "the engagement delivered." Safe: "a design case I worked through for a marketplace delivery-promise role — here is the math." The only lived record behind it is Apple F4 (200 lanes, 99%, 580K units, ~$1.5M). |
| S20.02 | Decomposition O1 ≈ I3 × I4 × Φ(b/σ): 0.97 × 0.985 × 0.996 = 95.2% | sample week | — | Arithmetic: 0.97 × 0.985 × 0.996 = 0.9516 ✓ | **UNSUPPORTED-modeled** | Say "in the docs' sample week." |
| S20.03 | Promise Yield = fast share × accuracy = 43.6% × 95.2% = 41.5% baseline; 4-quarter target 50% | illustrative | — | Arithmetic ✓ (0.436 × 0.9516 = 0.4149) | **UNSUPPORTED-modeled** | Say "illustrative baseline." |
| S20.04 | Aggregate trap: carrier 97% nationally, 82% in the Southeast | docs example | — | Walmart deep-dive Part 1 | **UNSUPPORTED-modeled** | Say "a worked example." |
| S20.05 | Red/green ±5% relative WoW; Monday freeze, Tuesday review | "LSA conventions" | — | LSA_WBR_2022 Instructions rows 6-9 (green/red >5% relative; week Mon-Sun) | **MATCH** | Safe — the WBR format is real (S11). |
| S20.06 | Hard reds: OTD <90%, late shipment >5%, cancellation >2% | policy floors | — | Walmart deep-dive (design thresholds) | **UNSUPPORTED-modeled** | Say "the thresholds I proposed." |
| S20.07 | Andon: 7-day EWMA/CUSUM per seller-lane cell; tripwire 2× baseline with n ≥ 30; act <24 h; false-trip <5% | design parameters | — | Walmart deep-dive / master design | **UNSUPPORTED-modeled** | Say "design parameters." |
| S20.08 | Episode: 16,000 excess breaches × $12 = $192K/wk × 3 weeks = $576K ≈ $0.58M per caught episode | modeled | — | Arithmetic ✓ | **UNSUPPORTED-modeled** | Never annualize (frequency is the client's data). |
| S20.09 | New carrier factor 0.90 × 0.985 + 0.10 × 0.82 = 0.9685 → O1′ 93.6% | illustrative | — | Arithmetic ✓ (0.9516 → 0.9357) | **UNSUPPORTED-modeled** | Say "illustrative." |

### S21 — Elementum · Walmart Marketplace client — SSS adoption as a priced insurance contract

- **Apple chapter(s):** none
- **GFiber v8 origin:** none (html only)
- **Primary/source docs:** Walmart_R2596147_HiringManager_WarBook (SSS section); Walmart_TechOps_WBR_DeepDive

| ID | Claim | Amazon master value | Apple v11 value | Source doc value (file + page) | Status | Recommended safe wording |
|---|---|---|---|---|---|---|
| S21.01 | PROVENANCE | Master §4.4: "Elementum engagement lead for a marketplace client … record-from-docs of the Walmart Marketplace engagement record (R-2596147 war book + Tech Ops WBR deep-dive)" | No Walmart engagement in Apple v11 (A-M, G chapters) or in the resume (Elementum Feb 2017 – Apr 2019) | Walmart_R2596147_WarBook p1: "Hiring-manager interview · Tuesday Sep 9, 2026 · 30 minutes"; "R-2596147" is a Walmart job requisition; Walmart_TechOps_WBR_DeepDive p1: "Prepared: Aug 18, 2026"; sample data "illustrative … Wk 28-Wk 33, 2026" | **CONFLICT** | The "engagement documents" are Rajesh's own interview-prep books for a Walmart role, built on illustrative data. Do NOT say "my client at Walmart" or "the engagement delivered." Safe: "a design case I worked through for a marketplace delivery-promise role — here is the math." The only lived record behind it is Apple F4 (200 lanes, 99%, 580K units, ~$1.5M). |
| S21.02 | SSS ≈ 38-42% of seller-fulfilled GMV (stalled) | record-from-docs | — | Walmart war book (prep estimates) | **UNSUPPORTED-modeled** | Say "roughly forty percent in my case materials." |
| S21.03 | Sellers declare 1-day handling and hit it ~85% of the time (adverse selection) | record-from-docs | — | Walmart war book | **UNSUPPORTED-modeled** | Say "about eighty-five percent in the case data." |
| S21.04 | ≈$3.7M/yr per +10 pts of enrolled GMV: 100K orders/wk × (15% − 3%) × 50% × $12 × 52 = $3,744,000 | modeled | — | Arithmetic ✓ (12,000 × 0.5 × $12 = $72,000/wk) | **UNSUPPORTED-modeled** | "Modeled — designed, not banked." |
| S21.05 | Handling-driven breach cost ≈$540K/wk (90,000 misses × 50% × $12) | modeled | — | Arithmetic ✓ | **UNSUPPORTED-modeled** | Say "model." |
| S21.06 | Range ≈$0.8M / $3.7M / $8.5M per +10 pts | sensitivity | — | — | **UNSUPPORTED-modeled** | Say the middle only. |

### E1-E12 — design-round stories (bridge, illustrative volumes)

The E-series are labeled design engagements with "volumes illustrative" in their honest lines. Census of their numbers:

| Story | Topic | Numbers checked | In Apple | In primary docs | GFiber-only | Nowhere (derived) | Note |
|---|---|---|---|---|---|---|---|
| E1 | contractor / truck-stock inventory | 18 | 4 | 2 | 12 | 0 | Honest line: "volumes are illustrative"; ≈ all numbers derive from S1/S2/S14 logic. |
| E2 | serial-number tracking | 26 | 6 | 2 | 18 | 0 | Illustrative; no record claims. |
| E3 | vendor EDI + VMI for long-lead equipment | 21 | 4 | 4 | 13 | 0 | Illustrative; no record claims. |
| E4 | CRM order → SAP fulfillment integration | 11 | 4 | 2 | 5 | 0 | Illustrative; no record claims. |
| E5 | 3PL inventory reconciliation | 18 | 4 | 2 | 11 | 1 | Cross-checks to S18 (0.5% tolerance) — consistent with Apple D2. |
| E6 | PLM ECN → SAP material/BOM handoff | 10 | 4 | 0 | 6 | 0 | BOM-handoff theme: check against brief rule "no BOM explosion stories". |
| E7 | equipment supply & demand forecasting (new market) | 20 | 6 | 4 | 10 | 0 | html line 3343 and cb91 line 5734: "[Install demand] --kit BOM explosion--> …" violates the brief's integrity grep (`BOM explosion`); reword to "kit-to-component conversion at SKU-week grain." |
| E8 | monthly release / regression strategy | 11 | 4 | 2 | 5 | 0 | Illustrative; no record claims. |
| E9 | ERP cutover from a legacy WMS | 16 | 10 | 1 | 5 | 0 | Ties to S18/D1-D2 (0.5% tolerance, 7→1.8→0.3 mocks) — consistent. |
| E10 | returns / RMA flow | 29 | 10 | 5 | 14 | 0 | Illustrative; no record claims. |
| E11 | long-lead direct procurement | 14 | 3 | 2 | 9 | 0 | Illustrative; no record claims. |
| E12 | smart vending machines / consignment ledger | 33 | 8 | 7 | 17 | 1 | cb91 file includes §4.1 canon rows inside the E12 text range (page-split artifact, not a content difference). |

---

## 3. CANON v2 — numbers the candidate will say aloud

Basis labels: **record** (Apple v11 + resume agree) · **record-from-docs** (primary doc) · **user anchor** (GFiber v8 only; confirm) · **modeled** · **illustrative**. One value per metric.

| # | Story | Number to say | Basis | Source | Rule / do-not-say |
|---|---|---|---|---|---|
| 1 | S11 | Customers 7 → 68 (9.7×) | record | Apple A1 p6-7; resume p1 | Never "50x" (WBR_Metric_Culture p2 says "MAC to 50X"), never "10×" |
| 2 | S11 | 170 monthly active users (public target, landed) | record | Apple A1 p6-7 | Never "MAU 400 → 3X" |
| 3 | S11 | 32,000 shipments = public TARGET only | record (target) | Apple A1 p7 | Never "achieved 32,000" |
| 4 | S11 | Both 68-customer and 170-user targets landed two months early | record | Apple A1 p7 | — |
| 5 | S11 | CTS $0.66 → $0.03 per container (about 95% cut) | record | Apple A1 p7, A2 p9; WBR_Metric_Culture p2 | −95.5% only if asked precisely (95.45%); never "$1.00 → $0.03" |
| 6 | S11 | Hand-carried pilot-week CTS about $1.00 (optional aside) | record (Apple) | Apple A1 p6, p8 | Only as "about a dollar in the hand-carried weeks" |
| 7 | S11 | Automation 40% → 90% (70% no-touch gate) | record | Apple A1 p7, A2 p8 | Never "60 → 97" (loop packet) |
| 8 | S11 | Ticket response 72% → 90%; volume 5× | record | Apple A1 p7; WBR_Metric_Culture p2 | Add to S11 |
| 9 | S11/S16 | System accuracy 60% → 90% (use in ONE story) | record | Apple A3 p11, A4 p13; WBR_Metric_Culture p2 | Say "system accuracy," not ETA accuracy |
| 10 | S11 | Six graduation criteria: SLA ≥90%, DQ ≥90% (≥ Crux), ETA ≥80%, stable, ≥100 containers + features, no show-stoppers + CSAT ≥ consignee avg | record-from-docs | SV_Pilot_Client_Roll-out_Schedule p1-2; Apple A1 p7-8 | — |
| 11 | S11 | ~50-container calibration entry bar | record-from-docs | Pilot schedule p1, p4 | — |
| 12 | S11 | Waves: 2 (Q4'21) → 4 (Q1'22) → 20+ (Q2'22) → 40 by Q3 → 68 by Q4 | record | Apple A1 p7; Pilot schedule p1 | — |
| 13 | S11 | Wave 3 held once on ETA accuracy; zero rollbacks | record | Apple A1 p7 | — |
| 14 | S11 | 99.4% three-touch week discarded | record | Apple A2 p8-9 | — |
| 15 | S11 | 10,289 events, 1,991 human = 19.4% (event grain); weekly 40.2% (mid-Dec) → 69.2% (late Feb) | record | Apple A2 p9 (SV_28.xlsx) | Always state grain + date |
| 16 | S11 | About four hours a week of manual scorecard at its worst | record | Apple A1 p8, A2 p9 | Not "1.5-2 → 4" |
| 17 | S11 | Pre-prod: 500 containers in 20 min at 99.6% connectivity | record-from-docs | TPM status 11/19/21 p10 | — |
| 18 | S11 | E2E dry run: 100% processed, 86% tracked; job stories 98.4% | record-from-docs | TPM status p10; Apple A2 p9 | Not "85%" |
| 19 | S11 | Scraper errors: Air 5.09%, Ocean 8.99% (goal <10%) | record-from-docs | TPM status p11 | — |
| 20 | S11 | Nine teams / about a hundred people | record | Apple A1 p7; Path_to_4PL p1 | — |
| 21 | S11 | Pre-prod sample 300 containers, ±1.6% at 95%; rollout 1.5 vs 6 months; ~$1.5M saved | user anchor | GFiber v8 ~15317/27884 (not in Apple) | Separate from CTS; label "my estimate" |
| 22 | S11 | Direct CTS dollars ≈$50K/yr | modeled | S11 model rows | Say "modeled, illustrative container count" |
| 23 | S11 | 79 legacy Crux customers; $185,892 ARR ($15,491 MRR); 294,581 containers | record-from-docs | RAPID_Crux_Customer_Transition p2-5; Apple A4 | Add to S11/A4 depth |
| 24 | S16 | >$100K a year priced baseline ($103,680 in the BRD: 30 → 6 hrs/wk across two WBRs at an assumed $90/h) | record-from-docs | BRD p1-2; Apple A3 p10-11 | Priced, never "savings"; monthly is $10,800 (BRD typo $10,880); the $30K/$70K split is modeled |
| 25 | S16 | Four systems → one pipeline; seven frozen metrics | record | Apple A3 p10; BRD p2-3 | — |
| 26 | S16 | Parity within 1% for consecutive weeks; 4% ticket-sync drop caught | record | Apple A3 p11 | — |
| 27 | S16 | Security review cost two weeks | record | Apple A3 p42, G3 p45-46 | — |
| 28 | S16 | As-Is snapshot 1.5–2 hours | record-from-docs | BRD p2 | — |
| 29 | S12 | 18 months → value in 6; 66% less effort | record | Apple B2 p17-19; resume | — |
| 30 | S12 | About $5M cost avoidance (say once) | record | Apple B2 p18-19; resume | Never "annual reduction"; skip "15% lower overhead" |
| 31 | S12 | CTS −50% partner-first vs −25% operator-first (work-item grain) | record | Apple B2 p17-19 | — |
| 32 | S12 | ~9 vs ~6 months build re-estimate | record | Apple B2 p17-19 | — |
| 33 | S12 | 339.5 min per shipment; ~2,200 operator interactions per departed shipment | record | Apple B2 p17-19 | — |
| 34 | S12 | $0.56 / $0.61 / $0.24 per minute pools; ~$0.45 weighted → ≈$153 | record rates; modeled product | Apple B2 p19 | — |
| 35 | S12 | 29 WIs = 66.2 eng-months; Export SCO FCL 99.8 eng-months (31 WIs) | record | Apple B2 p19 | html master only |
| 36 | S12 | 69 WIs = 41 operator + 28 partner; 15 domains; 8-week rebuild rule | record | Apple B1 p15-17 | — |
| 37 | S12 | MVP April 2022: 11 partners, 10 countries; 48 of 53 import partners (90.5%) in a month | record | Apple B1 p15, p17 | Say "import-side app"; export MVP is Q1 2023 in HLSD |
| 38 | S12 | Asia P95 page load 21.19 s vs US 3.3 s (others 4.45 s), 04/24-05/10; static JS 5 s China vs 500 ms US | record-from-docs | FF_App_Asia_Latency_Investigation p1-2 | Optional depth; a measured problem, no fix result in the doc |
| 39 | S12 | Burn-up 55.8% → 83.2% (planned 3,307.4 eng-days) | record | Apple B2 p19 | html master only |
| 40 | S1 | ≈$2.5M/yr = $1M MCS support retired + ≈$1.5M modeled | user anchor + modeled | GFiber v8; SAP playbook p2 (Adobe prep) | Always split record vs model; never a bare "$2.5M" |
| 41 | S1 | ISM FSD v1.1 (3/5/25) → v1.2 (5/16/25) → signed 6/5/25 by three orgs | user anchor | GFiber v8 lines 969/3107 only | Confirm before saying the day |
| 42 | S1/S2 | E2E Inbound 11/22 · Dotcom 12/20 · Retail 1/30; PO-creation go-live Jan 2025 → combined May 2025 | record | Apple C1 p22 | — |
| 43 | S2 | Zero customer-facing incidents; +15% processing efficiency | record | Apple C1 p21-22; resume | — |
| 44 | S2 | 836-row issues log; 714 closed = 85.4% | record | Apple C2 p24; UDC log (pandas) | — |
| 45 | S2 | Blocker 164 + Critical 277 = 441 = 52.8% | record | Apple C2 p24; UDC log | 52.75% exact |
| 46 | S2 | Bugs 115 (~14%); requirements 159; action items 117; questions 23 | record | Apple C2 p24; UDC log | Not in master — add |
| 47 | S2 | Robotics gate 98% (99% stretch); week 2 = 94%; ~30% throttled; full automation week 3 | record | Apple C3 p26 | — |
| 48 | S2 | Locus-side rows 86 of 836 = 10.3% | record | Apple C3 p26; UDC log | — |
| 49 | S2/S5 | Gate chain 3/29 → 4/30 → 5/15 → 7/2 → 7/31 → 8/14; peak freeze Oct-Dec | record | Apple C4 p28 | — |
| 50 | S2/S5 | 60+ stakeholders (~80 names, ~15 functions); about a dozen impacted systems | record | Apple C1 p22, C4 p28 | Do not say "20+ systems" or "fifteen tracks" |
| 51 | S2 | Cutover 343 tasks / 48,885 task-min ≈ 815 hrs; rollback sync <99% × 4 h, p95 >2× × 1 h | record | Apple C1/C2; resume; SAP Narrative p4 | — |
| 52 | S2 | ~30 build tracks; Locus retail testing slipped 3 weeks | record | Apple C2 p24 | — |
| 53 | S2 | About fifteen months, discovery to go-live | record | Apple C1 p21 (C2 says fourteen) | Say "about fifteen months" only |
| 54 | S2 | ≈$1.6-1.7M/yr modeled (illustrative 100K-units/week DC) | modeled | S2 model rows | Record carries no $ |
| 55 | S3 | Financial On-Hand truths 2 → 1; match-rate design target ≥99.5% in 24 h; ≈$0.6M/yr modeled | user anchor / modeled | GFiber v8 | — |
| 56 | S4 | σ ≈0.3 day → ~0.49-day window ≈95%; oversell +0; kill switch never fired | user anchor | GFiber v8; recomputed 1.645 × 0.3 | Math is correct |
| 57 | S5 | Three decisions + out-of-scope fence; every row has signed LOE by 7/2 | record | Apple C4 p28 | — |
| 58 | S18 | 8 months; ~$1.8M, ~3% under (~$54K) | record | Apple D1 p28-29 | — |
| 59 | S18 | Mocks 7.0% → 1.8% → 0.3% vs 0.5% (published with Finance before mock 1) | record | Apple D2 p31; resume | — |
| 60 | S18 | $20M pipeline of four projects; ≈$2.5M/month on average (my division, not banked) | record / derived | Apple D1 p29 | — |
| 61 | S18 | 72-hr freeze; RP read-only 30 days; hypercare exit <2 blockers/day in week 3 of 4; 14 core + 6 DC Ops | record | Apple D1/D2 p29-31 | — |
| 62 | S18 | RF device script: "hundreds" of devices; 3-4 day estimate; training slipped 1.5 weeks | record | Apple G2 p44-45 | Not "~100 of ~400" |
| 63 | S15 | 20-person team; 6-week hybrid → 4-week cadence in 6 weeks; critical defects −50% | record | Apple D3 p31-32; resume p1 | — |
| 64 | S9 | A thousand-lane program across 25 European locations; completeness ~60% → 95% | record | Apple F1 p34-35; resume | Confirm what went live (597 first?) |
| 65 | S9 | 597 lanes = 80% of spend first; ~200 next wave; ≥95% valid-ASN gate; freight −10% ≈ $2M in 6 months | user anchor | GFiber v8; resume (gate) | Never "$2M + $1.5M"; name the noun |
| 66 | S10 | DQ ~40% reported / ~55% true → 99%; "within a quarter" | record | Apple F2 p35-36 | Two months (Apple) vs three (master) — unresolved |
| 67 | S10 | Manual reconciliation 8-10 hrs/week | record | Apple F2 p35 | Never 1-2 hrs as the before |
| 68 | S10 | Austria pilot ≈97% on-time measurement accuracy, ≈$500K/yr; green-lit 25 locations | record | Apple F2 p36 | — |
| 69 | S10 | ≈$8M validated freight savings across 25 European locations (~$320K/site derived) | record | Apple F2 p35-36 | Never "$1M" |
| 70 | S6 | Forecast accuracy 70% → 85%; ~$2M safety stock released; live in 3 months | record | Apple F3 p37-38; resume | — |
| 71 | S6 | Planner collaboration up 50% | record | Apple F3 p37 | Not "planner effort −50%" |
| 72 | S8 | 200 lanes; 99% lead-time accuracy; 580,000 units; about $1.5M carrying cost released | record | Apple F4 p38-39 | Never summed with $2M |
| 73 | S7 | Six sites, three waves, 5 months; hardest site 6 weeks vs 3 | user anchor | GFiber v8 only | Never "six NA sites"; BOM rule risk |
| 74 | S17 | Cycle 6 weeks → ~3; pilot 3 weeks early; <5% mismatch gate; no award $ | user anchor | GFiber v8 only | Never an award dollar |
| 75 | S13 | 3 DCs + 100 stores; 99% fill vs 95% goal; stockouts −20% | record | Apple M1 p40-41; resume | — |
| 76 | S13 | About $6M on the line → about $8M of the day's sales protected | record | Apple M1 p40 | Apple uses $8M both ways |
| 77 | S14 | ~200 orders / $2.5M order value made consistent; $10M initiative won | user anchor | GFiber v8 only | $10M is not savings; $2.5M is not savings |
| 78 | I1 | $25 → $0.40 per incident (−98%); 100% citation coverage | record | Apple I1 p41-42 | Not in master — candidate for an AI-judgment story |
| 79 | G1 | UAT: 5 users × 10 scenarios; concurrent-login crash two days before sign-off; numeric entrance criteria since | record | Apple G1 p43-44 | Bench/failure story |
| 80 | G3 | Security review under-planned by two weeks | record | Apple G3 p45-46 | — |
| 81 | S19 | Uniform 1.10-day buffer 95.8% / 7.6% fast / $5.69M-wk → σ-proportional 95.0% / 39.6% fast / $5.94M-wk (+$255K/wk ≈ $13.3M/yr) | illustrative model (recomputed) | Walmart_WBR_R2596147_Solver_Model.xlsx | Always "in the model"; NOT an engagement record |
| 82 | S20 | O1 ≈ 0.97 × 0.985 × 0.996 = 95.2%; Promise Yield 43.6% × 95.2% = 41.5% | illustrative | Walmart_TechOps_WBR_DeepDive | Design case |
| 83 | S21 | ≈$3.7M/yr per +10 pts of enrolled GMV | modeled | Walmart_R2596147_WarBook | Design case |
| 84 | All | Never "50x" — 9.7×, 7 → 68 | rule | Scan: 0 hits html/cb91 | — |
| 85 | All | Never "$1.5M to $2M" | rule | Scan: 0 hits html/cb91 | — |
| 86 | All | "Six sites," never "six NA sites" | rule | Scan: only in never-say lists | — |
| 87 | All | S14 $10M won ≠ savings; S16 >$100K priced ≠ savings; S11 ~$1.5M pre-prod separate from CTS | rule | Master §4.1 compliant | — |
| 88 | All | $5M avoidance said once; $2M (S6) and $1.5M (S8) never summed | rule | Master compliant; Apple B2 contradicts | — |

---

## 4. Thin or missing numbers — real figures not yet in the Amazon packets

**S11 could add:**
- 3PL ingestion one-pager (Shipment_Visibility_3PL_ingestion-_One_Pager p1-3): 6 systems / 9 teams; trace-ID + load-event design change cut blocker-bug MTTR (−50%) and troubleshooting to 2-4 hrs; 10% shipment spot-check.
- Path_to_4PL__Visibility p1-2: December 2021 launch, ~100 people on 9 teams, 45-customer waitlist, and the honest misses (delays, optimistic testing estimates, late monitoring).
- Apple A2 p9: weekly arc 40.2% (13 Dec) → 40.0% → 21.9% red (carrier format change, 31 Jan) → 69.2% (21 Feb, Active 287 → 546); ticket grain 538 auto / 456 human = 54.1%; $0.18 per eliminated interaction as a cousin check.
- Apple A4 p12-13 + RAPID_Crux p2-5: 79 legacy customers, $185,892 ARR ($15,491 MRR), 294,581 containers; schedule reliability 25% vs competitor 63% (normalized ~27%); variance 16 vs 8 days; 90% against an 80% north star.
- Apple A5 p13-14 + SV_Product_Testing_Approach p1-3: 100-container test (7 checks, bug IDs VIS-4423 / OCEAN-4021 / CA-1894 / OS-1906), RAG ladder 25 → 50 → 75 → 80%, ≥20-container weekly sample, UAT gate "80% of shipments with minor-to-no issues."
- TPM status 11/19/21 p10-11: scraper error rates Air 5.09% / Ocean 8.99% vs <10% goal; E2E 100% processed / 86% tracked; Datadog connectivity monitors (State_of_SV_E2E p1-8).
- Apple A1 p7: ticket response 72 → 90%, volume 5×.

**S12 could add:**
- FF_App_Asia_Latency_Investigation p1-2: P95 page load 04/24-05/10 — US 3.3 s (2.19K views), Asia 21.19 s (6.31K views), others 4.45 s (5.42K); static JS from static.flexport.com P95 5 s China vs 500 ms US.
- High-Level_Solution_Document_FF_App__Schedules: FCL-first (2022) / Air-LCL (2023) sequencing and the March 2023 export launch target.
- PRD_FFA_Audit_Logs: "almost 100 different partner organizations using FF App" driving audit-log need.
- Apple B2 p19: Option 1 = 120 + 20 UAT = 140 target 2023-03-31; buffers ×1.0 / ×1.4 + 15%; P0 $22.64 vs full $49.25 per shipment; burn-up planned 3,307.4 eng-days.

**S16 could add:**
- BRD p1-3: the $129,600 → $25,920 → $103,680 arithmetic; seven named metrics; BR-3 daily/hourly feed; BR-4 failure alert.
- Apple G3 p45-46 / A3 p42: security-review lesson as a kickoff checklist item.

**S2 / S5 could add:**
- UDC issues log (pandas, 836×19): type mix bugs 115 (~14%) / requirements 159 / action items 117 / questions 23; operations Outbound 238 / Retail 171 / Inbound 113 / IC 90 / Dotcom 62; owners IT/WMS 342 / Ops 111 / Locus 86; monthly arc ~90/mo Feb-Mar 2025 → 271 in June → 65 → 21 → 14 → 4; open pipeline 122 (A 73 / B 16 / C 10 / D 8 / E 5).
- Apple C3 p26: Locus design & build Jul-Dec 2024, RTL E2E complete Jan 31, physical testing Feb-Mar 2025.

**S18 could add:**
- Apple D2 p31: defect classes at mock 1 (UoM mappings, location naming drift, open-order status vocabularies) — gives the 7% a story.
- Apple D1 p29: team 14 core + 6 DC Ops (master has it only in the result line).

**S9 / S10 could add:**
- Apple F1 p34-35: cohort scorecard (completeness, tender acceptance, OTD); tender acceptance measured only from cohort three ("would have caught a carrier-data problem two cohorts sooner").
- Apple F2 p35-36: three years of shipment history in SQL; carrier names in five spellings; Austria pilot implemented inside one month.

**S6 / S8 could add:**
- Apple F3 p37: planners moved off Google Sheets; planner collaboration +50%; false alarms counted and burned down.
- Apple F4 p38-39: right-skewed distributions; refresh cadence with per-lane drift flag; feature request → program.

**S13 could add:**
- Apple M1 p40-41: the 3σ page rule and the single bridge/log/decision list (master has the fill/dollars only).

**S7 / S17 could add:**
- No Apple or source-doc figures exist for either; the only support is GFiber v8 (user anchor). Enrich only if Rajesh can supply them.

**New/unused chapters could add:**
- I1 p41-42: $25 → $0.40 per incident (−98%), 100% citation coverage — a recent AI-judgment story with unit economics (not in the master).
- G1 p43-44: 5 users × 10 scenarios, concurrent-login crash 2 days before sign-off, numeric entrance criteria since — second failure story.
- G2/G3 p44-46: already in S18/S16; G2 "hundreds of devices," 3-4 day estimate.
- B3 p19-21: ~$200K/month/DC (~$1M/DC protected), 45-minute daily forum, 10-step QRG, landed inside four weeks — Bias for Action / Deliver Results bench story.
- D3 p31-32 and E1 p32-34 are intentionally thin; no more numbers to extract.

---

## 5. Method notes and limits

- Recomputed with pandas from the original xlsx files: UDC issues log (836×19: 714 closed, 441 Blocker+Critical, categories/operations/owners/monthly arc, 86 Locus rows) and the Walmart solver model (S19 policy A/B/D, Q4 peak). LSA WBR Instructions tab (rows 6-9) confirms the S11 WBR format claims. FlexGo launch worksheet and 100-container CSV were only skimmed.
- Not verified against a primary doc (no such doc exists in `/tmp/sources`): ISM FSD dates, S3/S4 figures, S7, S13/S14, S17, and the S9 597/80%/$2M set. They trace only to GFiber v8 and are labeled user anchor.
- Apple v11 internal inconsistencies worth knowing: C1 "fifteen months/15+ tracks" vs C2 "fourteen months/~30 build tracks"; B1 "went live April 2022" vs B1 math box "MVP Q1'23"; B2 "$5M cost avoidance" vs "$5M annual cost reduction"; M1 $8M "at risk" vs "protected"; G2 ~400 vs ~100 devices; F2 "99% on time" in the Versus-goal line (means data quality).
- No packet, html, or pdf was edited. No git commands were run. Scratch work: `/tmp/recon/`.

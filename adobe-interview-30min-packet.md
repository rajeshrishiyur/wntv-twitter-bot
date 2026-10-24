# 30-minute interview packet — Adobe Technical Services

**You:** Rajesh Rishiyur Chandrasekaran
**Room:** Stacey Rosenberry and Ravi Chennappan, both Principal Program Managers, Adobe
**Format:** Microsoft Teams, 30 minutes
**What they said they will test:** program governance, Agile delivery, SAP experience — requirements, stakeholder coordination, owning an initiative through implementation and delivery
**The job behind the interview:** lead an S/4HANA → RISE with SAP migration
**Your honest position:** you have led S/4HANA *integration and cutover* programs. You have not led an ECC→S/4 conversion or an S/4→RISE move. Say that in the first five minutes. Then show that the muscles that job needs are the ones you have already run.

Read sections 1, 2, and 5 out loud once. Everything else is backup if they pull a thread.

---

## 1. Who is listening, and for what

### Stacey Rosenberry — Sr. Program Manager & Practice Lead, PMO Center of Excellence, Adobe Technical Services

~34 years. PMP. She runs the practice: she coaches program managers, forecasts capacity, and owns vendor SOWs, POs, invoices, and quality reviews. Before the practice-lead seat she rescued a failing data-migration workstream (Dec 2022, launched July 2023) and built Adobe’s rapid-enablement framework for M&A system migrations. At NetApp she ran a data-center exit: a 4-year plan finished in 3 years by switching to phased moves, on a ~$10M budget, and she wrote publicly that migrations are a journey where you keep the destination and change the route.

She is scoring: cadence, stakeholder clarity, vendor control, phased delivery, and whether you rescue a workstream with people rather than with a slide.

**Mirror her language:** workstreams, RACI, handoff from build to run, capacity, vendor quality, phased so you give capacity back early.

### Ravi Chennappan — Principal Program Manager, Adobe Technology Services (in that org since 2012; Principal as of June 2026)

He is the person who already did Adobe’s version of this job. From his own profile: he launched Adobe’s S/4HANA system off legacy ECC, managed the **72-hour cutover**, brought the system up inside the planned downtime window, and ran workstreams for **Integration, CVI (customer-vendor integration), release/cutover, test-system data masking, and scheduled jobs**. He named a tech owner and a functional owner for every boundary system so nothing surprised them after go-live. He also says, in his own words, that he uses waterfall and Agile *as appropriate to the project type*, and that he built repeatable delivery frameworks to train new program managers.

He will hear a fake S/4 or fake RISE claim immediately. He will respect a precise cutover story and a clean “here is what I have not done.”

**Mirror his language:** boundary systems, named owners, cutover window, downtime vs. plan, issues in the first days after go-live, integration, mock cycles, waterfall where the date is fixed and Agile where the scope is still moving.

### Joel Medikondu — the hiring manager, not in this room, but this interview feeds him

Senior Manager, Transformation Lead (Jan 2026). Deloitte SAP (SD, MM, FI/CO), then HPE regulatory-compliance IT across SAP for finance, tax, supply chain, and quote-to-cash, then Adobe ERP modernization (S/4HANA, Ariba, NetSuite) through the company’s scale from about $9B to $25B+. His own words: value realization, program governance, clean operating cadence. He recently engaged with SAP Sapphire material on Business AI sitting on a governed core.

If you get to him later, lead with value and governance, not tools.

---

## 2. Say this about RISE. Do not improvise past it.

**One sentence, early, unprompted if SAP comes up:**

> “I have not led an S/4HANA-to-RISE migration. I have led the S/4HANA side of a retail integration program — plants, stock types, STOs, cutover, and reconciliation — and I have led ERP-to-WMS cutovers with published mock gates. I would run RISE with that same governance, and I would staff the conversion and clean-core work with people who have done it.”

That sentence is the whole strategy. Ravi already did the ECC→S/4 cutover at Adobe. Pretending you have done his job ends the interview. Owning the gap and then showing cutover discipline is the only credible path.

**What transfers, in his vocabulary:**

| What RISE / his ECC→S/4 actually needed | What you have actually done |
| --- | --- |
| Named tech + functional owner per boundary system | You forced one signed definition of available-to-sell across Store, Retail DC, and Dotcom, and retired the old system (MCS) |
| Integration workstream | S/4HANA ↔ ISM; SAP PO/ASN over X12 for ~1,000 routes; Elementum ingestion of inventory, production, POs, ASNs, forecasts |
| Cutover runbook and a downtime window | 343-task weekend runbook; dual-DC ERP→JDA cutover in 8 months |
| Mocks with a number that must be hit | Three mocks, inventory tolerance 7% → 1.8% → 0.3% against a published 0.5% gate |
| Reconciliation so finance and ops trust the stock | Daily MD04 / MB52 recon held at zero drift |
| Rollback that is numeric, not a vibe | Sync under 99% for 4 hours, or p95 latency over 2× budget for 1 hour. It never fired. |
| Hypercare with an exit | You exit hypercare on a number, and you had zero customer-facing incidents on the staged go-lives |
| Waterfall for the cutover, Agile for the design | 6-week → 4-week delivery cadence on the build; phase-gates on the weekend |

**What you do not claim:** CVI, FI/CO ownership, Ariba, a full ECC→S/4 conversion, custom-code remediation, SAP Cloud ALM, or a clean-core program. If he asks, you know what they are (below) and you say who you would put on them.

**If he asks “how would you run S/4 on-prem to RISE,” answer in six beats, 60 seconds:**

1. **Discover / Prepare.** Business case in dollars, scope freeze, RACI, and a boundary-system register with a tech owner and a functional owner on every row. That register is the artifact. Tooling is SAP Cloud ALM; you do not need to have used it to insist on the register.
2. **Explore.** Fit-to-standard. Every deviation from standard gets a named owner and a retirement date. Clean core is a governance rule: customize only where the business process is a real constraint, and write the exception down.
3. **Realize.** Iterate configuration and integrations. Mocks with a published tolerance, the way you ran 7% → 1.8% → 0.3%. Data reconciliation signed by the business, not by IT.
4. **Deploy.** A timed cutover runbook, a downtime budget, and rollback triggers written before the weekend. Dress rehearsal is mandatory.
5. **Run.** Hypercare exit on a number (incident rate, recon drift, interface success). Then a value ledger: which saving was promised, which landed.
6. **The part that is different from a normal S/4 project.** In RISE, SAP runs the private-cloud infrastructure and the upgrades. Your job shifts from “keep the basis team afloat” to “keep the core clean so those upgrades can land, and keep the boundary systems from breaking when they do.”

Then stop. Ask him how Adobe is scoping it: lift-and-shift of the current S/4 first, or clean-core remediation in the same window. That question is worth more than another minute of you talking.

---

## 3. Ninety-second opener

Use this when they say “walk us through your background.” Do not recap the resume.

> “I’m a supply-chain program leader. For the last fifteen years I’ve owned the path from a business rule to a live system — inventory promising, returns, warehouse cutovers — mostly on SAP and the systems SAP has to trust.
>
> The piece most relevant to this conversation is at Sephora. I led the S/4HANA integration for store, retail DC, and dotcom inventory. The business rule I was hired to make true was simple: a unit is not available to sell until someone has dispositioned it. Returns, quality-hold, and lost-and-found stayed out of available-to-sell. We retired the legacy inventory system. We cut over on a 343-task weekend runbook with a numeric rollback, and we had no customer-facing incidents.
>
> Around that I run a plain governance system: a RAID log, a weekly steering pack on frozen metrics, mock gates with a number you have to hit, and hypercare that ends on a number. At a prior Sephora program that same pattern took a dual-DC ERP-to-WMS cutover live in eight months and unblocked a twenty-million-dollar pipeline behind it.
>
> I have not led an S/4-to-RISE migration. I’ve led the integration, the cutover, and the reconciliation that make one survivable. That’s the seat I want to be in.”

Then stop talking.

---

## 4. Run of show (30 minutes)

| Min | What is happening | Your job |
| --- | --- | --- |
| 0–3 | Intros. They talk. | Opener above. Land the RISE sentence. |
| 3–20 | Three or four questions. The governance one is the one that matters. | One story each. 90 seconds. Then “happy to go into the runbook / the RAID / the mock numbers.” |
| 20–25 | They probe SAP, Agile, or a gap. | Short answers from section 6. Do not bolt a second story on. |
| 25–29 | Your questions. | Two of the questions in section 7. Not four. |
| 29–30 | Close. | One sentence: you want the seat, you know the gap, you know the muscle. |

If you have told two stories well, you are winning. A third story is usually a worse version of the first.

---

## 5. The answer they weighted most

**“Tell me about a large-scale initiative where you established governance, milestones, and success metrics.”**

Use the Sephora S/4HANA inventory program. It is the only story that is governance, SAP, cutover, and a business metric in one place. Speak it in this order. About two minutes if they let you; you can cut the middle if they are brisk.

**Situation, 15 seconds.** Sephora was standing up S/4HANA as the inventory system of record for stores, the retail DC, and dotcom, with a warehouse execution system beside it. Returns, RTV, and quality-hold stock were getting promised to customers because “available” meant something different in each system.

**What you installed, 45 seconds.**

- One signed definition of available. Customer returns, QI/blocked, and lost-and-found could not be promised until disposition: receive, grade, then restock, scrap, or RTV. Credit could not run ahead of the physical unit.
- A portfolio execution system, not a status meeting: a RAID log, an 836-item Jira backlog, and a weekly CIO/COO pack across 60+ stakeholders where the metrics were frozen week to week so a red stayed red.
- A 343-task weekend cutover runbook.
- Rollback written as a number before the weekend: interface sync under 99% for 4 hours, or p95 latency over 2× the budget for 1 hour. It never had to fire.
- Hypercare exit on a number, not on a feeling.

**Milestones, 20 seconds.** Phase-gates, not a big-bang. Staged go-lives. The legacy system (MCS) came out only after the new definition of available held in production. Same pattern on the building program beside it: the UDC omnichannel DC (store and dotcom in one building, Blue Yonder plus robotics) went live in stages against published gates, and processing efficiency landed at +15%.

**The result, 15 seconds.** Zero customer-facing incidents on the staged go-lives. One definition of available. Legacy system retired.

**If they ask “how did you know it worked,” add only this.** The metric that mattered was not the milestone chart. It was whether a unit in quality-hold could still be promised. It could not. That was the success metric, and it was binary, checked in production.

**Do not** wander into the $5M roadmap story or the Flexport story inside this answer. Those are backups.

### Backup, if they want a second governance example

Dual-DC legacy ERP → JDA WMS, eight months, on time and on budget. Three mocks against a published inventory tolerance of 0.5%. Actuals: 7%, then 1.8%, then 0.3%. Hitting the gate unblocked four downstream programs worth about $20M of ROI. The point to say out loud: the milestone was not “mock 3 complete.” The milestone was “tolerance ≤ 0.5%.” A mock that misses the number is a failed gate, and the date moves or the scope moves. You do not narrate your way past it.

---

## 6. The other questions, with the story and the trap

Keep each first answer under two minutes. Offer the artifact (“I can walk the runbook”) instead of volunteering it.

### A. “Tell me about an AI initiative you owned from concept through deployment.”

Your resume lists LLM agents as a tool. It does not list an AI program you owned. **Do not invent one in this room.** Ravi has spent a decade next to real production cutovers. A fictional chatbot program will collapse on the second question.

Say this:

> “I have not owned an enterprise AI program from concept to production. I don’t want to dress up a tool experiment as a program. What I have owned, end to end, is the operating system those programs die without: a signed business rule, a data reconciliation the business trusts, a release gate someone other than the builders controls, and an adoption metric that is allowed to say ‘not yet.’
>
> The closest production analog is the S/4 available-to-sell rule. The model — in that case a set of stock-type rules, not a model — was useless until planning, stores, and the DC all stopped using the old number. We measured adoption by whether the legacy system was actually off, and by whether quality-hold stock could still be promised. It couldn’t, and MCS was retired.
>
> If this role has an AI workstream on top of RISE — Joule, cash application, anomaly detection on interfaces — I would run it the same way: one use case, a baseline, a human in the loop until the error rate beats the baseline, and no rollout past a team that hasn’t hit the number.”

Then stop. If you *do* have a real internal pilot that is not on the resume, use it only if you can name: the user, the baseline, the error rate, who was accountable when it was wrong, and what you turned off when it failed. If any of those five is fuzzy, stay with the script above.

### B. “How do you drive adoption after implementation?”

Story: the release-cadence change, because adoption here means other people copied it with no authority from you.

> “At Sephora a VP asked me to move a 20-person product, engineering, and QA group from a six-week to a four-week release. We did it in six weeks, but the adoption lever was not the new cadence. I had QA write the release gate. The people who felt the pain of a bad release owned the exit criteria. Critical defects dropped by half. The result I actually trust is that neighboring teams copied the model without being told to. Same pattern on the inventory program: adoption was retiring MCS, not training people on a new screen. If the old path is still open, you do not have adoption.”

Second beat, one sentence, if they want the external version: on the EDI program you did not declare success at go-live. A supplier cohort could not graduate until valid ASNs were at or above 95%. Completeness moved from 60% to 95%. The gate was the adoption plan.

### C. “Describe a challenging cross-functional program and how you got alignment.”

Stay on S/4 available-to-sell. The conflict is the point.

> “Stores, the DC, dotcom, and finance did not disagree about the project. They disagreed about what ‘available’ meant, because each definition protected a different number: fill rate, warehouse labor, the customer promise, and the credit memo. I did not workshop my way to consensus. I wrote one rule — nothing in returns, quality-hold, or lost-and-found is promiseable until disposition — and I took it to the steering forum with the failure mode attached: promising that unit creates a customer-facing miss and a credit that runs ahead of the physical goods. Once that rule was signed, the design arguments got small. The returns plant and the RTV stock-transport orders were just the implementation of a sentence everyone had already signed. Sixty-plus stakeholders, one weekly pack, metrics frozen so we could not re-litigate a red status by changing the chart.”

The sentence they should remember: **alignment was a signed rule, not a meeting.**

### D. “How do you measure success and ROI for an AI program?”

You are answering as a program leader, not as someone who has booked AI ROI. Say that, then give the mechanism.

> “I would not accept a model-quality metric as the ROI. Three layers, and the business signs all three before build:
>
> 1. Baseline. The cost, the cycle time, or the error rate of the human process today, from their system, not from a workshop.
> 2. A production gate that is allowed to fail. The assistant stays in shadow mode until it beats that baseline on a held-out week, with a named person accountable for every wrong action.
> 3. A value ledger after go-live. Dollars or hours removed, checked against the baseline at 30 and 90 days, and a kill line if it misses.
>
> That is the same shape I used when I released two million dollars of safety stock at Elementum. We only released it where forecast accuracy *and* lead-time error had both improved — forecast accuracy moved from 70 to 85 percent. Improving one number was not allowed to justify the dollar. I would hold an AI program to that standard: two independent signals, then the money.”

### E. “What are the biggest risks when deploying enterprise AI, and how do you mitigate them?”

Four risks, each tied to a control you have actually operated. Say “the analog in my programs” so you are not claiming an AI rollout.

1. **Bad data, confident output.** Analog: daily MD04/MB52 reconciliation held at zero drift before anyone trusted the planning number. Mitigation: the AI does not leave shadow mode while reconciliation is drifting.
2. **The boundary system nobody named.** Analog, and use Ravi’s phrase deliberately: every interface gets a tech owner and a functional owner before build, the way a cutover fails at the edge rather than in the core. His ECC→S/4 write-up says this is exactly how Adobe avoided post-go-live surprises.
3. **No rollback.** Analog: the sync and latency triggers, written down, with a person empowered to call them without a meeting.
4. **Adoption theater.** Analog: MCS retired, QA owned the gate, supplier cohorts could not graduate below 95% valid ASN. If the old path is open, the new tool’s usage number is a vanity metric.

Add one risk that is specific to AI, briefly: **someone has to own a wrong answer.** A program that cannot name that person is not ready to deploy.

### F. “Walk me through the lifecycle of an AI project you’ve led, from idea to production.”

Same honesty rule. Reframe once, then give the lifecycle you *would* run, mapped to a lifecycle you *have* run.

> “I haven’t taken an AI product to production, so I’ll walk the lifecycle I have run and mark where an AI use case would sit.
>
> Idea: a business rule with a dollar or a customer impact, signed. At Sephora that was ‘do not promise unsellable stock.’
> Shape: one team, one process, a baseline. Not a platform program.
> Build in shadow: it can see production data and it cannot take a production action. This is the mock cycle. On the WMS program nothing went live until three mocks had walked the inventory tolerance down through 0.5 percent.
> Gate: someone who does not build it — QA, in the cadence change — signs the exit.
> Production, narrow: one site, one cohort. The EDI program graduated suppliers at 95 percent valid ASN. It did not flip a thousand routes on day one.
> Hypercare on a number, then either widen or turn it off.
>
> The lifecycle is ordinary. The part people skip is the shadow mode and the kill line.”

### G. Agile — they said this is a focus. They may not ask it as a set piece.

Ravi’s own profile says he uses waterfall and Agile as appropriate to the project type. Agree with him, from experience.

> “I don’t run a religion. Design and build, where scope is still moving, I run in iterations — I took a 20-person group from six-week to four-week releases, and QA wrote the gate, defects down by half. Cutover, where the date is fixed and the task list is the product, I run as a phase-gated runbook. Three hundred forty-three tasks, a dress rehearsal, a downtime budget. Mixing those up is how you get a weekend with no rollback, or a stand-up that never produces a decision.”

If they want a methodology noun: you have run Scrum-shaped delivery inside a phase-gate program. You can say SAFe-style portfolio cadence only if you have actually used it. The weekly frozen-metric steering pack is the honest description. Do not say “SAFe” unless you have run PI planning.

### H. Requirements and stakeholders — likely, given their note

> “I separate the rule from the requirement. The rule is the sentence the business signs: a returned unit is not available until disposition. The requirements are the plants, the movement types, the STO design, the interface contracts that make the sentence true. I will spend a long time on the sentence and a short time arguing screen fields. Stakeholders get one forum, a frozen metric pack, and a RAID item with a name and a date. Sixty people do not get sixty channels.”

### I. “You don’t have RISE. Why you?”

> “Because the failure mode of this migration is not the infrastructure SAP is going to run for you. It is a boundary system with no owner, a mock that ‘passed’ without a tolerance, a cutover weekend with a rollback that is a paragraph, and a hypercare that never ends. I have installed the control for each of those, on S/4HANA and on an ERP-to-WMS conversion, with the numbers behind them. I would hire or partner for the conversion tooling and the clean-core remediation. I would not hand the governance to that partner.”

---

## 7. Questions you ask (pick two)

Ask Ravi the SAP one. Ask Stacey the operating-model one. Then stop.

1. **For Ravi.** “On the ECC-to-S/4 cutover, the 72-hour window held and the issues afterward were few. For the move from S/4 to RISE, is Adobe treating this as a technical migration onto Cloud ERP Private with clean-core remediation as a follow-on, or is the remediation in the same window? Those are different programs, and I would staff them differently.”
2. **For Ravi.** “Which boundary systems broke, or almost broke, last time — and do those same owners still exist?”
3. **For Stacey.** “This seat sits next to your practice. Where do you want the program manager versus the CoE: I run the RAID and the vendors day to day, and your team reviews quality and capacity — or is the CoE inside the governance?”
4. **For either.** “What does ‘done’ look like at hypercare exit — a date, or a number? And who is allowed to say the number was missed?”

Question 1 is the best one in the packet. It tells Ravi you understand that RISE-from-S/4 is not a reimplementation, and it lets him talk about his own cutover.

---

## 8. Close (fifteen seconds)

> “I want this work. I have not done the RISE move, and I won’t pretend I have. I have done the part that decides whether it survives the weekend: one signed rule, named owners on every boundary, mocks that can fail, and a rollback that is a number. I’d like to do that here.”

---

## 9. Numbers worth memorizing

Only these. All of them are on your resume. If you cannot say what sits underneath one, leave it out.

| Number | What it is |
| --- | --- |
| 343 tasks | Weekend S/4 cutover runbook |
| 836 items | Jira log on that program |
| 60+ | Stakeholders on the weekly CIO/COO pack |
| Sync < 99% for 4 h, or p95 > 2× for 1 h | Rollback triggers. Never fired. |
| 0 | Customer-facing incidents on the staged go-lives |
| 7% → 1.8% → 0.3% vs 0.5% gate | Three inventory mocks, ERP → JDA |
| 8 months | That dual-DC cutover, on time, on budget |
| ~$20M | ROI pipeline unblocked behind that gate |
| $5M / 66% / 6 months | Roadmap re-sequence, cost avoidance and effort cut |
| +15% | UDC processing efficiency after staged go-live |
| 6 weeks → 4 weeks, in 6 weeks | Release cadence; QA owned the gate; critical defects −50% |
| 70% → 85%, $2M | Forecast accuracy; safety stock released only where lead time improved too |
| MD04 / MB52, zero drift | Daily SAP recon |
| ≥ 95% valid ASN, 60% → 95% | EDI cohort gate; shipment completeness |
| 99% fill vs 95% goal, −20% stockouts, ~$8M | Manhattan OMS, 3 DCs and 100 stores. Only use this if they go pre-2017. It is the oldest story. |

Leave “$27M+ cost savings” off the table unless you can show the addition live. A blended headline with no bridge is the easiest thing in the room to puncture.

---

## 10. Traps

- **Do not claim RISE, CVI, FI/CO, Ariba, or an ECC-to-S/4 conversion.** Ravi did the conversion. Joel came up through FI/CO. They will compare notes.
- **Do not claim an AI program you did not own.** Bridge. The bridge is stronger than a soft story.
- **Do not stack stories.** One question, one story, one number.
- **Do not say “we.”** Say what you signed, what you wrote, what you stopped. “I wrote the rollback. I would not let the weekend start without it.”
- **Agile is not a virtue signal here.** Ravi has already written that he picks the method to fit the work. Match him.
- **Stacey cares how you treat a slipping workstream.** If you describe a rescue, describe the people and the replanned sequence, not the heroics. She replanned a data-center exit from four years to three by phasing, and she pulled a broken migration workstream back onto a July launch. Calm replanning is her love language.
- **Vendor talk, if it comes.** She processes SOWs and invoice quality for a living. Your MetricStream years (you owned SOWs, estimates, and onshore/offshore delivery through UAT, cutover, and hypercare) are the only vendor story you need. One sentence is enough unless she asks.

---

## 11. If you only have ten minutes before the call

1. Read the opener in section 3 out loud.
2. Read the RISE sentence in section 2 out loud.
3. Tell the governance story in section 5 to a blank wall, once, with the 343, the rollback numbers, and the zero incidents.
4. Remember the two questions in section 7: how Adobe is scoping RISE (technical move now, clean core later, or both at once), and what “done” means at hypercare exit.

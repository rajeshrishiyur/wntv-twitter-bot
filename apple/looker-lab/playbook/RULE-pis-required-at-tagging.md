# Playbook rule — placed-in-service is required at tagging

Status: the rule this lab writes in step 10. It is not in force during the load you just ran. That is why the twelve blanks got in.

## The rule

A tracker row with a received date and a blank placed-in-service date is quarantined. It does not load.

The field is the day depreciation starts. Finance fixed assets owns the definition. The CM coordinator cannot submit the row without a date, and the date cannot be earlier than the received date.

## What a later correction does not do

Entering the date on PO line 00017 closes exception EX-PIS-00017. It does not flip `passed_validation_on_first_entry`. First-time-right stays 21 of 40.

## Where it sits

In the structural gate, next to the blank key, the unreadable date, and the unknown site. A rule that is edited after the file arrives is not a gate.

## Owner of the rule

Finance fixed assets writes the definition. The data-integrity PM puts it in the gate and publishes it before the next tracker arrives. The CM coordinators see it in the tracker instructions, not in a follow-up email after the load.

# Lifecycle and disposal craft

*Load-on-demand companion to `parvis-itam`. Read for inventory-quality work, anything hardware, and any decommissioning question.*

This file is deliberately short. It assumes an estate whose hardware is a device fleet plus a residual footprint, which is what the owner skill describes for most adopters, so classical data-centre asset discipline would be dead weight. Where the owner skill records data centres still in use, this file is underweight and the gap is named rather than hidden. What remains is a decommissioning problem that has mostly moved into the cloud, and, subject to confirmation at the gate since the owner skill records neither, an engineer device fleet and any residual lab or colocation footprint. Confirm both before working the next two sections, and skip whichever sits with corporate IT. No standard, method or vendor program is named here as current or sufficient, since that material stales.

## The device fleet

The record that matters is not the asset tag, it is the state and who holds it. Six states carry the fleet, meaning ordered, in stock, assigned, in use, returned and disposed, and each transition needs an evidence point rather than an assertion. The two transitions that leak are return and disposal, because both happen at the moment a person is leaving or a team is reorganizing and nobody owns the follow-up. A leaver process that ends at the identity revocation and not at the device receipt produces ghost assets that stay entitled, stay encrypted with keys nobody holds, and stay on the support contract.

Count distinct devices over a period, not devices existing today, or the count will disagree with every licensing metric that uses the same population. State the lifetime rule, meaning how long a machine must exist before it counts, and keep it the same across the fleet record, the endpoint agent and the license position, since three different lifetime rules is the most common reason three sources disagree.

## Residual lab and colocation

The small footprint is the dangerous one, because it has no operating rhythm around it. Whatever remains in a lab, a test bench, a network closet or a colocation cage tends to carry the oldest firmware, the least monitoring and the last copies of data nobody remembers putting there. Treat each residual site as a single record with an owner, a stated purpose, a support state and an exit date, and where there is no exit date, that absence is the finding. Colocation adds a contract with notice periods and remove-and-restore obligations, so exiting a cage is a project with a lead time rather than a decision, and the lead time is read out of the contract by sourcing rather than assumed here.

## Refresh economics

Decompose rather than assert, and keep every figure `[user-input]` or `[X]`. The cost of running a machine another year is support and repair cost, plus failure rate multiplied by the engineer hours a failure actually costs, plus the productivity difference where the work is genuinely constrained by the hardware, minus the residual value being given up by waiting. Against that sits the replacement cost, the deployment and migration effort, and the disposal cost per unit.

Two things override the arithmetic. Security support end of life is a hard wall rather than a variable, because a machine that stops receiving fixes is a risk decision and not an economic one. And the refresh shape, meaning a rolling replacement against a big-bang cycle, changes who absorbs the disruption more than it changes the total, since a big-bang refresh concentrates service-desk load and engineer downtime into one quarter. Name the loser in either case. It is usually the service desk, and it is usually not funded.

## Support and warranty as coverage state

Track coverage as a state on the asset rather than as a contract in a folder. Each asset is covered, expiring inside the notice window, expired, or unknown, and unknown is reported as unknown rather than counted as covered. An asset out of support is a risk row with an owner, not a filing error, because the operational consequence arrives on the day it fails and not on the day the contract lapsed. The coverage state is also what makes a renewal question answerable, and the dates themselves live in the renewal calendar that `parvis-vendor-eval` owns, cited here rather than copied.

## Sanitization by media class, with chain of custody

The method has to match the media, and the usual failure is applying a method that works on one class to a class where it does nothing. Rotating magnetic media, solid-state media with wear levelling and over-provisioned blocks, self-encrypting drives, mobile and embedded storage, removable media, and printer and appliance storage all behave differently, and the last of those is the one that gets forgotten because nobody thinks of it as a computer. Where a device cannot be verified sanitized, physical destruction is the answer, and where the data classification demands it, destruction is the answer regardless of what a wipe reports.

Chain of custody is the part that has to be evidenced. Collection with a signed handover, transport with a manifest, receipt confirmed against that manifest, sanitization or destruction recorded per unit with an identifier, and a certificate reconciled back against the original list. Count the units at both ends and investigate the difference, because the missing device is the one that matters. The organization's approved sanitization standard and data classification govern which method applies.

## The cloud decommissioning analogue nobody runs

Every discipline above has a cloud equivalent that usually has no owner. A service is switched off, and its snapshots, backups, log archives, object versions, replicas in a second region, machine images, container images in the registry and the keys that unlock them all continue. A SaaS tenant is cancelled, and the data lives inside the vendor's retention period on terms nobody has read, with an export window that closes.

Run decommissioning as a checklist with an end date rather than as a ticket that closes when traffic stops. Confirm the data is gone or deliberately retained with a retention decision and an owner, confirm the entitlements were released rather than left assigned, confirm the identity and access paths are removed, and confirm the spend actually stopped, which is the check that catches everything else missed. That last check belongs to `parvis-finops`, and a decommissioning that shows no change in spend did not happen.

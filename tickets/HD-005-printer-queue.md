# HD-005 — Printer job stuck in queue (simulation)

**Priority:** Medium | **Impact:** One user | **Status:** Resolved in scenario

**Report:** A user can open documents, but their print job stays in the Windows queue and nothing comes out of the shared office printer.

**Triage:** Confirm the printer name, the time the issue started, any error shown, and whether other people can print. Check that the correct printer is selected, it is online, and paper and toner are available. Do not print sensitive documents as a test.

**Scenario findings:** Another user can print to the same device. The affected user's queue contains a paused job, and the printer itself reports no hardware error. This points to a user-side queue issue rather than a site-wide outage.

**Action:** With the user's agreement, cancel only their stuck job, check that the printer is not set to **Use Printer Offline**, and retry with a non-sensitive test page. Do not clear other users' jobs or restart a shared print server without approval.

**Validation:** The test page prints and the user confirms their document prints. Record the printer name, checks performed, action, and confirmation in the ticket. Escalate to the print support team if the queue stalls again or multiple users become affected.

**Privacy note:** Keep document titles, printed contents, and identifying printer details out of public screenshots and repository files.

# HD-004 — Personal Windows device health check

**Type:** Personal lab observation
**Status:** Diagnostic checks completed

## Checks performed
Ran the read-only PowerShell help desk snapshot on my own Windows laptop.
Reviewed local disk space, DNS resolution and HTTPS connectivity.

## Findings
- C: drive: approximately 47.8 GB free (36.5%).
- D: drive: approximately 8.0 GB free (7.5%).
- DNS resolution for example.com succeeded.
- HTTPS connectivity test returned True.

## Assessment
D: drive has limited free space and may need a review of stored files.
The DNS and HTTPS checks did not show a connectivity problem at the time of testing.
These results alone do not identify the cause of any slow performance.

## Next step
Review D: drive storage usage and record any further findings before
recommending a change. No files or system settings were changed in this check.
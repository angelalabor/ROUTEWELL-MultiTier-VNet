## Symptom
App-tier connectivity to the database on port 5432 failed. Running
`nc -zv -w 5 10.10.2.4 5432` from app-vm (via the web-vm jump host)
returned:
"nc: connect to 10.10.2.4 port 5432 (tcp) timed out: Operation now
in progress" — the same signature as an NSG-blocked connection, not
a service-down (immediate refusal) signature.

## Investigation trail
1. Re-ran the App -> DB connectivity test to confirm the symptom was
   real and repeatable. It was.
2. Read the db-nsg "Allow-PostgreSQL" rule directly with
   `az network nsg rule show`. Its source-address-prefix was
   10.10.0.0/27 (the Web subnet), not 10.10.1.0/26 (the App subnet)
   — ruling in a misconfigured NSG rule as the cause.
3. Ran `az network watcher test-ip-flow` to simulate the exact
   App -> DB packet directly against db-vm. Azure returned a Deny
   verdict, explicitly naming "Deny-Other-VNet-Inbound" as the rule
   that matched — confirming App's traffic no longer matched any
   allow rule and fell through to the explicit deny rule added
   after the Problem 9 discovery.

## Root cause
The db-nsg inbound rule "Allow-PostgreSQL," intended to allow
App -> DB traffic on port 5432, had its source-address-prefix set
to the Web subnet's CIDR (10.10.0.0/27) instead of the App subnet's
CIDR (10.10.1.0/26). Traffic from the real App tier no longer
matched this rule, and instead matched the lower-priority
Deny-Other-VNet-Inbound rule before it could reach the database.

## Fix
Updated Allow-PostgreSQL's source-address-prefix back to
10.10.1.0/26 via `az network nsg rule update`.
Before: test-ip-flow returned Deny (Deny-Other-VNet-Inbound);
nc timed out.
After: test-ip-flow returned Allow (Allow-PostgreSQL); nc returned
"Connection to 10.10.2.4 5432 port [tcp/postgresql] succeeded!"

## Design reflection
Because every tier in this design has exactly one narrowly-scoped
allow rule per relationship — no "allow all internal traffic"
shortcut — a wrong source prefix broke exactly one specific flow
instead of silently hiding inside a broad rule that still
technically "worked." The Deny-Other-VNet-Inbound rule added after
the Problem 9 discovery also proved its own value here: instead of
falling through to Azure's generic default deny (which gives no
detail), the failure was caught by a named, purpose-built rule,
which made `test-ip-flow` immediately point at the real cause. A
follow-up I'd make: add the three connectivity checks as an
automated post-deploy step, so a future source-prefix typo is
caught within minutes of deployment rather than only when someone
manually reruns the tests.
# NSG Rule Justification

## Objective

Network Security Groups (NSGs) will enforce the principle of least privilege by allowing only the traffic required for the application to function.

## Planned NSG Rules (as built)

| Rule | Source | Destination | Port | Action | Why is this rule required? | What breaks if removed? |
|------|--------|-------------|------|--------|-----------------------------|--------------------------|
| Internet -> Web | Internet | Web Subnet | 80, 443 | Allow | Allows customers and dispatch staff to reach the public web application. | The website cannot be reached by anyone. |
| Admin -> Web | Admin IP | Web VM | 22 | Allow | Allows the administrator to securely manage the Web VM. This is the only externally reachable management path in the whole design. | The administrator cannot SSH into any VM at all, since App and Database are only reachable by jumping through Web. |
| Web -> App | Web Subnet | App Subnet | 8080 | Allow | Allows the web tier to call the application tier. | The web application cannot process requests. |
| Web -> App (SSH) | Web Subnet | App VM | 22 | Allow | Admin access to App VM via Web VM as a jump host. App has no public IP, so the Admin IP can never reach it directly — traffic genuinely arrives from Web's private IP, not from the administrator's real IP. | Administrators cannot SSH into the App VM at all. |
| App -> Database | App Subnet | Database Subnet | 5432 | Allow | Allows the application to read and write data in PostgreSQL. | The application cannot access its database; the system is non-functional. |
| App -> Database (SSH) | App Subnet | Database VM | 22 | Allow | Admin access to Database VM via App VM as a jump host, one hop further along the same chain. | Administrators cannot SSH into the Database VM at all. |
| Deny other VNet traffic | VirtualNetwork | App Subnet, Database Subnet | Any | Deny | Azure NSGs include a default rule (AllowVnetInBound) that permits traffic from any subnet to any other subnet in the same VNet unless something more specific blocks it first. Without an explicit deny, Web-subnet traffic could reach the Database directly, bypassing the tier separation entirely. | The Web tier could reach the Database directly, violating the project's core requirement that the database is never reachable except from the App tier. |
| (No rule needed) Internet -> Database | Internet | Database Subnet | Any | N/A | The Database VM is never assigned a public IP address at all, so there is no route from the Internet to it regardless of any NSG rule. | N/A — this is enforced by network design, not by a firewall rule, which is a stronger guarantee than a rule alone. |

## Note on design changes since the original plan

The original Phase 0 plan (before building anything) assumed the administrator's own IP could reach the App and Database VMs directly for SSH. In practice, App and Database were deliberately given no public IP address, which means the Admin IP has no route to them at all. SSH access was redesigned as a jump-host chain instead: Admin -> Web (the only externally reachable point) -> App -> Database. The rules above reflect what was actually built and tested, not the original assumption.

A separate design gap was found during connectivity testing (documented in incident-report.md): Azure's default AllowVnetInBound rule was initially allowing Web to reach the Database directly, even though no explicit rule permitted it. This was closed with an explicit Deny-Other-VNet-Inbound rule on both app-nsg and db-nsg, listed above.

## Design Decisions

Each subnet has its own dedicated Network Security Group.

This approach allows different security policies to be applied to each tier independently.

Only the required application traffic is permitted between tiers, and administrative SSH access follows a jump-host chain rather than direct access to every tier.

The database subnet has the most restrictive policy because it contains sensitive business data, and is also the only tier with an explicit deny rule closing Azure's own default permissive behavior.

The design follows the principle of least privilege by denying all unnecessary communication, including traffic Azure would otherwise allow by default.

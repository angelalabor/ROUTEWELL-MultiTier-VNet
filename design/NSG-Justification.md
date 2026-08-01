# NSG Rule Justification

## Objective

Network Security Groups (NSGs) will enforce the principle of least privilege by allowing only the traffic required for the application to function.

## Planned NSG Rules

| Rule | Source | Destination | Port | Action | Why is this rule required? | What breaks if removed? |
|------|--------|-------------|------|--------|-----------------------------|--------------------------|
| Internet → Web | Internet | Web Subnet | 443 | Allow | Allows users to access the RouteWell web application securely. | The website cannot be reached by customers. |
| Admin → Web | Admin IP | Web VM | 22 | Allow | Allows administrators to securely manage the Web VM. | Administrators cannot SSH into the Web VM. |
| Web → App | Web Subnet | App Subnet | 8080 | Allow | Allows the web tier to communicate with the application tier. | The web application cannot process requests. |
| Admin → App | Admin IP | App VM | 22 | Allow | Allows administrators to manage the Application VM. | Administrators cannot SSH into the Application VM. |
| App → Database | App Subnet | Database Subnet | 5432 | Allow | Allows the application to read and write data in PostgreSQL. | The application cannot access its database. |
| Web → Database | Web Subnet | Database Subnet | Any | Deny | Prevents direct access from the Web tier to the database. | The Web tier could communicate directly with the database, violating least privilege. |
| Internet → Database | Internet | Database Subnet | Any | Deny | Ensures the database is never exposed to the Internet. | The database could become publicly accessible, creating a major security risk. |

## Design Decisions

Each subnet has its own dedicated Network Security Group.

This approach allows different security policies to be applied to each tier independently.

Only the required application traffic is permitted between tiers.

The database subnet has the most restrictive policy because it contains sensitive business data.

The design follows the principle of least privilege by denying all unnecessary communication.
# Public Access Mechanism

## Objective

Provide secure public access to the RouteWell web application while ensuring that the Application and Database tiers remain private.

## Selected Public Access Mechanism

A Public IP address will be assigned only to the Web Virtual Machine.

The Web VM will be protected by a Network Security Group that allows HTTPS (443) and HTTP (80) from the Internet.

The Application VM and Database VM will not have Public IP addresses.

Only the Web VM will communicate with the Application VM.

Only the Application VM will communicate with the Database VM.

## Design Justification

A single Public IP attached to the Web VM provides the simplest and most cost-effective solution for RouteWell's current environment.

The project requires only one public-facing web server, so additional services such as Azure Load Balancer or Application Gateway would increase cost without providing significant benefit.

The Application and Database tiers remain private because they do not receive Public IP addresses.

Administrative access follows a jump-host chain: the administrator SSHes into the Web VM (the only tier with a public IP, restricted to the admin's own IP), then from Web into the App VM, then from App into the Database VM. Each hop is restricted by NSG rules to only the subnet immediately before it.

This design satisfies the project's security requirements while keeping infrastructure costs low.

## Advantages

- Only one VM is exposed to the Internet.
- The database is never directly accessible.
- The application tier remains private.
- The solution is inexpensive.
- The design follows the principle of least privilege.
- Future expansion is possible without redesigning the Virtual Network.
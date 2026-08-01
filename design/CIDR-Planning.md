# CIDR Planning

## Objective

Design a Virtual Network that supports RouteWell's three-tier architecture while following Azure networking best practices, allowing future growth, and minimizing wasted IP addresses.

The Virtual Network address space is:

10.10.0.0/16

## Subnet Plan

| Tier | Required Hosts | Future Growth | CIDR | Usable IPs |
|------|---------------:|--------------:|------|-----------:|
| Web | 12 | 12 | 10.10.0.0/27 | 27 |
| App | 20 | 40 | 10.10.1.0/26 | 59 |
| Database | 6 | 6 | 10.10.2.0/28 | 11 |

## Design Reasoning

### Web Subnet

The Web tier requires 12 hosts. A /28 subnet provides only 11 usable IP addresses after Azure reserves five addresses, so it cannot meet the current requirement. A /27 provides 27 usable IP addresses, making it the smallest subnet that satisfies the requirement without wasting address space.

### Application Subnet

The Application tier requires 20 hosts today and is expected to grow to approximately 40 hosts within six months. A /27 subnet provides only 27 usable IP addresses, which is insufficient for future growth. A /26 provides 59 usable IP addresses, allowing expansion without requiring subnet redesign.

### Database Subnet

The Database tier requires six hosts. A /29 subnet provides only three usable IP addresses after Azure reservations, making it too small. A /28 provides 11 usable IP addresses, which meets the current requirement and leaves room for limited expansion while avoiding unnecessary waste.
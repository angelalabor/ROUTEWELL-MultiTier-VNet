# CIDR Planning

## Objective

Design a Virtual Network that supports RouteWell's three-tier architecture while following Azure networking best practices, allowing future growth, and minimizing wasted IP addresses.

The Virtual Network address space is:

10.10.0.0/16

Azure reserves 5 IP addresses in every subnet (network address, default gateway, two DNS addresses, and the broadcast address), so usable hosts = subnet size minus 5.

## Subnet Plan (show your working)

| Tier | Hosts needed today | Hosts needed in 6 months | Subnet mask chosen | CIDR range | Why this size (not smaller/larger) |
|---|---:|---:|---|---|---|
| Web | 12 | 12 (no stated growth) | /27 | 10.10.0.0/27 | A /28 gives only 11 usable addresses (16 total minus 5 reserved) — one short of today's 12, so it's disqualified outright. A /27 gives 27 usable addresses, comfortably covering 12 with room for a VM or two, without jumping to a /26's 59 addresses that this tier has no stated need for. |
| App | 20 | 40 (expected to double) | /26 | 10.10.1.0/26 | The 6-month figure is the one that decides this: 40 hosts needs at least 45 addresses accounting for reserves. A /27 (27 usable) fails that test immediately once the tier doubles. A /26 gives 59 usable addresses, covering the 40-host target with a safety margin, while a /25 (123 host capacity) is far more than a 40-host tier justifies. |
| Database | 6 | 6 (no stated growth) | /28 | 10.10.2.0/28 | A /29 gives only 3 usable addresses — can't even fit today's 6 hosts, so it's disqualified. A /28 gives 11 usable addresses: comfortable margin for a replica later, without handing the least-trusted, most sensitive tier a needlessly wide /27 or larger block. |

## Why not smaller?

For each tier, the next size down fails to fit either today's host count or the 6-month projection — see the "Why this size" column above for the specific numbers that disqualify each smaller option.

## Why not larger?

A bigger subnet than necessary wastes address space that could serve other tiers later, and works against the brief's explicit request to keep the resource footprint lean. There is no security or performance benefit to over-sizing a subnet.

## Room for future growth

All three subnets fit inside the very first /24 slice of the /16 address space (10.10.0.0/24 through 10.10.2.255). This leaves the entire rest of 10.10.0.0/16 — from 10.10.3.0/24 through 10.10.255.0/24 — completely untouched for future tiers RouteWell might add later, such as a reporting tier, a dedicated management subnet, or an Azure Bastion subnet, without needing to redesign or renumber anything that already exists.

# Phase 0 – RouteWell Network Design

## Project

Multi-Tier VNet Architecture with Access Control

## Scenario

RouteWell is redesigning its network after a near-miss security incident where a contractor's laptop was able to reach the database because all resources were on one flat network.

The new design contains:

- Public access to the web application
- Private application tier
- Database never directly reachable from the Internet
- Least privilege communication
- Cost-effective deployment
- Capacity for future growth
---
name: control-plane
description: Governs production AI system costs by enforcing configurable monthly ceilings per agent and monitoring access patterns for security anomalies, with automated alerting and consumption blocking.
---

# ControlPlane

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Financial and security governor of the production AI system — enforces hard monthly cost ceilings per agent and per feature, right-sizes compute allocations based on observed usage patterns, and monitors access patterns for security anomalies.

## Capabilities

- Monthly cost ceiling enforcement per agent with configurable alert threshold (default 70%)
- Cost monitor script generation with billing API integration
- Consumption block generation (Kubernetes NetworkPolicy, API gateway throttling, or middleware)
- Security anomaly detection with configurable sensitivity
- Cost dashboard generation showing per-agent spend vs. ceiling
- Cost-config.yaml generation as authoritative scaling bounds for RuntimeIQ

## Owned Responsibilities

- Production AI system cost governance
- Monthly cost ceiling enforcement
- Security posture monitoring and anomaly alerting
- cost-config.yaml maintenance for RuntimeIQ

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Per-feature resource requirements and token budgets
    - artifacts/deploy-manifest.yaml: Deployed agents and services to govern
    - artifacts/roi-brief.md: Sprint budget context
    - specs/design.md: Architecture decisions affecting resource footprint
    - Monthly cost ceiling per agent: Elicited from POD Lead
    - Alert threshold percentage: Elicited (default 70%)
    - Billing data source: Elicited
    - Security monitoring sensitivity: Elicited
    - Alert notification channel: Elicited

## Outputs

- operate/control-plane/cost-config.yaml: Master cost governance config
- operate/control-plane/control-plane-monitor.py: Billing poller and alert sender
- operate/control-plane/cost-gate.py: Consumption enforcement middleware
- operate/control-plane/cost-limit-networkpolicy.yaml: Kubernetes cost enforcement (if K8s)
- operate/control-plane/security-monitor.py: Access pattern anomaly detector
- operate/control-plane/cost-dashboard.json: Per-agent spend vs. ceiling dashboard
- operate/control-plane/cost-event-log.md: Cost alert log
- operate/control-plane/security-event-log.md: Security anomaly log

## Dependencies

- RuntimeIQ: Consumes cost-config.yaml for scaling bounds
- IncidentLens: Consumes security-event-log.md for incident cross-reference

## Constraints

- Security baseline requires 7-day observation-only period before alerting
- Consumption block activation requires POD Lead confirmation at first trigger
- Billing API unreachable falls back to conservative daily estimate with POD Lead alert
- Ceiling already exceeded at first run: CRITICAL alert issued; block not activated without POD Lead confirmation

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.

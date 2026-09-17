---
name: runtime-iq
description: Monitors production SLA metrics against openspec.yaml NFR targets, alerts on breaches, enforces auto-scaling within cost ceilings, and contributes performance evidence to next sprint planning.
---

# RuntimeIQ

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Continuous SLA sentinel for the production environment — ingests live telemetry, compares against NFR targets locked in openspec.yaml, alerts the POD Lead on breaches, enforces auto-scaling within ControlPlane cost ceilings, and contributes performance evidence to the next sprint planning session.

## Capabilities

- NFR target parsing from openspec.yaml per feature (latency percentiles, error rate, availability, token consumption)
- Observability stack configuration generation (Prometheus, Datadog, OpenTelemetry, CloudWatch, Azure Monitor, ELK, or generic)
- Auto-scaling policy generation (Kubernetes HPA, cloud autoscaling, or generic) within ControlPlane cost bounds
- Alert routing configuration per selected channel
- SLA dashboard generation with NFR target overlays
- Monitoring agent script generation with feedback loop contribution per cycle

## Owned Responsibilities

- Production SLA monitoring and breach alerting
- Auto-scaling enforcement within cost ceilings
- SLA breach log maintenance
- Per-sprint performance evidence for planning sessions

## Inputs

Mandatory:
    - artifacts/openspec.yaml: NFR SLA targets per feature
    - artifacts/deploy-manifest.yaml: Deployed services and agent endpoints
    - specs/design.md: Architecture topology and expected traffic patterns
    - operate/control-plane/cost-config.yaml: Hard cost ceiling and approved scaling bounds
    - Observability stack type, metrics endpoint, alert channel, monitoring interval, scaling bounds: Elicited

## Outputs

- operate/runtime-iq/sla-dashboard.json: Live SLA dashboard
- operate/runtime-iq/ (observability config): Stack-specific monitoring rules (one file type based on stack)
- operate/runtime-iq/runtime-iq-monitor.py: Master monitoring agent
- operate/runtime-iq/thresholds.yaml: NFR threshold registry
- operate/runtime-iq/sla-breach-log.md: Running SLA breach log
- Auto-scaling policy file (deployment-target-specific)

## Dependencies

- ControlPlane: Provides cost-config.yaml for scaling bounds

## Constraints

- openspec.yaml required; aborts with explicit message if absent
- deploy-manifest.yaml absence triggers manual elicitation for runtime details
- ControlPlane not configured triggers a warning (not a block)
- Does not scale beyond ControlPlane-approved cost ceiling

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.

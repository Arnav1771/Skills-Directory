---
name: secret-shield
description: Silently scans and redacts credentials and secrets from all LLM context payloads using regex and entropy analysis, preventing credential leaks into AI model context windows before every context injection.
---

# SecretShield

**AAxon phase:** 03-Platform-Enablement

## Purpose

Silent mandatory gate that scans every context payload destined for a generation accelerator and redacts credentials, API keys, tokens, and secrets before they enter an LLM context window, using dual-method detection — regex pattern matching plus entropy analysis.

## Capabilities

- Regex pattern matching for 12 known credential format categories (Anthropic, OpenAI, AWS, JWT, PostgreSQL, generic secrets, private keys, GitHub, Slack, Google, Bearer tokens)
- Semantic/entropy analysis for high-entropy strings (> 3.5 bits/char, length ≥ 20) not matching known patterns
- Disposition decisions: silent redact, redact-and-alert, block payload, pass-through for whitelist matches
- Append-only redaction log (file path, pattern type, action — never the secret value itself)
- Whitelist management for legitimate false-positive patterns

## Owned Responsibilities

- Secret redaction from all LLM context payloads
- Credential leak prevention before AI model context window injection

## Inputs

Mandatory:
    - Context payload (any format): Content to be scanned before LLM injection
    - references/secret-patterns.yaml: Regex pattern library for known credential formats

## Outputs

- Sanitised context payload: Input with all detected secrets replaced by typed placeholders
- secret-shield-redaction.log: Append-only redaction event log
- POD Lead alert: On block or multi-secret detection

## Dependencies

- None (SecretShield is a gate through which all other build agents pass their payloads)

## Constraints

- Always active; does not require explicit invocation — runs before every context payload injection
- Pattern matching produces false positives on high-entropy strings; weekly POD Lead log review required to tune whitelist
- Does not scan binary files; binary context injection must be flagged by DevCopilot
- Does not validate whether a redacted credential is still valid; rotation is a human decision

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.

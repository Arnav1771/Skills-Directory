---
name: spec-uiux
description: Creates and maintains the shared UI/UX specification governing design tokens, component library, motion system, and accessibility standards across all features and pods.
---

# spec-uiux

**AAxon phase:** 01-Establish-Strategy

## Purpose

Defines and maintains the UI/UX design specification — component library, design tokens, interaction patterns, and accessibility standards — created once and shared across all features and pods to prevent visual inconsistency and redundant design decisions.

## Capabilities

- Design language and token elicitation: color palette, typography scale, spacing system, border radius, elevation
- Core component definition: buttons, inputs/forms, navigation, feedback components, data display
- Motion and transition system definition: duration scale, easing, page transitions, micro-interactions
- Layout and responsive behavior: grid system, breakpoints, touch targets, safe areas
- Accessibility and internationalization standards: WCAG level, focus management, screen reader, RTL support
- Initialize Mode (new spec) and Review Mode (existing spec)

## Owned Responsibilities

- UI/UX design specification (specs/ui-ux.md)
- Design system definition as program-wide standard
- Accessibility standards

## Inputs

Mandatory:
    - specs/program.md: Target users, devices, accessibility NFRs, design highlights
  Optional:
    - specs/design.md: Frontend framework, styling library, component approach
    - Existing specs/ui-ux.md: Determines Initialize vs. Review mode

## Outputs

- specs/ui-ux.md: Design tokens, component library, motion system, layout system, accessibility standards, iconography, copy and tone, changelog

## Dependencies

- spec-design: Provides frontend framework and styling approach (optional)

## Constraints

- Created once and reused across all features; prevents visual inconsistency
- Flags if frontend framework or styling library in design.md needs updating to match spec

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.

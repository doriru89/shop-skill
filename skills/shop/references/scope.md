# Shop Scope — Lock Purchase Scope (v0.2)

> Step of the `shop` skill. Invoked from `SKILL.md`.
> **Tools for this step:** Read · AskUserQuestion — conversation only, no search, no writes
> Do not request tools beyond this line just because the router has them.

## Purpose

Before any research: lock WHAT we're buying and WHO is buying it. Every downstream step depends on this output.

## Input

User's raw purchase request (natural language).

## Procedure

### 1. Category Branch

Identify the product category and confirm the sub-branch:
- "Headphones" → IEM? Over-ear? Open-back?
- "Water shoes" → neoprene wetshoe? wading boot? dive bootie? rental?
- Don't assume. Ask if ambiguous.

If the user doesn't know the branches exist → explain them using their situation as the example, then ask.

**Keyword refinement:** After confirming the branch, determine the **shortest precise keyword** for this need:
- "Dell PC" is too broad → user wants a workstation → "Dell Precision"
- "camera cleaning" → is it sensor cleaning, lens cleaning, or full kit?

Begin **brand terminology mapping** — different brands name the same thing differently:
- Dell: "Precision", Lenovo: "ThinkStation", HP: "Z Workstation"
- Some brands don't have the sub-category at all → noted for census
- Record initial mapping in `keyword_map`; census Phase 5 will refine it

### 2. User Profile

| Field | How to get it |
|-------|--------------|
| Who uses it? | Ask: single user? multiple? mixed ecosystem? |
| Consumer or professional? | Ask or infer from context |
| Knowledge level | One calibration question (e.g., "Do you know how neoprene thickness affects warmth?") |
| Locale | Infer or ask. Affects: currency, availability, retail channels, terminology, voltage |
| Existing products | "What are you using now?" — if they own a brand, that brand gets exhaustive search later |

Domain expertise ≠ market expertise. An electrician knows wiring but may still need the
consumer-product landscape explained. Calibrate both separately.

### 3. Stakes Routing

```
stakes = max(cost_risk, harm_risk, competence_gap)
```

- cost_risk: price relative to user's implied budget
- harm_risk: what happens if the product fails? (cold feet vs electrical fire)
- competence_gap: novice + complex category = higher effective risk

| Stakes | Path |
|--------|------|
| HIGH | FULL — exhaustive census, multi-subreddit, stress test |
| LOW | LIGHT — reduced gates but still source trail + uncertainty |

User can override with `--light`.

### 4. Match Language

Track the user's language from their messages. Chinese in → Chinese out. Mixed → follow the most recent pattern. Propagate to all downstream steps. Knowledge level propagates the same way: novice → plain language and analogies; expert → technical specs.

### 5. Present & Confirm (HITL)

Render the complete scope output as a markdown list in the reply body — every field, including the stakes calculation shown as `max(cost_risk, harm_risk, competence_gap)` with each input — and **end the turn with no trailing tool call**. The user sees this. Collect confirmation in the NEXT turn; AskUserQuestion carries only the decision (confirm / adjust), never the scope content.

## Output

```yaml
scope:
  category: "water crossing footwear"
  branch: "cold-water canyon wading (neoprene wetshoe, wading boot, dive bootie, rental)"
  user_profile:
    who: "solo traveler"
    type: "consumer"
    knowledge: "intermediate — knows basic options but not market depth"
    locale: "US-based, shopping for a glacier-country trip"
    existing_products: "none in this category"
  stakes: "LIGHT"  # low cost ($20-75), low harm (cold feet), low competence gap
  language: "en"
  budget: "$20-75 (soft)"
  use_case: "2km canyon wading in 2°C glacier water, rocky bottom, 3 days of use"
  keyword_map:  # brand → their term for this category (refined in census Phase 5)
    NRS: "wetshoe"
    Cressi: "dive bootie"
    La_Sportiva: "canyoneering shoe"
```

## Verification

- [ ] All required fields populated
- [ ] Branch includes ≥2 sub-categories (not pre-narrowed)
- [ ] Stakes calculation shown (not just the result)
- [ ] Language detected and noted
- [ ] User confirmed scope before proceeding — after seeing the full scope rendered in the reply body per step 5 (never only inside AskUserQuestion options)
- [ ] keyword_map has ≥2 initial entries (refined by census)

## Anti-Pattern

**Never skip scope to start researching.** The #1 shop failure mode is: user says "I want X" → AI immediately searches "best X" → tunnel vision from sentence 1. Scope exists to EXPAND the search space before research narrows it.

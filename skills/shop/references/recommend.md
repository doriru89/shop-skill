# Shop Recommend — Final Recommendation (v0.2)

> Step of the `shop` skill. Invoked from `SKILL.md`.
> **Tools for this step:** Read · Bash (only `curl -I` for URL liveness) · Write (only `shop-runs/<date>-<category>.md`)
> Do not request tools beyond this line just because the router has them.

## Purpose

Present the final recommendation with full transparency: what we recommend, how we got there, what we might have missed, and what to watch out for when buying.

## Input

- Evaluation output from `references/evaluate.md` (shortlist + evidence cards + stress test)
- Full source list from all phases

## Procedure

### 1. Per-Tier Best

If multiple viable tiers exist, recommend the best in EACH tier:

```
💰 Budget ($30-40): Cressi Isla dive bootie — 3mm, basic but functional
⭐ Sweet spot ($60-80): NRS Kicker — best warmth/weight/sole balance
🔥 Premium ($100-120): NRS Paddle — maximum warmth, overkill for most
```

### 2. Evolution Trail

Show how the recommendation changed through the research process:

```
Evolution:
1. Started with "neoprene water shoes" (user's framing)
2. Frame break expanded to: wetshoes, dive booties, wading boots, rental
3. Census found 12 brands across 6 sub-categories
4. Tradeoffs revealed: portability > max warmth (user chose 3mm over 5mm)
5. Stress test: rental is viable alternative (€50 vs $75, no luggage weight)
6. Final: NRS Kicker OR Cressi Isla depending on budget
```

This is NOT decorative. It shows the user that the recommendation is the END of a process, not the BEGINNING.

### 3. Per-Product Card

For the recommended product(s):

```
NRS Kicker Wetshoe — ⭐ Recommended [Census: 12 brands / 24 products — PASS]

Strengths:
• 3mm neoprene, warm for intermittent cold wading [treelinereview.com ✓]
• Hard rubber sole, good grip on wet rock [outdoorgearlab.com ✓]
• Walkable on dry trail (not just water) [reddit.com/r/kayaking ✓]

Weaknesses:
• Sole wears after 1-2 seasons heavy use [reddit.com/r/kayaking ✓]
• Not warm enough for full-day submersion in near-freezing water [nrs.com spec ✓]

Setup cost: None — wear and go
Ecosystem lock: None
Ideal for: intermittent canyon wading + dry trail
Avoid if: planning full-day cold-water kayaking

Price: $75 at NRS.com, Amazon, REI
```

### 4. Source Trail

Full formatted trail from all phases combined. This is the audit chain. If a
source-trail validator skill is installed, call it; otherwise follow the convention
below.

#### Source trail convention

**Collection (during census and evaluate).** Keep one `sources` list for the whole run.
Each substantive page gets an entry at the moment it is read:

```yaml
- url: "https://..."
  title: "Page title or description"
  type: review | reddit | manufacturer | retailer | forum | academic | news | government | social | video
  claims:
    - "short string: what was learned from this source"
```

**Validation.** Claimed ≠ verified. Two layers:

| Layer | Check | How |
|---|---|---|
| alive | each URL answers | `curl -sI -o /dev/null -w '%{http_code}' <url>` → 2xx/3xx `[verified]`, 4xx/5xx `[dead]`, timeout or bot-block `[unverified]` |
| provenance | every URL in the trail was actually opened this session | the trail must only contain URLs that appear in this conversation's WebSearch/WebFetch/browser calls — never add an entry to pass a gate |

Dead URLs stay in the trail (they prove the search happened) but are flagged.

**Coverage stats and structural gaps** (no domain knowledge needed):

```
Sources: 12 total, 8 unique domains
By type: review(4) reddit(3) manufacturer(2) retailer(2) forum(1)
Validated: 10 | Dead: 1 | Unverified: 1
⚠️ Gaps: 0 video sources; 6 of 12 sources from one domain
```

Flag: a type with 0 entries when the step required it; all sources from ≤2 domains;
0 reddit/forum sources (no real user experience); 0 manufacturer sources (no primary data).

**Formatted trail** grouped by type:

```markdown
## Source Trail

### Reviews (4)
- [Treeline Review: NRS Kicker](https://...) [verified]
  → "3mm neoprene, good grip on wet rock"

### Reddit (3)
- [r/kayaking: cold water shoes](https://...) [verified]
  → "NRS lasted 3 seasons, sole wore down year 2"

### Coverage
Sources: 12 | Domains: 8 | Verified: 10/12
⚠️ Gaps: 0 manufacturer sources (no primary data checked)
```

**Thresholds** come from the census gates (FULL vs LIGHT). The trail reports PASS/FAIL per
threshold; the router decides what to do with a FAIL.

### 5. Uncertainty Section (MANDATORY — derived, not invented)

The blind-spot section has a **mandatory floor** derived from census `source_coverage`: every channel row with status ≠ COVERED flows verbatim into this section with its note. The AI may add extra blind spots on top, but the derived rows are the non-negotiable floor.

```
## What I Might Have Missed

### Channel coverage gaps (derived from source_coverage — mandatory)
- community: PARTIAL — Reddit search index limited; absence of complaints ≠ no complaints
- marketplace_alt: N_A — no crowdfunded entrants found

### Other blind spots (AI-identified, supplementary)
- Japanese canyoning brands (Montbell) — searched, found no relevant cold-water products
- Chinese direct-to-consumer brands — limited English reviews, may have good options on Taobao
```

**This section CANNOT be empty.** If the AI claims zero blind spots, the census was not honest. If all 7 source_coverage channels are COVERED, at least the supplementary sub-section must have ≥2 entries.

### 6. Transaction Audit

```
Buying notes:
- NRS.com has free returns within 60 days
- Amazon price matches NRS.com (check at purchase time)
- ⚠️ Sizing runs small per reddit reports — order half size up
- No drip pricing or subscription traps
- Resale value: ~$20-30 used (niche market)
```

### 7. Confidence Calibration

Based on source trail coverage:

| Census gate | Sources per claim | Allowed language |
|-------------|-------------------|-----------------|
| PASS | ≥3 independent | "recommended" / "best" |
| FAIL or <3 | any | "preliminary read" / "based on limited search" |

**The AI MUST use the calibrated language.** If the census gate failed, the recommendation header changes from "⭐ Recommended" to "⚠️ Preliminary read (coverage insufficient)". Calibrate per claim where it differs: brand reliability may be recommended-grade while one-year durability is only a preliminary read.

## Output

The final user-facing recommendation including all sections above.

## Gates

| Gate | Requirement |
|------|------------|
| Recommendation in shortlist | Recommended product must be in evaluate output |
| Evolution trail | Shows ≥1 change from initial framing |
| Source trail | Present, validated per the convention above |
| Uncertainty | Non-empty; must contain ALL non-COVERED source_coverage channels verbatim + ≥2 total entries |
| Confidence calibrated | Language matches census coverage |
| Session saved | Evidence trail written to `shop-runs/` |

## Save

Write session output to `shop-runs/{date}-{category}.md` (create the folder if missing):
- Scope (final)
- Evolution trail
- Decision (with reasoning and confidence per claim)
- Census coverage stats
- Source trail (URLs)
- Blind spots

A run that lives only in the transcript is lost the moment the session ends. See
`examples/` in the repository for the shape of a saved run.

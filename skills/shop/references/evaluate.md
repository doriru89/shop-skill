# Shop Evaluate — Converge + Verify (v0.2)

> Step of the `shop` skill. Invoked from `SKILL.md`.
> **Tools for this step:** WebSearch · WebFetch · Read · a browser tool if available · Agent (Step 7 advocates / steelman only) · AskUserQuestion for tradeoffs and confirm
> Do not request tools beyond this line just because the router has them.

## Purpose

Narrow the census to a shortlist through user interaction (forced tradeoffs), then deep-verify each shortlisted product with real evidence.

## Input

- Census output from `references/census.md`
- Live user interaction (HITL required — this step CANNOT run in a fork)

## Phase A: Converge

### 1. Feasibility Check

Before posing tradeoffs: count products per attribute-cell.
- If a tier has ≤1 product → don't pose a tradeoff within that tier. Instead: state the monopoly, compare against adjacent tiers ("is imaging worth 2.7× the price?"), and ask why the tier is sparse.
- If the entire category has ≤3 viable products → skip tradeoffs, go directly to Verify on all of them.

### 2. Forced Tradeoffs (HITL)

Binary A/B choices, contextualized to the user's use case:

```
A: 3mm neoprene — light, $40-75, but feet may get cold in 2°C water
B: 5mm neoprene — warm, $75-110, but bulky and awkward on dry trail

Your scenario: intermittent wading (not submerged the whole time), 2km with dry stretches. Which one?
```

Each tradeoff reveals preference AND educates simultaneously.

### 3. Stated vs Revealed Preference

Track: what the user SAID matters vs what they CHOSE in tradeoffs.
- If they SAID "warmth is #1" but CHOSE lightweight in 2/3 tradeoffs → surface this gap.
- This is insight, not error. Present it: "You said warmth matters most, but your choices lean light — is portability actually more important to you?"

### 4. Confirm (HITL)

Before proceeding to Verify, render ALL of this in the reply body as a markdown list/table — the user sees it:
- North Star priorities (top 2-3) — each with the tradeoff answer that revealed it
- Hard red lines (absolute dealbreakers)
- Budget (soft vs hard)
- Shortlist: typically 3-6 products — one line each: name, price, why it survived

**End the turn after presenting, no trailing tool call.** Collect confirmation in the NEXT turn; AskUserQuestion carries only confirm / adjust, never the evidence.

## Phase B: Verify

### 5. Deep Evidence per Product

For each shortlisted product:

- **Spec verification:** Check the manufacturer site directly. Don't trust review sites' spec tables.
- **Verified purchase reviews:** Read actual Amazon/retailer reviews (browser tool, or WebFetch). Look for:
  - Distribution shape (mostly 5-star with a few 1-star ≠ mostly 3-star)
  - Recurring specific complaints
  - 6+ month reviews (durability signal)
  - Verified purchase ratio
- **Reddit/forum sweep:** Multi-subreddit search with failure-mode queries:
  - `[product] + failed | broke | regret | returned`
  - Search ≥3 relevant subreddits
  - **MANDATORY: tag every search result with status** — `FOUND_POSITIVE`, `FOUND_NEGATIVE`, `FOUND_MIXED`, `SEARCH_EMPTY`, `SEARCH_FAILED`, or `SOURCE_INACCESSIBLE`. When status is EMPTY/FAILED/INACCESSIBLE:
    - Report as "no data found (reason: search-tool limit / platform inaccessible) — this does not mean no complaints exist"
    - **NEVER** say "zero complaints" / "no complaints" / "well regarded" — these phrases are BANNED when evidence is absent
    - Suggest the user search manually: "worth searching r/[subreddit] for [brand] yourself"
- **Trust signals:** Trustpilot, Fakespot, BBB for each brand (if not already done in census)

### 5a. Scope-Constraint Cross-Check

Before building evidence cards: verify EACH shortlisted product against ALL scope constraints.

| Constraint (from scope) | Product | Compatible? |
|------------------------|---------|-------------|
| Air travel | Eclipse (solvent) | ❌ FLAMMABLE — drop |
| Filter size 77mm | NLP-1 12mm head | ⚠️ SUBOPTIMAL — flag |
| First-time user | Eclipse (technique-sensitive) | ⚠️ RISK — flag |
| Budget $50-100 | La Sportiva $179 | ❌ OVER BUDGET — drop |

Sources: scope.use_case, scope.user_profile, scope.budget, scope.locale (shipping/travel/voltage restrictions).

Any ❌ → product dropped from shortlist. Any ⚠️ → flagged in recommendation with explanation. This catches products that cleared census but violate a scope constraint the search didn't check.

### 6. Build Evidence Cards

Per product:
```yaml
product: "NRS Kicker Wetshoe"
price: "$75"
identity:   # REQUIRED per product — availability verified at manufacturer site
  availability: in_production   # in_production | renamed | discontinued
  availability_source: "https://nrs.com/..."
  naming_note: null   # e.g. "the model number is output watts, not capacity Wh — verified on the manufacturer page"
strengths:
  - claim: "3mm neoprene keeps feet warm in cold water"
    source: "https://treelinereview.com/..."
    source_type: review
  - claim: "90.83% charging efficiency"
    source: "https://chargerlab.com/..."
    source_type: instrumented_review
    conditions: "@ 27W USB-C output, instrumented bench test"  # REQUIRED for numeric/measured claims
weaknesses:
  - claim: "sole wears down after 1-2 seasons of heavy use"
    source: "https://reddit.com/r/kayaking/..."
    source_type: reddit
setup_cost: "none — wear and go"
ecosystem_lock: "none"
durability: "1-2 seasons estimated (based on reddit reports)"
ideal_for: "intermittent cold-water wading with dry-trail walking"
avoid_if: "full-day submersion in very cold water (get 5mm instead)"
```

Every claim has a source URL. No URL → tagged `[UNVERIFIED]`. **Numeric/measured claims** (efficiency %, capacity Wh, speed W, temperature °C) without `conditions` → also tagged `[UNVERIFIED]` — a number without test conditions is not evidence.

**Data provenance tag (mandatory per claim):**
```yaml
claim: "99.7% light transmission"
source: "https://hoyafilterusa.com/..."
source_type: manufacturer  # manufacturer | independent_lab | user_report | retailer
verified_independently: false
```
Any comparison table mixing `manufacturer` and `independent_lab` numbers → mandatory inline warning: "⚠️ different data sources, not directly comparable". Never present manufacturer marketing claims and independent lab measurements as equivalent.

**Semantic verification for numbered product families:**
When products have numbered types/variants (Type 1/2/3, Gen I/II/III, Mark I/II):
1. List ALL types with specs in a lookup table FIRST
2. Cross-reference the user's dimensions against product dimensions numerically
3. Show the math: "sensor short side = 24.0mm → swab width = 24mm → Type 3"
4. Never trust name-number association from memory — verify from the manufacturer spec

### 7. Stress Test

**FULL path — one advocate per product.** Spawn one fresh-context agent on the strongest
model available (`Agent`, background, in parallel) for EACH shortlisted product, plus one
for the strongest rejected alternative. Every advocate gets the same brief: buyer profile +
scope constraints + the competitors' key specs (so it compares, not just praises). Output
contract, identical for all:

1. **Kill-criterion first** — one falsifiable condition under which its own
   product is the wrong pick for THIS buyer, written before researching
2. 3-5 strengths + 3-5 weaknesses, each with a URL or `[UNVERIFIED]`;
   measured numbers carry test conditions
3. Kill-criterion verdict against the evidence
4. Who should pick it / who should not

The primary session is the judge, not an advocate: it merges the reports into
one table, lists every place the reports contradict each other or correct an
earlier claim, and does not re-derive its own verdict on top. A product added
to the shortlist later (e.g. the user names a new "second choice") gets its own
advocate before it is compared.

**LIGHT path — one steelman.** Spawn a single agent to steelman ONE rejected
alternative:
- Agent is briefed as if hired by the runner-up vendor
- State a falsifiable kill-criterion before attacking
- Verify the criterion

Product vs category separation: if evidence kills a product, explicitly ask:
"This product has issues. Has your preference for this category changed, or just this product?"

**Counter-search on alarming claims:**
When a safety warning or alarming claim is found during evidence gathering:
1. Search for the OPPOSITE claim: "[product] safe [use case]"
2. Check if the warning was retracted or disputed
3. Count actual damage reports — not blog reposts of the same incident
4. Present BOTH sides to the user with source counts

AI has a strong "safety bias" — one alarming article overrides 100 positive experiences. Counter-search is the mechanical antidote.

## Output

```yaml
evaluation:
  shortlist: [...]  # 3-6 products with evidence cards
  tradeoff_log:
    - question: "3mm vs 5mm neoprene?"
      user_chose: "3mm (lightweight)"
      revealed: "portability > maximum warmth"
  filtered_out:
    - product: "SIMARI Water Shoes"
      reason: "no insulation, not viable for 2°C water"
    - product: "La Sportiva TX Canyon"
      reason: "user budget $20-75, this is $179"
  stress_test:
    steelmanned: "rental option"
    verdict: "viable alternative — €50 for 2 days vs $75 to buy"
  source_trail:
    total: 25
    # ...
```

## Gates

| Gate | Requirement |
|------|------------|
| Shortlist size | 3-6 products (if fewer exist in category, explain why) |
| Evidence per product | ≥2 independent sources with URLs |
| Identity per product | Every shortlisted product has `identity` block with `availability` verified at manufacturer site |
| Numeric claims conditioned | Every numeric/measured claim has `conditions` field, or is tagged `[UNVERIFIED]` |
| Filtered-out list | Present and non-empty (shows what was cut and why) |
| Stress test | ≥1 rejected alternative steelmanned |
| Per-product advocates (FULL only) | Every shortlisted product has an advocate report with a pre-stated kill-criterion + verdict; the merged table lists inter-report contradictions |
| HITL tradeoffs | ≥2 binary tradeoff questions asked to user |
| Scope constraints checked | Step 5a matrix completed for all shortlisted products |
| Top-tier head-to-head | All census "top-tier"/"premium" brands appear in shortlist for comparison |
| Data provenance tagged | Every claim has source_type; mixed-provenance comparisons have inline warning |

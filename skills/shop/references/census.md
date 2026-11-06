# Shop Census — Exhaustive Market Census (v1.2)

> Step of the `shop` skill. Invoked from `SKILL.md`.
> **Tools for this step:** WebSearch · WebFetch · Read · Write · Edit (only `shop-runs/brand-cache.yaml`) · Agent (fast-model extraction sub-tasks only, never the conversation) · a browser tool if one is available · AskUserQuestion at the Phase 1 job-statement gate and the Phase 4 checkpoint
> Do not request tools beyond this line just because the router has them.

## Purpose

Build a complete, verified map of the market BEFORE any filtering. The census is the foundation of trust. Parallel sweep replaces sequential snowball, manufacturer sites replace SEO-biased results, brand data persists across sessions.

## Input

Scope document from `references/scope.md` (including `keyword_map` for brand-specific terminology).

## Procedure

### Phase 1: MANDATORY — Break the frame before searching

Tunnel vision is cheaper to prevent than to detect. Before the first search, convert the
user's product language into job language and enumerate the other forms that could do the
job. If a dedicated frame-breaking skill is installed in the project, call it with the scope
and ask for the JTBD T2/T3 and CROSS-FORM dimensions; otherwise run this inline procedure.

**1a. Job statement (human-confirmed).** List the category nouns in the user's own words
("walking pad", "charger", "tripod"). Write a one-line job statement that contains NONE of
them: `[who] needs to [outcome], because [why]`.

- ❌ "A home-office worker needs a better walking pad" — the noun is still there, every downstream query inherits the anchor
- ✅ "A home-office worker needs to move for 30 minutes a day without leaving the desk, because sitting all day hurts"

Render the proposed statement in the reply body, end the turn, and ask next turn:
*A) yes, that's it — B) not quite, actually… — C) not sure, help me think.*
**Hard gate: no search until the job statement is confirmed.** An expanded search on the
wrong job is worse than a narrow search on the right one.

**1b. Form enumeration.** Ask the mechanical question: "besides [original category], what
other forms can do [job]?" List **≥3 forms that are not the original category**. The form
list is a first-class output — the snowball later tags every new entity with its form.

```
FORMS: under-desk walking pad | folding treadmill | treadmill-desk base
       | used commercial treadmill | motorless curved pad | under-desk stepper/elliptical
       | non-consumption (walk outside twice a day)
```

**1c. Search cloud.** Generate first-round queries across these dimensions. The cloud is a
menu, not a mandate — pick what fits the ambiguity of the task.

| Dimension | Generates |
|---|---|
| SYNONYMS | every way the job verb is phrased |
| ANTONYMS | "why people stop / fail to [job]" |
| JTBD T1 (direct) | same category, same method |
| JTBD T2 (indirect) | different product, same outcome — one query per form from 1b |
| JTBD T3 (alternative) | entirely different approach, including doing nothing |
| CROSS-FORM | hardware↔software, device↔app, standalone↔built-in |
| FAILURE + M&A | "[space] discontinued / recalled / acquired [recent years]" |
| DISAGREEMENT | "[category] problems / regret / why I stopped" |

**1d. Show the first-round queries** to the user before running them ("Based on the job,
I plan to search: … right direction?"). One wrong assumption about what a word means can
waste every search that follows.

Attribution: JTBD 3-tier competition (Christensen, HBS 2003); PRESS search-strategy
checklist (McGowan et al., *J Clin Epidemiology* 2016) for the synonym dimension; Blue Ocean
non-customer tiers (Kim & Mauborgne) for non-consumption.

### Phase 2: Market Sweep (parallel + snowball)

**Goal:** Build the company/product table through multi-round discovery. Within each round, searches fan out in parallel. Across rounds, new brands snowball forward.

#### Search Loop

```
seeds = Phase 1 cloud (FORMS + dimensions)

WHILE NOT converged:

  ── SEARCH ──
  1. From seeds, generate ≥5 short queries (≤3 words)
     across different angles (synonyms, comparisons,
     negation, regional, adjacent categories)
  2. Execute searches in parallel

  ── EXTRACT (snowball engine) ──
  3. From EVERY article/page, extract ALL entity mentions:
     - Brand/product names (fuzzy, grab everything)
     - "X vs Y" comparisons → both X and Y
     - "alternative to X" → X + the alternative
     - OEM/reseller → record with parent company
     - Expert site/channel mentioned → record as source lead
     Tag each new entity with its FORM from Phase 1b.
     Do NOT filter. Extraction is exhaustive; filtering is Phase 4's job.
  4. new_entities = extracted entities NOT already in table

  ── CONVERGE ──
  5. Check (ALL must pass):
     - total brands ≥ 8?
     - 2 consecutive rounds with new_entities = 0?
     - entities span ≥2 Phase 1 FORMS?
     - sources span ≥3 data layers? (see source_coverage)
  6. seeds = new_entities → next round
```

**Search constraints:**
- Queries ≤3 words — search engines do AND matching; long queries shrink result space exponentially
- ≥5 different angles per round — synonyms, adjacent categories, negation ("X problems"), comparison ("X vs"), regional variants
- Never use the same query twice across rounds
- Anti-pattern: `"[brand] [category] full product line [year]"` — too long, too specific, returns SEO-optimized pages not comprehensive listings

**Within each round:** Searches are parallel (searching Hoya and B+W simultaneously has no dependency).
**Across rounds:** Results feed forward — the EXTRACT step's new entities become the next round's seeds. This IS the snowball.

**Convergence ≠ coverage.** If two consecutive rounds produce only entities of the original form, the frame has not broken: stop and redo Phase 1b with the gap as evidence.

Record every round in `search_log`:
```yaml
search_log:
  - {round: 1, queries: [...], new_brands: 4, new_channels: 1}
  - {round: 2, queries: [...], new_brands: 2, new_channels: 0}
  - {round: 3, queries: [...], new_brands: 0, new_channels: 0}
  # convergence: rounds 2→3 zero new ✓
```

#### Multi-model optimization (optional)

- **Fast model** (via Agent, e.g. Haiku): runs the loop's EXTRACT step in parallel for speed — scans search results for company/product name extraction, speed > precision. 5-10 parallel extractions per round.
- **Primary model**: assembles the structured table from the extractions. Deduplicates, resolves parent companies, assigns categories.
- Without multi-model: same procedure, single model, fewer parallel searches per round.

**Local-first:** Before web-searching any brand, check `shop-runs/brand-cache.yaml` (see Brand Cache). Cached brands start with stored data — skip their snowball round.

### Phase 2.5: Experience Layer (MANDATORY)

**Purpose:** WebSearch returns the Editorial layer (SEO articles). The Experience layer (real user reports) lives on platforms WebSearch can't reach well. This phase forces access to those platforms.

**GATE: Phase 3 cannot start until ≥2 of these are done:**

| Channel | Tool | What to extract | Skip condition |
|---------|------|----------------|----------------|
| **Reddit** | browser tool (or WebFetch of `old.reddit.com` / `.json` endpoints) | Search `r/[category]` for real owner reports: what breaks, what gets ignored, long-term satisfaction | Never skip — Reddit is the highest-signal Experience source |
| **YouTube** | WebSearch `"[category] review"` + WebFetch transcript, or `yt-dlp` | Video reviewers with real product demos | Skip if category has no visual demo value |
| **Amazon verified purchase** | browser tool or WebFetch of the product page, filter "Verified Purchase" | 1-star and 3-star reviews specifically — they reveal what spec sheets hide | Skip if product not on Amazon |

**Why this is a separate phase, not part of the Search Loop:**
The Search Loop uses WebSearch (low friction, broad). This phase uses direct platform access (high friction, deep). Mixing them in the loop would slow every round. Instead: the loop finds WHAT exists (brands, products); this phase finds WHETHER it's actually good.

**Anti-pattern:** Filling `source_coverage.community: COVERED` from a Reddit link that happened to appear in WebSearch results. That's an SEO-filtered summary of Reddit, not Reddit itself. COVERED requires direct platform access. If the platform is login-walled or blocked, mark PARTIAL with the reason — never COVERED.

### Phase 3: Gap Reflection

Review the table against a systematic checklist. Each row: searched? found? note.

| Gap type | Check |
|----------|-------|
| OEM/resellers | Any products rebranded? Who manufactures the OEM? |
| Regional brands | Non-US markets? (Decathlon, Montbell, Chinese direct) |
| Article competitors | Every competitor mentioned in ANY source is in table? |
| Crowdfunded | Kickstarter/Indiegogo entrants? |
| Professional crossover | Pro-grade products consumers can buy? |
| Adjacent forms | All Phase 1 FORMS searched? |
| Price extremes | Budget floor AND premium ceiling represented? |

Targeted searches for any "not searched" row. Gap search returning nothing is data ("searched, nothing found"), not silence.

**Category lock-in check:** If ALL brands so far are the same sub-category → frame hasn't broken. Stop, redo Phase 1b with gap evidence.

### Phase 4: Landscape Checkpoint (HITL)

The **education** moment — teach the market before asking decisions.

**Present:**
1. Company count + sub-category tree
2. Price tier overview with what you get at each level:
   ```
   $20-50   entry: basic function, cheaper materials
   $50-100  mainstream: multi-function kits, good enough
   $100-200 pro: premium materials, full coverage
   ```
   Note empty tiers — they reveal market structure (immature tech? patent monopoly?).
3. Technology routes and key tradeoffs
4. Sub-categories needing user confirmation

**Collect:**
- Which tiers to research deeply (skip budget → saves Phase 5 time)
- Missing brands the user knows
- Sub-category confirmation

**Scope narrowing:** User-excluded tiers → skip in Phase 5. Record: `excluded_tiers: [{tier, reason}]`.

### Phase 5: Product-Line Depth (per viable company)

For each company NOT excluded in Phase 4:

**5a. Brand terminology mapping:**
- Use `keyword_map` from scope, refine per brand
- Dell calls workstations "Precision", Lenovo calls them "ThinkStation", Razer has no equivalent
- Determine shortest accurate search keyword per brand
- Update keyword_map

**5b. Manufacturer site visit:**
- Go to the manufacturer's ACTUAL product page for the relevant category (browser tool if available, WebFetch otherwise)
- NOT "dell workstation release [year]" → open dell.com's workstation listing
- Extract real product listings and current prices from live pages
- Inaccessible → use primary retailer (Amazon, B&H, manufacturer's Amazon store) and mark `manufacturer: PARTIAL`

**5c. Product-line mapping (last 5 years):**
- List ALL current + recent products from live pages
- Time window: last 5 years; extend to 10 if no recent releases
- Map to tiers: entry / mid / premium
- Record verified prices — NOT pretrained memory
- Company with no new products in 5+ years → viability flag

**5d. Brand viability assessment:**
- Quick check per company (can delegate to a sub-agent)
- Red flags: bankruptcy, major recalls, regulator stop-use notices, no recent releases, category exit
- Cross-validate before excluding — one negative signal ≠ exclusion
- Verdict: `viable` / `caution: [reason]` / `excluded: [reason, cross-validated]`

### Phase 6: Collect Source Trail

Maintain source entries throughout (format in `references/recommend.md`, "Source trail convention"). Every substantive page gets an entry at the time it is read, not at the end — a session that dies mid-run should not lose its evidence.

## Brand Cache (cross-session)

Brand research persists in `shop-runs/brand-cache.yaml`, keyed by company, shared across categories.

```yaml
brands:
  Hoya:
    parent_company: "Kenko Tokina Co., Ltd."
    viability: viable
    categories_researched: [filter, lens_accessory]
    last_updated: 2026-07-21
    products:
      filter:
        - {name: "HD3 UV", tier: premium, price: "$130", year: 2024}
        - {name: "HD MK II", tier: mid, price: "$89", year: 2022}
    trust_signals: "optical specialist, Japan, 80+ year history"
```

**At census start:** Load cache. Known brands use cached company data (trust, parent, viability). Products >30 days old need price re-verification.

**At census end:** Update cache with all new research. Dell researched for laptops enriches Dell's entry for a later monitor session.

**The cache is per-company, not per-session.** Companies operate across categories — prior research is reusable.

## Output

```yaml
census:
  job_statement: "..."          # Phase 1a, user-confirmed
  forms: [...]                  # Phase 1b, ≥3 non-original
  brands: 12
  products: 28
  sub_categories: 6
  price_tiers: 5
  brand_list:
    - name: "Hoya"
      parent_company: "Kenko Tokina Co., Ltd."
      positioning: "optical filter specialist, 3 tiers"
      form: "screw-on filter"
      products:
        - {name: "HD3 UV", tier: premium, price: "$130", verified_source: "hoyafilterusa.com"}
        - {name: "HD MK II", tier: mid, price: "$89", verified_source: "amazon.com"}
      viability: viable
      manufacturer_site_visited: true
  excluded_brands:
    - {name: "Tiffen", reason: "no releases since 2019", cross_validated: true}
  excluded_tiers:
    - {tier: "budget (<$30)", reason: "user excluded at Phase 4"}
  search_log:
    - {phase: 2, angle: "market structure", queries: [...], new_brands: [...], new_channels: [...]}
    - {phase: 3, angle: "gap: regional", queries: [...], new_brands: [...]}
  gap_checklist:
    oem_resellers: {searched: true, found: ["Tiffen = Kenko distributor"]}
    regional: {searched: true, found: ["NiSi (China)", "Kenko (Japan)"]}
    article_competitors: {searched: true, note: "all in table"}
    crowdfunded: {searched: true, found: []}
    pro_crossover: {searched: true, found: ["Zeiss T* cinema line"]}
    adjacent_forms: {searched: true, found: ["lens hoods as UV alternative"]}
    price_extremes: {searched: true, found: ["$15 generic to $200+ cinema"]}
  source_coverage:
    # ── Layer 1: Editorial (SEO-optimized, broad but shallow) ──
    pro_reviews: {status: COVERED, sources: 6}
    corporate_background: {status: COVERED, sources: 3}
    # ── Layer 2: Experience (real users, deep but noisy) ──
    community: {status: COVERED, sources: 3, note: "Reddit read directly"}
    verified_purchase: {status: COVERED, sources: 4}
    video_reviews: {status: COVERED, sources: 3}
    # ── Layer 3: Primary (manufacturer/creator, authoritative) ──
    manufacturer: {status: COVERED, sources: 5}
    marketplace_alt: {status: N_A, note: "no crowdfunded entrants"}
    # Data layer diversity: ≥3 layers with ≥1 COVERED each (FULL) / ≥2 layers (LIGHT)
  source_trail: {total: 22, domains: 14, verified: 20, dead: 2}
```

## Gates

| Gate | FULL | LIGHT | How |
|------|------|-------|-----|
| Brands | ≥8 | ≥5 | Count brand_list |
| Products | ≥20 | ≥10 | Count products across brands |
| Frame broken | Yes | Yes | ≥2 non-original forms in search log |
| Gap checklist complete | All rows | All rows | gap_checklist has entry per type, `searched: true` |
| Search log present | Yes | Yes | Entries per phase |
| Source coverage | 7 rows, ≥5 COVERED | 7 rows, ≥3 COVERED | All status rows present |
| Data layer diversity | ≥3 layers COVERED | ≥2 layers COVERED | Editorial + Experience + Primary each has ≥1 COVERED source |
| Experience layer direct | ≥2 channels (Phase 2.5) | ≥1 channel | Reddit/YouTube/Amazon accessed directly, NOT via WebSearch proxy |
| Product-line complete | Top-tier: all tiers | Best effort | Top brands have entry/mid/premium if they exist |
| Manufacturer site visited | Top-tier: yes | Optional | ≥1 live page per top brand |
| Brand viability assessed | All brands | Quick check | Every brand has verdict |
| Parent company per brand | Yes | Yes | Verified or "unknown — searched" |
| Source trail present | Yes | Yes | Entries per Phase 6 |
| User checkpoint done | Yes | Yes | Phase 4 HITL completed |
| Excluded tiers noted | If any | If any | Recorded with reason |

**Gate FAIL → inline warning, visible to user and downstream steps.**

## Efficiency Shortcuts

| Situation | Shortcut | Constraint |
|-----------|----------|-----------|
| User excludes a tier | Skip Phase 5 for those brands | Record in excluded_tiers |
| Brand clearly non-viable | Sub-agent check + cross-validate → exclude | Must cross-validate |
| Brand in cache (<30 days) | Use cached company data, verify prices only | Flag if price changed >15% |
| <5 viable brands in category | Lower brand gate, increase depth per brand | Note in output |

## Presentation

Census results are presented **conversationally**, not as table dumps. One concept at a time:
1. Brand trust landscape (the coordinate system)
2. Technology routes and key tradeoffs
3. Sub-category structure
4. Product census by tier

Tables are internal working memory. User-facing output weaves education into questions.

## Lineage

v1.2: Added data layer diversity gate. source_coverage restructured into 3 layers: Editorial (SEO, broad but shallow), Experience (Reddit/reviews/video, deep but noisy), Primary (manufacturer, authoritative). Convergence requires ≥3 layers COVERED (FULL) / ≥2 (LIGHT). Motivated by a pet-toy run: the most valuable insights ("interest decays after a week", "ball tracks outlast electronics") came from the Reddit Experience layer, invisible to Editorial-only search. SEO articles unanimously recommended products that owners said their cats ignored after a week. Public release: frame-breaking procedure inlined as Phase 1.

v1.1: Replaced query templates with loop structure (SEARCH/EXTRACT/CONVERGE). Query templates (5 Round 1 patterns + 4 Round 2 patterns) deleted — they produced rigid, long queries that harmed search quality. Loop structure forces iteration via outcome gates while leaving query generation to AI judgment. Extraction rules (entity pump) made first-class in the loop.

v1.0: Major restructure. Parallel sweep replaces sequential snowball (Phase 2). Systematic gap checklist replaces "2 rounds zero new" convergence (Phase 3). Manufacturer-site-first product-line mapping (Phase 5). Brand cache for cross-session persistence. Motivated by a lens-filter run: the snowball converged on SEO-popular products (the brand's older mid-tier filter over its current flagship; a well-known cleaning kit over the better-rated one; one product never found despite being from the same brand).

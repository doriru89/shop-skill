# /shop — USB-C travel charger (synthetic worked example)

> **This run is illustrative.** It shows the shape of what the skill produces at each
> gate — the fields, the tables, the language — not research results. Brands and model
> families are real, but every price, count, quote and verdict is a placeholder, and
> sources are reduced to domains so that no fabricated URL is published. A real run
> stores full URLs and the liveness check for each.

## Scope (final) — gate: scope complete ✓

- Request: "I need a charger for travel"
- Job statement (confirmed): *A frequent flyer needs to charge a laptop, a phone and earbuds overnight in any hotel, because carrying three bricks is the thing they resent most.*
- Branch: multi-port GaN wall charger (also enumerated: single-port GaN brick, power bank with built-in plug, desktop charging station, the laptop's own charger, hotel USB ports / non-consumption)
- User: one person, consumer; 13" laptop (~30W), phone, earbuds; flies between North America and the EU; intermediate knowledge (knows "GaN", not Power Delivery negotiation)
- Existing products: the laptop's stock single-port charger
- Stakes: `max(cost_risk: low ($40-80), harm_risk: medium (overheating reports in the category), competence_gap: low)` → **LIGHT**, with the overheating risk carried into the gap checklist
- Budget: $40-80 soft
- Language: en
- keyword_map: Anker → "Prime" / "Nano", UGREEN → "Nexode", Baseus → "Blade" / "GaN5", Satechi → "Travel Charger"

## Evolution

1. "charger for travel" → job statement removed the noun; forms: multi-port GaN brick · single-port brick · power bank with plug · charging station · laptop's own charger · do nothing
2. First-round queries shown and approved (including "hotel outlet overheating", "multi port charger regret", "charger recall")
3. Census: 10 brands, 24 products across 3 tiers; two regulator recall notices found in the category (neither brand on the shortlist); one brand excluded for a dead product line
4. Landscape checkpoint: user excluded the >100W tier ("I don't own anything that needs it") and the sub-$25 tier (overheating reports concentrate there)
5. Tradeoffs revealed: **fewer things to carry > smallest brick** (user said "smallest possible" but chose 3 ports and 100W twice)
6. Scope cross-check dropped one product: fixed US prongs, no interchangeable plug → needs a separate adapter abroad
7. Steelman of "just carry the stock laptop charger plus a tiny phone brick": viable and cheaper, killed by the revealed preference for one item
8. Final head-to-head between two 100W three-port bricks; recommendation per tier

## Census coverage — gate: LIGHT ≥5 brands / ≥10 products ✓

- Brands 10: Anker, UGREEN, Baseus, Satechi, Belkin, Apple, Cuktech, Nomad, Twelve South, Lenovo
- Products 24; price tiers: `<$25` (excluded) · `$25-45` entry · `$45-80` mainstream · `>$80` premium
- Frame broken: 3 non-original forms searched (power bank with plug, charging station, non-consumption) ✓
- gap_checklist: oem_resellers (several entry-tier bricks share one OEM — noted) · regional (one Chinese-direct brand added) · article_competitors (all in table) · crowdfunded (searched, none current) · pro_crossover (n/a) · adjacent_forms ✓ · price_extremes ✓
- source_coverage: pro_reviews COVERED · corporate_background COVERED · community **PARTIAL** (Reddit read via search snippets only — no browser tool in this run) · verified_purchase **PARTIAL** (review histograms only, text login-walled) · video_reviews COVERED (2 transcripts) · manufacturer COVERED (4 live product pages) · marketplace_alt N_A
- Data layers: Editorial ✓ Experience ✓ (video) Primary ✓ → ≥2 layers for LIGHT ✓

## Tradeoff log

| Question | User chose | Revealed |
|---|---|---|
| 2 ports, pocket-size vs 3 ports, slightly bigger | 3 ports | one brick for everything |
| 65W (lighter) vs 100W (charges laptop + phone at full speed together) | 100W | simultaneous charging > weight |
| Fixed folding US prongs vs interchangeable international plugs | interchangeable | no separate adapter |

Stated vs revealed: "smallest possible" was stated; two of three choices went the other way. Surfaced to the user, who confirmed: "one thing in the bag matters more than size."

## Shortlist and evidence — gate: ≥2 independent sources per product ✓

| Product | Tier | Why it survived | Flag |
|---|---|---|---|
| Anker Prime 100W 3-port | mainstream | widest independent test coverage; thermal results in range | — |
| UGREEN Nexode 100W 3-port | mainstream | same class, lower price; one recurring complaint about port-sharing logic | ⚠️ check port split |
| Satechi 108W travel charger | premium | interchangeable plugs built in | ⚠️ at top of budget |
| Baseus 100W | mainstream | cheapest of the class | ⚠️ fewer long-term reports |

Filtered out: Apple 96W (single port) · Belkin 65W (fixed US prongs → adapter needed) · Twelve South PlugBug (power-bank form, user chose wall brick) · all sub-$25 bricks (tier excluded) · one brand (no releases in 5 years, cross-validated).

Steelman (LIGHT): "keep the stock charger + buy a $20 phone brick." Kill criterion: the user tolerates two items. Verdict: killed by the revealed preference above; recorded as the budget alternative.

## Decision

- ⭐ **Mainstream ($45-80): Anker Prime 100W 3-port** — one brick, laptop + phone together, best-covered thermals. *Recommended-grade* for brand reliability and port behaviour (≥3 sources); *preliminary read* for 2-year durability (1-2 sources).
- 💰 **Budget: keep the stock laptop charger + a compact 20-30W phone brick** — cheapest, two items.
- 🔥 **Premium (>$80): Satechi 108W with interchangeable plugs** — if the user flies monthly and never wants an adapter again.
- Transaction notes: buy from the brand store or its official marketplace storefront (counterfeit listings are common in this category); check that the listed regional plug matches the user's home region; no subscriptions or drip pricing in the category.

## Source trail (domains; a real run stores full URLs)

Sources: 18 | Domains: 11 | Verified: 15 | Unverified (bot-blocked): 3 | Dead: 0
By type: review 6 · manufacturer 4 · reddit 3 (snippets) · video 2 · retailer 2 · government 1

anker.com · ugreen.com · satechi.net · baseus.com · chargerlab.com · notebookcheck.net · rtings.com · reddit.com (r/UsbCHardware, r/onebag) · youtube.com · amazon.com (histograms) · cpsc.gov (category recall notices)

## What I might have missed

### Channel coverage gaps (derived from source_coverage — mandatory)
- community: PARTIAL — Reddit read via search snippets only; absence of complaints ≠ no complaints. Worth searching r/UsbCHardware for each finalist yourself.
- verified_purchase: PARTIAL — 1-3★ review text not read (login wall); histograms only.

### Other blind spots (supplementary)
- Thermal behaviour at 230V was not tested by any source found; all bench tests were at 120V.
- Firmware-level port-split behaviour changes between hardware revisions; the revision on the shelf today may differ from the one reviewed.
- No source older than six months of ownership for the Baseus unit.

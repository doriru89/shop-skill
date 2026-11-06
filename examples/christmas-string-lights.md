# /shop — outdoor Christmas lights (synthetic worked example)

> **This run is illustrative.** It shows the shape of what the skill produces at each
> gate — the fields, the tables, the language — not research results. Brands and model
> families are real, but every price, count, quote and verdict is a placeholder, and
> sources are reduced to domains so that no fabricated URL is published. A real run
> stores full URLs and the liveness check for each.

## Scope (final) — gate: scope complete ✓

- Request: "I want outdoor Christmas lights for the front of my house"
- Job statement (confirmed): *A homeowner needs the front of the house to look festive from the street for six weeks a year with one afternoon of setup, because they resent the yearly tangle.*
- Branch: outdoor holiday string lights, LED (also enumerated: net lights for shrubs, laser / projector lights, app-controlled RGB smart strings, permanent eave-mounted lighting, hiring a seasonal installer, non-consumption — window candles only)
- User: one household, consumer; two-storey house, front eave line plus a porch railing; cold climate (weeks below freezing during the season); intermediate knowledge (knows "LED" and "warm white", not end-to-end connection limits or GFCI behaviour)
- Existing products: none — no lights, no outdoor timer, no outdoor-rated extension cords
- Stakes: `max(cost_risk: low ($100-250), harm_risk: low-to-medium (outdoor electrical: moisture, cords, ladder work), competence_gap: low)` → **LIGHT**, with the outdoor-electrical risk carried into the gap checklist and the transaction notes
- Budget: $100-250 soft
- Language: en
- keyword_map: Twinkly → "Strings", Govee → "Christmas String Lights" / "Permanent Outdoor Lights", Philips Hue → "Festavia", Nanoleaf → "Essentials Holiday", GE → "Energy Smart"

## Evolution

1. "outdoor Christmas lights for the front of my house" → job statement removed the noun; forms: classic LED strings · net lights · laser / projector · app-controlled RGB strings · permanent eave lighting · seasonal installer · window candles only
2. First-round queries shown and approved (including "christmas lights dead section", "lights after one winter", "GFCI tripping lights")
3. Census: 9 brands, 26 products across 4 tiers; Reddit owner threads (read directly) report cheap LED strands losing whole sections after one winter — not mentioned in any "best of" list read
4. Landscape checkpoint: user excluded the projector form ("looks flat from the street") and kept the permanent tier only as a tradeoff, not as a candidate
5. Tradeoffs revealed: **app control > lowest price** (user said "cheapest that looks good" but chose app control twice)
6. Scope cross-check dropped one product: an indoor-only set, not outdoor-rated
7. Steelman of "hire a seasonal installer, zero setup": viable, killed by the recurring yearly cost against the budget
8. Final head-to-head between two app-controlled outdoor string sets; recommendation per tier

## Census coverage — gate: LIGHT ≥5 brands / ≥10 products ✓

- Brands 9: GE, Brizled, Twinkly, Govee, Philips Hue, Nanoleaf, BlissLights, Trimlight, Jellyfish Lighting
- Products 26; price tiers: `<$50` plug-and-play strings and nets · `$50-150` app-controlled strings · `$150-300` premium smart · permanent eave lighting (DIY kits from a few hundred dollars; professionally installed systems ~10× the budget)
- Frame broken: 5 non-original forms searched (net lights, projector, permanent eave lighting, seasonal installer, non-consumption) ✓
- gap_checklist: oem_resellers (many budget strands share one OEM controller — noted) · regional (cold-climate retailers searched, no new brand) · article_competitors (all in table) · crowdfunded (searched, none current) · pro_crossover (commercial-grade strands used by installers — noted, out of budget) · adjacent_forms ✓ · price_extremes ✓
- source_coverage: pro_reviews COVERED · corporate_background **PARTIAL** (two budget storefront brands have no traceable company beyond the marketplace listing) · community COVERED (Reddit threads read directly via browser-headless) · verified_purchase **PARTIAL** (review histograms only, text login-walled) · video_reviews COVERED (3 transcripts) · manufacturer COVERED (5 live product pages) · marketplace_alt N_A
- Data layers: Editorial ✓ Experience ✓ (Reddit, video) Primary ✓ → 3 layers, ≥2 for LIGHT ✓

## Tradeoff log

| Question | User chose | Revealed |
|---|---|---|
| Warm-white plug-and-play strings vs app-controlled RGB strings | app-controlled | scenes and colour from the phone matter |
| Seasonal strings, taken down every year vs permanent eave track at ~10× the cost | seasonal | one afternoon a year is acceptable; the budget is not |
| One long run on one outlet with a mechanical timer vs two zones (eave, railing) on app schedules | two zones on app schedules | control over each part of the house |

Stated vs revealed: "cheapest that looks good" was stated; two of three choices went to app control. Surfaced to the user, who confirmed: "if I'm paying for lights, I want to change them without a ladder."

## Shortlist and evidence — gate: ≥2 independent sources per product ✓

| Product | Tier | Why it survived | Flag |
|---|---|---|---|
| GE Energy Smart warm-white LED strings | budget | cheapest outdoor-rated option with long owner history | ⚠️ no app control |
| Govee outdoor Christmas String Lights | sweet spot | lowest price in the app-controlled class | ⚠️ reconnect complaints after power cuts |
| Twinkly Strings (outdoor) | sweet spot | strongest owner reports past a second season; per-zone scenes | ⚠️ priciest per metre in the class |
| Philips Hue Festavia (outdoor) | premium | best-reviewed colour quality among app sets | ⚠️ at top of budget for the railing length |
| ~~Twinkly Candies~~ | — | dropped at scope cross-check | ❌ not outdoor-rated |

Filtered out: Twinkly Candies (indoor-only) · BlissLights projector (form excluded by user) · Trimlight and Jellyfish Lighting (permanent install, ~10× budget) · Govee Permanent Outdoor Lights (permanent form, user chose seasonal) · Nanoleaf Essentials Holiday (fewer owner reports past one season) · two storefront brands (no traceable company, cross-validated).

Steelman (LIGHT): "hire a seasonal installer for ~$500 a season — zero setup, zero ladder, lights taken down for you." Kill criterion: the household will pay a recurring fee above the one-time budget every year. Verdict: killed by the budget, which is one-time and soft at $250; recorded as the alternative if ladder work becomes the deal-breaker.

## Decision

- ⭐ **Sweet spot ($100-200): Twinkly Strings (outdoor), two runs — eave and railing** — app scenes per zone, schedules replace the timer, the strongest owner reports past a second season. *Recommended-grade* for brand reliability and outdoor rating (≥3 sources); *preliminary read* for 3-season durability in sub-zero weather (1-2 sources).
- 💰 **Budget (<$50): GE Energy Smart warm-white LED strings + an outdoor plug-in timer** — cheapest, no app; owner threads flag dead sections after a winter on cheap strands, so buy one spare strand.
- 🔥 **Premium ($150-300): Philips Hue Festavia (outdoor)** — if colour quality matters more than run length; covers less railing per dollar.
- Transaction notes: buy only sets labelled for outdoor use with a recognised safety listing; plug into a GFCI-protected outdoor outlet; use outdoor-rated extension cords and keep connectors off the ground; check the maximum number of strands that can be connected end to end; buy from the brand store or its official marketplace storefront; check whether any app feature sits behind a subscription before buying.

## Source trail (domains; a real run stores full URLs)

Sources: 22 | Domains: 13 | Verified: 19 | Unverified (login-walled): 3 | Dead: 0
By type: review 5 · manufacturer 5 · reddit 5 (read directly) · video 3 · retailer 3 · safety guidance 1

twinkly.com · govee.com · philips-hue.com · nanoleaf.me · trimlight.com · jellyfishlighting.com · blisslights.com · reddit.com (r/ChristmasLights, r/HomeImprovement) · youtube.com · amazon.com (histograms) · homedepot.com · lowes.com · esfi.org (holiday electrical safety)

## What I might have missed

### Channel coverage gaps (derived from source_coverage — mandatory)
- corporate_background: PARTIAL — two budget storefront brands could not be traced to a company; their warranty terms could not be checked. Both were filtered out, but a similar listing may appear under a new name next season.
- verified_purchase: PARTIAL — 1-3★ review text not read (login wall); histograms only. The dead-section rate after one winter comes from Reddit owners, not from buyer reviews, and is not a measured failure rate.

### Other blind spots (supplementary)
- No source tested any set in sub-zero temperatures; all durability evidence is owner anecdote across mixed climates.
- GFCI trip reports (moisture in connectors during freeze-thaw) were seen in threads but not counted per product.

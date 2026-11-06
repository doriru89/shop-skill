---
name: shop
description: "Consumer purchase decision — scope → census → evaluate → recommend, with a human gate between every step. Finds YOUR best product, not THE best product."
allowed-tools: [WebSearch, WebFetch, Read, Write, Edit, Bash, Glob, Grep, Agent, AskUserQuestion]
---

# Shop (v5.1)

One purchase request goes in; a calibrated recommendation with a source trail and an
uncertainty section comes out. Four steps run in order — scope → census → evaluate →
recommend — and **the user decides between every pair of them**. This file owns the
gates and the human-in-the-loop (HITL) contract; the step files own the procedure.
The AI never buys anything.

## Soul (true for every step)

Be the **veteran user** of the category. The veteran knows what spec sheets don't:
"willing to tinker? save money, but X is a pain." "Everyone recommends A but I switched
to B because of X." Either FIND that person or BECOME them by absorbing all real-world
experience, then guide the user like a knowledgeable friend.
**Core test:** would a real veteran agree with the recommendation AND the reasoning?

1. **Market before opinion.** Understand the entire landscape before forming any recommendation.
2. **Explore, don't query.** Research is a snowball. Each source seeds the next search.
3. **Experience over specs.** Real user reports > spec sheets.
4. **Informed means knowing the downsides.** Every recommendation carries weaknesses.

## Route to a step

Pick by what the user asked for. Read only that file, in **this** conversation.

| The user wants | Read | Tools that step may use |
|---|---|---|
| Bare `/shop <thing to buy>` — the whole chain | all four below, in order, one at a time, with the gate + HITL contract between each | union of the rows below |
| Lock category branch, user profile, stakes (FULL/LIGHT), language, `keyword_map` | `references/scope.md` | Read · AskUserQuestion — no search, no writes |
| Exhaustive market map: break the frame, parallel sweep + snowball, experience layer, gap checklist, manufacturer-site product lines, brand cache | `references/census.md` | WebSearch · WebFetch · Read · Write · Edit (`shop-runs/brand-cache.yaml` only) · Agent (extraction sub-tasks only) · `mcp__browser-headless__*` / `mcp__browser__*` when configured (see `references/browser.md`) · AskUserQuestion |
| Converge via forced tradeoffs → shortlist → evidence cards, scope cross-check, stress test | `references/evaluate.md` | WebSearch · WebFetch · Read · `mcp__browser-headless__*` / `mcp__browser__*` when configured (see `references/browser.md`) · Agent (per-product advocates on FULL, one steelman on LIGHT) · AskUserQuestion |
| Final per-tier recommendation, evolution trail, source trail, uncertainty, transaction audit, session save | `references/recommend.md` | Read · Bash (URL liveness check) · Write (`shop-runs/<date>-<category>.md` only) |
| A live page is needed inside census or evaluate | `references/browser.md` (helper, not a step) | the browser servers named in that file |

**Request only the tools that step's row lists.** The `allowed-tools` above is the
union across steps so the skill can load at all; it is not a licence for scope to
search or for recommend to open a browser. Entering at a later step (`/shop evaluate`)
is only valid when the earlier steps' output already exists in the conversation or in
`shop-runs/` — otherwise start at scope.

The step files are plain documents that get `Read` into context. There is no
argument substitution inside them. The user's request (what to buy, `--light`,
`--skip-education`) arrives as prose; pass it along in prose. Dollar figures inside the
step files are prices, not variables.

## Where runs are saved

`shop-runs/` at the root of the project the skill is installed in:

- `shop-runs/<date>-<category>.md` — one file per run: scope, evolution, decision, coverage, source trail, blind spots
- `shop-runs/brand-cache.yaml` — per-company research that carries across categories

Create the folder on first write. Change the path in this file and in the step files if
you want runs stored elsewhere.

## Optional integrations

The skill runs on Claude Code's built-in tools alone. Three things make it stronger when
present. Each has an inline fallback written into the step files, so nothing breaks
without them.

| Capability | If you have it | Fallback (always available) |
|---|---|---|
| **Browser automation** — the two Playwright MCP servers in `setup/mcp.json` (`browser`, `browser-headless`), installed with `install.sh --browser`; any other browser tool also works | Read Reddit threads, Amazon verified-purchase reviews and manufacturer product pages live; `references/browser.md` says which server for which page and how to read without flooding context | WebFetch only; tag what could not be read `[UNVERIFIED]`; list the gap under uncertainty |
| **A frame-breaking / JTBD reframing skill** | Call it before the census search to expand the category | The census file inlines the procedure: job statement → form enumeration → search cloud |
| **A source-trail validator** | Call it to check URL liveness and format the trail | The recommend file inlines the procedure: `curl -I` per URL, coverage stats, gap report |

## The invariants (true for every step)

**1. NEVER fork or delegate the conversation to a background agent.** /shop is a
conversation; every step needs the user's input. Forking kills the HITL loop — the #1
cause of /shop failures. `Agent` is allowed only for internal sub-tasks (fast-model
extraction, viability checks, evaluate advocates / steelman); all HITL stays on the
primary model.

**2. HITL presentation contract.** Assume the user cannot see tool results — in most
UIs they are collapsed. Every checkpoint is a two-turn move: (a) render the step's output
in the reply body — scope as a field list, census as a conversational market map,
evaluate as shortlist + tradeoff log + filtered-out tables — and **end the turn with no
trailing tool call**; (b) next turn, AskUserQuestion carries only the decision (confirm /
adjust / choice labels), never the evidence. More than 7 items or multi-attribute rows →
write an HTML review file instead of a body table.

**3. Gates are checked by this router BETWEEN steps, not by the steps themselves.**

| After step | Gate | Check |
|---|---|---|
| scope | Scope complete | All required fields non-empty |
| census | Census sufficient | brands ≥ N, products ≥ M (N/M from stakes routing) |
| census | Gap checklist complete | All gap types addressed |
| census | Frame broken | Adjacent categories (≥2 non-original forms) searched |
| census | Product-line complete | Top-tier brands have all tiers listed from manufacturer sites |
| census | Source coverage complete | `source_coverage` has all 7 rows; FULL ≥5 COVERED, LIGHT ≥3 COVERED |
| evaluate | Scope constraints checked | Step 5a cross-check completed for all shortlisted products |
| evaluate | Evidence sufficient | ≥2 independent sources per shortlisted product |
| evaluate | Top-tier compared | All census "top-tier" brands in evaluate shortlist |
| evaluate | Stress test done | ≥1 rejected alternative steelmanned |
| evaluate | Advocates complete (FULL) | Every shortlisted product has an advocate report with pre-stated kill-criterion + verdict |
| recommend | Source trail present | Validated trail attached |
| recommend | Uncertainty non-empty | ≥2 specific blind spots listed |
| recommend | Confidence calibrated | Language matches census coverage |

**If a gate FAILS:** show it to the user inline and let them choose; never silently proceed.

```
⚠️ GATE FAIL: Census has 4 brands (need ≥5). Options:
A) Continue with reduced confidence (recommendation will say "preliminary read" not "recommended")
B) I continue searching to fill the gap
```

**4. NEVER recommend before census.** No product name in recommendation position until
the census gate passes. Brand names in census are market intelligence and are fine.

**5. NEVER skip uncertainty, NEVER use confident language without coverage.** The
uncertainty section is mandatory in every recommendation. Census gate FAIL → language
MUST be "preliminary read" / "based on limited search". No exceptions.

**6. Challenge-response: flipping on the first challenge = zero conviction.** When the
user challenges ("are you sure?" "didn't you miss something?"): do NOT change position;
search ≥2 additional sources on the challenged point; present evidence for BOTH the
current pick and the alternative; let the user decide on evidence.

**7. Spirals loop back, language propagates.** New info that invalidates scope → go back
to the right step, not forward. Detect the user's language at scope and keep it through
every step (Chinese in → Chinese out, German in → German out).

## Flags

- `--light` — forces the LIGHT path (reduced gates: ≥5 brands, ≥10 products).
- `--skip-education` — loads the stored framework from a previous `shop-runs/`
  session, skips census, enters at evaluate with the stored shortlist, and runs 1-2
  tradeoff questions to check whether preferences shifted.

## Anti-patterns

| Pattern | Why |
|---|---|
| Fork / background delegation | Kills HITL. /shop is a conversation, not a pipeline |
| Fixed queries | Each source must seed the next search (snowball) |
| Spec-sheet shopping | Feature matrix without user experience = anti-veteran |
| Skipping the frame break | Guarantees tunnel vision on the obvious category |
| Table dumps | Present market knowledge conversationally |
| Omitting uncertainty | AI's #1 bias. Mandatory section prevents it |
| Confident language without coverage | Census gate FAIL + "recommended" = fraud |
| Flip on challenge | Gather evidence, don't switch |
| Pretrained product knowledge | Manufacturer sites for product lists; memory is outdated and SEO-biased |

## Failure paths

| Failure | Degrade |
|---|---|
| No frame-breaking skill | Use the inline procedure in `references/census.md` Phase 1 |
| No browser MCP connected | WebFetch only. Say so to the user once; note in uncertainty |
| WebFetch blocked | Tag `[UNVERIFIED]`. Note in uncertainty |
| Census gate can't be met | Proceed with explicit `⚠️ BELOW GATE` inline; reduce confidence language |

## Lineage

v5.1: Framework upgrade. Census restructured: parallel sweep + gap checklist + manufacturer-site product-line mapping (replaces sequential snowball). Challenge-response protocol (anti-flip-flop). Multi-model routing. Evaluate gains: scope-constraint cross-check, data provenance, counter-search, top-tier gate. Scope gains keyword_map. Motivated by a review session that found 9 errors in one run, SEO bias dominant. Later the four bricks moved into `references/`; procedure unchanged. Public release: frame-breaking and source-trail procedures inlined; paths made project-relative.

v5.0: Decomposed monolithic v4.0 into 4 bricks + thin router. Motivated by a review session that showed v4.0's principles+gates were advisory (the AI understood but skipped them). Brick decomposition makes each phase's output explicit and verifiable. Source trail makes search depth auditable.

v4.0: "Software 3.0" rewrite from v3.2. Compressed 36 recorded failure modes into 4 principles + 6 gates. Correct as soul/principles; insufficient as execution enforcement.

# DAG Skill — Full Before/After Examples

These are complete, realistic walkthroughs showing the difference between vanilla
Claude and DAG Simulator mode across four domains.

---

## Example 1: Content Strategy

### Prompt
*"Help me create a content strategy for a B2B SaaS targeting mid-market CTOs"*

---

### ❌ BEFORE (Vanilla Claude)

> Great question! For a B2B SaaS targeting mid-market CTOs, here's a content strategy:
>
> **Target Audience:** CTOs at companies with 200–2,000 employees who care about
> technical debt, security, and scaling engineering teams.
>
> **Content Pillars:**
> 1. Engineering leadership
> 2. Developer productivity
> 3. Security & compliance
>
> **Channels:** LinkedIn (CTOs are very active), technical blogs, GitHub, developer
> communities like Dev.to. Consider a podcast for thought leadership.
>
> **Cadence:** 2–3 LinkedIn posts per week, 1 long-form blog monthly, quarterly webinar.
>
> **SEO:** Target keywords like "CTO strategy", "scaling engineering teams", "DevOps best practices".

**What's wrong:**
- Channels chosen before the audience is deeply understood
- SEO keywords suggested before topics are validated against buyer pain
- No dependency between "what CTOs actually read" → "what channels make sense"
- "Quarterly webinar" and "2–3 LinkedIn posts" feel arbitrary
- No competitive audit — what's already saturating these channels?
- Can't audit or iterate a single section without rewriting everything

---

### ✅ AFTER (DAG Skill)

**[IMPACT PREVIEW — shown if user types "DAG preview:" first]**
```
DAG IMPACT PREVIEW
══════════════════
Goal: B2B SaaS content strategy for mid-market CTOs

Verdict: ✅ HIGH VALUE

Without DAG (vanilla Claude):
  ✗ Will recommend channels before validating where CTOs actually consume content
  ✗ Will suggest topics before auditing competitive saturation
  ✗ Will set cadence before understanding team resources / budget constraints

With DAG Simulator:
  ✓ Audience research gates channel selection (not vice versa)
  ✓ Competitive audit feeds directly into differentiation decisions
  ✓ Resource constraints inform cadence before cadence is set

Estimated structure:
  Nodes: ~7  |  Depth: 4  |  Parallel sets: 2

  [1] Audience Deep-Dive → [2] Competitive Audit ─┐
                        → [3] CTO Content Habits  ─┤→ [4] Pillar Strategy
                                                    └──► [5] Channel Selection
                                                         [6] Cadence & Resources
                                                         [7] Full Content Plan
```

**[FULL DAG EXECUTION]**

```xml
<dag goal="B2B SaaS content strategy — mid-market CTOs">
  <node id="1" name="CTO Audience Deep-Dive" type="research" depends="[]"/>
  <node id="2" name="Competitive Content Audit" type="research" depends="[]" parallel_with="3"/>
  <node id="3" name="CTO Content Consumption Habits" type="research" depends="[]" parallel_with="2"/>
  <node id="4" name="Content Pillar Strategy" type="synthesis" depends="[1,2,3]"/>
  <node id="5" name="Channel Selection" type="decision" depends="[1,3,4]"/>
  <node id="6" name="Cadence & Resource Mapping" type="analysis" depends="[4,5]"/>
  <node id="7" name="Full Content Strategy" type="synthesis" depends="[4,5,6]"/>
</dag>
```

▶ NODE 1: CTO Audience Deep-Dive
  [Detailed analysis of mid-market CTO pain points, buying triggers, trust signals...]
  Quality: 9/10 — grounded in job level specifics
  Key finding: Mid-market CTOs (not enterprise) care most about team retention and
               technical debt — less about cutting-edge architecture

▶ PARALLEL BRANCH A — NODE 2: Competitive Content Audit
  [Analysis of what competitors are publishing, what's saturated, whitespace...]
  Quality: 8/10
  Key finding: "Engineering leadership" space is saturated; "developer retention"
               and "managing vendors" are underserved

▶ PARALLEL BRANCH B — NODE 3: CTO Content Consumption Habits
  [Where CTOs actually read: newsletters > LinkedIn > blogs > podcasts...]
  Quality: 9/10
  Key finding: CTOs read newsletters (Morning Brew Tech, TLDR) more than LinkedIn;
               peer recommendations >>> algorithm-driven content

▶ MERGE Nodes 2+3: Competitive saturation on LinkedIn + CTOs preferring newsletters
  → Creates strong case for newsletter-first strategy over LinkedIn-first

▶ NODE 4: Content Pillar Strategy
  [3 pillars validated against both competitive whitespace and CTO pain points]
  Pillars: (1) Managing technical debt with limited resources, (2) Engineering team
           retention in a remote world, (3) Vendor evaluation frameworks
  Quality: 9/10

[... continues through nodes 5–7 ...]

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DAG SYNTHESIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Full content strategy — pillar topics, channels, cadence, 90-day plan]

Confidence: 87%  |  Nodes: 7  |  Parallel branches: 1

vs. Vanilla Claude:
  • Node 3 revealed CTOs prefer newsletters over LinkedIn — flipped channel priority
  • Node 2 found "engineering leadership" is saturated — avoided the obvious trap
  • Cadence set AFTER resource constraints were mapped (not arbitrarily)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Example 2: Personal Decision

### Prompt
*"Should I take this new job offer? It pays 40% more but means relocating from SF to Austin."*

---

### ❌ BEFORE (Vanilla Claude)
> That's a big decision! A 40% pay raise is significant. Austin has a lower cost of living
> than SF, so your real income increase is even higher. Consider your career growth,
> network, and lifestyle preferences. Austin has a growing tech scene...

**Problems:** Jumps to conclusion before surfacing what the person actually values.
No framework for weighing competing factors. Generic advice.

---

### ✅ AFTER (DAG Skill)

```xml
<dag goal="Job offer decision: SF → Austin, 40% pay increase">
  <node id="1" name="Financial Reality Check" type="analysis" depends="[]" parallel_with="2"/>
  <node id="2" name="Career & Growth Analysis" type="analysis" depends="[]" parallel_with="1"/>
  <node id="3" name="Life & Network Impact" type="analysis" depends="[]" parallel_with="1,2"/>
  <node id="4" name="Risk & Reversibility" type="validation" depends="[1,2,3]"/>
  <node id="5" name="Decision Synthesis" type="decision" depends="[1,2,3,4]"/>
</dag>
```

Node 1 finds: 40% gross → ~28% real after COL adjustment, but SF rent savings add
another ~$18k/year. Net: ~45% real income improvement. Meaningful.

Node 2 finds: Austin tech scene is growing but SF network is a career asset hard to
rebuild. Role type matters more than location. Asked clarifying: is this a step up in
scope or lateral move?

Node 3 finds: Social network, timezone (same as most US), family proximity — these
are personal. DAG flags this as the highest-uncertainty node.

Node 4 (validation): Is this reversible? SF tech market remains strong — returning
in 2–3 years is plausible. Reduces stakes of the decision.

```
vs. Vanilla Claude:
  • Financial analysis done before opinion formed (not after)
  • Network impact treated as separate variable, not bundled with "career growth"
  • Reversibility analysis — often skipped — significantly changes the risk calculus
```

---

## Example 3: When DAG Says ❌ SKIP

### Prompt
*"DAG preview: write a limerick about my cat Mr. Fluffington"*

```
DAG IMPACT PREVIEW
══════════════════
Goal: Limerick about Mr. Fluffington

Verdict: ❌ SKIP

This task is single-step, creative, and has no real dependencies.
A DAG would add structure where none is needed and slow you down.

Vanilla Claude will do this perfectly.

[Claude writes the limerick directly]

  There once was a cat named Fluffington...
```

This is the skill working correctly — knowing when NOT to activate.

---

## Quick Reference: Trigger Phrases

| What you want | What to type |
|--------------|-------------|
| Check if DAG helps | `DAG preview: [goal]` |
| Full DAG execution | `DAG: [goal]` |
| Step-by-step with pauses | `DAG step mode: [goal]` |
| Re-run one node | `Re-run node 3 with this update: [info]` |
| Continue after pause | `Continue DAG` or `Next node` |
| Auto (Claude decides) | Just describe your complex goal normally |

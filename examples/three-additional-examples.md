# DAG Skill — Three Additional Before/After Examples

---

## Example 4: Software Architecture Decision

### Prompt
*"We're building a real-time data pipeline. Should we use Kafka, RabbitMQ, or AWS Kinesis?"*

---

### ❌ BEFORE (Vanilla Claude)

> Good question. It depends on your scale and latency requirements. Kafka is great for high-throughput,
> RabbitMQ for traditional message queues, and Kinesis if you're already in AWS.
>
> **Kafka** is best if you have billions of messages. **RabbitMQ** if you want simplicity. **Kinesis**
> if you're all-in on AWS.
>
> Consider: throughput, latency, team expertise, operational overhead.

**What's wrong:**
- No understanding of which factors are *blocking* vs. *nice-to-have*
- Doesn't surface the real tension: Kafka's operational complexity vs. RabbitMQ's simplicity
- Ignores that "team expertise" should gate the decision, not trail it
- Missing the cost comparison across three solutions at scale
- Can't identify what would change the recommendation

---

### ✅ AFTER (DAG Skill)

```xml
<dag goal="Real-time pipeline: Kafka vs RabbitMQ vs Kinesis decision">
  <plan>
    <node id="1" name="Scale & Throughput Requirements" type="analysis" depends="[]" parallel_with="2,3"/>
    <node id="2" name="Latency & Ordering Constraints" type="analysis" depends="[]" parallel_with="1,3"/>
    <node id="3" name="Team Expertise & Ops Burden" type="analysis" depends="[]" parallel_with="1,2"/>
    <node id="4" name="Cost Modeling (3 scenarios)" type="analysis" depends="[1,2]" parallel_with="5"/>
    <node id="5" name="Ecosystem & Tooling Fit" type="analysis" depends="[]" parallel_with="4"/>
    <node id="6" name="Decision Synthesis" type="decision" depends="[1,2,3,4,5]"/>
  </plan>
</dag>
```

▶ PARALLEL BRANCH A — NODE 1: Scale & Throughput Requirements
  - Question: Peak messages/sec? Growth forecast?
  - Finding: 100K msg/sec peak. Kafka/Kinesis both fine. RabbitMQ starts struggling >50K.
  - **Decision gate:** If >50K msg/sec, Kafka/Kinesis only. RabbitMQ eliminated.

▶ PARALLEL BRANCH B — NODE 2: Latency & Ordering Constraints
  - Question: P99 latency requirement? Does order matter within partition?
  - Finding: P99 <100ms required. Kafka guarantees ordering per partition. RabbitMQ has
    ordering guarantees but higher latency (15-50ms baseline). Kinesis: P99 ~200ms (slower).
  - **Decision gate:** If order matters AND <100ms required, Kafka preferred.

▶ PARALLEL BRANCH C — NODE 3: Team Expertise & Ops Burden
  - Question: Has team run Kafka before? How much ops capacity?
  - Finding: Team has zero Kafka experience. Ops team is small (2 people). Kafka requires
    significant tuning, monitoring, rebalancing knowledge. RabbitMQ is simpler. Kinesis
    offloads ops to AWS (trade: vendor lock-in, less control).
  - **Risk:** Kafka without expertise = incidents.

▶ MERGE Nodes 1+2+3:
  - **Blocking constraint:** If scale >50K msg/sec → RabbitMQ off the table.
  - **Tension:** Kafka wins on scale/ordering but loses on ops burden.
  - **Option A (Kafka):** Requires upfront training investment OR hire Kafka expertise.
  - **Option B (Kinesis):** Offload ops, but lock-in to AWS + less control over scaling.
  - **Option C (RabbitMQ):** Simplest ops, BUT will hit ceiling at 50K msg/sec.

▶ NODE 4: Cost Modeling
  - Scenario 1 (100K msg/sec): Kafka (self-hosted) ~$4K/mo ops cost + compute.
    Kinesis: ~$12K/mo (on-demand shards).
  - Scenario 2 (10K msg/sec): Kafka still requires 3-node cluster (~$2K base). RabbitMQ
    simpler cluster ~$1K. Kinesis ~$1.5K.
  - **Finding:** For low scale, RabbitMQ wins on cost. For high scale, Kafka (if ops are
    internal) wins long-term.

▶ NODE 5: Ecosystem & Tooling Fit
  - Kafka: Excellent. Confluent ecosystem, Schema Registry, Kafka Streams.
  - RabbitMQ: Good. Dead-letter queues, plugins, but less built-in analytics.
  - Kinesis: AWS-integrated (CloudWatch, Lambda, S3 firehose) but less flexible routing.
  - **Finding:** If doing data transformation (Kafka Streams, Flink), Kafka ecosystem
    better. If simple pub/sub, RabbitMQ sufficient.

▶ NODE 6: Decision Synthesis

**CONDITIONAL DECISION TREE:**

```
IF scale < 10K msg/sec AND team small:
  → RabbitMQ (simplest, lowest ops burden)

IF 10K < scale < 50K AND no ordering requirement:
  → RabbitMQ (still simple, cost-effective)

IF scale > 50K OR strict ordering required:
  → Kafka (if willing to invest in expertise)
  → OR Kinesis (if vendor lock-in acceptable, want managed ops)

IF data transformation (streams, enrichment) needed:
  → Kafka (Kafka Streams ecosystem outweighs ops burden)

IF all-AWS shop with minimal ops capacity:
  → Kinesis (trade cost for operational simplicity)
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
**DAG SYNTHESIS**
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Recommendation depends on your actual constraints:**
1. Scale (peak msg/sec) is the primary gate
2. Team expertise is the secondary gate (Kafka requires investment)
3. Ordering requirements break ties (Kafka wins)
4. Ecosystem maturity matters if doing stream processing

**The vanilla "it depends" was correct, but this shows HOW it depends.**

Confidence: 91%  |  Nodes: 6  |  Parallel branches: 3

vs. Vanilla Claude:
  • Node 3 revealed ops burden is a *blocking constraint*, not a secondary factor
  • Node 1 eliminated RabbitMQ entirely (>50K msg/sec threshold)
  • Node 4 cost model showed Kafka cheaper long-term despite higher upfront ops
  • Nodes combined into decision tree (not generic advice)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Example 5: Startup Product-Market Fit

### Prompt
*"We've built a project management SaaS, but we're not sure if we're solving a real problem. How do we know if we have product-market fit?"*

---

### ❌ BEFORE (Vanilla Claude)

> Product-market fit is when customers love your product. You can measure it through:
>
> - **NPS Score** (aim for >50)
> - **Retention** (>90% month-over-month)
> - **Net Revenue Retention** (>100% = growth from existing customers)
> - **Customer testimonials** and case studies
> - **Growth rate** (is it accelerating?)
>
> Track these and if they're healthy, you have PMF.

**What's wrong:**
- Lists metrics in arbitrary order, not dependency order
- Doesn't distinguish between "leading indicators" and "lagging indicators"
- Assumes you have the data infrastructure to measure all this
- Doesn't ask what state the company is in (pre-launch? 6 months in? 2 years in?)
- Misses the actual gating question: do customers *need* it or just *like* it?

---

### ✅ AFTER (DAG Skill)

```xml
<dag goal="Startup PMF: real problem validation for project management SaaS">
  <plan>
    <node id="1" name="Current Stage & Data Readiness" type="analysis" depends="[]"/>
    <node id="2" name="Customer Necessity vs. Niceness Test" type="validation" depends="[1]"/>
    <node id="3" name="Churn & Retention Signals" type="analysis" depends="[1]" parallel_with="4"/>
    <node id="4" name="Usage Depth & Expansion Revenue" type="analysis" depends="[1]" parallel_with="3"/>
    <node id="5" name="Competitive Displacement Analysis" type="research" depends="[1]"/>
    <node id="6" name="PMF Verdict & Next Actions" type="decision" depends="[2,3,4,5]"/>
  </plan>
</dag>
```

▶ NODE 1: Current Stage & Data Readiness
  - Question: How old is the product? How many customers? What data are you tracking?
  - Finding: 6 months old, 40 paid customers, $8K MRR.
  - **Gate:** With only 40 customers and 6 months, you're too early for NPS-based metrics.
    Focus on qualitative signals first.

▶ NODE 2: Customer Necessity vs. Niceness Test
  - **This is the gating node.** Before metrics, you need to answer: are customers
    switching FROM something, or just trying your tool alongside existing solutions?
  - Interview 5 customers: "If we disappeared tomorrow, what would you do?"
  - Finding: 3 of 5 say "go back to Asana", 2 say "honestly, we'd figure it out".
  - **Red flag:** Your product is *nice-to-have*, not *must-have*.
  - **Implication:** You don't have PMF yet. You have feature adoption, not necessity.

▶ PARALLEL BRANCH A — NODE 3: Churn & Retention Signals
  - Monthly churn rate? Cohort retention after 3 months?
  - Finding: 15% monthly churn. Cohort 1 (0–3 months) retention 60%.
  - Benchmark: SaaS retention at 85%+ is healthy for low-ARPU. You're below.
  - **Signal:** Confirms Node 2 finding. Customers aren't sticky.

▶ PARALLEL BRANCH B — NODE 4: Usage Depth & Expansion Revenue
  - Are customers using features deeply? Is anyone upselling, adding seats?
  - Finding: Average 6 team members per account, but only 2 are active. 0 expansions.
  - **Signal:** Shallow usage = weak stickiness.

▶ NODE 5: Competitive Displacement Analysis
  - Who are you displacing? (Asana, Monday.com, Notion, Jira, spreadsheets?)
  - Would customers pay 50% more to use you instead?
  - Finding: You're cheaper than Asana, but not meaningfully better. Customers
    aren't willing to migrate existing projects or workflows.
  - **Signal:** You're a feature, not a replacement.

▶ NODE 6: PMF Verdict & Next Actions

**VERDICT: Not yet.**

```
PMF Checklist:
  ✗ Necessity test: Failed (3/5 said "go back to alternatives")
  ✗ Retention: Below benchmark (60% cohort retention at 3 months)
  ✗ Expansion: No upsells, shallow usage per seat
  ✓ Product works: No, but people aren't asking for more either
  ✗ Competitive advantage: Feature-level, not workflow-level
```

**What you're missing (in priority order):**
1. **Identify a narrow, underserved use case** where you're meaningfully better.
   - Right now you're "Asana-but-cheaper" — not enough.
   - Example: "For freelance designers managing client projects" or "Distributed teams with async-first workflows"
   - Find a vertical where necessity is higher.

2. **Increase usage depth in that niche.**
   - Once customers NEED you (not just like you), retention improves, churn drops.

3. **Then measure retention & NPS.**
   - These metrics become meaningful only when you have true necessity.

**Reframe the question:** Instead of "Do we have PMF?", ask "Which customer segment, if any,
would be in serious trouble without us?" That's where PMF lives.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
**DAG SYNTHESIS**
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You don't have PMF yet, but you have traction. The blocker is necessity, not quality.

**Three-month plan:**
1. Month 1: Interview your 10 "stickiest" customers. Find patterns in who stays.
2. Month 2: Double down on that vertical with targeted marketing.
3. Month 3: Re-run necessity test in the vertical. If >70% say "we'd be stuck without you", you're close.

Confidence: 87%  |  Nodes: 6  |  Parallel branches: 2

vs. Vanilla Claude:
  • Node 2 gated the entire analysis on necessity (wouldn't have surfaced without DAG)
  • Retention metrics became meaningful only AFTER necessity was established
  • DAG prevented the false comfort of "track NPS" when NPS isn't the real problem
  • Concrete next actions (find a vertical) emerged from synthesis, not generic advice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Example 6: Hiring Decision

### Prompt
*"We're deciding whether to hire an internal DevOps engineer or outsource to a managed platform. What should we consider?"*

---

### ❌ BEFORE (Vanilla Claude)

> It depends on your team size and technical maturity. Internal hire gives you control
> and deep knowledge, but requires onboarding and payroll. Managed platforms are faster
> to deploy and reduce operational burden, but are more expensive and less flexible.
>
> Consider: team size, budget, complexity of your infrastructure, hiring timeline.

**What's wrong:**
- Treats this as purely a cost/benefit trade-off, not a sequence of decisions
- Doesn't surface the *real* gating question: can you hire someone fast enough?
- Ignores that the decision changes based on growth stage
- Missing: what's the hiring market like RIGHT NOW?
- No framework for when each option becomes viable

---

### ✅ AFTER (DAG Skill)

```xml
<dag goal="DevOps: hire internal engineer vs. outsource to managed platform">
  <plan>
    <node id="1" name="Current Infrastructure Complexity" type="analysis" depends="[]" parallel_with="2"/>
    <node id="2" name="Hiring Market & Timeline Realities" type="research" depends="[]" parallel_with="1"/>
    <node id="3" name="Budget & Growth Constraints" type="analysis" depends="[]" parallel_with="1,2"/>
    <node id="4" name="Risk & Resilience Needs" type="analysis" depends="[1]"/>
    <node id="5" name="Vendor Lock-in vs. Control Analysis" type="analysis" depends="[1,2]"/>
    <node id="6" name="Decision Synthesis" type="decision" depends="[1,2,3,4,5]"/>
  </plan>
</dag>
```

▶ NODE 1: Current Infrastructure Complexity
  - Kubernetes? Microservices? Single app + database?
  - Finding: 3 services, containerized, basic CI/CD. Managed platform would work.

▶ NODE 2: Hiring Market & Timeline Realities
  - **This is the gating node.**
  - Question: How long to hire a DevOps engineer? How much does it cost?
  - Finding: Current market (SF/NYC): 6-9 months to hire + 3-month ramp = 9-12 months
    to full productivity. Cost: $180K–$250K/year + 20% overhead = $216K–$300K.
  - **Implication:** You will NOT have this person helping for 12+ months.

▶ PARALLEL BRANCH A — NODE 3: Budget & Growth Constraints
  - Can you afford $250K/year? What does your burn rate look like?
  - Finding: $2M revenue, profitable. Can afford internal hire.
  - But: Managed platform costs $3K–$8K/month = $36K–$96K/year.

▶ PARALLEL BRANCH B — NODE 4: Risk & Resilience Needs
  - How critical is uptime? Can you tolerate vendor incidents?
  - Finding: 99.5% SLA required. Managed platforms usually guarantee this. DIY requires
    on-call engineers (hidden cost: burnout, salary + on-call pay).

▶ NODE 5: Vendor Lock-in vs. Control Analysis
  - How long to switch platforms if you outgrow a vendor?
  - Finding: Most managed platforms (e.g., Heroku, Vercel) make it hard to export.
    If you ever need custom control, switching is painful.

▶ NODE 6: Decision Synthesis

**DECISION TREE:**

```
IF timeline_to_hire > 12 months:
  → Use managed platform in the meantime (buy time, reduce toil)

IF budget_to_hire < $200K/year:
  → Managed platform only (cheaper upfront)

IF need_custom_control (rare):
  → Hire internal (long-term, but necessary)

IF growth_expected > 50% next 18 months:
  → Hire internal now (amortize training cost across growth)

IF stable_infrastructure AND risk_tolerance_high:
  → Managed platform (simpler, lower ops burden)
```

**RECOMMENDATION (based on your findings):**

**Short-term (months 1–6):** Use a managed platform ($50K/year). Unblocks engineering.

**Long-term (months 6–12):** Start hiring internal DevOps engineer. By month 12, you
have expertise in-house. At month 18, migrate off managed platform (if you want custom
control) or stay on it (if it's working well).

**Hidden benefit:** Managed platform use during hiring ramp gives your future hire context.
They'll understand why you chose it, what the constraints are, and whether switching is
worth the effort.

**Avoids:** The common failure mode of hiring DevOps engineer + having them spend 6 months
on ticket toil because there's no stack yet.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
**DAG SYNTHESIS**
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Don't force a binary choice. Use a two-phase strategy:**

Phase 1 (0–6mo): Managed platform (reduces toil, buys hiring time)
Phase 2 (6–18mo): Hire internal engineer in parallel (knowledge building)
Phase 3 (18mo+): Decide whether to stay managed or own the stack

This strategy lets you:
  ✓ Unblock engineering immediately (managed platform)
  ✓ Hire without time pressure (gives you better candidates)
  ✓ Make the switch/stay decision from a position of strength (not desperation)

Confidence: 89%  |  Nodes: 6  |  Parallel branches: 2

vs. Vanilla Claude:
  • Node 2 revealed hiring timelines are the actual constraint (not cost or complexity)
  • Node 5 surfaced vendor lock-in risks that would have been implicit costs later
  • Synthesis provided a *phased* approach (not a binary choice), which de-risks both paths
  • Hidden benefit (managed platform as training ground) emerged only after full analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Summary: When Compare Shows Its Power

The DAG skill's **Before/After compare function** reveals:

1. **Vanilla Claude** tends to be:
   - Balanced (all sides presented equally)
   - Generic (applies to everyone)
   - Asynchronous (lists factors without dependency order)
   - Exhaustive (comprehensive, but overwhelming)

2. **DAG skill** tends to:
   - Gated (some factors are *blocking*, others secondary)
   - Conditional (paths diverge based on actual constraints)
   - Sequential (respects dependencies, order matters)
   - Actionable (synthesizes into specific next steps)

The compare function makes this difference **explicit and visual**, so users can see what
they would have missed with vanilla reasoning.

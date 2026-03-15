<div align="center">

# 🧠 Claude DAG Skill

### *Structured, dependency-aware reasoning for Claude — in any chat, zero setup*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Compatible](https://img.shields.io/badge/Claude-claude.ai%20%7C%20API%20%7C%20Claude%20Code-orange)](https://claude.ai)
[![Skill Type](https://img.shields.io/badge/Type-Prompt%20Skill-blue)]()
[![Install Time](https://img.shields.io/badge/Install-30%20seconds-green)]()

**80% of multi-agent DAG power. 0% setup. Works everywhere Claude does.**

*Turns Claude's linear reasoning into structured, dependency-aware DAG execution —
decompose any complex goal into nodes, enforce ordering, simulate parallel branches,
synthesize findings, and see exactly what vanilla Claude would have missed.*

</div>

---

## The Problem With Vanilla Claude on Complex Tasks

When you give Claude a complex, multi-part goal, it tends to:

- ❌ **Jump straight to conclusions** before validating prerequisites
- ❌ **Flatten parallel branches** into a single blended answer that misses depth
- ❌ **Ignore hidden dependencies** (e.g., "pick your channels" before "define your personas")
- ❌ **Contradict itself** across sections of a long answer with no reconciliation
- ❌ **Produce outputs you can't audit** — no traceability, no per-step quality signal

The DAG Skill fixes all of this — with no external tools, no API keys, no frameworks.

---

## ✨ Before → After

### Example: Market Research

<table width="100%">
<tr>
<th width="50%">❌ Before</th>
<th width="50%">✅ After</th>
</tr>
<tr>
<td valign="top" width="50%">

**Prompt:** *"Analyze the EV charging market in Europe for 2026 investment opportunities"*

The European EV charging market is set for significant growth by 2026, driven by AFIR regulations and the phase-out of ICE vehicles. Key players like Ionity and Allego are expanding, while Tesla is opening its Supercharger network. Norway leads in penetration, but Germany and France offer the largest absolute growth. However, grid constraints remain a major bottleneck. Investment opportunities include hardware manufacturing, SaaS for fleet management, and decentralized storage. Market size is projected to hit €20B by 2030, though some reports suggest €15B if infrastructure lags. Additionally, public-private partnerships (PPPs) will be crucial for scaling high-power charging (HPC) across the TEN-T corridors. Investors should also watch for advancements in vehicle-to-grid (V2G) technology, which could transform EVs into mobile energy storage units, though regulatory frameworks for this are still in their infancy in many member states. Furthermore, the integration of renewable energy sources at charging sites will become a competitive differentiator...

**Problems:**
- **Logical Gaps:** Jumped to "Investment opportunities" before analyzing competitors or demand forecasts.
- **Surface Level:** Mixed regulatory, infra, and player data into a flat summary with no dependency logic.
- **Auditability:** No way to trace which market size projection (€15B vs €20B) is more credible based on the logic.
- **Scoring:** All opportunities are treated as equally valid with no risk-adjusted weighting.
- **Contradictions:** Mentions "grid constraints" as a bottleneck but doesn't reconcile this with "rapid growth" projections.
- **Hidden Prerequisites:** Discusses V2G opportunities without first establishing underlying grid stability requirements.
- **Lack of Synthesis:** Multiple high-level claims are made, but they are never synthesized into a cohesive thesis.
- **Static Thinking:** Fails to account for how a change in regulation (Node 1) would cascade through the entire analysis.

</td>
<td valign="top" width="50%">

**Prompt:** *"decompose: Analyze the EV charging market in Europe for 2026 investment opportunities"*

**Plan (shown upfront):**
```xml
<dag goal="EV Charging Market">
  <node id="1" name="Regulation"/>
  <node id="2" name="Infra" deps="[1]"/>
  <node id="3" name="Players" deps="[1]" pl="4"/>
  <node id="4" name="Demand" deps="[1]" pl="3"/>
  <node id="5" name="Risk" deps="[2,3,4]"/>
  <node id="6" name="Scoring" deps="[3,4,5]"/>
  <node id="7" name="Synthesis" deps="[5,6]"/>
</dag>
```

Then executes node-by-node, merging parallel branches 3+4, resolving contradictions, and closing with:

**vs. Vanilla Claude:**
- AFIR mandates analyzed BEFORE player strategy
- Parallel branches found demand ≠ infra alignment
- Risk Matrix caught grid-constraint contradiction

</td>
</tr>
</table>

---

### Example: Software Refactoring

<table width="100%">
<tr>
<th width="50%">❌ Before</th>
<th width="50%">✅ After</th>
</tr>
<tr>
<td valign="top" width="50%">

**Prompt:** *"Refactor my payment module for security and scalability"*

To improve your payment module, start by migrating all secrets to environment variables. Implement dependency injection for the payment gateway to allow for easier testing. For scalability, I recommend switching to an asynchronous message queue (like RabbitMQ) for processing transactions. You should also add input validation to prevent SQL injection. Here is a refactored version of your `PaymentService` class that includes these changes and some basic logging for audit trails... [generates 100 lines of code]

**Problems:**
- **Sequence Error:** Suggests performance-heavy "async processing" before fixing critical security vulnerabilities.
- **Backwards Logic:** Generates code first, then mentions validation and rate limiting as afterthoughts.
- **Missing Prerequisites:** Proposes dependency injection but doesn't establish a testing strategy first.
- **Black Box:** No explanation of *why* specific architectural choices were made over alternatives.
- **Auditability:** Hard to verify if the refactor actually covers all OWASP top 10 risks.

</td>
<td valign="top" width="50%">

**Prompt:** *"decompose: Refactor my payment module for security and scalability"*

**Nodes execute in order:**
1. Dependency & flow mapping
2. Security audit (OWASP) — *flags SQL injection in auth*
3. Scalability bottlenecks *(parallel with 4)*
4. Performance profiling *(parallel with 3)*
5. Synthesis: refactor plan (security first, then scale)
6. Code generation (with tests)
7. Validation & edge-case check

**Key difference:** Node 2's SQL injection finding forces Node 5 to mandate prepared statements *before* async refactoring — order that vanilla Claude reverses.

</td>
</tr>
</table>

---

### Example: Strategy Planning

<table width="100%">
<tr>
<th width="50%">❌ Before</th>
<th width="50%">✅ After</th>
</tr>
<tr>
<td valign="top" width="50%">

**Prompt:** *"Build a 2026 go-to-market plan for an AI productivity SaaS"*

> For your 2026 GTM strategy, I recommend targeting SMBs in tech and professional services. Your pricing should be a freemium model starting at $19/user/month to stay competitive with Notion AI and Grammarly. Use LinkedIn ads and SEO content as your primary acquisition channels. Your core messaging should focus on "10x team productivity." You should also consider a partner program for consultants...

**Problems:**
- **Premature Decisions:** Selects channels and pricing before defining user personas or validating the value prop.
- **Circular Logic:** Competitive analysis is mentioned but doesn't actually inform the differentiation strategy.
- **Dependency Blindness:** Messaging is created in a vacuum without considering market sizing or demand data.
- **Brittle Output:** The plan is a single linear block; changing the "target audience" requires a total rewrite of the entire response.

</td>
<td valign="top" width="50%">

**DAG enforces the real dependency order:**

```
[1] Goals
      ↓
[2] Personas ──┐
[3] Market   ──┤ (parallel)
               ↓
[4] Value Prop (deps: 2+3)
      ↓
[6] Channels ──┐ (deps: 4+5)
[7] Pricing  ──┘
      ↓
[8] Risk + GTM (synthesis)
```

Changing Node 2 (personas) automatically signals which downstream nodes need updating. Dependency-aware by design.

</td>
</tr>
</table>

---

---

## 🎯 Three Ways This Helps (Pick Your Path)

### Lens 1: Better Answers Today
**For:** Anyone using Claude now who wants significantly better outputs on complex tasks

DAG skill gives you **80% of production multi-agent DAG power with zero setup**:
- Dependencies are explicit, not hidden
- Parallel branches are explored, not flattened
- Contradictions are resolved, not ignored
- Every answer is traceable: you can see *why* each conclusion exists

**Result:** Better outputs, better decisions, auditable reasoning.

---

### Lens 2: Learn How AI Orchestration Actually Works
**For:** Anyone building with agents, workflows, or multi-step automation

The next era of AI isn't "one prompt, one answer." It's orchestration — chaining models,
parallelizing work, synthesizing across branches. Most people will need this skill in the
next 12 months.

DAG Skill teaches you the *mental model* first, risk-free:
- **Feel it:** Run a DAG, see dependencies materialize
- **Name it:** "Oh, this is sequential, that's parallel, we need to resolve this contradiction"
- **Build it:** Recognize patterns in your own problems
- **Transfer it:** Open LangGraph / CrewAI / n8n and realize you already know this

**Result:** When orchestration hits you, you're ready. No learning curve, just syntax.

---

### Lens 3: Decompose Tasks Before Building Real Agents
**For:** Teams planning to move from "ask Claude once" to "build real workflows"

The biggest bottleneck in orchestration isn't *execution* — it's **decomposition**.

Your orchestration tool (LangGraph, CrewAI, n8n) can execute a DAG structure perfectly.
What it can't do is figure out what the structure *should be*.

DAG Skill solves that:
1. You describe a messy problem to Claude
2. Claude breaks it into a clear DAG structure (nodes, dependencies, parallel branches)
3. You port that structure into your orchestration tool (20 minutes of straightforward mapping)
4. Your agents execute it (handled by the tool)

DAG is the *planning layer*. Real tools are the *execution layer*.

**Result:** When you're ready to build agents, you already have the blueprint.

---

**You can use this skill for any or all three. Most users will do Lens 1 first, then discover Lens 2,
then graduate to Lens 3 when they're ready for real orchestration.**

---

## 🚀 Install (30 Seconds)

### Option A — claude.ai (Web/Mobile/Desktop)

1. Download or clone this repo
2. Zip the `SKILL.md` file (or the entire folder)
3. Go to **claude.ai → Settings → Skills → Add Skill**
4. Upload the zip

### Option B — Claude Code Plugin (Recommended for CLI)

Install via Claude Code's plugin marketplace:

```bash
/plugin marketplace add matt-k-wong/mkw-DAG-architect
/plugin install decompose@decompose-marketplace
```

Then use in any conversation:

```
/decompose [your task]
/decompose preview: [your task]
/decompose step mode: [your task]
```

### Option C — Claude Code (Manual)

```bash
# Clone the repo
git clone https://github.com/matt-k-wong/mkw-DAG-architect.git

# Symlink to your skills directory
ln -s "$(pwd)/mkw-DAG-architect" ~/.claude/skills/decompose

# Or run the install script
cd mkw-DAG-architect && bash install.sh
```

### Option D — API / Custom Deployment

Paste the contents of `SKILL.md` into your system prompt (remove the YAML header).
The skill is purely prompt-based — no external dependencies.

---

## 💬 Usage

Once installed, use any of these in a Claude chat:

```
# Check if decomposition will help (before committing)
decompose preview: write a comprehensive onboarding guide for new engineers

# Run the full decomposition
decompose: analyze competitor positioning for our B2B SaaS

# Step through node-by-node (good for large tasks)
decompose step mode: refactor our authentication system

# Re-run one node after updating context
Re-run node 3 with this new data: [paste data]
```

Claude will **also auto-activate** on complex tasks without explicit triggers — the skill
description tells Claude when to engage automatically.

---

## 📊 When to Use / When NOT to Use

| Use Decompose When... | Skip When... |
|----------------------|-------------|
| ✅ Task has 4+ interdependent steps | ❌ Single-answer factual question |
| ✅ Multiple angles need synthesis | ❌ Short creative task (poem, haiku, blurb) |
| ✅ Order of operations matters | ❌ Simple explanation of one concept |
| ✅ Parallel branches need exploring | ❌ Quick draft or rough notes |
| ✅ Contradictions are likely | ❌ Casual conversation / chat |
| ✅ You want auditable, traceable output | ❌ Task you've already fully decomposed |
| ✅ Stakes are high (strategy, code, research) | ❌ User explicitly asks for "brief" or "quick" |

**Not sure?** Type `decompose preview: [your goal]` — Claude will tell you whether it's worth it
and exactly what you'd gain. No commitment required.

---

## 🎯 Use Cases (Where It Shines)

### 🔬 Research & Analysis
Market research, competitor analysis, literature reviews, investment theses, due diligence.
DAG enforces: *gather facts → identify patterns → resolve conflicts → synthesize conclusions*

### 💻 Software Development
Refactoring, architecture design, debugging complex bugs, code review pipelines.
DAG enforces: *understand dependencies → audit → plan → implement → validate*

### 📈 Business & Strategy
GTM planning, OKRs, M&A integration, pricing strategy, operational playbooks.
DAG enforces: *customer before channel, market before message, risk before commit*

### 📝 Content & Marketing
Content calendars, long-form reports, campaign pipelines, ebook production.
DAG enforces: *research → outline → draft (parallel sections) → cross-link → optimize*

### 🎓 Learning & Education
Skill acquisition plans, curriculum design, thesis outlining, study guides.
DAG enforces: *prerequisites → concepts → practice → gap-filling → mastery check*

### 🏗️ Project & Life Planning
Product launches, event planning, career pivots, home renovations, annual reviews.
DAG enforces: *constraints → resources → critical path → dependencies → milestones*

---

## 🌉 From Claude DAG to Real Orchestration

The biggest gap between "thinking in DAGs" and "building with agents" isn't execution — it's **decomposition**.

In production orchestration, your first step is always:
> *"Break this messy task into a DAG structure"*

That's where DAG Skill shines.

---

### The Real Workflow

#### Step 1: Use Claude DAG to Break Down the Task (This Skill)
**Problem:** "Build a product recommendation engine"

You write:
```
DAG: Design a recommendation engine that balances personalization, performance, and compliance
```

Claude shows you:
```xml
<node id="1" name="Requirements & Constraints" depends="[]"/>
<node id="2" name="Data Architecture" depends="[1]"/>
<node id="3" name="ML Model Selection" depends="[1]" parallel_with="4"/>
<node id="4" name="Privacy & Compliance" depends="[1]" parallel_with="3"/>
<node id="5" name="Integration Points" depends="[2,3,4]"/>
<node id="6" name="Testing Strategy" depends="[5]"/>
<node id="7" name="Implementation Plan" depends="[6]"/>
```

**Output:** A dependency graph. A clear structure. A roadmap.

This is the hard part. Claude does it for you.

---

#### Step 2: Port the DAG to Your Orchestration Tool (You Handle Later)

Once you have the DAG, the execution layer is straightforward:

**LangGraph:**
```python
# Your DAG structure → LangGraph agents
graph = StateGraph(State)

graph.add_node("requirements", requirements_agent)
graph.add_node("data_arch", data_agent)
graph.add_node("ml_model", ml_agent)
graph.add_node("compliance", compliance_agent)
graph.add_node("integration", integration_agent)
graph.add_node("testing", testing_agent)
graph.add_node("implementation", impl_agent)

# Your dependencies → Graph edges
graph.add_edge("requirements", "data_arch")
graph.add_edge("requirements", "ml_model")
graph.add_edge("requirements", "compliance")
graph.add_edge(["data_arch", "ml_model", "compliance"], "integration")
graph.add_edge("integration", "testing")
graph.add_edge("testing", "implementation")
```

**CrewAI:**
```python
requirements_task = Task(..., agent=requirements_agent)
data_task = Task(..., depends_on=[requirements_task], agent=data_agent)
ml_task = Task(..., depends_on=[requirements_task], agent=ml_agent)
compliance_task = Task(..., depends_on=[requirements_task], agent=compliance_agent)
# ... and so on, mirroring your DAG structure
```

**n8n:**
- Nodes = workflow steps (your nodes become n8n nodes)
- Dependencies = connections (your edges become n8n links)
- Parallel branches = n8n parallel branches
- Synthesis = n8n merge node or code step

---

### Why This Matters

**The hard part is knowing what to ask each agent to do and in what order.**

Production frameworks (LangGraph, CrewAI, n8n) handle the *execution* fine. They don't help you figure out the *structure*.

DAG Skill helps you figure out the structure. Once you have it, translating to code is mechanical.

```
Your brain (using DAG Skill) → Decomposition ← THE HARD PART
                                    ↓
                  (straightforward mapping, frameworks handle this)
                                    ↓
                    Your agent workflow (LangGraph/CrewAI/n8n)
```

---

### The Practical Flow

1. **Use DAG Skill** to break down a complex task
   - Type: `DAG: [messy problem]`
   - Get: Clear XML structure + synthesis
   - Output: A blueprint

2. **Copy the structure** into your orchestration tool
   - Map nodes to agents/tasks
   - Map dependencies to edges/ordering
   - No guessing, no back-and-forth
   - This takes minutes

3. **Build the agent logic** for each node
   - What does each agent actually *do*?
   - This is the hard part, but it's isolated per-node
   - Easier because you know the context (other nodes, dependencies)

4. **Test and iterate**
   - Your DAG structure already told you the critical path
   - You know which failures cascade

---

### Real Example: From DAG to LangGraph

**Your Claude DAG (5 minutes to create):**
```
[1] Market Research
[2] Competitive Analysis (parallel with 3)
[3] Pricing Strategy (parallel with 2)
[4] Go-to-Market Plan (depends on 1,2,3)
[5] Risk Assessment (depends on 4)
```

**Your LangGraph code (20 minutes to write):**
```python
graph = StateGraph(State)

# Nodes map 1:1 from DAG
graph.add_node("market_research", market_research_agent)
graph.add_node("competitive_analysis", competitive_analysis_agent)
graph.add_node("pricing", pricing_strategy_agent)
graph.add_node("gtm", gtm_planning_agent)
graph.add_node("risk", risk_assessment_agent)

# Edges map 1:1 from DAG dependencies
graph.add_edge(START, "market_research")
graph.add_edge("market_research", "competitive_analysis")
graph.add_edge("market_research", "pricing")  # parallel
graph.add_edge(["competitive_analysis", "pricing"], "gtm")
graph.add_edge("gtm", "risk")
graph.add_edge("risk", END)
```

**The bridge is trivial because you already decomposed correctly.**

---

### When You're Ready to Build

Once you've internalized DAG thinking:
- **DAG Skill** helps you design the structure
- **LangGraph** (or CrewAI, n8n) executes it
- **Your LLM agents** do the actual work

But step 1 — the decomposition — is the bottleneck. DAG solves that.

---

## 🏗️ How It Works

```
User Goal
    │
    ▼
┌─────────────────────────────────────────┐
│  PHASE 0: PLAN                          │
│  Generate DAG (nodes + dependencies)    │
│  Validate: no cycles, all deps exist    │
│  Show full plan before executing        │
└────────────────────┬────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│  PHASE 1: EXECUTE (topological order)   │
│                                         │
│  Node 1 → Node 2 ──────────────────┐   │
│                └──► Node 3 (parallel)│  │
│                       Node 4 ◄──────┘  │
│                                         │
│  Each node: Generate → Score → Log     │
└────────────────────┬────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│  PHASE 2: AGGREGATE                     │
│  Merge parallel branches                │
│  Resolve contradictions explicitly      │
└────────────────────┬────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│  PHASE 3: SYNTHESIS BLOCK               │
│  Final output + Confidence score        │
│  "vs. Vanilla Claude" — what was gained │
└─────────────────────────────────────────┘
```

### Why Simulation Works (~80% of Real Multi-Agent Value)

| Feature | Real DAG (LangGraph etc.) | DAG Simulator Skill |
|---------|--------------------------|---------------------|
| Topological execution order | ✅ | ✅ Enforced by prompt |
| Explicit dependencies | ✅ | ✅ XML plan shown upfront |
| Parallel branch exploration | ✅ (true parallel) | ✅ (simulated sequential, labeled) |
| Aggregation & synthesis | ✅ | ✅ Explicit merge phase |
| Per-node quality scoring | ⚠️ Custom | ✅ Built-in |
| Traceable output | ✅ | ✅ XML execution log |
| Setup required | ❌ Hours | ✅ 30 seconds |
| External dependencies | ❌ Docker, Python, LLM APIs | ✅ None |
| Works on claude.ai free | ❌ | ✅ |
| Cost | ❌ Significant | ✅ Just Claude tokens |
| True parallelism | ✅ | ❌ Sequential under hood |
| Cross-session persistence | ✅ | ❌ In-context only |
| Production reliability | ✅ | ⚠️ Prompt-dependent |

**The 20% you give up** (true parallelism, persistence, prod reliability) rarely matters
for research, planning, content, and analysis workflows. The 80% you keep changes everything.

---

## 🗂️ Repository Structure

```
claude-dag-skill/
├── SKILL.md                    # ← The skill itself (install this)
├── README.md                   # This file
├── install.sh                  # One-command install for Claude Code
├── LICENSE                     # MIT
├── templates/
│   ├── dag-template.xml        # Blank starter template
│   ├── research-dag.xml        # Research & analysis pattern
│   ├── code-dag.xml            # Software dev pattern
│   └── strategy-dag.xml        # Business strategy pattern
└── examples/
    └── before-after.md         # Full before/after walkthroughs
```

---

## 🔮 Roadmap

- [ ] v1.1 — Mermaid/ASCII DAG visualization via Artifacts
- [ ] v1.2 — Claude Code sub-agent integration (real parallel execution when available)
- [ ] v1.3 — Domain packs: Research Pro, Engineering Pro, Strategy Pro
- [ ] v2.0 — Companion MCP server for true parallelism and cross-session state

---

## ❓ Common Questions

### "Will this help me build real agents?"
**Yes, but indirectly.** DAG teaches you how to *think* about orchestration AND helps you
decompose complex tasks into clear structures. When you move to LangGraph/CrewAI, your DAG
becomes your blueprint — nodes map to agents, dependencies map to edges. See the mapping
guides in `examples/`.

---

### "Is decompose overkill for simple decisions?"
**Sometimes.** Use the `decompose preview:` mode first. If Claude says ❌ SKIP, just ask normally.
The skill knows when it's useful.

---

### "Can I use decompose in production?"
**Not directly.** Decompose is the *planning* layer. But here's what you do:

1. Use decompose to break your task into a clear structure
2. Copy that structure into LangGraph, CrewAI, or n8n
3. Those tools *execute* the structure

Decompose is where decomposition happens (the hard part). The orchestration tool is where
execution happens (the straightforward part). You get the best of both.

**Example:** An LLM can't know the right 7-node structure for "build a recommendation engine."
Claude + decompose figures that out for you. Then you plug it into your orchestration tool.

---

### "Do I need to know anything before using this?"
No. Start with `decompose preview: [something complex]`. If it helps, great. If not, Claude tells
you. Zero required knowledge.

---

### "Is there a video tutorial?"
Not yet, but: run `decompose preview: what should I prioritize in my product roadmap`, see the
structure, then read the synthesis. That's the tutorial. Repeat 3–5 times, you'll get it.

---

## 🤝 Contributing

PRs welcome. Priority areas:

- New domain-specific DAG templates (legal, medical, academic, etc.)
- Better compression strategies for 20+ node DAGs
- Additional before/after examples
- Orchestration mapping guides (LangGraph, CrewAI, n8n, Sub-Agents)
- Real-world examples of DAG → production agent system

Please open an issue first for large changes.

---

## 📄 License

MIT — free for personal and commercial use. See [LICENSE](LICENSE).

---

<div align="center">

**If this saves you hours, consider starring ⭐ the repo — it helps others find it.**

*Built for the Claude ecosystem. Not affiliated with Anthropic.*

</div>

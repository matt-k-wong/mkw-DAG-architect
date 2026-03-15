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

<table>
<tr>
<th width="50%">❌ Before (Vanilla Claude)</th>
<th width="50%">✅ After (DAG Skill)</th>
</tr>
<tr>
<td valign="top">

**Prompt:** *"Analyze the EV charging market in Europe for 2026 investment opportunities"*

> The European EV charging market is growing rapidly due to EU regulations. Key players include Ionity, Allego, ChargePoint, and Tesla. Growth is driven by Norway (90%+ EV penetration), Germany, France, and the UK. Challenges include grid capacity and high installation costs. Market size projected to reach €15–20B by 2030…

**Problems:**
- Regulatory + infrastructure + players mixed together with no dependency logic
- "Investment opportunities" appears before competitive landscape is analyzed
- No scoring of opportunities — all treated as equally valid
- Contradictions possible between sections (different timelines, different market sizes)
- No way to audit which claim came from which analysis

</td>
<td valign="top">

**Prompt:** *"DAG: Analyze the EV charging market in Europe for 2026 investment opportunities"*

**Plan (shown upfront):**
```xml
<dag goal="EV charging market — EU investment thesis">
  <node id="1" name="Regulatory Landscape" depends="[]"/>
  <node id="2" name="Infrastructure Gaps" depends="[1]"/>
  <node id="3" name="Player Mapping" depends="[1]" parallel_with="4"/>
  <node id="4" name="Demand Forecast" depends="[1]" parallel_with="3"/>
  <node id="5" name="Risk Matrix" depends="[2,3,4]"/>
  <node id="6" name="Opportunity Scoring" depends="[3,4,5]"/>
  <node id="7" name="Investment Thesis" type="synthesis" depends="[5,6]"/>
</dag>
```

Then executes node-by-node, merging parallel branches 3+4, resolving contradictions, and closing with:

```
vs. Vanilla Claude:
• AFIR mandates were analyzed BEFORE player strategy
  (not after) — uncovered Tesla's open-network pivot
• Parallel branches found demand ≠ infrastructure 
  alignment in Eastern EU — overlooked opportunity
• Risk Matrix caught grid-constraint contradiction 
  between nodes 2 and 4, resolved with hybrid thesis
```

</td>
</tr>
</table>

---

### Example: Software Refactoring

<table>
<tr>
<th width="50%">❌ Before</th>
<th width="50%">✅ After</th>
</tr>
<tr>
<td valign="top">

**Prompt:** *"Refactor my payment module for security and scalability"*

> First, move API keys to env vars. Use dependency injection. Switch to async processing. Add input validation. Here's refactored code: [big block]. Also consider rate limiting…

**Problems:**
- Suggests async processing *before* securing endpoints
- Validation appears *after* code generation (backwards)
- No test strategy — code generated without test dependencies
- Can't audit why specific choices were made

</td>
<td valign="top">

**Prompt:** *"DAG: Refactor my payment module for security and scalability"*

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

<table>
<tr>
<th width="50%">❌ Before</th>
<th width="50%">✅ After</th>
</tr>
<tr>
<td valign="top">

**Prompt:** *"Build a 2026 go-to-market plan for an AI productivity SaaS"*

> Target SMBs first. Pricing: $19/mo freemium. Channels: LinkedIn ads, content marketing. Messaging: "10x your team's output." Competitors: Notion AI, Grammarly Business...

**Problems:**
- Channels picked before personas are defined
- Pricing set before value prop is validated
- Competitor analysis doesn't feed into differentiation
- Linear delivery — changing one assumption requires redoing everything

</td>
<td valign="top">

**DAG enforces the real dependency order:**

```
[1] Goals & Metrics
      ↓
[2] Persona Research ─┐
[3] Market Sizing    ─┤ (parallel)
                      ↓
[4] Value Prop & Messaging (depends on 2+3)
      ↓
[5] Competitive Differentiation
      ↓
[6] Channel Strategy ─┐ (depends on 4+5)
[7] Pricing Model    ─┘ (parallel)
      ↓
[8] Risk Scenarios + GTM Roadmap (synthesis)
```

Changing Node 2 (personas) automatically signals which downstream nodes need updating. Dependency-aware by design.

</td>
</tr>
</table>

---

## 🚀 Install (30 Seconds)

### Option A — claude.ai (Web/Mobile/Desktop)

1. Download or clone this repo
2. Zip the `dag-simulator/` folder
3. Go to **claude.ai → Settings → Skills → Add Skill**
4. Upload the zip

### Option B — Claude Code (CLI)

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/claude-dag-skill.git

# Symlink to your skills directory
ln -s "$(pwd)/claude-dag-skill/dag-simulator" ~/.claude/skills/dag-simulator

# Or run the install script
cd claude-dag-skill && bash install.sh
```

### Option C — API / Custom Deployment

Paste the contents of `SKILL.md` into your system prompt (remove the YAML header).
The skill is purely prompt-based — no external dependencies.

---

## 💬 Usage

Once installed, use any of these in a Claude chat:

```
# Check if DAG will help (before committing)
DAG preview: write a comprehensive onboarding guide for new engineers

# Run the full DAG
DAG: analyze competitor positioning for our B2B SaaS

# Explicit trigger (also works)
Use DAG mode for: planning a product launch

# Step through node-by-node (good for large tasks)
DAG step mode: refactor our authentication system

# Re-run one node after updating context
Re-run node 3 with this new data: [paste data]
```

Claude will **also auto-activate** on complex tasks without explicit triggers — the skill
description tells Claude when to engage automatically.

---

## 📊 When to Use / When NOT to Use

| Use DAG When... | Skip DAG When... |
|----------------|-----------------|
| ✅ Task has 4+ interdependent steps | ❌ Single-answer factual question |
| ✅ Multiple angles need synthesis | ❌ Short creative task (poem, haiku, blurb) |
| ✅ Order of operations matters | ❌ Simple explanation of one concept |
| ✅ Parallel branches need exploring | ❌ Quick draft or rough notes |
| ✅ Contradictions are likely | ❌ Casual conversation / chat |
| ✅ You want auditable, traceable output | ❌ Task you've already fully decomposed |
| ✅ Stakes are high (strategy, code, research) | ❌ User explicitly asks for "brief" or "quick" |

**Not sure?** Type `DAG preview: [your goal]` — Claude will tell you whether it's worth it
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

## 🤝 Contributing

PRs welcome. Priority areas:

- New domain-specific DAG templates (legal, medical, academic, etc.)
- Better compression strategies for 20+ node DAGs
- Additional before/after examples
- Integration guides (Claude Code, API, n8n, etc.)

Please open an issue first for large changes.

---

## 📄 License

MIT — free for personal and commercial use. See [LICENSE](LICENSE).

---

<div align="center">

**If this saves you hours, consider starring ⭐ the repo — it helps others find it.**

*Built for the Claude ecosystem. Not affiliated with Anthropic.*

</div>

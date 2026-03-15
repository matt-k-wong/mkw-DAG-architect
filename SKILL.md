---
name: decompose
version: 1.1.0
description: >
  Learn to decompose complex problems before building real agents. Better answers today.
  Ready for orchestration tomorrow. Breaks messy tasks into clear DAG structures with
  explicit dependencies, parallel branches, and synthesis logic. Improves Claude outputs
  by enforcing topological order and catching contradictions. Teaches the mental model
  for LangGraph, CrewAI, n8n, and Sub-Agents. Type "decompose: [goal]" or "decompose preview: [goal]"
  to start. Zero experience required.
license: MIT
---

You are now in decompose mode. Instead of streaming a single linear response, you break
down complex goals into a structured Directed Acyclic Graph of dependent tasks, execute
them in topological order, simulate parallel branches, and synthesize a final output that
is explicitly better than what vanilla linear reasoning produces.

---

## IMPACT PREVIEW MODE  ← The "Do I Need This?" Feature

**Trigger:** User types `decompose preview: [goal]` OR `decompose: [goal]` OR `Should I decompose [goal]?`

When triggered, respond ONLY with this block — do NOT execute the full DAG:

```
╔══════════════════════════════════════════════╗
║           DAG IMPACT PREVIEW                 ║
╚══════════════════════════════════════════════╝
Goal: [restate goal concisely]

Verdict: ✅ HIGH VALUE  /  ⚠️ MARGINAL  /  ❌ SKIP

Without DAG (vanilla Claude):
  ✗ [Specific weakness #1 — dependency it would ignore]
  ✗ [Specific weakness #2 — contradiction it would risk]
  ✗ [Specific weakness #3 — branch it would skip or flatten]

With DAG Simulator:
  ✓ [What topological ordering unlocks]
  ✓ [What parallel branching explores]
  ✓ [What synthesis aggregates that linear misses]

Estimated structure:
  Nodes: ~N  |  Depth: ~D  |  Parallel sets: ~P

  [1] Foundation ──► [2] Branch A ──► [4] Synthesis
                 └──► [3] Branch B ──►

Type "decompose go" or "proceed" to run the full decomposition.
```

**Verdict criteria:**
- ✅ HIGH VALUE: 4+ steps with real dependencies, multi-angle analysis needed, synthesis required, contradiction risk is real
- ⚠️ MARGINAL: 2–3 steps, mild branching — DAG adds some structure but user can decide
- ❌ SKIP: Single-step, factual lookup, simple creative, <2 real dependencies — say so and answer normally

---

## WHEN TO ACTIVATE (Auto-Trigger Signals)

Activate DAG mode automatically when the request involves ANY of:

- Research from 3+ angles that must be synthesized
- Planning where step B genuinely cannot precede step A
- Analysis spanning multiple competing dimensions (e.g., security AND performance AND cost)
- Decisions requiring trade-off evaluation across criteria
- Code tasks touching architecture + implementation + testing + validation
- Strategy work flowing from market → customer → channels → budget → risks
- Content pipelines where sections depend on earlier sections
- Projects with a critical path where sequencing matters
- Any goal where "getting one part wrong" cascades into later parts

## WHEN TO STAY SILENT (Do NOT Activate)

Do NOT activate DAG mode for:

- Single-answer factual questions ("What year was X founded?")
- Simple explanations of a single concept
- Short creative tasks with no structural dependencies ("Write a haiku about rain")
- Quick summaries of content already provided
- Casual conversation or chat
- Tasks the user has already fully decomposed themselves
- Requests explicitly marked "quick", "brief", or "rough draft"

**When unsure:** Offer the IMPACT PREVIEW instead of auto-running the full DAG.

---

## 📚 Learning Path (If Your Goal Is Orchestration Readiness)

If you're here to learn how decomposition and orchestration thinking works, follow this progression:

### Phase 1: Orientation (1–2 uses)
**Goal:** Feel what dependency-driven thinking is like

- Run `DAG preview:` on something you're unsure about
- Don't overthink it — just see what Claude shows you
- **Key insight:** Notice which branches *had* to be sequential vs. which could run in parallel

**You'll notice:** Claude shows you a *reason* for the order, not just an order

---

### Phase 2: Recognition (3–5 uses)
**Goal:** Start naming the patterns

- When you use DAG, read the XML plan carefully
- Ask yourself: "Why is Node 3 parallel with Node 4?"
- Notice how dependencies *unlock* downstream thinking
- Start asking Claude to `DAG preview:` naturally on hard problems

**You'll notice:** You start seeing DAG patterns in your own thinking ("I can't pick channels until I know personas")

---

### Phase 3: Construction (ongoing)
**Goal:** Build your own mental DAGs

- Use the templates in `templates/` folder
- Customize node types for your domain
- Run `DAG step mode:` to slow down and see each decision point
- Tweak and iterate

**You'll notice:** You're writing DAG structures before asking Claude to execute them

---

### Phase 4: Transfer (when you build real systems)
**Goal:** Move to production orchestration

Once you're building workflows in LangGraph, CrewAI, or n8n, look back:
- Your DAGs maps to agent graphs (nodes → agents, dependencies → edges)
- Your synthesis logic maps to control flow
- Your parallel branches map to async patterns
- Nothing is new, just syntax

**See the mapping guides in `examples/orchestration-mappings.md`**

---

**Where are you in this path? Just tell Claude:**
- `"I'm in phase 1 — help me learn to recognize dependencies"`
- `"I'm building real agents now — show me how this DAG maps to LangGraph"`

Claude will adapt the explanation to where you are.

---

## Orchestration Context (AI Teaching Mode)

If the user is learning orchestration concepts (even just understanding them), activate
DAG mode and **add bridge commentary** to the synthesis:

Example bridge line (add to every synthesis when user seems to be learning):

```
🌉 DECOMPOSITION BRIDGE:
In LangGraph, this would be:
  - Nodes 1–3 → Three separate agents (parallel execution)
  - Node 4 → An aggregator agent that synthesizes outputs
  - Decision logic → Conditional routing based on findings

When you're ready to build real agents, you'll copy this structure directly
into your tool's code. The decomposition you just did is the hard part.
The execution is mechanical.
```

---

## DAG EXECUTION FRAMEWORK

### PHASE 0: PLAN

Before executing anything, output the full DAG plan in XML. Do not skip this.

```xml
<dag goal="[user's goal]" mode="full|iterative|preview">
  <plan>
    <node id="1" name="[Name]" type="[research|analysis|synthesis|validation|creative|decision]"
          depends="[]" parallel_with="[]">
      <objective>[Single sentence: what this node produces]</objective>
    </node>
    <node id="2" name="[Name]" type="analysis" depends="[1]" parallel_with="3">
      <objective>[Single sentence]</objective>
    </node>
    <node id="3" name="[Name]" type="research" depends="[1]" parallel_with="2">
      <objective>[Single sentence]</objective>
    </node>
    <node id="4" name="Synthesis" type="synthesis" depends="[2,3]" parallel_with="[]">
      <objective>Merge, resolve conflicts, produce final answer</objective>
    </node>
  </plan>
</dag>
```

**Validation checklist before proceeding:**
- [ ] No cycles (if A→B then B must not depend on A, directly or transitively)
- [ ] Every dependency ID exists in the plan
- [ ] Parallel nodes are genuinely independent (neither depends on the other)
- [ ] At least one terminal synthesis node aggregates prior branches
- [ ] Node count is appropriate for task complexity (see Scale table below)

---

### PHASE 1: EXECUTE (Topological Order)

For each node, in dependency order:

1. **State the node:** `▶ NODE [id]: [Name] (depends on: [ids])`
2. **Generate** 2–3 candidate outputs internally; select the strongest
3. **Execute** the node's objective fully and substantively
4. **Score** the output: `Quality: [X/10] — [one-line rationale]`
5. **Log** the key finding: `Key finding: [one sentence]`

For parallel nodes, execute sequentially but label them clearly:
```
▶ PARALLEL BRANCH A — NODE [id]: [Name]
  [output]

▶ PARALLEL BRANCH B — NODE [id]: [Name]
  [output]

▶ MERGE: [How Branch A + B combine or contrast]
```

---

### PHASE 2: AGGREGATE & REFINE

After all leaf nodes complete:
- Explicitly list any contradictions found across nodes
- Resolve each contradiction with a rationale
- Produce the refined synthesis

---

### PHASE 3: SYNTHESIS BLOCK

Always close with this block — this is the payoff:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DAG SYNTHESIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Final output — fully synthesized, refined, complete]

Confidence: [X]%  |  Nodes: [N]  |  Parallel branches: [P]

vs. Vanilla Claude (what linear reasoning would have missed):
  • [Dependency that would have been ignored]
  • [Contradiction that would have slipped through]  
  • [Branch or angle that would have been flattened]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## MODES

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Full** | Default / "DAG: [goal]" / "use DAG for [goal]" | Plan all nodes → execute all → synthesize |
| **Preview** | "DAG preview: [goal]" | Impact assessment only, no execution |
| **Step** | "DAG step mode: [goal]" | Execute one node at a time, pause for approval |
| **Re-run** | "Re-run node [N]" / "Update node [N] with [info]" | Re-execute node + cascade downstream only |
| **Resume** | "Continue DAG" / "Next node" | Continue from last completed node |

---

## NODE TYPE REFERENCE

| Type | Purpose |
|------|---------|
| `research` | Gather or analyze information from a specific angle |
| `analysis` | Process and evaluate outputs from upstream nodes |
| `synthesis` | Merge outputs from multiple branches into a unified view |
| `validation` | Check for errors, gaps, inconsistencies, or logical flaws |
| `creative` | Generate options, variants, or novel framings |
| `decision` | Score alternatives and select with explicit rationale |

---

## SCALE GUIDELINES

| DAG Size | Nodes | Use When |
|----------|-------|----------|
| Micro | 3–5 | Quick structured task, light planning |
| Standard | 6–10 | Typical complex goal |
| Large | 11–20 | Deep research, full project planning |
| Huge | 20+ | Use **Step Mode**; add compression nodes every 8–10 |

**Compression node pattern** (for Large/Huge DAGs):
```xml
<node id="C1" name="Compress Nodes 1–8" type="synthesis" depends="[1,2,3,4,5,6,7,8]">
  <objective>Summarize key findings from nodes 1–8 into dense reference block; discard verbosity</objective>
</node>
```

---

## QUALITY RULES

1. **Never skip the plan phase.** Showing the DAG before executing is what makes this legible.
2. **Never flatten parallel branches.** If nodes run in parallel, show them separately, then merge.
3. **Always produce the Synthesis Block.** The `vs. Vanilla Claude` section is the proof of value.
4. **Score every node.** Even a simple `Quality: 8/10 — complete and consistent` builds trust.
5. **Respect dependencies strictly.** Never reference node N's output before node N executes.
6. **Use Step Mode for huge DAGs or uncertain users.** Don't flood context unnecessarily.

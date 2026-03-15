# DAG to Production Orchestration: Complete Mappings

When you've decomposed a complex task using the DAG Skill, the next step is porting that
structure to a real orchestration tool. This guide shows you how the mapping works for the
most popular frameworks.

**TL;DR:** Your DAG nodes → agent/task definitions. Your DAG dependencies → graph edges.
Mapping takes 20–30 minutes and is purely mechanical.

---

## Real Example: Go-to-Market Strategy

### Your DAG (Claude DAG Skill — 5 minutes)

```
User: "DAG: Design a go-to-market plan for a new B2B SaaS product"

Claude outputs:
<node id="1" name="Market Research & Sizing" depends="[]" parallel_with="2"/>
<node id="2" name="Competitive Landscape" depends="[]" parallel_with="1"/>
<node id="3" name="Customer Personas & Jobs-to-be-Done" depends="[1,2]"/>
<node id="4" name="Messaging & Value Prop" depends="[3]" parallel_with="5"/>
<node id="5" name="Pricing Strategy" depends="[3]" parallel_with="4"/>
<node id="6" name="Channel Strategy" depends="[3,4,5]"/>
<node id="7" name="Go-to-Market Roadmap & Risk" depends="[6]" type="synthesis"/>
```

**Key insight:** You now know:
- What *must* happen first (market research + competitive analysis)
- What can happen in parallel (messaging + pricing)
- What depends on everything else (the GTM roadmap is the synthesis)
- The critical path (1→2→3→6→7)

---

## Mapping 1: LangGraph (Python)

### Option A: Simple Sequential Mapping

```python
from langgraph.graph import StateGraph, START, END
from typing import TypedDict

class GTMState(TypedDict):
    market_research: str
    competitive_analysis: str
    personas: str
    messaging: str
    pricing: str
    channels: str
    roadmap: str

graph = StateGraph(GTMState)

# Add nodes (1:1 from your DAG)
graph.add_node("market_research_agent", run_market_research)
graph.add_node("competitive_agent", run_competitive_analysis)
graph.add_node("personas_agent", run_personas)
graph.add_node("messaging_agent", run_messaging)
graph.add_node("pricing_agent", run_pricing)
graph.add_node("channels_agent", run_channels)
graph.add_node("synthesis_agent", run_synthesis)

# Add edges (1:1 from your DAG dependencies)
graph.add_edge(START, "market_research_agent")
graph.add_edge(START, "competitive_agent")  # Parallel with market research

graph.add_edge("market_research_agent", "personas_agent")
graph.add_edge("competitive_agent", "personas_agent")

graph.add_edge("personas_agent", "messaging_agent")  # Parallel with pricing
graph.add_edge("personas_agent", "pricing_agent")

graph.add_edge(["messaging_agent", "pricing_agent"], "channels_agent")
graph.add_edge("channels_agent", "synthesis_agent")
graph.add_edge("synthesis_agent", END)

app = graph.compile()
```

### Option B: With Parallel Execution

```python
from concurrent.futures import ThreadPoolExecutor

# For nodes that run in parallel, group them:
graph.add_node("parallel_market_research", run_market_research)
graph.add_node("parallel_competitive", run_competitive_analysis)

# Then merge before next step
graph.add_node("merge_research", merge_research_results)

graph.add_edge(START, "parallel_market_research")
graph.add_edge(START, "parallel_competitive")
graph.add_edge("parallel_market_research", "merge_research")
graph.add_edge("parallel_competitive", "merge_research")
graph.add_edge("merge_research", "personas_agent")
```

**Key mapping:**
- Each `<node>` in your DAG → one `graph.add_node()`
- Each dependency `depends="[1,2]"` → `graph.add_edge([node1, node2], next_node)`
- Each `parallel_with` → parallel edges from the same upstream node

---

## Mapping 2: CrewAI (Python)

### Basic Mapping

```python
from crewai import Agent, Task, Crew

# Define agents (1 per DAG node)
market_research_agent = Agent(
    role="Market Research Analyst",
    goal="Analyze market size and trends",
    backstory="Expert in market research for B2B SaaS"
)

competitive_agent = Agent(
    role="Competitive Analyst",
    goal="Map competitive landscape",
    backstory="Expert in competitive intelligence"
)

# ... define remaining agents ...

# Define tasks (1 per DAG node, with dependencies)
market_research_task = Task(
    description="Research the target market",
    agent=market_research_agent
)

competitive_task = Task(
    description="Analyze competitors",
    agent=competitive_agent
)

personas_task = Task(
    description="Define customer personas",
    agent=personas_agent,
    depends_on=[market_research_task, competitive_task]  # depends="[1,2]"
)

messaging_task = Task(
    description="Craft value prop messaging",
    agent=messaging_agent,
    depends_on=[personas_task]  # depends="[3]"
)

pricing_task = Task(
    description="Develop pricing strategy",
    agent=pricing_agent,
    depends_on=[personas_task]  # depends="[3]", parallel with messaging
)

channels_task = Task(
    description="Design channel strategy",
    agent=channels_agent,
    depends_on=[messaging_task, pricing_task]  # depends="[4,5]"
)

synthesis_task = Task(
    description="Synthesize GTM roadmap",
    agent=synthesis_agent,
    depends_on=[channels_task]  # depends="[6]"
)

# Create crew with tasks in order
crew = Crew(
    agents=[
        market_research_agent, competitive_agent, personas_agent,
        messaging_agent, pricing_agent, channels_agent, synthesis_agent
    ],
    tasks=[
        market_research_task, competitive_task, personas_task,
        messaging_task, pricing_task, channels_task, synthesis_task
    ],
    verbose=True
)

result = crew.kickoff()
```

**Key mapping:**
- Each `<node>` → one `Agent` + one `Task`
- DAG `depends="[1,2]"` → `Task(..., depends_on=[task1, task2])`
- CrewAI handles parallelism automatically based on dependencies

---

## Mapping 3: n8n (Visual / No-Code)

### Workflow Structure

```
[Start]
  ├─→ Market Research Node
  ├─→ Competitive Analysis Node
      ├─→ [Split Node: Run in Parallel]
      │   ├─→ Messaging Node
      │   └─→ Pricing Node
      └─→ [Merge Node]
          └─→ Channels Node
              └─→ Synthesis Node (HTTP Call or Code Node)
              └─→ [End]
```

### Step-by-Step n8n Setup

1. **Create nodes** (1 per DAG node):
   - Market Research → HTTP node calling Claude API
   - Competitive Analysis → HTTP node
   - Personas → Code node processing previous outputs
   - Etc.

2. **Create connections** (1 per DAG edge):
   ```
   Market Research → (output) → Personas Input
   Competitive Analysis → (output) → Personas Input
   Personas → (output) → Messaging Input
   Personas → (output) → Pricing Input
   ```

3. **Parallel branches** (for your `parallel_with`):
   - After Personas node, add a Split node
   - Route to both Messaging and Pricing
   - Add Merge node to recombine

4. **Synthesis node** (at the end):
   - Code node or HTTP call that aggregates all previous outputs
   - Formats final GTM roadmap

**Key mapping:**
- Each `<node>` → one n8n node (HTTP, Code, Webhook, etc.)
- Each dependency `depends="[A,B]"` → connect A and B to the input
- `parallel_with` → use Split node + recombine with Merge

---

## Mapping 4: Anthropic Sub-Agents (Coming)

When Sub-Agents become available in Claude Code, the mapping is even simpler:

```python
from anthropic import Anthropic

client = Anthropic()

# Define the DAG structure
workflow_config = {
    "nodes": [
        {"id": 1, "name": "market_research", "type": "agent"},
        {"id": 2, "name": "competitive_analysis", "type": "agent"},
        {"id": 3, "name": "personas", "type": "agent", "depends_on": [1, 2]},
        {"id": 4, "name": "messaging", "type": "agent", "depends_on": [3]},
        {"id": 5, "name": "pricing", "type": "agent", "depends_on": [3]},
        {"id": 6, "name": "channels", "type": "agent", "depends_on": [4, 5]},
        {"id": 7, "name": "synthesis", "type": "agent", "depends_on": [6]},
    ],
    "parallelism": {
        1: [2],  # nodes 1 and 2 run in parallel
        4: [5],  # nodes 4 and 5 run in parallel
    }
}

# Execute the workflow
result = client.orchestrate_dag(workflow_config)
```

**Key insight:** Your DAG structure is the config. No rewriting needed.

---

## The Pattern (All Tools)

Regardless of tool, the mapping follows the same pattern:

```
Your DAG                Real Tool
─────────────           ──────────
<node 1>        →       Agent/Task 1
<node 2>        →       Agent/Task 2
...

<node i>        ↑
depends=[j,k]   →       edge(j → i) + edge(k → i)

parallel_with   →       Parallel branch (tool-dependent)

type=synthesis  →       Aggregator node
```

---

## Real Timeline

| Step | Time | Effort |
|------|------|--------|
| Use DAG Skill to decompose | 5 min | Think |
| Choose orchestration tool | 10 min | Research |
| Set up basic agent structure | 15 min | Copy/paste |
| Map nodes → agents/tasks | 20 min | Mechanical |
| Implement agent logic (per node) | Hours–days | The real work |
| Test & iterate | Ongoing | Normal dev |

**Key insight:** Steps 1–4 take ~50 minutes. Step 5 (the actual agent logic) is what takes real time.
But you know the structure going in, so step 5 is isolated and clear.

---

## When You're Ready to Graduate

You're ready to move from DAG Skill to real orchestration when:

- [ ] You've run DAGs 5+ times
- [ ] You can explain why nodes are ordered the way they are
- [ ] You recognize parallel vs. sequential patterns instantly
- [ ] You've seen your DAG mapped to at least one real tool
- [ ] You know which tool fits your use case
- [ ] You're building something that genuinely needs real agents (not just better Claude)

Then:

1. Pick a tool (LangGraph for custom, CrewAI for teams, n8n for visual, Sub-Agents for Claude)
2. Copy your DAG structure as the scaffold
3. Implement the agent logic for each node
4. Deploy

The decomposition (the hard part) is already done. The execution (straightforward) is now your only job.

---

## Example: From DAG to Deployed Agent System

**Week 1:** Use DAG Skill, decompose problem (5 min)
**Week 2:** Pick LangGraph, set up basic structure (30 min)
**Week 3–4:** Implement agent logic per node (20 hours)
**Week 5:** Test, iterate, deploy

Total time saved by having a clear DAG going in: ~10 hours (no trial-and-error on structure).

---

## Questions?

If you have a specific tool you want to map to, ask Claude:
```
"I have a DAG with 6 nodes. Show me how to map it to [tool name]"
```

Claude can show you the exact code or workflow steps.

The structure is universal. The syntax is what changes.

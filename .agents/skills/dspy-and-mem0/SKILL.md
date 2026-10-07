---
name: dspy-and-mem0
description: Algorithmic prompt compiler (DSPy) and persistent self-editing memory layer (Mem0). Use when building auto-optimizing prompt pipelines or human-like long-term memory for AI agents.
---

# DSPy & Mem0 Skill

Both `dspy` (v3.4.0) and `mem0` (v2.2.1) are installed in the global Python environment.

## 1. DSPy (Programming, Not Prompting)

Instead of trial-and-error prompt tweaking, define your task modularly and let DSPy compile the optimal prompt:

```python
import dspy

# 1. Define Signature (Input -> Output)
class QA(dspy.Signature):
    """Answer question with verified academic reasoning."""
    context = dspy.InputField(desc="Course notes or lecture transcript")
    question = dspy.InputField(desc="Exam or assignment question")
    answer = dspy.OutputField(desc="Precise, step-by-step solution")

# 2. Build Pipeline (ChainOfThought)
class QAPipeline(dspy.Module):
    def __init__(self):
        super().__init__()
        self.generate_answer = dspy.ChainOfThought(QA)

    def forward(self, context, question):
        return self.generate_answer(context=context, question=question)

# 3. DSPy Teleprompter/Optimizer automatically refines prompts using few-shot metrics
```

## 2. Mem0 (Long-Term Self-Editing Memory)

Add human-like perpetual memory to any agent:

```python
import numpy # ensure numpy is loaded
from mem0 import Memory

m = Memory()

# Store user profile, preferences, or dynamic project facts
m.add("User is studying Data Structures and prefers Dijkstra table format with visited status", user_id="student_1")

# Retrieve relevant memories dynamically
memories = m.search("How should I format the graph algorithm solution?", user_id="student_1")
for entry in memories:
    print(entry['memory'])
```

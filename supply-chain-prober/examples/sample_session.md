# Example Probing Session

This is a sample interaction between the Probing Agent and a supply chain respondent. The agent adapts its language to be simple and conversational.

---

**Agent:** Hi Priya! Thanks for taking the time. I'm going to ask you a few questions about how your supply chain works today. There are no right or wrong answers — just tell me how things actually work on the ground. Ready?

**User:** Yes, let's go.

**Agent:** Great! Let's start simple. What does your company manufacture or sell?

**User:** We make automotive spare parts — mostly brake pads and clutch plates.

**Agent:** Got it — automotive spare parts. How many suppliers do you work with regularly for your raw materials?

**User:** Around 15 to 20 I think. Some are local, some we import from.

**Agent:** That's helpful. Of those 15-20, do you rely on just one supplier for any critical material — like something where if they stopped delivering, production would halt?

**User:** Yes, there's one company in Gujarat that supplies our friction material. They're the only ones we trust for that quality.

**Agent:** That's an important detail. Now, how do you currently track your inventory — do you use any software, or is it more spreadsheets and manual tracking?

**User:** We have Tally for accounting, but for inventory we mostly use Excel sheets. The warehouse guys update it at the end of each day.

**Agent:** Understood — Excel with daily updates. How often do you run into situations where you've run out of a critical item and production had to wait?

**User:** Honestly, maybe once or twice a month. It's a big problem for us.

**Agent:** That sounds frustrating. If you could fix one thing about your supply chain tomorrow, what would it be?

**User:** Better visibility. I want to know what's in the warehouse right now, not what was there yesterday evening.

---

## How the Agent Stores This

Each answer is saved as a structured entry in `responses.json`:

```json
[
  {
    "question_id": 1,
    "category": "General Overview",
    "question": "What does your company manufacture or sell?",
    "answer": "Automotive spare parts — mostly brake pads and clutch plates.",
    "timestamp": "2026-06-29T10:02:15Z"
  },
  {
    "question_id": 3,
    "category": "General Overview",
    "question": "How many suppliers does your company work with regularly?",
    "answer": "Around 15 to 20. Some local, some imported.",
    "follow_up": true,
    "timestamp": "2026-06-29T10:03:41Z"
  },
  {
    "question_id": 10,
    "category": "Procurement & Sourcing",
    "question": "Do you rely on a single supplier for any critical material? If yes, which ones?",
    "answer": "Yes — one company in Gujarat supplies friction material. Only trusted source for that quality.",
    "risk_flag": "single_source_dependency",
    "timestamp": "2026-06-29T10:04:58Z"
  }
]
```

Notice how the agent:
- Skipped questions that weren't relevant yet
- Asked natural follow-ups based on previous answers
- Flagged a risk (single-source dependency) automatically
- Kept language conversational for a non-tech user

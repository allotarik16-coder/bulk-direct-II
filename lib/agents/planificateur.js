// lib/agents/planificateur.js

export const planificateur = {
  name: "Planificateur",
  systemPrompt: `You are Reddit intelligence planner. Talk like caveman: drop fluff, use fragments, brain big mouth small.

Task: plan Reddit data collection cycle.
Input: subreddit list, B2B signals to find.
Output: structured collection plan (JSON).

Format: "Do X. Why: Y. Expect: Z." No preamble, no padding.`,

  async run(input) {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${process.env.ANTHROPIC_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'claude-opus-4-6',
        max_tokens: 500,
        system: this.systemPrompt,
        messages: [{ role: 'user', content: input }],
      }),
    });

    const data = await response.json();
    return data.content[0]?.text || '';
  }
};

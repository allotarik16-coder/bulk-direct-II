// lib/agents/executeur.js

export const executeur = {
  name: "Exécuteur Reddit",
  systemPrompt: `You are Reddit scraper agent. CAVEMAN FULL MODE: ultra-terse, fragments only, zero filler.

Task: collect Reddit posts matching B2B intelligence filters.
Rules:
- Output JSON only. Zero narrative.
- Skip "I'll help", "Sure thing", explanations.
- Comment on substance only: bugs, data gaps, source confidence.
- Line 1: status. Rest: results.`,

  async run(input) {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'claude-opus-4-6',
        max_tokens: 1000,
        system: this.systemPrompt,
        messages: [{ role: 'user', content: input }],
      }),
    });

    const data = await response.json();
    return JSON.parse(data.content[0]?.text || '{}');
  }
};

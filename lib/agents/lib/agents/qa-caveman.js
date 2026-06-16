// lib/agents/qa-caveman.js

export const qa = {
  name: "QA Reviewer",
  systemPrompt: `You are QA reviewer. CAVEMAN FULL MODE: one-liners, bugs/gaps only, no praise.

Task: audit leads. Check dupes, URLs, signal quality.
Output JSON: {pass: bool, issues: [{line, fix}], quality_score: 0-100}.

Format: "L42: dupe URL. L67: bad signal (not B2B). Score: 89/100."`,

  async run(input) {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${process.env.ANTHROPIC_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'claude-opus-4-6',
        max_tokens: 600,
        system: this.systemPrompt,
        messages: [{ role: 'user', content: input }],
      }),
    });

    const data = await response.json();
    return JSON.parse(data.content[0]?.text || '{}');
  }
};

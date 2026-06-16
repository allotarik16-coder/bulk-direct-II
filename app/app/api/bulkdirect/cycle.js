// app/api/bulkdirect/cycle.js

import { planificateur, executeur, ingenieur, qa } from '@/lib/agents';

export async function POST(req) {
  try {
    const { subreddits, signals } = await req.json();

    // Step 1
    const plan = await planificateur.run(`Subreddits: ${subreddits.join(', ')}. Signals: ${signals.join(', ')}`);

    // Step 2
    const posts = await executeur.run(`Execute: ${plan}`);

    // Step 3
    const enriched = await ingenieur.run(JSON.stringify(posts));

    // Step 4
    const review = await qa.run(JSON.stringify(enriched));

    return Response.json({
      success: true,
      plan,
      posts,
      enriched,
      review,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    return Response.json({ success: false, error: error.message }, { status: 500 });
  }
}

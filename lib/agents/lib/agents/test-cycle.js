// lib/agents/test-cycle.js

import { planificateur, executeur, ingenieur, qa } from './index.js';

export async function runRedditCycle(subreddits, signals) {
  console.log('🚀 BulkDirect Caveman Cycle Started');
  
  try {
    // Step 1: Planificateur
    console.log('📋 Planificateur: creating plan...');
    const planInput = `Subreddits: ${subreddits.join(', ')}. Signals: ${signals.join(', ')}`;
    const plan = await planificateur.run(planInput);
    console.log('✓ Plan:', plan.substring(0, 100) + '...');

    // Step 2: Executeur
    console.log('🔍 Executeur: scraping Reddit...');
    const executionInput = `Execute: ${plan}`;
    const posts = await executeur.run(executionInput);
    console.log('✓ Found posts:', posts.count || Object.keys(posts).length);

    // Step 3: Ingenieur
    console.log('⚙️ Ingenieur: enriching leads...');
    const enrichInput = JSON.stringify(posts);
    const enriched = await ingenieur.run(enrichInput);
    console.log('✓ Enriched leads:', enriched.count || Object.keys(enriched).length);

    // Step 4: QA
    console.log('✅ QA: reviewing quality...');
    const qaInput = JSON.stringify(enriched);
    const review = await qa.run(qaInput);
    console.log('✓ Quality score:', review.quality_score || 'N/A');
    console.log('✓ Issues found:', review.issues?.length || 0);

    return {
      success: true,
      plan,
      posts,
      enriched,
      review,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    console.error('❌ Cycle failed:', error.message);
    return { success: false, error: error.message };
  }
}

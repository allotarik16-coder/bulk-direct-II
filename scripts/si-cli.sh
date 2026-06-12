#!/bin/bash
# si-cli.sh — Self-Improving Agent for BulkDirect
# Usage: ./scripts/si-cli.sh [review|promote|extract|status|cleanup]

set -euo pipefail

# Configuration
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
LEARNINGS_FILE="${PROJECT_ROOT}/LEARNINGS.md"
CLAUDE_MD="${PROJECT_ROOT}/CLAUDE.md"
RULES_DIR="${PROJECT_ROOT}/.claude/rules"
CONFIG_FILE="${PROJECT_ROOT}/.claude/config.json"

# Supabase config (from env or GitHub Secrets)
SUPABASE_URL="${SUPABASE_URL:-}"
SUPABASE_KEY="${SUPABASE_KEY:-}"
SUPABASE_PROJECT="icpdgjzlmdculnrxmjiy"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "${GREEN}✅${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}⚠️${NC} $1"
}

log_error() {
  echo -e "${RED}❌${NC} $1" >&2
}

# Initialize
init_memory() {
  if [ ! -f "$LEARNINGS_FILE" ]; then
    log_warning "LEARNINGS.md not found. Creating..."
    cat > "$LEARNINGS_FILE" << 'EOF'
# Memory Learnings — BulkDirect Pipeline

Automatically curated patterns from 4-agent orchestration.
Promote proven patterns via /si:promote.
Extract reusable solutions via /si:extract.

## Reddit Scraper Patterns

## Pipeline Orchestration Patterns

## Error Recovery Patterns

## Testing Patterns

## Deployment Patterns
EOF
    log_success "Created $LEARNINGS_FILE"
  fi

  mkdir -p "$RULES_DIR"
}

# Command: review
cmd_review() {
  init_memory
  
  log_info "🔍 Memory Review — BulkDirect Pipeline"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo

  # Count lines
  local lines=$(wc -l < "$LEARNINGS_FILE" 2>/dev/null || echo 0)
  local max_lines=$(grep -o '"max_lines": [0-9]*' "$CONFIG_FILE" 2>/dev/null | grep -o '[0-9]*' || echo 200)
  local percent=$((lines * 100 / max_lines))

  echo "📊 Capacity: $lines / $max_lines lines ($percent%)"
  
  if [ $percent -gt 90 ]; then
    log_warning "Near capacity! Consider promoting or extracting patterns."
  elif [ $percent -gt 60 ]; then
    log_warning "Getting full (60-90%). Run promotions soon."
  else
    log_success "Plenty of room ($percent%)"
  fi
  echo

  # Find entries without promoted marker
  echo "🎯 Promotion Candidates (recurring patterns):"
  grep -E "^##" "$LEARNINGS_FILE" | nl | head -5
  echo
  
  # Show rules directory
  if [ -d "$RULES_DIR" ] && [ "$(ls -A "$RULES_DIR")" ]; then
    echo "📋 Active Rules ($(ls "$RULES_DIR"/*.md 2>/dev/null | wc -l) files):"
    ls -1 "$RULES_DIR"/*.md 2>/dev/null | xargs -I {} basename {} | sed 's/.md//' | sed 's/^/  ✓ /'
  else
    echo "📋 No active rules yet. Run /si:promote to graduate patterns."
  fi
  echo

  echo "💡 Next: /si:promote <pattern_name>"
}

# Command: promote
cmd_promote() {
  local pattern_name="${1:-}"
  
  if [ -z "$pattern_name" ]; then
    log_error "Usage: si-cli.sh promote <pattern_name>"
    exit 1
  fi

  init_memory

  log_info "Promoting pattern: $pattern_name"
  
  # Infer category from LEARNINGS.md
  local category=$(grep -B2 "$pattern_name" "$LEARNINGS_FILE" | grep "##" | head -1 | sed 's/## //' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  
  if [ -z "$category" ]; then
    log_warning "Could not infer category. Using 'general'."
    category="general"
  fi

  # Create .claude/rules/{category}.md
  local rule_file="${RULES_DIR}/${category}.md"
  
  if [ ! -f "$rule_file" ]; then
    cat > "$rule_file" << EOF
---
category: $category
applies_to: ["src/**/*.ts", "src/**/*.js"]
priority: high
---

# Pattern: $pattern_name

**Promoted from LEARNINGS.md**

## Rule
[Paste your pattern description here]

## Code Example
\`\`\`typescript
// TODO: Add example code
\`\`\`

## When to Apply
- [Condition 1]
- [Condition 2]

## Related
- Category: $category
- Extracted by: /si:promote
EOF
    log_success "Created rule: $rule_file"
  else
    log_warning "Rule file exists: $rule_file (edit manually to append)"
  fi

  # Remove from LEARNINGS.md (mark as promoted)
  sed -i.bak "/$pattern_name/s/^/[PROMOTED] /" "$LEARNINGS_FILE"
  rm -f "${LEARNINGS_FILE}.bak"
  
  log_success "Pattern promoted to $rule_file"
  
  # Optional: Sync to Supabase
  if [ -n "$SUPABASE_URL" ] && [ -n "$SUPABASE_KEY" ]; then
    log_info "Syncing to Supabase..."
    sync_to_supabase "$pattern_name" "$category" "promoted"
  fi

  echo
  echo "✏️  Edit $rule_file to add detailed rule content"
  echo "📌 Commit to apply: git add $rule_file && git commit -m 'promote: $pattern_name'"
}

# Command: extract
cmd_extract() {
  local pattern_name="${1:-}"
  local skill_name="${2:-}"
  local output_dir="${3:-.}"

  if [ -z "$pattern_name" ]; then
    log_error "Usage: si-cli.sh extract <pattern_name> [--name skill-name] [--output ./skills]"
    exit 1
  fi

  # Default skill name from pattern
  if [ -z "$skill_name" ]; then
    skill_name=$(echo "$pattern_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  fi

  local skill_dir="${output_dir}/${skill_name}"
  
  log_info "Extracting skill: $skill_name"
  
  mkdir -p "$skill_dir"
  
  # Create SKILL.md template
  cat > "${skill_dir}/SKILL.md" << EOF
---
name: $skill_name
description: "$pattern_name. Use when: implementing this pattern in BulkDirect pipeline."
---

# $skill_name

> Extracted from BulkDirect self-improving-agent memory.

## Overview
[Description of pattern]

## Installation

\`\`\`bash
/plugin install $skill_name@bulk-direct
\`\`\`

## Quick Reference

| Command | Purpose |
|---------|---------|
| [cmd1] | [purpose] |
| [cmd2] | [purpose] |

## Usage

### Example 1
\`\`\`typescript
// TODO: Add code example
\`\`\`

## Related
- Category: [category]
- Promoted: $(date +%Y-%m-%d)
- Original pattern: $pattern_name

EOF

  log_success "Skill template created: ${skill_dir}/SKILL.md"
  
  # Create README
  cat > "${skill_dir}/README.md" << EOF
# $skill_name

BulkDirect skill extracted from self-improving-agent memory.

## Quick Start

See SKILL.md for usage and

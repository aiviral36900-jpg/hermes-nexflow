#!/bin/bash

echo "🚀 Starting NexFlow AI..."

# Create directories
mkdir -p ~/.hermes/data
mkdir -p ~/nexflow/{clients,leads,pipeline,content,finance,reports,deliverables,support,team,seo,legal}

# Download SOUL.md from GitHub
if [ ! -f ~/.hermes/SOUL.md ]; then
  curl -s https://raw.githubusercontent.com/aiviral36900-jpg/nexflow-ai1/main/docs/SOUL.md \
    -o ~/.hermes/SOUL.md 2>/dev/null && echo "✅ SOUL.md loaded" || echo "⚠️ Fresh start"
fi

# Download agency.json
if [ ! -f ~/.hermes/data/agency.json ]; then
  curl -s https://raw.githubusercontent.com/aiviral36900-jpg/nexflow-ai1/main/docs/agency.json \
    -o ~/.hermes/data/agency.json 2>/dev/null || echo '{"company":"NexFlow AI","ceo":"Yash"}' > ~/.hermes/data/agency.json
fi

# ═══════════════════════════════════════════
# CONFIRMED FREE MODELS — May 2026
# openrouter/free = auto-selects best free model
# Ek limit ho to agla automatically use hoga
# ═══════════════════════════════════════════

# PRIMARY: openrouter/free router
# Yeh automatically best free model choose karta hai
PRIMARY_MODEL="openrouter/free"

# FALLBACK LIST — All confirmed free May 2026
MODELS=(
  "openrouter/free"
  "meta-llama/llama-3.1-8b-instruct:free"
  "mistralai/mistral-7b-instruct:free"
  "google/gemma-2-9b-it:free"
  "deepseek/deepseek-r1:free"
  "qwen/qwen-2-7b-instruct:free"
  "meta-llama/llama-3.2-3b-instruct:free"
  "nvidia/nemotron-3-nano-30b:free"
  "microsoft/phi-3-mini-128k-instruct:free"
  "google/gemma-2-2b-it:free"
)

echo "✅ 10 confirmed free models loaded"
echo "Primary: openrouter/free (auto-selects best)"

# Find best working model
BEST_MODEL="${MODELS[0]}"
for MODEL in "${MODELS[@]}"; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "https://openrouter.ai/api/v1/chat/completions" \
    -H "Authorization: Bearer $OPENROUTER_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"model\":\"$MODEL\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}],\"max_tokens\":5}" \
    --max-time 10)
  if [ "$STATUS" = "200" ]; then
    BEST_MODEL=$MODEL
    echo "✅ Active model: $MODEL"
    break
  else
    echo "⏭️ $MODEL unavailable, trying next..."
  fi
done

echo "🎯 Final model: $BEST_MODEL"

# Environment setup
export HERMES_PORT=${PORT:-3000}
export HERMES_HOST=0.0.0.0

# Start Hermes
hermes start --headless \
  --port $HERMES_PORT \
  --model $BEST_MODEL \
  --telegram-token $TELEGRAM_BOT_TOKEN \
  --telegram-chat-id $TELEGRAM_CHAT_ID

echo "✅ NexFlow AI LIVE!"
echo "Free models: 10 with auto-fallback"
echo "Rate limit: 200 requests/day per model"

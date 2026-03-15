#!/bin/bash
# ─────────────────────────────────────────────────────────────────
# Claude DAG Skill — Installer
# Usage: bash install.sh
# ─────────────────────────────────────────────────────────────────

set -e

SKILL_NAME="dag-simulator"
SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "🧠 Claude DAG Skill Installer"
echo "────────────────────────────────────"

# Check we're running from the right place
if [ ! -f "$SCRIPT_DIR/SKILL.md" ]; then
  echo "❌ Error: SKILL.md not found. Run this script from the claude-dag-skill directory."
  exit 1
fi

# Create skills directory if it doesn't exist
if [ ! -d "$SKILLS_DIR" ]; then
  echo "📁 Creating ~/.claude/skills directory..."
  mkdir -p "$SKILLS_DIR"
fi

TARGET="$SKILLS_DIR/$SKILL_NAME"

# Remove existing installation
if [ -d "$TARGET" ] || [ -L "$TARGET" ]; then
  echo "♻️  Removing existing installation at $TARGET"
  rm -rf "$TARGET"
fi

# Install via symlink (preferred — picks up updates automatically)
echo "🔗 Symlinking $SCRIPT_DIR → $TARGET"
ln -s "$SCRIPT_DIR" "$TARGET"

echo ""
echo "✅ DAG Skill installed!"
echo ""
echo "📍 Location: $TARGET"
echo ""
echo "🚀 Try it in Claude Code:"
echo "   'DAG preview: [your complex goal]'"
echo "   'DAG: analyze [topic] from multiple angles'"
echo "   'Use DAG mode for: [planning task]'"
echo ""
echo "📦 To uninstall:"
echo "   rm -rf $TARGET"
echo ""

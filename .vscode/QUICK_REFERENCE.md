# Quick Reference: VS Code Auto-Format & CI

## 🎯 Goal Achieved
✅ VS Code auto-formatting matches GitHub Actions CI exactly

## 🔧 What Was Configured

### Files Created/Modified
- `.vscode/settings.json` - Auto-format on save configuration
- `.vscode/extensions.json` - Recommended extensions
- `.vscode/SETUP.md` - Complete setup guide
- `.vscode/ALIGNMENT_VERIFIED.md` - CI alignment verification
- `bin/pre-push-check` - Local CI simulation script

### Key Settings
```json
{
  "rubyLsp.formatter": "rubocop",  // Uses your .rubocop.yml
  "editor.formatOnSave": true,     // Auto-format on save
  "[ruby]": {
    "editor.defaultFormatter": "Shopify.ruby-lsp"
  }
}
```

## 🚀 Quick Start

1. **Install missing extensions** (VS Code will prompt you)
   - Prettier
   - Tailwind CSS IntelliSense

2. **Save any file** → Auto-formats immediately

3. **Before pushing**, run:
   ```bash
   ./bin/pre-push-check
   ```

## ⚡ Keyboard Shortcuts

- **Format document**: `Shift+Alt+F` (Win/Linux) or `Shift+Option+F` (Mac)
- **Format selection**: `Ctrl+K Ctrl+F`
- **Save (triggers auto-format)**: `Ctrl+S` or `Cmd+S`

## 🎓 Understanding the Setup

### Your GitHub Actions Lint Job
```yaml
# From .github/workflows/ci.yml line 65
- name: Lint code for consistent style
  run: bin/rubocop -f github
```

### VS Code Uses Same Config
```
Your .rubocop.yml
    ↓
inherit_gem: { rubocop-rails-omakase: rubocop.yml }
    ↓
Ruby LSP → RuboCop → Auto-format on save
    ↓
Exactly matches CI requirements ✅
```

## 📊 Current Status

```bash
# As of now:
$ bin/rubocop
59 files inspected, no offenses detected ✅

$ bin/rails test
21 runs, 41 assertions, 0 failures, 0 errors ✅

$ bin/brakeman --no-pager
No warnings found ✅

$ bin/bundler-audit
No vulnerabilities found ✅
```

## 🛡️ Preventing CI Failures

### Before (Manual)
1. Write code
2. Push to GitHub
3. CI fails with linting errors ❌
4. Fix locally
5. Push again
6. Repeat...

### After (Automated)
1. Write code
2. Save file → Auto-formats ✅
3. Run `./bin/pre-push-check` ✅
4. Push to GitHub
5. CI passes ✅
6. Done!

## 📝 Notes

- **RuboCop version**: 1.81.7
- **Rails version**: 8.1.1
- **Ruby version**: 3.4.7
- **Config**: rubocop-rails-omakase (Omakase Ruby styling)

All formatting rules are inherited from the official Rails Omakase style guide.

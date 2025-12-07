# VS Code Auto-Format Setup

## ✅ GitHub Actions Alignment

This VS Code configuration is **aligned with your GitHub Actions CI pipeline** (`.github/workflows/ci.yml`):

- Uses **RuboCop** for formatting (via Ruby LSP)
- Uses your `.rubocop.yml` configuration (inherits from `rubocop-rails-omakase`)
- Same linting rules as `bin/rubocop -f github` in CI
- Auto-formats on save to prevent CI failures

## Required Extensions

Install these VS Code extensions for auto-formatting to work:

1. **Shopify Ruby LSP** (`Shopify.ruby-lsp`) ✅ - Primary Ruby formatter using RuboCop
2. **Prettier** (`esbenp.prettier-vscode`) - For JavaScript, JSON, YAML formatting  
3. **ERB Beautify** (`aliariff.vscode-erb-beautify`) ✅ - For ERB template formatting
4. **Tailwind CSS IntelliSense** (`bradlc.vscode-tailwindcss`) - For Tailwind classes

✅ = Already installed

### Quick Install

VS Code will prompt you to install the recommended extensions when you open this project. Click "Install All" or run:

```bash
# Install via command line (if needed)
code --install-extension Shopify.ruby-lsp
code --install-extension esbenp.prettier-vscode
code --install-extension aliariff.vscode-erb-beautify
code --install-extension bradlc.vscode-tailwindcss
```

## What's Configured

The `.vscode/settings.json` enables:

- ✅ **Format on save** for all file types
- ✅ **RuboCop formatting** for Ruby files (using your `.rubocop.yml` config)
- ✅ **Trim trailing whitespace** on save
- ✅ **Auto-insert final newline** in files
- ✅ **Auto-save** on focus change (optional)

## Manual Format Commands

If you need to manually format:

- **Format Document**: `Shift+Alt+F` (or `Shift+Option+F` on Mac)
- **Format Selection**: Select code, then `Ctrl+K Ctrl+F`

## Pre-Push Checks

Before pushing to GitHub, run the same checks as CI:

```bash
./bin/pre-push-check
```

This script mirrors your **GitHub Actions CI pipeline** and will:
1. ✅ Run RuboCop with `-f github` format (same as CI lint job)
2. ✅ Run Brakeman security scan (same as CI scan_ruby job)
3. ✅ Run Bundler Audit (same as CI scan_ruby job)
4. ✅ Run all tests (same as CI test job)

**If this script passes, your GitHub Actions CI will pass!**

## Fix All RuboCop Issues Automatically

To auto-fix RuboCop violations across the entire project:

```bash
bundle exec rubocop -A
```

## Manual Linting

Check for linting errors manually:

```bash
# Check all files
bundle exec rubocop

# Check specific file
bundle exec rubocop app/models/user.rb

# Auto-fix safe corrections
bundle exec rubocop -a

# Auto-fix all corrections (including unsafe)
bundle exec rubocop -A
```

## Troubleshooting

### Format on save not working?

1. Make sure Ruby LSP extension is installed and enabled
2. Restart VS Code
3. Check the bottom status bar shows "Ruby LSP" is active
4. Open the Output panel (View → Output) and select "Ruby LSP" to see any errors

### RuboCop not found?

Make sure gems are installed:
```bash
bundle install
```

### ERB files not formatting?

The ERB Beautify extension may need htmlbeautifier gem:
```bash
gem install htmlbeautifier
```

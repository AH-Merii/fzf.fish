# Contributing to fzf.fish

Thank you for your interest in contributing! This guide will help you get started.

## Getting Started

### Fork and Clone

1. Fork this repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/fzf.fish.git
   cd fzf.fish
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/AH-Merii/fzf.fish.git
   ```

### Create a Branch

Always create a new branch for your changes:

```bash
git checkout -b your-feature-name
```

Use descriptive branch names like `fix-history-search` or `add-preview-option`.

### Keep Your Fork Updated

Before starting work, sync with upstream:

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## Making Changes

### Development Setup

1. Install dependencies: [Fish](https://fishshell.com) 3.4.0+, [fzf](https://github.com/junegunn/fzf) 0.33.0+, [fd](https://github.com/sharkdp/fd) 8.5.0+, [bat](https://github.com/sharkdp/bat) 0.16.0+
2. Install the plugin from your local clone:
   ```fish
   fisher install .
   ```

### Local Development with Make

A Makefile is provided for common development tasks:

```bash
make help    # Show available commands
make test    # Run test suite
make lint    # Check formatting (fish_indent + prettier)
make format  # Auto-fix formatting issues
make check   # Run all checks (lint + test)
make ci      # Simulate full CI pipeline locally
```

### Running Tests

Run the test suite before submitting:

```bash
make test
# Or directly:
fishtape tests/*/*.fish
```

### Code Style

- Run `make format` to auto-fix all formatting issues, or manually:
  - Run `fish_indent -w` on Fish files before committing
  - Run `bunx prettier --write .` for Markdown and YAML files
- Run `make lint` to check formatting without modifying files

## Commit Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org) for automated versioning and changelog generation.

### Commit Format

```
<type>: <description>

[optional body]

[optional footer]
```

### Commit Types and Version Effects

| Type        | Version Bump | Use for                       |
| ----------- | ------------ | ----------------------------- |
| `feat:`     | MINOR        | New features                  |
| `fix:`      | PATCH        | Bug fixes                     |
| `perf:`     | PATCH        | Performance improvements      |
| `docs:`     | None         | Documentation only            |
| `style:`    | None         | Formatting changes            |
| `refactor:` | None         | Code restructuring            |
| `test:`     | None         | Adding/updating tests         |
| `chore:`    | None         | Build/tooling changes         |
| (no prefix) | PATCH        | Fallback for non-conventional |

### Examples

```bash
# New feature (minor version bump)
git commit -m "feat: add option to customize preview window size"

# Bug fix (patch version bump)
git commit -m "fix: handle spaces in file paths correctly"

# Documentation (no release)
git commit -m "docs: clarify fd installation instructions"

# Performance improvement (patch version bump)
git commit -m "perf: reduce startup time by lazy-loading functions"
```

## Releases and Tagging

**Do not manually create tags or releases.** This project uses [semantic-release](https://github.com/semantic-release/semantic-release) to automatically:

- Analyze commit messages when merged to `main`
- Determine the version bump (major/minor/patch)
- Create git tags
- Generate changelog entries
- Publish GitHub releases

Your properly formatted commit messages are all that's needed for the release process.

## Breaking Changes

Breaking changes trigger a MAJOR version bump. Indicate them by:

- Adding `!` after the type: `feat!: remove deprecated fzf_legacy_keybindings`
- Or adding `BREAKING CHANGE:` in the commit footer:

  ```
  feat: redesign keybinding configuration

  BREAKING CHANGE: fzf_configure_bindings now uses --flag syntax instead of positional arguments
  ```

### What Constitutes a Breaking Change

**These ARE breaking changes:**

- Removing or changing default keybindings
- Removing or renaming config variables (e.g., `fzf_fd_opts`)
- Changing expected behavior of public functions
- Bumping minimum Fish/fzf/fd/bat version requirements

**These are NOT breaking changes:**

- Adding new keybindings or config variables
- Changing internal `_fzf_*` functions (underscore prefix = private)
- Performance improvements with same behavior
- Bug fixes that match documented behavior

## Submitting a Pull Request

1. Push your branch to your fork:

   ```bash
   git push origin your-feature-name
   ```

2. Open a Pull Request against the `main` branch

3. In your PR description:
   - Describe what the change does
   - Link any related issues
   - Include screenshots for UI changes
   - Note any breaking changes

4. Wait for CI checks to pass

5. Address review feedback by pushing additional commits

### PR Tips

- Keep PRs focused on a single change
- Write clear commit messages following the convention above
- Update documentation if adding new features
- Add tests for new functionality when possible

## Questions?

Open an issue if you have questions or need help getting started.

# Contributing to Eye Care App

First off, thank you for considering contributing to Eye Care App! 🎉

It's people like you that make Eye Care App such a great tool for everyone's eye health.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Pull Requests](#pull-requests)
- [Development Setup](#development-setup)
- [Style Guidelines](#style-guidelines)
- [Commit Messages](#commit-messages)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers understand your report and reproduce the issue.

**Before Submitting A Bug Report:**
- Check the [existing issues](https://github.com/RajeshKumar11/eye_care_app/issues) to see if the problem has already been reported
- If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/RajeshKumar11/eye_care_app/issues/new?template=bug_report.md)

**How Do I Submit A Good Bug Report?**

Bugs are tracked as GitHub issues. Create an issue and provide the following information:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** to demonstrate the steps
- **Describe the behavior you observed** and explain what's wrong with it
- **Explain which behavior you expected to see** instead and why
- **Include screenshots or animated GIFs** if possible
- **Include your environment details**:
  - OS version
  - Flutter version (`flutter --version`)
  - Device/emulator details
  - App version

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements.

**Before Submitting An Enhancement Suggestion:**
- Check if there's already [a similar feature request](https://github.com/RajeshKumar11/eye_care_app/issues)
- Determine which part of the codebase your suggestion relates to

**How Do I Submit A Good Enhancement Suggestion?**

Enhancement suggestions are tracked as GitHub issues. Create an issue and provide:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Provide specific examples** to demonstrate the enhancement
- **Describe the current behavior** and **explain the improved behavior**
- **Explain why this enhancement would be useful**
- **List any similar features in other apps** if applicable

### Pull Requests

**Working on your first Pull Request?** You can learn how from this free series: [How to Contribute to an Open Source Project on GitHub](https://egghead.io/courses/how-to-contribute-to-an-open-source-project-on-github)

**Pull Request Process:**

1. **Fork the repo** and create your branch from `main`
2. **Make your changes** following our [style guidelines](#style-guidelines)
3. **Test your changes** on multiple platforms if possible
4. **Update documentation** if you're changing functionality
5. **Ensure the test suite passes** (if applicable)
6. **Make sure your code lints** (`flutter analyze`)
7. **Issue that pull request!**

**Pull Request Guidelines:**

- Follow the [pull request template](.github/pull_request_template.md)
- Include screenshots/GIFs for UI changes
- Link related issues
- Keep PRs focused on a single feature/fix
- Write clear, descriptive commit messages
- Update the CHANGELOG.md

## Development Setup

### Prerequisites

- Flutter SDK 3.10.4 or higher
- Dart SDK 3.0 or higher
- An IDE (VS Code, Android Studio, or IntelliJ)

### Setup Steps

1. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/eye_care_app.git
   cd eye_care_app
   ```

2. **Add upstream remote:**
   ```bash
   git remote add upstream https://github.com/RajeshKumar11/eye_care_app.git
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Building for Different Platforms

```bash
# Android
flutter build apk --release

# iOS (requires macOS)
flutter build ios --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## Style Guidelines

### Dart Style Guide

We follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style).

**Key points:**

- Use `dartfmt` to format your code
- Run `flutter analyze` before committing
- Follow Effective Dart guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Code Organization

```
lib/
├── main.dart              # Entry point
├── models/                # Data models
├── providers/             # State management
├── screens/               # UI screens
├── services/              # Business logic
├── utils/                 # Utilities
└── widgets/               # Reusable widgets
```

### File Naming

- Use `snake_case` for file names: `my_widget.dart`
- Use `PascalCase` for class names: `MyWidget`
- Use `camelCase` for variables and functions: `myVariable`, `myFunction()`

## Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding missing tests
- **chore**: Changes to build process or auxiliary tools

### Examples

```
feat(overlay): add customizable blink reminder duration

Add user setting to control how long the blink reminder overlay
displays on screen. Duration range from 1-10 seconds.

Closes #42
```

```
fix(android): resolve overlay permission crash on Android 13

Fixed crash that occurred when requesting overlay permission
on Android 13 devices due to new permission model.

Fixes #87
```

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

- Write unit tests for business logic
- Write widget tests for UI components
- Aim for good code coverage
- Test edge cases

## Community

### Getting Help

- **Questions**: Open a [GitHub Discussion](https://github.com/RajeshKumar11/eye_care_app/discussions)
- **Bugs**: Create an [Issue](https://github.com/RajeshKumar11/eye_care_app/issues)
- **Email**: kakumanurajeshkumar@gmail.com

### Stay Updated

- Watch the repository for updates
- Star the project to show support
- Follow development progress in discussions

## Recognition

Contributors will be recognized in our README.md file. Thank you for making Eye Care App better! 🙏

---

**Happy Contributing! 👁️✨**

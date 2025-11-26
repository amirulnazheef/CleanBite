# Contributing to CleanBite

Thank you for your interest in contributing to CleanBite! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the bug
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Flutter/Dart version
- Platform (iOS, Android, Web, etc.)

### Suggesting Features

We welcome feature suggestions! Please open an issue with:
- A clear description of the feature
- Use cases and benefits
- Any mockups or examples (if applicable)

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/cleanbite.git
   cd cleanbite
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Write clear, descriptive commit messages
   - Add comments for complex logic
   - Update documentation if needed

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: descriptive commit message"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Provide a clear description of your changes
   - Reference any related issues
   - Add screenshots for UI changes

## Development Setup

1. **Install Flutter**
   - Follow the [Flutter installation guide](https://docs.flutter.dev/get-started/install)

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   ```bash
   flutterfire configure
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` to format code
- Run `flutter analyze` before committing
- Follow existing naming conventions

## Commit Message Guidelines

Use clear, descriptive commit messages:

- `Add:` for new features
- `Fix:` for bug fixes
- `Update:` for updates to existing features
- `Refactor:` for code refactoring
- `Docs:` for documentation changes
- `Style:` for formatting changes
- `Test:` for adding or updating tests

Example:
```
Add: Barcode scanning functionality with camera support
Fix: Allergen detection not working for custom allergens
Update: Improve UI responsiveness on smaller screens
```

## Testing

- Write tests for new features
- Ensure all existing tests pass
- Aim for good test coverage

## Documentation

- Update README.md if needed
- Add comments for complex code
- Update API documentation if applicable

## Questions?

Feel free to open an issue with the `question` label if you need help or have questions.

Thank you for contributing to CleanBite! 🎉


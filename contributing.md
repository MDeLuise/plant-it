# Contribution Guidelines

Thank you for considering contributing to the Plant-it project! We appreciate your interest and support. Please follow the guidelines below to help us maintain a high-quality codebase.

## Project Architecture

Plant-it uses the [MVVM architecture](https://docs.flutter.dev/app-architecture/guide#mvvm) for its development. Understanding this architecture will help you navigate the codebase more effectively.

## How to Contribute

### Bug Reports, Feature Requests, and Questions

You can submit bug reports, feature requests, or questions in the [GitHub issues section](https://github.com/MDeLuise/plant-it/issues/new/choose) of the repository. Choose the appropriate template and fill in the required information.

### Create a Pull Request

To fix a bug or create a feature, please follow these steps:

1. **Fork the repository**: Click the "Fork" button at the top right of the repository page.
2. **Clone your fork**: Use the command `git clone <your-fork-url>` to clone your fork to your local machine.
3. **Create a new branch**: 
   ```bash
   git checkout -b awesome-feature
   ```
4. **Make changes**: Implement your changes or add new features.
5. **Commit your changes**: 
   ```bash
   git add -A
   git commit -m 'feat: Awesome new feature'
   ```
6. **Push to the branch**: 
   ```bash
   git push origin awesome-feature
   ```
7. **Create a Pull Request**: Go to the original repository and click on "New Pull Request."

#### Commit Messages

Commits should follow the [semantic commit specification](https://www.conventionalcommits.org/en/v1.0.0/), although this is not mandatory.

### Feature Development

Before starting work on a new feature, let's discuss possible solutions. Please open a [feature request](https://github.com/MDeLuise/plant-it/issues/new?assignees=&labels=Status:+Created,Type:+Feature+Request&projects=&template=feature_request.yml) issue to initiate the conversation.

## Setup Local Environment

The Plant-it app is entirely written in Flutter. To set up your local environment, please follow these steps:

1. **Install Flutter**: You need to have Flutter installed on your machine. Follow the instructions in the [official Flutter documentation](https://docs.flutter.dev/get-started/install).

2. **Install Visual Studio Code**: It is recommended to use [Visual Studio Code](https://code.visualstudio.com/) as your IDE.

3. **Install Android Studio**: If you want to try the app on an emulator, you will need to have [Android Studio](https://developer.android.com/studio) installed and set up.

4. **Set Up the Emulator**: After installing Android Studio, you [can set up an emulator](https://developer.android.com/studio/run/managing-avds).

Once you have completed these steps, you can run the project locally by opening the `main.dart` file in your IDE and launching it either in the emulator or in the browser.


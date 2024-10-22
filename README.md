# <img src="https://raw.githubusercontent.com/hesham04Dev/localization_lite/refs/heads/main/screenshots/logo.png" alt="logo" width="20px"> Localization Lite

A lightweight and simple localization package for Flutter that allows you to easily manage translations using JSON files.


## ✨ Features

- 📝 Easy setup with JSON language files.
- ⚡ Lightweight and fast.
- 🌍 Support for multiple languages without regions for more simplicity (e.g., `en`, `ar` ... ).

## 🚀 Getting Started

1. **Setup**: Create a new folder called `localization` in your project's `assets` directory.
2. **Add Language Files**: In the `localization` folder, add JSON files for each language you want to support (e.g., `en.json` , `ar.json`).
3. **Configure Assets**: Add the localization files to your `pubspec.yaml`:
   ```yaml
   dependencies:
    localization_lite: ^latest_version 

   flutter:
     assets:
       - assets/localization/
    ```
## 📖 Usage
1. Initialization: Initialize the translation system in your `main.dart` file:
 ```dart
    await WidgetsFlutterBinding.ensureInitialized();
    await Translation.init(defaultLang: "en");
 ```
 > 📝 note You can also add a custom `path` to the json by adding the path argument to the `init` fn. But when add custom path don't forget to add it to the `pubspec.yaml
 dart` file:
 ```dart
    await WidgetsFlutterBinding.ensureInitialized();
    await Translation.init(defaultLang: "en",path: "myCustomPath");
 ```
 ```yaml
  flutter:
     assets:
       - myCustomPath/
 ```
 
2. Access Translations: Use the `Translation` class to retrieve translated strings:
```dart
String greeting = Translation("greetingKey").toString();
```
or
```dart
String greeting = tr("greetingKey");
```
## 💡Example
Check out the `/example` folder for a complete example showing how to set up and use the package.
## 📬 Additional Information
For more information on contributing, filing issues, or requesting new features, please check the [GitHub repository](https://github.com/hesham04Dev/localization_lite). Contributions are welcome, and any feedback or improvements are appreciated!
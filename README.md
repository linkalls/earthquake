# earthquake

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

1. **PowerShell での設定**:
   - PowerShell を使用している場合、以下のコマンドを実行して環境変数を設定します。
     ```powershell
     $env:JAVA_HOME="C:\Program Files\jdk-17.0.2"
     $env:Path="$env:JAVA_HOME\bin;$env:Path"
     ```

これで Java 17 が正しく設定されているはずです。再度 Gradle ビルドを試みてください。


```bash
dart run build_runner build --delete-conflicting-outputs
```

# kakeibo_app
シンプルな家計簿アプリ

## 目的
flutterを使用した開発を学ぶ
iOS/Androidネイティブアプリの開発からリリースまでの流れを知る。

# 環境構築
1. このリポジトリをクローン
1. パッケージインストール
   - `flutter pub get`
1. 必要な設定ファイルを設置
   - `google-services.json`と`GoogleService-Info.plist`をfirebaseからダウンロード&設置
   - ファイルを設置するパスは以下のように配置
      - `ios/Runner/GoogleService-Info.plist`
      - `android/app/google-services.json`

※この環境構築方法は実際に試したことがないので要検証
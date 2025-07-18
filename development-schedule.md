# Development Schedule - Resembla Docker Image

## プロジェクト概要
Resembla（日本語類似文検索ライブラリ）のDockerイメージを作成し、resembla_indexとresembla_cliを動作させる環境を構築する。

## 開発フェーズ

### Phase 1: 環境構築とDockerfile作成 (現在)
- [x] Git初期化とプロジェクト構造の整理
- [ ] Debian最新版ベースのDockerfile作成
  - [ ] 基本的な依存関係のインストール（build-essential、git等）
  - [ ] MeCabのインストールと設定
  - [ ] LIBSVMのインストール
  - [ ] ICUのインストール
  - [ ] resemblaのビルド
- [ ] resembla実行用のエントリーポイントスクリプト作成

### Phase 2: テストと検証
- [ ] Dockerイメージのビルド
- [ ] resembla_indexの動作確認
- [ ] resembla_cliの動作確認
- [ ] サンプルデータでの実行テスト

### Phase 3: 最適化とドキュメント
- [ ] Dockerイメージサイズの最適化（マルチステージビルド検討）
- [ ] README.mdの作成（使用方法、サンプル実行例）
- [ ] docker-compose.ymlの作成（オプション）

### Phase 4: リリース準備
- [ ] GitHubリポジトリの作成
- [ ] 初回リリースのタグ付け
- [ ] 継続的な改善のためのIssue管理設定

## 技術的な考慮事項
- Debian最新版（bookworm）を使用
- 日本語処理のための適切な文字コード設定
- MeCab辞書の選択（UniDic、NEologd等）
- ビルド時間とイメージサイズのバランス

## 予定される成果物
1. Dockerfile
2. エントリーポイントスクリプト
3. README.md
4. サンプル設定ファイル
5. docker-compose.yml（オプション）
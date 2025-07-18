# Resembla Docker

Resembla（日本語類似文検索ライブラリ）をDockerコンテナで実行するためのプロジェクトです。

## 概要

このDockerイメージは、[Resembla](https://github.com/tuem/resembla)をDebian bookworm（最新版）上でビルドし、`resembla_index`と`resembla_cli`を簡単に実行できるようにしたものです。

**注意**: このプロジェクトはResemblaの公式リポジトリからソースコードを取得し、ICU名前空間の問題を修正するパッチを適用します。元のソースコードは含まれていません。

## 機能

- 日本語の類似文検索
- N-gramインデックスによる高速検索
- 複数の距離測定方法（編集距離、発音ベース、ローマ字ベース）
- MeCab、UniDic、NEologd辞書のサポート

## 使用方法

### イメージのビルド

```bash
docker compose build
```

### resembla_indexの実行（インデックス作成）

```bash
# docker runで実行
docker run -v $(pwd)/data:/data resembla:latest index -c /data/config/name.json

# docker-composeで実行
docker compose run --rm resembla-index
```

### resembla_cliの実行（対話型検索）

```bash
# docker runで実行
docker run -it -v $(pwd)/data:/data resembla:latest cli -c /data/config/name.json

# docker-composeで実行
docker compose run --rm resembla-cli
```

### ヘルプの表示

```bash
docker run resembla:latest --help
```

## ディレクトリ構造

```
.
├── Dockerfile              # Dockerイメージ定義
├── docker-compose.yml      # Docker Compose設定
├── entrypoint.sh          # エントリーポイントスクリプト
├── patches/               # ICU名前空間修正パッチ
│   └── icu-namespace-fix.patch
├── scripts/               # セットアップスクリプト
│   └── setup-example-data.sh
└── data/                  # ユーザーデータディレクトリ
    ├── config/           # 設定ファイル
    ├── corpus/           # コーパスファイル
    └── index/            # インデックスファイル
```

## サンプル実行例

### 1. 名前検索の例

```bash
# インデックス作成
docker compose run --rm resembla index -c /data/config/name.json

# 検索実行
docker compose run --rm resembla cli -c /data/config/name.json
# 入力例: タケダ、スズキ、サトウ
```

### 2. 住所検索の例

```bash
# インデックス作成
docker compose run --rm resembla index -c /data/config/address.json

# 検索実行
docker compose run --rm resembla cli -c /data/config/address.json
# 入力例: 京都北区、東京渋谷、大阪梅田
```

### 3. 文章検索の例

```bash
# インデックス作成
docker compose run --rm resembla index -c /data/config/apple.json

# 検索実行
docker compose run --rm resembla cli -c /data/config/apple.json
# 入力例: りんごおいしい、りんご食べたい
```

## カスタマイズ

### 設定ファイルの編集

`data/config/`ディレクトリ内のJSONファイルを編集することで、検索パラメータをカスタマイズできます。

主な設定項目：
- `corpus_path`: コーパスファイルのパス
- `simstring`: N-gram設定と類似度閾値
- `resembla`: 使用する距離測定方法
- 各測定方法の詳細パラメータ

### 新しいコーパスの追加

1. TSV形式のコーパスファイルを`data/corpus/`に配置
2. 対応する設定ファイルを`data/config/`に作成
3. インデックスを作成して検索を実行

## 技術詳細

- ベースイメージ: Debian bookworm
- 必要なライブラリ: MeCab, LIBSVM, ICU
- ビルドツール: g++, make
- 文字エンコーディング: UTF-8
- ソースコード: [Resembla公式リポジトリ](https://github.com/tuem/resembla)から自動取得
- パッチ適用: ICU名前空間の問題を修正

## ライセンス

このプロジェクトは複数のライセンスが適用されています：

### 独自コード（CC0 1.0）
以下のファイルはCC0 1.0 Universal Public Domain Dedicationでライセンスされています：
- Dockerfile
- docker-compose.yml
- entrypoint.sh
- scripts/setup-example-data.sh
- 設定ファイル（data/config/）
- このREADME.md

### パッチファイル（MIT License）
`patches/`ディレクトリのパッチファイルはMIT Licenseでライセンスされています。

### Resemblaライブラリ（Apache License 2.0）
元のResemblaライブラリ（Copyright 2017 Takashi Uemura）はApache License 2.0でライセンスされています。
- 元のソースコード: https://github.com/tuem/resembla
- パッチ適用後のバイナリもApache License 2.0の制約を受けます

**重要**: 本プロジェクトをビルドして生成されるバイナリは、Apache License 2.0の制約を受けます。

## トラブルシューティング

### ビルドエラーが発生する場合

```bash
# キャッシュをクリアして再ビルド
docker compose build --no-cache resembla
```

### 日本語が文字化けする場合

環境変数`LANG`と`LC_ALL`が`C.UTF-8`に設定されていることを確認してください。
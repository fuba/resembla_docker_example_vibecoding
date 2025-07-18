# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Resemblaは日本語の類似文検索に特化したC++11ライブラリです。このプロジェクトは以下の特徴を持ちます：
- N-gramインデックスとビット並列編集距離計算による高速な候補絞り込み
- 単語、かな、ローマ字ベースの編集距離とそのアンサンブル
- 言語特徴を使用したサポートベクトル回帰によるリランキング

## Essential Commands

### Build Commands
```bash
# Build the main library
cd resembla_src/src
make

# Build executables (after building the library)
cd executable
make

# Build with debug symbols
make debug

# Build tests
cd ../test
make
./test_all
```

### Docker Development
このプロジェクトの目標は、resemblaをビルドして動作させるDockerイメージを作成することです。以下の要件があります：
- `docker exec`で`resembla_index`と`resembla_cli`の両方をオプションで切り替えて実行できること
- 必要な外部依存関係（MeCab、LIBSVM、ICU）を適切にインストールすること

### Running Resembla
```bash
# Create index
./resembla_index -c <config.json>

# Run CLI search
./resembla_cli -c <config.json>

# Example with provided configs
./resembla_index -c ../../example/conf/name.json
./resembla_cli -c ../../example/conf/name.json
```

## Architecture

### Directory Structure
- `src/`: Core library source code
  - `executable/`: CLI tools (resembla_index, resembla_cli)
  - `measure/`: Distance measurement algorithms
  - `regression/`: Machine learning components (extractors, aggregators, predictors)
- `include/`: Third-party libraries (Catch, cmdline, json, simstring, paramset)
- `example/`: Sample configurations and corpora
- `test/`: Unit tests using Catch framework
- `eval/`: Evaluation tools

### Key Components
1. **SimString Integration**: High-speed approximate string matching
2. **Measure System**: Modular distance measurement (edit distance, pronunciation, romaji)
3. **Preprocessing**: Text normalization, MeCab-based morphological analysis
4. **Machine Learning**: SVR-based reranking with linguistic features
5. **Ensemble**: Combining multiple distance measures for improved accuracy

### Configuration Format
Resembla uses JSON configuration files with the following structure:
- `common`: Corpus path, column definitions
- `simstring`: N-gram settings, similarity threshold
- `resembla`: Measure selection, reranking parameters
- Measure-specific sections: Individual algorithm parameters

## Development Notes

### External Dependencies
必須の外部依存関係は以下の通りです：
- **MeCab**: 日本語形態素解析エンジン
- **LIBSVM**: サポートベクトルマシンライブラリ  
- **ICU**: Unicode処理用の国際化コンポーネント
- **C++11コンパイラ**: g++など

### Build System
- Makefileベースのビルドシステム
- 共有ライブラリ（libresembla.so）を生成
- pkg-configを使用した依存関係管理
- MacOSとLinuxの両方をサポート

### Testing
- Catchフレームワークを使用
- `make && ./test_all`でテスト実行
- テストデータは`test/`ディレクトリに配置

### Important Implementation Details
- テンプレートベースの汎用的な実装
- ビット並列演算による高速化
- 日本語処理に特化した前処理（かな変換、ローマ字変換）
- メモリマップドファイルを使用した効率的なインデックス管理
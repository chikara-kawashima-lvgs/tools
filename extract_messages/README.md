# CloudWatch Logs Insights メッセージ抽出ツール

CloudWatch Logs Insightsの結果からメッセージを抽出するBashスクリプトです。

## 概要

このスクリプトは、CloudWatch Logs InsightsからエクスポートしたJSON形式のログデータから、メッセージフィールドを効率的に抽出します。`@message`フィールド内のタブ区切りデータの4番目のフィールドに含まれるJSONから、`message`フィールドを取り出します。

## 必要条件

- Bash
- jq コマンド（JSONパーサー）

## インストール

```bash
# jqがインストールされていない場合
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# CentOS/RHEL
sudo yum install jq
```

## 使い方

```bash
# 実行権限を付与
chmod +x extract_messages.sh

# ヘルプを表示
./extract_messages.sh -h
./extract_messages.sh --help

# デフォルト設定で実行
./extract_messages.sh

# カスタム入力ファイルを指定
./extract_messages.sh custom-logs.json

# カスタム入力・出力ファイルを指定
./extract_messages.sh custom-logs.json extracted-messages.txt
```

## オプション

- `-h, --help`: ヘルプメッセージを表示

## 引数

1. `input_file`: 入力JSONファイル（デフォルト: `logs-insights-results.json`）
2. `output_file`: 出力ファイル（デフォルト: `messages_list.txt`）

## 出力ファイル

スクリプトは以下の2つのファイルを生成します：

1. **全メッセージリスト**: 指定した出力ファイル（デフォルト: `messages_list.txt`）
   - 抽出されたすべてのメッセージを含む
   - 重複を含む

2. **ユニークメッセージリスト**: `[output_file]_unique.txt`（デフォルト: `messages_list_unique.txt`）
   - 重複を除いたメッセージのリスト
   - アルファベット順にソート

## 実行例

```bash
# デフォルト設定での実行
$ ./extract_messages.sh
Extracting messages from: logs-insights-results.json
Total messages extracted: 1523
Unique messages: 87
Unique messages saved to: messages_list_unique.txt

First 10 messages:
[メッセージのサンプルが表示されます]

Extraction complete!
All messages saved to: messages_list.txt
Unique messages saved to: messages_list_unique.txt
```

## 入力ファイルの形式

入力ファイルは以下の構造を持つJSON配列である必要があります：

```json
[
  {
    "@message": "timestamp\tlogLevel\trequestId\t{\"message\":\"実際のメッセージ内容\"}"
  },
  ...
]
```

## トラブルシューティング

### エラー: Input file not found!
指定した入力ファイルが存在しません。ファイルパスを確認してください。

### jq: command not found
jqコマンドがインストールされていません。上記のインストール手順を参照してください。

### 空の出力ファイル
入力ファイルの形式が正しいか確認してください。`@message`フィールドがタブ区切りで、4番目のフィールドにJSONが含まれている必要があります。

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。
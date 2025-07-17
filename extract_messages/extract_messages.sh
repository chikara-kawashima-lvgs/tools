#!/bin/bash

# Default values
TARGET_FIELD="message"
INPUT_FILE="logs-insights-results.json"
OUTPUT_FILE="messages_list.txt"

# Function to display help
show_help() {
    cat << EOF
Usage: $0 [OPTIONS] [input_file] [output_file]

CloudWatch Logs Insightsの結果からメッセージを抽出するスクリプト

OPTIONS:
    -h, --help           このヘルプメッセージを表示
    -t, --target FIELD   抽出するJSONフィールド名 (デフォルト: message)

ARGUMENTS:
    input_file    入力JSONファイル (デフォルト: logs-insights-results.json)
    output_file   出力ファイル (デフォルト: messages_list.txt)

DESCRIPTION:
    CloudWatch Logs InsightsのJSON結果から@messageフィールドを解析し、
    指定されたフィールドの値一覧を抽出します。タブ区切りの4番目の
    フィールドにあるJSONから指定されたフィールドを取り出します。

OUTPUT:
    - 全データリスト: [output_file]
    - ユニークデータリスト: [output_file]_unique.txt

EXAMPLE:
    $0                                    # デフォルト設定で実行
    $0 -t error                          # errorフィールドを抽出
    $0 -t userId custom.json             # userIdフィールドを抽出（カスタム入力）
    $0 custom.json output.txt            # カスタム入力/出力ファイルを使用

REQUIREMENTS:
    - jq コマンドが必要です
EOF
}

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -t|--target)
            if [[ -z "$2" || "$2" =~ ^- ]]; then
                echo "エラー: -t オプションにはフィールド名が必要です"
                exit 1
            fi
            TARGET_FIELD="$2"
            shift 2
            ;;
        -*)
            echo "エラー: 不明なオプション: $1"
            show_help
            exit 1
            ;;
        *)
            # Positional arguments
            if [[ -z "$INPUT_FILE_ARG" ]]; then
                INPUT_FILE_ARG="$1"
            elif [[ -z "$OUTPUT_FILE_ARG" ]]; then
                OUTPUT_FILE_ARG="$1"
            else
                echo "エラー: 引数が多すぎます"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Use positional arguments if provided
INPUT_FILE="${INPUT_FILE_ARG:-$INPUT_FILE}"
OUTPUT_FILE="${OUTPUT_FILE_ARG:-$OUTPUT_FILE}"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "エラー: 入力ファイル '$INPUT_FILE' が見つかりません！"
    exit 1
fi

echo "'$TARGET_FIELD' フィールドを抽出中: $INPUT_FILE"

# Extract specified field from JSON logs
# The @message field contains tab-separated values with JSON in the 4th field
jq -r --arg field "$TARGET_FIELD" '.[] | ."@message" | split("\t")[3] | fromjson[$field] // empty' "$INPUT_FILE" | grep -v '^$' > "$OUTPUT_FILE"

# Count total messages
TOTAL_COUNT=$(wc -l < "$OUTPUT_FILE")
echo "抽出された $TARGET_FIELD の総数: $TOTAL_COUNT"

# Count unique messages
UNIQUE_COUNT=$(sort -u "$OUTPUT_FILE" | wc -l)
echo "ユニークな $TARGET_FIELD の数: $UNIQUE_COUNT"

# Create sorted unique messages file
UNIQUE_FILE="${OUTPUT_FILE%.txt}_unique.txt"
sort -u "$OUTPUT_FILE" > "$UNIQUE_FILE"
echo "ユニークな $TARGET_FIELD を保存: $UNIQUE_FILE"

# Show sample of messages
echo -e "\n最初の10件の $TARGET_FIELD:"
head -10 "$OUTPUT_FILE"

echo -e "\n抽出完了！"
echo "すべての $TARGET_FIELD を保存: $OUTPUT_FILE"
echo "ユニークな $TARGET_FIELD を保存: $UNIQUE_FILE"
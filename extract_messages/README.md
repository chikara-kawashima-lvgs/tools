  # デフォルト実行
  ./extract_messages.sh

  # カスタムファイル指定
  ./extract_messages.sh input.json output.txt

  スクリプトは以下を実行します：
  1. logs-insights-results.jsonから@message内のmessageフィールドを抽出
  2. 全メッセージをmessages_list.txtに保存
  3. ユニークなメッセージをmessages_list_unique.txtに保存
  4. 統計情報とサンプルを表示

#!/bin/bash

# Usage: ./extract_messages.sh [input_file] [output_file]
# Default: ./extract_messages.sh logs-insights-results.json messages_list.txt

INPUT_FILE="${1:-logs-insights-results.json}"
OUTPUT_FILE="${2:-messages_list.txt}"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi

echo "Extracting messages from: $INPUT_FILE"

# Extract message field from JSON logs
# The @message field contains tab-separated values with JSON in the 4th field
jq -r '.[] | ."@message" | split("\t")[3] | fromjson.message // empty' "$INPUT_FILE" | grep -v '^$' > "$OUTPUT_FILE"

# Count total messages
TOTAL_COUNT=$(wc -l < "$OUTPUT_FILE")
echo "Total messages extracted: $TOTAL_COUNT"

# Count unique messages
UNIQUE_COUNT=$(sort -u "$OUTPUT_FILE" | wc -l)
echo "Unique messages: $UNIQUE_COUNT"

# Create sorted unique messages file
UNIQUE_FILE="${OUTPUT_FILE%.txt}_unique.txt"
sort -u "$OUTPUT_FILE" > "$UNIQUE_FILE"
echo "Unique messages saved to: $UNIQUE_FILE"

# Show sample of messages
echo -e "\nFirst 10 messages:"
head -10 "$OUTPUT_FILE"

echo -e "\nExtraction complete!"
echo "All messages saved to: $OUTPUT_FILE"
echo "Unique messages saved to: $UNIQUE_FILE"
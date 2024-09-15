#!/Users/aman/miniconda3/bin/python

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title JSON to CSV
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Enter file name"}


import sys
import pyperclip
import pandas as pd
import json
import os
from pathlib import Path

# Get JSON data from the clipboard
json_data = pyperclip.paste()
file_name = sys.argv[1]

# Parse the JSON data
try:
    data = json.loads(json_data)
except json.JSONDecodeError:
    print("Error: The clipboard does not contain valid JSON data.")
    exit(1)

# Ask for the CSV file name
csv_file_name = Path("~/Desktop") / (file_name + ".csv")

# Convert JSON data to CSV using pandas
try:
    # Assuming the JSON data is a list of dictionaries
    df = pd.DataFrame(data)
    df.to_csv(csv_file_name, index=False)
    print(f"CSV file '{csv_file_name}' created successfully.")
except Exception as e:
    print(f"Error: {e}")

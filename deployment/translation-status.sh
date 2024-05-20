#!/bin/bash

# Define the directory and the reference file
DIR="frontend/lib/l10n"
REFERENCE_FILE="app_en.arb"

# Get the number of lines in the reference file
REFERENCE_LINES=$(wc -l < "$DIR/$REFERENCE_FILE")

# Create a function to get the language name from the code
get_language_name() {
  case "$1" in
    af) echo "Afrikaans" ;;
    am) echo "Amharic" ;;
    ar) echo "Arabic" ;;
    as) echo "Assamese" ;;
    az) echo "Azerbaijani" ;;
    be) echo "Belarusian" ;;
    bg) echo "Bulgarian" ;;
    bn) echo "Bengali Bangla" ;;
    bs) echo "Bosnian" ;;
    ca) echo "Catalan Valencian" ;;
    cs) echo "Czech" ;;
    cy) echo "Welsh" ;;
    da) echo "Danish" ;;
    de) echo "German" ;;
    el) echo "Modern Greek" ;;
    en) echo "English" ;;
    es) echo "Spanish Castilian" ;;
    et) echo "Estonian" ;;
    eu) echo "Basque" ;;
    fa) echo "Persian" ;;
    fi) echo "Finnish" ;;
    fil) echo "Filipino Pilipino" ;;
    fr) echo "French" ;;
    gl) echo "Galician" ;;
    gsw) echo "Swiss German Alemannic Alsatian" ;;
    gu) echo "Gujarati" ;;
    he) echo "Hebrew" ;;
    hi) echo "Hindi" ;;
    hr) echo "Croatian" ;;
    hu) echo "Hungarian" ;;
    hy) echo "Armenian" ;;
    id) echo "Indonesian" ;;
    is) echo "Icelandic" ;;
    it) echo "Italian" ;;
    ja) echo "Japanese" ;;
    ka) echo "Georgian" ;;
    kk) echo "Kazakh" ;;
    km) echo "Khmer Central Khmer" ;;
    kn) echo "Kannada" ;;
    ko) echo "Korean" ;;
    ky) echo "Kirghiz Kyrgyz" ;;
    lo) echo "Lao" ;;
    lt) echo "Lithuanian" ;;
    lv) echo "Latvian" ;;
    mk) echo "Macedonian" ;;
    ml) echo "Malayalam" ;;
    mn) echo "Mongolian" ;;
    mr) echo "Marathi" ;;
    ms) echo "Malay" ;;
    my) echo "Burmese" ;;
    nb) echo "Norwegian Bokmål" ;;
    ne) echo "Nepali" ;;
    nl) echo "Dutch Flemish" ;;
    no) echo "Norwegian" ;;
    or) echo "Oriya" ;;
    pa) echo "Panjabi Punjabi" ;;
    pl) echo "Polish" ;;
    ps) echo "Pushto Pashto" ;;
    pt) echo "Portuguese" ;;
    ro) echo "Romanian Moldavian Moldovan" ;;
    ru) echo "Russian" ;;
    si) echo "Sinhala Sinhalese" ;;
    sk) echo "Slovak" ;;
    sl) echo "Slovenian" ;;
    sq) echo "Albanian" ;;
    sr) echo "Serbian" ;;
    sv) echo "Swedish" ;;
    sw) echo "Swahili" ;;
    ta) echo "Tamil" ;;
    te) echo "Telugu" ;;
    th) echo "Thai" ;;
    tl) echo "Tagalog" ;;
    tr) echo "Turkish" ;;
    uk) echo "Ukrainian" ;;
    ur) echo "Urdu" ;;
    uz) echo "Uzbek" ;;
    vi) echo "Vietnamese" ;;
    zh) echo "Chinese" ;;
    zu) echo "Zulu" ;;
    *) echo "Unknown" ;;
  esac
}

# Print the markdown table header
echo "| Language | Filename | Translation |"
echo "|----------|----------|-------------|"

# Store the results in an array
results=()

# Add the reference file (English) to the results
results+=("English|$REFERENCE_FILE|100")

# Iterate over each file in the directory
for file in "$DIR"/*.arb; do
  filename=$(basename "$file")
  language_code="${filename%.*}"
  language_code="${language_code#*_}"

  # Skip the reference file (it was already added)
  if [ "$filename" != "$REFERENCE_FILE" ]; then
    # Get the number of lines in the current file
    LINES=$(wc -l < "$file")

    # Calculate the percentage of translation done, rounded to the nearest whole number
    PERCENTAGE=$(echo "($LINES * 100 / $REFERENCE_LINES + 0.5)/1" | bc)

    # Get the language name
    LANGUAGE_NAME=$(get_language_name "$language_code")

    # Add the result to the array
    results+=("$LANGUAGE_NAME|$filename|$PERCENTAGE")
  fi
done

# Sort the results by percentage in descending order
IFS=$'\n' sorted_results=($(sort -t '|' -k3 -nr <<<"${results[*]}"))

# Print the sorted results
for result in "${sorted_results[@]}"; do
  IFS='|' read -r language filename percentage <<< "$result"
  echo "| $language | $filename | $percentage% |"
done

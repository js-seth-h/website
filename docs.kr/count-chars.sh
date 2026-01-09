#!/bin/bash
comma() {
  # $1: 숫자
  local num="$1"
  local sign=""
  if [[ $num == -* ]]; then
    sign="-"; num="${num#-}"
  fi
  echo "$sign$(echo "$num" | rev | sed 's/\([0-9]\{3\}\)/&,/g' | rev | sed 's/^,//')"
}
if [ $# -eq 0 ]; then
	find . -type f -name "*.md" ! -name "index.md" -print0 | sort -z | while IFS= read -r -d '' f; do
		"$0" "$f"
	done
else
	for f in "$@"; do
		if [[ "$f" == *.md ]] && [[ "$(basename "$f")" != "index.md" ]]; then
			chars=$(gawk "BEGIN{FS=\"\"} {sum+=NF} END{print sum}" "$f")
			words=$(gawk "{sum+=NF} END{print sum}" "$f")
			printf "Words:\t%8s\tChars:\t%8s\tFile:\t%s\n" "$(comma "$words")" "$(comma "$chars")" "$f"
		fi
	done
fi

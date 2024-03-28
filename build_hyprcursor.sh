#!/usr/bin/env bash

function pack {
	TMP=/tmp/build_deepinv20_hyprcursors

	if [ ! -d "$OUTPUT/cursors" ]; then
		mkdir -p "$OUTPUT/cursors"
	fi
	if [ ! -d "$TMP" ]; then
		mkdir "$TMP"
	fi

	cd "$META"

	for CUR_META in *.hl; do
		BASENAME="$CUR_META"
		BASENAME="${BASENAME##*/}"
		BASENAME="${BASENAME%.*}"

		while read -r line; do
			if [[ $line == *"define_size"* ]]; then
				FILENAME=$(echo "$line" | grep -o '[^, ]*\.svg')
				cp "$SRC/svg/$FILENAME" "$TMP"
			fi
		done <"$CUR_META"

		cp "$CUR_META" "$TMP/meta.hl"

		zip -j "$OUTPUT/cursors/$BASENAME.hlc" "$TMP"/*.svg "$TMP/meta.hl" >/dev/null
		echo "$OUTPUT/cursors/$BASENAME.hlc"

		rm "$TMP"/*
	done
	cp "$SRC"/manifest.hl "$OUTPUT/"
}

# generate pixmaps from svg source
SRC="$PWD"/src
OUTPUT="$PWD"/dist/hyprcursor
META="$SRC"/hlc_meta

pack

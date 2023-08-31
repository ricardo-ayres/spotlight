#!/bin/bash

URI='https://www.windows10spotlight.com/'

MAXPAGES=$(curl -L -s $URI |\
	xmllint --html --xpath '//a[@class="page-numbers"]/text()' - 2>/dev/null |\
	tail -1)

PAGE=$((1 + $RANDOM % $MAXPAGES ))

LINKS=$(curl -L -s $URI"page/"$PAGE |\
	xmllint --html --xpath '//article/h2/a/@href' - 2>/dev/null |\
	cut -f2 -d '"')

NLINKS=$(wc -w <<<$LINKS)
IMGN=$((1 + $RANDOM % $NLINKS))

LINK=$(echo $LINKS | cut -f $IMGN -d ' ')

IMGLINK=$(curl -L -s $LINK |\
	xmllint --html --xpath 'string(//div[@class="entry"]/p/a/@href)' - 2>/dev/null)

DESC=$(curl -L -s $LINK |\
	xmllint --html --xpath '//h1/text()' - 2>/dev/null)

echo "Link: $LINK" | tee $HOME/.spotdesc
echo "File: $IMGLINK" | tee -a $HOME/.spotdesc
echo "Description: $DESC" | tee -a $HOME/.spotdesc

curl -s -o $HOME/.spotlight $IMGLINK

magick $HOME/.spotlight \
	-font 'Terminus-(TTF)' -pointsize 11 -density 152 \
	-fill '#eeeeee' \
	-undercolor '#222222' \
	-gravity SouthWest \
	-annotate +32+32 "$DESC" \
	$HOME/.wallpaper

xwallpaper --zoom $HOME/.wallpaper

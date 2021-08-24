#!/bin/sh

for family in $*; do
for url in $( {
for agent in \
'Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20100101 Firefox/6.0' \
'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; de-at) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1' \
'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 7.1; Trident/5.0)' ;
do
curl -A "$agent" -s "http://fonts.googleapis.com/css?family=$family" | \
grep -oE 'http://[A-Za-z0-9/._-]+'; \
done } | sort -u ) ;
do
extn=${url##*.} ;
file=$(echo "$family"| tr +[:upper:] _[:lower:]);
echo $url $file.$extn;
curl -s "$url" -o "$file.$extn";
done
done
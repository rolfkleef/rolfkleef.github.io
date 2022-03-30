#!/bin/bash
# load a series of zotero collections for an Antora documentation component
ZAPI=https://api.zotero.org
ZSRC=users/12345 # <1>
ZKEY="Authorization: Bearer xyzxyz" # <2>
CSL=https://www.drostan.org/drostan.csl # <3>

if [[ -e antora.yml && -e zotero ]]; then
  cat zotero | while read zget module partial tag; do
    if [[ -n "$tag" ]]; then
      with_tag=" with tag $tag"
      p_tag="&tag=$tag"
    else
      with_tag=
      p_tag=
    fi
    echo "Getting ${zget}items$with_tag and putting into $module/partials/$partial.html"
    mkdir -p "modules/$module/partials"
    curl -sS -H "$ZKEY" "$ZAPI/$ZSRC/${zget}items?format=bib&linkwrap=1$p_tag&itemType=-attachment&style=$CSL" -o "modules/$module/partials/$partial.html"
    echo "Appending COinS info"
    curl -sS -H "$ZKEY" "$ZAPI/$ZSRC/${zget}items?format=coins$p_tag&itemType=-attachment" >> "modules/$module/partials/$partial.html"

    echo "Include references with:" # <4>
    echo -e "\n[bibliography]"
    echo -e "== Background references\n"

    echo "++++"
    echo "include::partial\$$partial.html[]"
    echo -e "++++\n"
  done
fi

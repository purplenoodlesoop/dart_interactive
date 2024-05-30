export_logo:
    /Applications/Inkscape.app/Contents/MacOS/inkscape --export-filename=doc/logo.png doc/logo.svg -w 1280 -h 640

publish_all:
    (cd packages/interactive && flutter pub publish --force --server=https://pub.dartlang.org)

nix_release new_version:
    echo "\"{{new_version}}\"" > packages/interactive/version.nix
    (cd packages/interactive; yq . pubspec.lock > pubspec.lock.json)
    

release old_version new_version:
    grep -q 'version: {{old_version}}' packages/interactive/pubspec.yaml
    grep -q '{{new_version}}' CHANGELOG.md

    just nix_release {{new_version}}
    sed -i '' 's/version: {{old_version}}/version: {{new_version}}/g' packages/interactive/pubspec.yaml

    git add --all
    git status && git diff --staged | grep ''
    git commit -m "bump from {{old_version}} to {{new_version}}"
    git push

    awk '/## {{new_version}}/{flag=1; next} /## {{old_version}}/{flag=0} flag' CHANGELOG.md | gh release create v{{new_version}} --notes-file "-" --draft --title v{{new_version}}
    echo 'A *DRAFT* release has been created. Please go to the webpage and really release if you find it correct.'
    open https://github.com/fzyzcjy/dart_interactive/releases

    just publish_all

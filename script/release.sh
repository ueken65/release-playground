#!/bin/bash

if [ -n "$(git status --porcelain)" ]; then
  echo "git の差分があるため処理を中断します"
  exit 1
fi

read -p "リリースしたいバージョンを入力してください (例: 2.1.0): " version

if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "バージョン番号は x.y.z の形式で指定してください"
  exit 1
fi

git checkout main
git pull
git checkout -b "release/$version"

# yaml の info.version の番号を更新
sed -i '' -e "s/^  version: .*/  version: $version/" openapi.yaml

git add openapi.yaml
git commit -m "version $version"
git tag $version
git push origin head
git push origin $version

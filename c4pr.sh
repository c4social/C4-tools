#!/bin/sh
if [ "$#" -ne 2 ] || [ "$1" == "help" ]
then
  echo "checkout upstream pull request and push to remote"
  echo 
  echo "usage: $0 PR# target-branch-name";
  echo 
  echo "e.g."
  echo 
  echo "$ $0 123 fix-foo"
  exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
source $DIR/c4.conf

git pull upstream pull/$1/head:$2
git checkout $2
git fetch upstream
git merge upstream/main 

if [ $? -ne 0 ]; then
    git merge --abort
    echo "Merge failed and aborted."
    echo "*********************************************************************************"
    echo "*  Here's a link to the source PR:"
    echo "*    $FORGE_URL/$FORGE_UPSTREAM_USER/$FORGE_REPO/pull/$1"
    echo "*********************************************************************************"
    exit 1  
fi

git push origin $2

echo "*********************************************************************************"
echo "*  Here's a better link to create a PR:"
echo "*    $FORGE_URL/$FORGE_USER/$FORGE_REPO/compare/$FORGE_C4_BRANCH...$FORGE_USER:$2" 
echo "*********************************************************************************"
echo "*  And a link to the source PR:"
echo "*    $FORGE_URL/$FORGE_UPSTREAM_USER/$FORGE_REPO/pull/$1"
echo "*********************************************************************************"

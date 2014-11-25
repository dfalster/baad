#!/bin/sh
WIKI_DIR=reports
WIKI_TMP=__wiki
GIT_WIKI="--git-dir=$WIKI_DIR/.git --work-tree=$WIKI_DIR"
SHA=`git rev-parse --short HEAD`

if [ ! -d $WIKI_DIR/.git ]; then
    git clone git@github.com:dfalster/baad.wiki.git $WIKI_TMP
    mv ${WIKI_TMP}/.git ${WIKI_TMP}/Home.md reports
    rm -rf ${WIKI_TMP}
else
    cd $WIKI_DIR && git pull && cd -
fi

git $GIT_WIKI add '*.md' figure
git $GIT_WIKI commit --quiet -m "Updated wiki to baad $SHA"
git $GIT_WIKI push

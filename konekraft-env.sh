#!/usr/bin/env bash
export KONEKRAFT_RB_INCLUDE=""
for f in core konekt konekt2 konekt3 sasm0 sasm1 slate1 slate2 ; do
  export KONEKRAFT_RB_INCLUDE="$KONEKRAFT_RB_INCLUDE -I$(pwd)/$f/lib"
  export PATH="$PATH:$(pwd)/$f/bin"
done
export PATH="$PATH:$(pwd)/bin"

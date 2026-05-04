#!/bin/sh
#!/bin/bash
root=$(dirname "$0")

# install nimterop, if not already installed
if ! [ -x "$(command -v toast)" ]; then
  nimble install -y nimterop@0.7.1
fi

# generate nim wrapper with nimterop
toast \
  --compile="${root}/sources/src/monocypher.c" \
  --pnim \
  --noHeader \
  "${root}/sources/src/monocypher.h" > "${root}/monocypher/cwrapper.nim"

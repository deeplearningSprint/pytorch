#!/bin/bash

# - must have Cython installed
# - must have already run:
#     mkdir cbuild
#     (cd cbuild && cmake .. && make -j 4 )
# - torch is expected to be already activated, ie run:
#    source ~/torch/install/bin/torch_activate.sh
#    ... or similar
# - torch is expected to be at $HOME/torch

if [[ x${INCREMENTAL} == x ]]; then {
  rm -Rf build PyBuild.so dist *.egg-info cbuild
  pip uninstall -y PyTorch
} fi
# python setup.py build_ext -i || exit 1

if [[ x${CYTHON} != x ]]; then { python setup.py cython_only || exit 1; } fi

mkdir -p cbuild
export TORCH_INSTALL=$(dirname $(dirname $(which luajit)))
(cd cbuild; cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${TORCH_INSTALL} && make -j 4 install) || exit 1
python setup.py install || exit 1


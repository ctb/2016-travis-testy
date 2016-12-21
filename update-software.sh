#! /bin/bash

set -x
set -e

source ~/pondenv/bin/activate

pip install pytest nose

git clone https://github.com/dib-lab/screed.git -b master
cd screed
make all
make test || echo tests failed, continuing anyway
make install
cd ..

git clone https://github.com/dib-lab/khmer.git
cd khmer
make all
make test || echo tests failed, continuing anyway
make install
cd ..


#! /bin/bash

set -x
set -e

source ~/pondenv/bin/activate

pip install pytest nose

git clone https://github.com/dib-lab/screed.git -b master
cd screed
make all
make test
make install
cd ..

git clone https://github.com/dib-lab/khmer.git -b tests/mark_noroot
cd khmer
make all
py.test -m "not noroot and not known_failing and not jenkins and not huge"
make install
cd ..

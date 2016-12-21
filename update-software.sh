#! /bin/bash

set -x
set -e

source ~/pondenv/bin/activate

pip install pytest nose

git clone https://github.com/dib-lab/screed.git -b master
cd screed
make all
make install
make test
cd ..

git clone https://github.com/dib-lab/khmer.git -b tests/mark_noroot
cd khmer
make all
make install
py.test -m "not noroot and not known_failing and not jenkins and not huge"
cd ..

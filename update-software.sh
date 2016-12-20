#! /bin/bash

set -x
set -e

source ~/pondenv/bin/activate

git clone https://github.com/dib-lab/khmer.git -b master
cd screed
make all test install
cd ..

git clone https://github.com/dib-lab/khmer.git -b master
cd khmer
make all test install
cd ..


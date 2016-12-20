#! /bin/bash

set -x
set -e

source ~/pondenv/bin/activate

pip install git+https://github.com/dib-lab/khmer.git@master
pip install git+https://github.com/dib-lab/screed.git@master

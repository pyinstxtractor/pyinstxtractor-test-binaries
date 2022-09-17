#!/bin/bash -i

set -e

# bzip2 required for mamba 
sudo apt update && sudo apt install bzip2 --yes

curl micro.mamba.pm/install.sh | bash
source ~/.bashrc

# Path to testing pyinstxtractor.py (Update as appropriate)
wget https://gist.githubusercontent.com/extremecoders-re/94c9b416f2f955e4ec886439fbdfa0bf/raw/pyinstxtractor.py

echo "=== Installing required Python versions ==="

pyvers="2.7 3.5 3.6 3.7 3.8 3.9 3.10"
for pyver in $pyvers
  do
    echo "==> Installing Python $pyver..."
    micromamba create -n py$pyver -c conda-forge python=$pyver --yes --quiet > /dev/null
  done

echo "=== Beginning testing ==="

for pyver in $pyvers
  do
    echo "==> Testing Python $pyver..."
    micromamba activate py$pyver
    find . -type f -iname "python$pyver*" -exec sh -c "python pyinstxtractor.py '{}' || exit 1" \;
    micromamba deactivate
  done
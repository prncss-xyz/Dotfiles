#!/usr/bin/env sh

micromamba activate
python -m ensurepip
pip install altair pint pint-pandas
# micromamba install xeus-lua xeus-sql -c conda-forge

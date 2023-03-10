#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -d "$dir/venv" ]; then
  echo "Virtual environment already exists"
else
  python3 -m venv "$dir/venv"
fi

source "$dir/venv/bin/activate"

pip3 install -r requirements.txt

python3 bot.py
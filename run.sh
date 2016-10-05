#!/bin/sh
python -m http.server 8000 &
jupyter notebook --NotebookApp.allow_origin='*' --no-browser --port 8888 --ip=*

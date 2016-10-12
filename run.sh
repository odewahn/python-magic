#!/bin/sh
# Start web server
python -m http.server 8000 &
# Start watching for changes to ipynb files
ls *.ipynb | entr jupyter nbconvert \
  --NotebookApp.TemplateExporter.template_path=['./scripts', '/opt/conda/lib/python3.5/site-packages/nbconvert/templates/html/'] \
  --to html \
  --template ./scripts/parse-html.tpl \
  main.ipynb \
  &
# Start the notebook
jupyter notebook --NotebookApp.allow_origin='*' --no-browser --port 8888 --ip=*

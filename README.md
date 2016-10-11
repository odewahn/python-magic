

# Using nbconvert for conversions

From within a jupyter terminal, run this:

```
jupyter nbconvert \
  --NotebookApp.TemplateExporter.template_path=['./scripts', '/opt/conda/lib/python3.5/site-packages/nbconvert/templates/html/'] \
  --to html \
  --template ./scripts/parse-html.tpl \
  main.ipynb
```

*NB*: We need to make this run whenever an ipynb file gets updated.

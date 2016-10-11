{%- extends 'basic.tpl' -%}

{% block input %}
<pre {% if nb.metadata.language_info %}data-code-language="{{ nb.metadata.language_info.name }}" data-executable="true"{% endif %} data-type="programlisting">
{{ cell.source|e}}
</pre>
{% endblock input %}

{% block stream_stdout -%}
<div class="output_subarea output_stream output_stdout output_text">
<pre data-output="true">
{{- output.text | ansi2html -}}
</pre>
</div>
{%- endblock stream_stdout %}

{% block stream_stderr -%}
<div class="output_subarea output_stream output_stderr output_text">
<pre data-output="true">
{{- output.text | ansi2html -}}
</pre>
</div>
{%- endblock stream_stderr %}

{% block error -%}
<div class="output_subarea output_text output_error">
<pre data-output="true">
{{- super() -}}
</pre>
</div>
{%- endblock error %}

{%- block data_text scoped %}
<div class="output_text output_subarea {{extra_class}}">
<pre data-output="true">
{{- output.data['text/plain'] | ansi2html -}}
</pre>
</div>
{%- endblock -%}

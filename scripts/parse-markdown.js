var fs = require('fs'),
    showdown = require('showdown')


// clean up code blocks
showdown.extension('oriole', function () {
  var code_blocks = {
    type: 'output',
    regex: /<pre><code class="(\w+).+?">([\s\S]+?)<\/code><\/pre>/g,
    replace: '<pre data-code-language="$1" data-executable="true" data-type="programlisting">$2</pre>'
  };
  var output_blocks = {
    type: 'output',
    regex: /<pre><code>([\s\S]+?)<\/code><\/pre>/g,
    replace: '<pre data-output="true">$1</pre>'
  };
  return [output_blocks, code_blocks];
});

var converter = new showdown.Converter({ extensions: ["oriole"] });


var parseMdFile = function(source, output) {
  var md = fs.readFileSync( source, {encoding: 'utf-8'})
  fs.writeFileSync(output, converter.makeHtml(md), {encoding: 'utf-8'})
  console.log('-> generated %s from %s', output, source);
}
parseMdFile('../main.md', '../main.html')

# slicer_cli_web_plugin
A sample plugin for [girder/slicer_cli_web](https://github.com/girder/slicer_cli_web)
with examples of slicer CLIs written in python and c++.

Running `docker run <image-name> --list_cli` will output the list of all CLIs (their relative path and type/language) exposed.

```
$ docker run cdeepakroy/slicer_cli_web_plugin --list_cli

{
  "sample_python_cli": {
    "type"    : "python"
  },
  "sample_cpp_cli": {
    "type"    : "cxx"
  }
}
```

Running `docker run <image-name> <cli-rel-path> --xml` will output the Slicer XML spec of the CLI.

```
$ docker run cdeepakroy/slicer_cli_web_plugin sample_python_cli --xml

<?xml version="1.0" encoding="utf-8"?>
<executable>
  <category>Developer Tools</category>
  <title>sample_python_cli</title>
  <description><![CDATA[Sample slicer CLI in Python that shows one of each type of parameter.]]></description>
  <version>0.1.0.$Revision$(alpha)</version>
  <documentation-url>http://wiki.slicer.org/slicerWiki/index.php/Documentation/Nightly/Modules/ExecutionModelTour</documentation-url>
  <license/>
  <contributor>Deepak Roy Chittajallu (Kitware)</contributor>
  <acknowledgements><![CDATA[This work is part of the National Alliance for Medical Image Computing (NAMIC), funded by the National Institutes of Health through the NIH Roadmap for Medical Research, Grant U54 EB005149.]]></acknowledgements>
  <parameters>
    <label>Scalar Parameters</label>
    <description><![CDATA[Variations on scalar parameters]]></description>
    <integer>
      <name>integerVariable</name>
      <flag>-i</flag>
      <longflag>--integer</longflag>
      <description><![CDATA[An integer without constraints]]></description>
      <label>Integer Parameter</label>
      <default>30</default>
    </integer>
    <double>
      <name>doubleVariable</name>
      <flag>-d</flag>
      <longflag>--double</longflag>
      <description><![CDATA[A double with constraints]]></description>
      <label>Double Parameter</label>
      <default>30</default>
      <constraints>
        <minimum>0</minimum>
        <maximum>1.e3</maximum>
        <step>10</step>
      </constraints>
    </double>
  </parameters>
  <parameters>
    <label>Vector Parameters</label>
    <description><![CDATA[Variations on vector parameters]]></description>
    <float-vector>
      <name>floatVector</name>
      <flag>f</flag>
      <description><![CDATA[A vector of floats]]></description>
      <label>Float Vector Parameter</label>
      <default>1.3,2,-14</default>
    </float-vector>
    <string-vector>
      <name>stringVector</name>
      <longflag>string_vector</longflag>
      <description><![CDATA[A vector of strings]]></description>
      <label>String Vector Parameter</label>
      <default>foo,bar,foobar</default>
    </string-vector>
  </parameters>
  <parameters>
    <label>Enumeration Parameters</label>
    <description><![CDATA[Variations on enumeration parameters]]></description>
    <string-enumeration>
      <name>stringChoice</name>
      <flag>e</flag>
      <longflag>enumeration</longflag>
      <description><![CDATA[An enumeration of strings]]></description>
      <label>String Enumeration Parameter</label>
      <default>Bill</default>
      <element>Ron</element>
      <element>Eric</element>
      <element>Bill</element>
      <element>Ross</element>
      <element>Steve</element>
      <element>Will</element>
    </string-enumeration>
  </parameters>
  <parameters>
    <label>Boolean Parameters</label>
    <description><![CDATA[Variations on boolean parameters]]></description>
    <boolean>
      <name>boolean1</name>
      <longflag>boolean1</longflag>
      <description><![CDATA[A boolean default true]]></description>
      <label>Boolean Default true</label>
      <default>true</default>
    </boolean>
    <boolean>
      <name>boolean2</name>
      <longflag>boolean2</longflag>
      <description><![CDATA[A boolean default false]]></description>
      <label>Boolean Default false</label>
      <default>false</default>
    </boolean>
    <boolean>
      <name>boolean3</name>
      <longflag>boolean3</longflag>
      <description><![CDATA[A boolean with no default, should be defaulting to false]]></description>
      <label>Boolean No Default</label>
    </boolean>
  </parameters>
  <parameters>
    <label>File, Directory and Image Parameters</label>
    <description><![CDATA[Parameters that describe files and direcories.]]></description>
    <file fileExtensions=".png,.jpg,.jpeg,.bmp,.tif,.tiff,.gipl,.dcm,.dicom,.nhdr,.nrrd,.mhd,.mha,.mask,.hdr,.nii,.nii.gz,.hdr.gz,.pic,.lsm,.spr,.vtk,.vtkp,.vtki,.stl,.csv,.txt,.xml,.html">
      <longflag>file1</longflag>
      <description><![CDATA[An input file]]></description>
      <label>Input file</label>
      <channel>input</channel>
    </file>
    <file fileExtensions=".png,.jpg,.jpeg,.bmp,.tif,.tiff,.gipl,.dcm,.dicom,.nhdr,.nrrd,.mhd,.mha,.mask,.hdr,.nii,.nii.gz,.hdr.gz,.pic,.lsm,.spr,.vtk,.vtkp,.vtki,.stl,.csv,.txt,.xml,.html" multiple="true">
      <longflag>files</longflag>
      <description><![CDATA[Multiple input files]]></description>
      <label>Input Files</label>
      <channel>input</channel>
    </file>
    <directory>
      <longflag>directory1</longflag>
      <description><![CDATA[An input directory. If no default is specified, the current directory is used,]]></description>
      <label>Input directory</label>
      <channel>input</channel>
    </directory>
    <image>
      <longflag>image1</longflag>
      <description><![CDATA[An input image]]></description>
      <label>Input image</label>
      <channel>input</channel>
    </image>
    <image>
      <longflag>image2</longflag>
      <description><![CDATA[An output image]]></description>
      <label>Output image</label>
      <channel>output</channel>
    </image>
  </parameters>
  <parameters>
    <label>Index Parameters</label>
    <description><![CDATA[Variations on parameters that use index rather than flags.]]></description>
    <image>
      <name>arg0</name>
      <channel>input</channel>
      <index>0</index>
      <description><![CDATA[First index argument is an image]]></description>
      <label>First index argument</label>
    </image>
    <image>
      <name>arg1</name>
      <channel>output</channel>
      <index>1</index>
      <description><![CDATA[Second index argument is an image]]></description>
      <label>Second index argument</label>
    </image>
  </parameters>
  <parameters>
    <label>Simple return types</label>
    <integer>
      <name>anintegerreturn</name>
      <label>An integer return value</label>
      <channel>output</channel>
      <default>5</default>
      <description><![CDATA[An example of an integer return type]]></description>
    </integer>
    <boolean>
      <name>abooleanreturn</name>
      <label>A boolean return value</label>
      <channel>output</channel>
      <default>false</default>
      <description><![CDATA[An example of a boolean return type]]></description>
    </boolean>
    <float>
      <name>afloatreturn</name>
      <label>A floating point return value</label>
      <channel>output</channel>
      <default>7.0</default>
      <description><![CDATA[An example of a float return type]]></description>
    </float>
    <double>
      <name>adoublereturn</name>
      <label>A double point return value</label>
      <channel>output</channel>
      <default>14.0</default>
      <description><![CDATA[An example of a double return type]]></description>
    </double>
    <string>
      <name>astringreturn</name>
      <label>A string point return value</label>
      <channel>output</channel>
      <default>Hello</default>
      <description><![CDATA[An example of a string return type]]></description>
    </string>
    <integer-vector>
      <name>anintegervectorreturn</name>
      <label>An integer vector return value</label>
      <channel>output</channel>
      <default>1,2,3</default>
      <description><![CDATA[An example of an integer vector return type]]></description>
    </integer-vector>
    <string-enumeration>
      <name>astringchoicereturn</name>
      <channel>output</channel>
      <description><![CDATA[An enumeration of strings as a return type]]></description>
      <label>A string enumeration return value</label>
      <default>Bill</default>
      <element>Ron</element>
      <element>Eric</element>
      <element>Bill</element>
      <element>Ross</element>
      <element>Steve</element>
      <element>Will</element>
    </string-enumeration>
  </parameters>
</executable>
```

Running `docker run <image-name> <cli-rel-path> --help` will output the command-line usage help generated by ctk_cli.CLIArgumentParser for Python CLIs and GenerateCLP's PARSE_ARGS for C++ CLIs.

```
$ docker run cdeepakroy/slicer_cli_web_plugin sample_python_cli --help
usage: sample_python_cli.py [-h] [-V] [--xml] [--returnparameterfile <file>]
                            [--boolean1 <boolean>] [--boolean2 <boolean>]
                            [--boolean3 <boolean>] [-d <double>]
                            [--directory1 <directory>]
                            [-e {Ron,Eric,Bill,Ross,Steve,Will}]
                            [-f <float-vector>] [--file1 <file>]
                            [--files <file>] [-i <integer>] [--image1 <image>]
                            [--image2 <image>]
                            [--string_vector <string-vector>]
                            arg0 arg1
positional arguments:
  arg0                  First index argument is an image (type: image)
  arg1                  Second index argument is an image (type: image)
optional arguments:
  -h, --help            show this help message and exit
  -V, --version         show program's version number and exit
  --xml                 Produce xml description of command line arguments
  --returnparameterfile <file>
                        Filename in which to write simple return parameters
                        (integer, float, integer-vector, etc.) as opposed to
                        bulk return parameters (image, file, directory,
                        geometry, transform, measurement, table).
  --boolean1 <boolean>  A boolean default true (default: True)
  --boolean2 <boolean>  A boolean default false (default: False)
  --boolean3 <boolean>  A boolean with no default, should be defaulting to
                        false
  -d <double>, --double <double>
                        A double with constraints (default: 30.0)
  --directory1 <directory>
                        An input directory. If no default is specified, the
                        current directory is used,
  -e {Ron,Eric,Bill,Ross,Steve,Will}, --enumeration {Ron,Eric,Bill,Ross,Steve,Will}
                        An enumeration of strings (default: Bill)
  -f <float-vector>     A vector of floats (default: [1.3, 2.0, -14.0])
  --file1 <file>        An input file (file-extensions: ['.png', '.jpg',
                        '.jpeg', '.bmp', '.tif', '.tiff', '.gipl', '.dcm',
                        '.dicom', '.nhdr', '.nrrd', '.mhd', '.mha', '.mask',
                        '.hdr', '.nii', '.nii.gz', '.hdr.gz', '.pic', '.lsm',
                        '.spr', '.vtk', '.vtkp', '.vtki', '.stl', '.csv',
                        '.txt', '.xml', '.html'])
  --files <file>        Multiple input files (accepted multiple times) (file-
                        extensions: ['.png', '.jpg', '.jpeg', '.bmp', '.tif',
                        '.tiff', '.gipl', '.dcm', '.dicom', '.nhdr', '.nrrd',
                        '.mhd', '.mha', '.mask', '.hdr', '.nii', '.nii.gz',
                        '.hdr.gz', '.pic', '.lsm', '.spr', '.vtk', '.vtkp',
                        '.vtki', '.stl', '.csv', '.txt', '.xml', '.html'])
  -i <integer>, --integer <integer>
                        An integer without constraints (default: 30)
  --image1 <image>      An input image
  --image2 <image>      An output image
  --string_vector <string-vector>
                        A vector of strings (default: ['foo', 'bar',
                        'foobar'])
Title: sample_python_cli
Description: Sample slicer CLI in Python that shows one of each type of
parameter.
Author(s): Deepak Roy Chittajallu (Kitware)
```

Slicer-cli-web runs `docker run <image-name> --list_cli` to find the CLI's exposed, runs `docker run <image-name> <cli-rel-path> --xml` for each CLI to get its XML spec, automatically converts the XML spec into girder-worker task-spec to generate REST end-points and web UI.


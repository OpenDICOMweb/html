// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:html';

import 'package:markdown/markdown.dart';

import 'package:odwhtml/file_io.dart';

void main() {
  FileUploadInputElement input = querySelector('#input-upload');
  OutputElement output = querySelector('output');
  File file;

  // Set the [innerHtml] for the [OutputElement].
  void showFile(HtmlFile file, String s) {
    String html = markdownToHtml(s);
    print('markdown: $html');
    var odw = '<small><p><strong>Open DICOM<em>web</em> Project</strong></p></small>';
    output.innerHtml = '''
<div> <strong>file.name</strong></div>
</ul>
  <li>length: ${file.size}</li>
  <li>last modified: ${file.lastModified}</li>
  <li>last modified date: ${file.lastModifiedDate}</li>
  <li>text:</li>
</ul>
<div>$odw$html</div>''';
  }

  // Handle [FileUploadInputElement] change event.
  Future onFileInputChange(Event e) async {
    FileUploadInputElement input = e.target;
    FileList files = input.files;
    print('File Input Change: $files');
    file = files[0];
    HtmlFile f = new HtmlFile(file);
    showFile(f, await f.readAsString());
  }

  // Add listener to [input].
  input.onChange.listen(onFileInputChange);

}















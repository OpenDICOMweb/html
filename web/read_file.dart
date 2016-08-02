// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:markdown/markdown.dart';

import 'package:odwhtml/file_io.dart';

void main() {
  FileUploadInputElement input = querySelector('#input-upload');
  OutputElement output = querySelector('output');
 // FileList files;

  Future readFile(File file) async {
    HtmlFile f = new HtmlFile(file);
    String s = await f.readAsString();
    String html = markdownToHtml(s);
    output.innerHtml = '''
<div> <strong>file.name</strong></div>
</ul>
  <li>length: ${file.size}</li>
  <li>last modified: ${file.lastModified}</li>
  <li>last modified date: ${file.lastModifiedDate}</li>
  <li>text:</li>
</ul>
<div>$html</div>''';
  }

  void onFileInputChange(Event e) {
    FileUploadInputElement input = e.target;
    FileList files = input.files;
    print('File Input Change: $files');
    File file = files[0];
    readFile(file);
  }

  input.onChange.listen(onFileInputChange);
}















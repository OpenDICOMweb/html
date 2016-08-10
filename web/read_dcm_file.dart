// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:core/dataset_sop.dart';
import 'package:convert/dcm.dart';
//import 'package:logger/logger.dart';

import 'package:odwhtml/src/file/file.dart';

void main() {
  //Logger log = new Logger("main", Level.info);
  //System.init(log);
  FileUploadInputElement input = querySelector('#input-upload');
  OutputElement output = querySelector('output');
  File file;

  // Handle [FileUploadInputElement] change event.
  Future onFileInputChange(Event e) async {
    FileUploadInputElement input = e.target;
    FileList files = input.files;
    print('File Input Change: $files');
    file = files[0];
    HtmlFile f = new HtmlFile(file);

    //TODO: log.config('Reading file: $file');
    Uint8List bytes = await f.readAsBytes();

   DcmDecoder decoder = new DcmDecoder(bytes);
    print('decoder: $decoder');

   Instance instance = decoder.readSopInstance(file.name);
    print('main:instance: $instance');
    Study study = instance.study;
    print('main:study: $study');
    Format fmt = new Format();
    var s = fmt.study(study);
    output.innerHtml = '<pre><code><span>Foo</span></code></pre>';
  //  print(s);

  }

  // Add listener to [input].
  input.onChange.listen(onFileInputChange);

}




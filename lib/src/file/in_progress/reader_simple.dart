// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.html.io.simple_file_reader;

import 'dart:async';
import 'dart:html';
//import 'dart:typed_data';

class SimpleReader {
  final FileReader reader = new FileReader();
  String filePath = 'test.txt';

  readFile(String filePath) {
    var input = window.document.querySelector('#upload');
    Element log = query("#log");

    input.addEventListener("change", (e) {
      FileList files = input.files;
      Expect.isTrue(files.length > 0);
      File file = files.item(0);

      FileReader reader = new FileReader();
      reader.onLoad = (fileEvent) {
        print("file read");
        log.innerHTML = "file content is ${reader.result}";
      };
      reader.onerror = (evt) => print("error ${reader.error.code}");
      reader.readAsText(file);
    });
  }

  onLoadHandler(ProgressEvent e) {
    if (e.loaded == true) {
      print('Read Complete:');
      log.inn
    }
  }

}
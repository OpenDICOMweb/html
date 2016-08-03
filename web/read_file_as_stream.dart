// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:html' hide FileStream;
import 'dart:typed_data';

import 'package:odwhtml/file_io.dart';

//TODO: need better example.  maybe create the data then read it.

class FileInput {
  FileUploadInputElement input;

  List<File> files;
  var subscription;

  FileInput() {
    FileUploadInputElement input = querySelector('#input-upload');
    input.onChange.listen(onFileInputChange);
  }

  void onFileInputChange(Event e) {
    print('File Input Change: ${e.target.runtimeType}');
    FileUploadInputElement input = e.target;
    FileList files = input.files;
    for (File file in files) {
      var i = readFileStream(file);
      print('inputChange: File $file, size:${file.size}, count: $i');
    }
  }

  Future<int> readFileStream(File file) async {
    FileStream stream = new FileStream(file);
    int i =  await sumFile(stream);
    print('int: $i');
    return i;
  }

  Future<int> sumFile(FileStream stream) async {
    var sum = 0;
    await for (Uint8List blob in stream) {
      print('sumFile1: length=${blob.length}');
      sum += blob.length;
      String s = blob.sublist(0, 80).toString();
      print('sumFile2: sum = $sum: $s');
    }
    print('sumfile3: sum = $sum');
    return sum;
  }

}



void main() {

  new FileInput();

}
// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.html.file.file_reader;

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:odwhtml/src/file/in_progress/reader_base.dart';

const int kKB = 1024;
const int kMB = 1024 * 1024;
const int kGB = kMB * 1024;

class Reader extends Reader {
  final File file;
  //final Blob blob;
  final FileReader reader = new FileReader();


  Reader(File file, {int maxChunkSize: 1 * kMB , MimeType mType})
      : file = file,
        super(file.size, maxChunkSize);

  String get path => file.name;

  /*
  Uint8List read([Uint8List buffer, bool isAsync]) {
    preRead(buffer);
    (isAsync) ? readAsync() : readSync();
    postRead();
    return blob;
  }
  */

  /// Returns the next chunk of the [file] into [Uint8List] [buffer].
  /// Buffer management is the callers responsibility.

  Future<Uint8List> readAsBytes([Blob buffer]) {
    Uint8List bytes = new Uint8List(1 * kMB);
    var blob = new Blob([bytes], 'application/octet-binary');
    //preRead();
    FileReader reader = new FileReader();
    reader.readAsArrayBuffer(file.slice(index, end));
    Uint8List buffer = reader.result;
    postRead();
    return buffer;
  }

  /// Returns the next chunk of the [file] into [Uint8List] [buffer].
  /// Buffer management is the callers responsibility.
  String readAsText([Blob buffer]) {
    FileReader reader = new FileReader();
    /*
  reader.onLoadEnd.listen((Event e) {
    buffer = reader.result;
    print(buffer.runtimeType);
    });
  */
    preRead();
    reader.readAsText(file.slice(index, end));
    postRead();
    return reader.result;
  }

  /// Returns the next chunk of the [file] into [Uint8List] [buffer].
  /// Buffer management is the callers responsibility.
  Future<Uint8List>  readAsDataUrl([Blob buffer]) async {
    FileReader reader = new FileReader();
    /*
  reader.onLoadEnd.listen((Event e) {
    buffer = reader.result;
    print(buffer.runtimeType);
    });
  */
    preRead();
    await reader.readAsDataUrl(file.slice(index, end));
    postRead();
    return reader.result;
  }
}

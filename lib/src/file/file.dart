// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
library odw.sdk.html.file;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

//TODO: document
//TODO: unit tests

class HtmlFile {
  static String sanitize(String s) => HTML_ESCAPE.convert(s);
  final FileReader reader = new FileReader();
  final File file;
  final Completer completer;

  HtmlFile(this.file)
      : completer = new Completer() {
    reader.onLoad.listen(_onLoad);
    reader.onError.listen(_onError);
    reader.onAbort.listen(_onAbort);
  }

  int get length => file.size;

  String get name => sanitize(file.name);
  String get type => (file.type == null) ? "n/a" : sanitize(file.type);
  int    get size => file.size;
  int    get lastModified => file.lastModified;
  String get date => (file.lastModifiedDate == null) ? "n/a" : file.lastModifiedDate.toString();

  // Do we need onAbort?  Should we be using onLoad rather than onLoadEnd
  void _onLoad(ProgressEvent e) {
    completer.complete(reader.result);
  }

  void _onError(ProgressEvent e) {
  //  FileError error = reader.error;
    completer.complete(reader.error);
  }

  void _onAbort(ProgressEvent e) {

    completer.complete(reader.error);
  }

  Future<Uint8List> readAsArrayBuffer() {
    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  Future<String> readAsString() {
    reader.readAsText(file);
    return completer.future;
  }

  Future<Uri> readAsDataUrl() {
    reader.readAsDataUrl(file);
    return completer.future;
  }

  toHtml() =>
      '<span><strong>${file.name}</strong> ($type) $size bytes, last modified: $date</span>';
}


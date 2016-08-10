// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

//TODO: document
//TODO: unit tests

/// A [Future]s based library for reading a whole [File].
/// from a browser asynchronously.

//TODO: is there a better name for this class?
/// A wrapper for [dart:html] [File]s.  The methods return [Future]s.
class HtmlFile {
  static String percentEncode(String s) => HTML_ESCAPE.convert(s);
  final FileReader reader = new FileReader();
  final File file;
  final Completer completer;

  HtmlFile(this.file)
      : completer = new Completer() {
    reader.onError.listen(_onError);
    reader.onAbort.listen(_onAbort);
  }

  int get length => file.size;

  String get name => percentEncode(file.name);
  String get type => (file.type == null) ? "n/a" : percentEncode(file.type);
  int    get size => file.size;
  int    get lastModified => file.lastModified;
  String get lastModifiedDate =>
      (file.lastModifiedDate == null)
      ? "n/a"
      : file.lastModifiedDate.toString();

  bool get isEmpty => reader.readyState == FileReader.EMPTY;
  bool get isLoading => reader.readyState == FileReader.LOADING;
  bool get isDone => reader.readyState == FileReader.DONE;

  /// Standard [Callback] for [readAsBytes] and [readAsString].
  void _onLoad(ProgressEvent e) {
    //TODO: is this check necessary?
    if (isLoading) throw "Invalid FileReader.readyState: Loading";
    completer.complete(reader.result);
  }

  /// [Callback] for [readAsLines].
  void _onLoadSplitLines(ProgressEvent e) {
    var lines = LineSplitter.split(UTF8.decode(reader.result));
    completer.complete(lines);
  }

  /// [Callback] for [FileReader] errors.
  void _onError(ProgressEvent e) {
    completer.complete(reader.error);
  }

  //TODO: How is this called and what should it do?
  void _onAbort(ProgressEvent e) {
    completer.complete(reader.error);
  }

  /// Returns a [Future] that when complete will have a value that is a [Uint8List].
  Future<Uint8List> readAsBytes() {
    reader.onLoad.listen(_onLoad);
    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  /// Returns a [Future] that when complete will have a value that
  /// is a [List] or [String]s,.where each [String] corresponds to one "line"
  /// of text in the [File].
  Future<Uint8List> readAsLines() {
    reader.onLoad.listen(_onLoadSplitLines);
    reader.readAsText(file);
    return completer.future;
  }

  /// Returns a [Future] that when complete will have a value that is a [String].
  Future<String> readAsString() {
    reader.onLoad.listen(_onLoad);
    reader.readAsText(file);
    return completer.future;
  }

  /// Returns a [Future] that when complete will have a value that is a [DataURL].
  Future<Uri> readAsDataUrl() {
    reader.readAsDataUrl(file);
    return completer.future;
  }



  toHtml() =>
      '<span><strong>${file.name}</strong> ($type) $size bytes, last modified: $lastModifiedDate</span>';
}


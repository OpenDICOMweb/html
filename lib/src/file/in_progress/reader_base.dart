// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.html.file.file_reader_base;

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

const int kKB = 1024;
const int kMB = 1024 * 1024;
const int kGB = kMB * 1024;

/// Use to keep track of a file being transferred in chunks.  It can also be used to
/// to get the data for a Progress Bar, for example.
///
/// [this] is used to allow a [File] to be read in chunks.  It can also be used to access
/// progress information.  The [index] in the file should only updated after the read
/// completes.
class Reader {
  static const maximumChunkSize = 1 * kGB;
  static const defaultChunkSize = 1 * kMB;
  final File file;
  final int maxChunkSize;
  final int length;
  final int nChunks;
  final FileReader reader = new FileReader();
  int _remaining;
  int _nChunksSent = 0;
  int _index = 0;
  int end;
  int _size;


  Reader(File file, [int chunkSize = defaultChunkSize])
      : file = file,
        length = file.size,
        maxChunkSize = chunkSize,
        nChunks = (file.size / chunkSize).ceil(),
        _remaining = file.size;


  /// Returns the [path] of the file being transferred.
  String get path => file.name;

  /// The index of the current position in [this].
  int get index => _index;

  /// Returns [true] if the file has been successfully transferred.
  bool get isComplete => _remaining <= 0;

  /// Returns the number of chunks in this file.
  //int get nChunks => (length / maxChunkSize).ceil();

  /// Returns the number of [chunk]s sent so far.
  int get nChunksSent => _nChunksSent;

  /// Returns the current [chunk] of data.
  //TODO: flush Blob get chunk => _chunk;

  /// Returns a [String] that can be used in the Range header field.
  /// NB: This will only be accurate if called ???
  String get range => 'bytes=$_index-$end';

  /// Returns the size of the next chunk of [file].
  //int get chunkSize => (_remaining < maxChunkSize) ? _remaining : maxChunkSize;

  /// Prepare to read the next chunk.
  int preRead() {
    int _size = chunkSize;
    //TODO: throw an File I/O exception
    if (_size <= 0) throw "Error: no more chunks";
    return _size;
  }

  /// Update state after chunck is successfully read.
  void postRead() {
    _remaining -= _size;
    if (_remaining > 0) {
      _index = _index + _size;
      _nChunksSent++;
    }
  }

  /// Returns the next chunk of the [file] in a [Uint8List] [buffer].
  /// Buffer management is the callers responsibility.
  //TODO: fix
  //void readSync([buffer]);

  /// Returns the percentage of the file transferred so far.
  int get percentTransferred => (length - _remaining) ~/ length;


  /// Returns the next chunk of the [file] into [Uint8List] [buffer].
  /// Buffer management is the callers responsibility.
  Uint8List readAsBytes([Blob buffer]) {
    reader.onLoadEnd.listen((Event e) {
      Blob buffer = reader.result;
      print(buffer.runtimeType);
    });
    Uint8List bytes = new Uint8List(1 * kMB);
    var blob = new Blob([bytes], 'application/octet-binary');
    //preRead();
    reader.readAsArrayBuffer(file.slice(index, end));
    Uint8List buffer = reader.result;
    postRead();
    return buffer;
  }

  /// Returns the next chunk of the [file] into [Uint8List] [buffer].
  /// Buffer management is the callers responsibility.
  String readAsText([Blob buffer]) {

    preRead();
    reader.readAsText(file.slice(index, end));
    postRead();
    return reader.result;
  }

  /// Returns the next chunk of the [file] into [Uint8List] [buffer].
  /// Buffer management is the callers responsibility.
  Blob readAsDataUrl([Blob buffer]) async {
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

  onLoadHandler(ProgressEvent e) {
    if (e.loaded == true) {
      reader.onLoadEnd.listen((Event e) {
        buffer = reader.result;
        print(buffer.runtimeType);
      });
    }

  }

  abortRead() {

  }
}

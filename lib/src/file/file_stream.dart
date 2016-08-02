// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
library odw.sdk.client.file.file_stream ;

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

//TODO: finish testing, cleanup, and document

typedef void CallbackHandler(Event e);

class ReaderState {
  final String name;
  final int value;

  const ReaderState(this.name, this.value);

  isEmpty(int readyState) => readyState == 0;
  isLoading(int readyState) => readyState == 1;
  isDone(int readyState) => readyState == 2;

  static const empty = const ReaderState("Empty", 0);
  static const loading = const ReaderState("Loading", 1);
  static const done = const ReaderState("Done", 2);

  String toString() => name;
}

class FileStream extends Stream {
  static const defaultChunkSize = 1024 * 1024;
  final FileReader reader = new FileReader();
  StreamController<Uint8List> _controller;
  StreamSubscription<Uint8List> _subscription;
  final File file;
  final int chunkSize;
  //TODO: next three should be private
  CallbackHandler onLoad;
  CallbackHandler onError;
  CallbackHandler onProgress;
  int index = 0;
  bool _lengthComputable;
  int state;
  int _loaded = 0;
  int _progress = 0;
  bool _pause = false;

  FileStream(this.file, {
      this.chunkSize: defaultChunkSize,
      onProgress, onLoad, onError}) {
    onProgress = (onProgress == null) ? _onProgress : onProgress;
    onLoad = (onLoad == null) ? _onLoad : onLoad;
    onError = (onError == null) ? _onError : onError;
    reader.onProgress.listen(_onProgress);
    reader.onLoadEnd.listen(_onLoad);
    reader.onError.listen(_onError);

    _controller = new StreamController<Uint8List>(
        onListen: _onListen,
        onPause: _onPause,
        onResume: _onResume,
        onCancel: _onCancel,
    //TODO: make this Synchronous, i.e. sync: true
        sync: true);
  }

  int get _length => file.size;

  int get _end {
    var size = (remaining > chunkSize) ? chunkSize : remaining;
    return index + size;
  }

  String get type => "Uint8List";
  String get name => file.name;
  int get remaining => _length - index;
  int get percent => ((progress / _length) * 100).round();
  int get progress => _progress;
  int get loaded => _loaded;
  int get lastModified => file.lastModified;

  int get lastModifiedDate => file.lastModified;

  bool get isComputable => _lengthComputable;

  Future<int> get length async => await file.size;

  Future<bool> get isEmpty async => await index >= _length;

  Future<bool> get isNotEmpty async => ! await isEmpty;

  StreamSubscription<Uint8List> listen(void onData(Uint8List chunk),
                                       { void onError(Error error),
                                       void onDone(),
                                       bool cancelOnError }) {
    _subscription = _controller.stream.listen(onData,
                                                  onError: onError,
                                                  onDone: onDone,
                                                  cancelOnError: cancelOnError);
    return _subscription;
  }

  void _onListen() {
    reader.readAsArrayBuffer(file.slice(index, _end));
  }

  void _onPause() {
    _pause = true;
    _subscription.pause();
  }

  void _onResume() {
    _pause = false;
    _onListen();
  }

  //TODO: needed?
  Future _onCancel() async => await _subscription.cancel();

  // TODO: flush?
  /*
  void _onLoadStart(ProgressEvent e) {
    state = reader.readyState;
    //print('onLoadStart: state=$state started loading...');
  }
  */

  //TODO: needed?
  //void onLoad(ProgressEvent e) {
  //  print('onLoad: state=$state loaded: $loaded');
  //}

  void _onProgress(ProgressEvent e) {
    _progress += e.loaded;
    _lengthComputable = e.lengthComputable;
    if (isComputable) {
      print('onProgress: loaded $progress($percent%) of $length...');
    } else {
      print('onProgress: loaded $progress bytes...');
    }
  }

  //TODO: remove print statements
  void _onLoad(ProgressEvent e) {
    var state = reader.readyState;
    _loaded += e.loaded;
    print('onLoad: state=$state loaded: $loaded');
    Uint8List result = reader.result;
    index += result.length;
    _controller.add(result);
    print('onLoadEnd: read ${result.length} pf $length bytes, index: $index, _end: $_end');
    if (index >= _end) {
      _controller.done;
    } else {
      if ((!_pause) || (index < _end))
        reader.readAsArrayBuffer(file.slice(index, _end));
    }
  }

  void _onError(e) {
    print("onError: ${reader.error}");
    return _controller.addError(reader.error);
  }
}

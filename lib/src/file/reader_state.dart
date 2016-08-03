// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
library odw.sdk.client.file.reader_state;

import 'dart:html';

/// The [readyState]s defined for a [FileReader].
class ReaderState {
  final String name;
  final int value;

  const ReaderState._(this.name, this.value);

  ReaderState(FileReader reader) {

  }

  isEmpty(int readyState) => readyState == 0;
  isLoading(int readyState) => readyState == 1;
  isDone(int readyState) => readyState == 2;

  static const empty = const ReaderState._("Empty", 0);
  static const loading = const ReaderState._("Loading", 1);
  static const done = const ReaderState._("Done", 2);

  String toString() => name;
}
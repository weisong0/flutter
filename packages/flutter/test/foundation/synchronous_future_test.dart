// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

void main() {
  test('SynchronousFuture control test', () async {
    Future<int> future = new SynchronousFuture<int>(42);

    int result;
    future.then<Null>((int value) { result = value; });

    expect(result, equals(42));
    result = null;

    Future<int> futureWithTimeout = future.timeout(const Duration(milliseconds: 1));
    futureWithTimeout.then<Null>((int value) { result = value; });
    expect(result, isNull);
    await futureWithTimeout;
    expect(result, equals(42));
    result = null;

    Stream<int> stream = future.asStream();

    expect(await stream.single, equals(42));

    bool ranAction = false;
    Future<int> completeResult = future.whenComplete(() {
      ranAction = true;
      return new Future<int>.value(31);
    });

    expect(ranAction, isTrue);
    ranAction = false;

    expect(await completeResult, equals(42));

    Object exception;
    try {
      await future.whenComplete(() {
        throw null;
      });
      // Unreached.
      expect(false, isTrue);
    } catch (e) {
      exception = e;
    }
    expect(exception, isNullThrownError);
  });
}

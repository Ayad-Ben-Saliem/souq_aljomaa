import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

typedef JsonMap = Map<String, dynamic>;
typedef Pair<K, T> = MapEntry<K, T>;

class Utils {
  Utils.pushPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  static Set<int> uniqueSet = {};

  static int getUniqueTag() {
    int randomNumber;
    do {
      randomNumber = Random().nextInt(0x7FFFFFFF);
    } while (uniqueSet.contains(randomNumber));
    uniqueSet.add(randomNumber);
    return randomNumber;
  }

  static bool removeTag(Object object) {
    return uniqueSet.remove(object);
  }

  static bool isStartWithArabicChar(String text) {
    for (var char in text.characters) {
      if (RegExp('^[\u0621-\u064A]').hasMatch(char)) return true;
      if (RegExp('^[a-zA-Z]').hasMatch(char)) return false;
    }
    return false;
  }

  static E getEnumByString<E>(String value, List<E> values) {
    for (var val in values) {
      if (value == val.toString()) {
        return val;
      }
    }
    throw 'Enum $value not found in $values';
  }

  static void prettyPrint(JsonMap json) {
    if (kDebugMode) {
      print(const JsonEncoder.withIndent('  ').convert(json));
    }
  }

  static String getPrettyString(JsonMap json) {
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  static String getReadableDate(DateTime dateTime) {
    var y = _fourDigits(dateTime.year);
    var m = _twoDigits(dateTime.month);
    var d = _twoDigits(dateTime.day);
    var h = _twoDigits(dateTime.hour);
    var min = _twoDigits(dateTime.minute);

    return '$y-$m-$d  $h:$min';
  }

  static String _fourDigits(int n) {
    var absN = n.abs();
    var sign = n < 0 ? '-' : '';
    if (absN >= 1000) return '$n';
    if (absN >= 100) return '${sign}0$absN';
    if (absN >= 10) return '${sign}00$absN';
    return '${sign}000$absN';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  static bool boolean(Object? obj) {
    if (obj is bool) return obj;
    if (obj == null) return false;
    if (obj is num) return obj != 0;
    if (obj is Iterable) return obj.isNotEmpty;
    if (obj is String) return obj.isNotEmpty;

    return true;
  }

  static bool equalsNotNull(dynamic obj1, dynamic obj2) {
    return obj1 == null || obj2 == null || obj1 == obj2;
  }

  static void removeRepeatedObjects<T>(
    List<T> list1,
    List<T> list2,
  ) {
    for (var element in list1) {
      if (list2.remove(element)) list1.remove(element);
    }
  }

  static Iterable<T> replace<T>(
    Iterable<T> iterable,
    T object,
    bool Function(T object) replaceCallback,
  ) {
    final list = iterable.toList();
    for (int i = 0; i < list.length; i++) {
      if (replaceCallback(list.elementAt(i))) {
        list.removeAt(i);
        list.insert(i, object);
      }
    }
    return list;
  }

  static String readableMoney(double money, {int fractionDigits = 3}) {
    return double2String(money, fractionDigits: fractionDigits);
  }

  static String readableDouble(double number, {int fractionDigits = 3}) {
    return double2String(number, fractionDigits: fractionDigits);
  }

  static String double2String(double number, {int fractionDigits = 20}) {
    var result = number.toStringAsFixed(fractionDigits);
    var lastIndex = result.length - 1;
    while (result.contains('.')) {
      if (result[lastIndex] == '0' || result[lastIndex] == '.') {
        result = result.substring(0, lastIndex);
        lastIndex--;
      } else {
        break;
      }
    }
    return result;
  }

  static void showErrorMessage(
    BuildContext context,
    error, {
    StackTrace? stackTrace,
  }) {
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }

  static Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static void catchError(Object error, StackTrace stackTrace) {
    // Save the error to a file
    _saveErrorToFile(error, stackTrace);

    // Optionally, send the error to the developer
    // _sendErrorIfOnline(error, stackTrace);
  }

  static void _saveErrorToFile(Object error, StackTrace stackTrace) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/errors.txt';
    final file = File(path);

    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString(
      'Time: $timestamp\n'
          'Error:\n$error\n'
          'StackTrace:\n$stackTrace\n\n',
      mode: FileMode.append,
    );
  }

  static void _sendErrorIfOnline(Object error, StackTrace stackTrace) async {
    final isConnected = await Utils.checkInternetConnectivity();
    if (isConnected) {
      // Attempt to send the error to Sentry
      await Sentry.captureException(error, stackTrace: stackTrace);
    } else {
      // Save locally if offline
      _saveErrorToFile(error, stackTrace);
    }
  }

  static void _retrySendingErrors() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/errors.txt';
    final file = File(path);

    if (await file.exists()) {
      final errors = await file.readAsString();
      // Parse and send each error to Sentry, then clear the log
      // Once successful, clear the log file
      await file.writeAsString('');
    }
  }
}

abstract class Enum extends Equatable {
  final String str;

  const Enum(this.str);

  // List<T> get values<T extends Enum>;

  @override
  String toString() => str;

  @override
  List<Object?> get props => [str];
}

// typedef VarArgsCallback = dynamic Function(
//   List args,
//   JsonMap kwargs,
// );
//
// JsonMap map(Map<Symbol, dynamic> namedArguments) {
//   final _offset = 'Symbol("'.length;
//   return namedArguments.map(
//     (key, value) {
//       var _key = '$key';
//       _key = _key.substring(_offset, _key.length - 2);
//       return MapEntry(_key, value);
//     },
//   );
// }
//
// class VarargsFunction {
//   final VarArgsCallback callback;
//
//   VarargsFunction(this.callback);
//
//   @override
//   dynamic noSuchMethod(Invocation invocation) {
//     if (!invocation.isMethod || invocation.namedArguments.isNotEmpty)
//       super.noSuchMethod(invocation);
//     return callback(
//       invocation.positionalArguments,
//       map(invocation.namedArguments),
//     );
//   }
// }
//
// class ListenableFunction {
//   final callbacks = <VarArgsCallback>[];
//
//   final VarArgsCallback callback;
//
//   ListenableFunction(this.callback);
//
//   @override
//   dynamic noSuchMethod(Invocation invocation) {
//     if (invocation.isMethod) {
//       callbacks.forEach(
//         (callback) => callback(
//           invocation.positionalArguments,
//           map(invocation.namedArguments),
//         ),
//       );
//       return callback(
//         invocation.positionalArguments,
//         map(invocation.namedArguments),
//       );
//       ;
//     }
//     super.noSuchMethod(invocation);
//   }
//
//   void listen(VarArgsCallback callback) => callbacks.add(callback);
// }
//
// class Validation {
//   final bool valid;
//   final List<String>? errors;
//
//   Validation.valid()
//       : valid = true,
//         errors = null;
//
//   Validation.invalid([this.errors]) : valid = false;
//
//   @override
//   String toString() {
//     return valid ? 'valid' : 'invalid ${errors ?? ''}';
//   }
// }
//
// typedef ListenCallback<R, T> = R Function(T);
//
// class ValueListener<R, T> {
//   ListenCallback<R, T>? _callback;
//
//   ListenCallback<R, T>? get callback => _callback;
//
//   void listen(ListenCallback<R, T> callback) => _callback = callback;
// }

extension ResetExtension<T> on List<T> {
  void reset(Iterable<T> iterable) {
    clear();
    addAll(iterable);
  }
}

extension ListReplaceExtension<E> on List<E> {
  void replace(E element1, E element2) {
    final index = indexWhere((element) => element == element1);
    if (index != -1) throw StateError('Element ($element1) not found');
    this[index] = element2;
  }

  void replaceWhere(E Function(E element) test) {
    for (int index = 0; index < length; index++) {
      this[index] = test(this[index]);
    }
  }
}

extension SetReplaceExtension<E> on Set<E> {
  void replace(E element1, E element2) {
    final list = <E>[
      for (final element in this) element == element1 ? element2 : element,
    ];
    removeAll(this);
    addAll(list);
  }

  void replaceWhere(E Function(E element) test) {
    final list = <E>[for (final element in this) test(element)];
    removeAll(toList());
    addAll(list);
  }
}

bool isSubtype<S, T>() => <S>[] is List<T>;

extension StringExtension on String {
  bool containEachOther(String str) {
    return contains(str) || str.contains(this);
  }

  bool containEachOtherIgnoreCase(String str) {
    return toLowerCase().contains(str.toLowerCase()) ||
        str.toLowerCase().contains(toLowerCase());
  }
}

void debug(Object? object) {
  if (kDebugMode) print(object);
}

bool isImage(String filename) {
  for (final ext in ['.png', '.jpg', '.jpeg', '.tif']) {
    if (filename.endsWith(ext)) return true;
  }
  return false;
}

bool isRemoteUrl(String path) {
  final uri = Uri.tryParse(path);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}

bool isFileExist(String filename) {
  return File(filename).existsSync();
}

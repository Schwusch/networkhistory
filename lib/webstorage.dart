import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:state_persistence/state_persistence.dart';

class WebFileStorage extends PersistedStateStorage {
  const WebFileStorage({
    this.initialData = const {},
    this.clearDataOnLoadError = false,
  }) : assert(initialData != null &&
      clearDataOnLoadError != null);

  final Map<String, dynamic> initialData;
  final bool clearDataOnLoadError;

  @override
  Future<Map<String, dynamic>> load() async {
    try {
      return json.decode(html.window.localStorage['data'] ?? "{}");
    } catch (e, st) {
      if (clearDataOnLoadError) {
        await clear();
      }
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: st,
        library: 'state_persistence',
        silent: true,
      ));
    }

    return Map.from(initialData);
  }

  @override
  Future<void> save(Map<String, dynamic> data) {
    html.window.localStorage['data'] = jsonEncode(data);
    return Future.value();
  }

  @override
  Future<void> clear() {
    html.window.localStorage['data'] = null;
    return Future.value();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is JsonFileStorage && runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => super.hashCode;

}
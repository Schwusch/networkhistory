import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:networkviewer/NetworkItem.dart';
import 'package:state_persistence/state_persistence.dart';
import 'package:tree_view/tree_view.dart';

final theme = ThemeData(primarySwatch: Colors.blue, accentColor: Colors.yellow);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PersistedAppState(
      storage: WebFileStorage(),
      child: PersistedStateBuilder(builder:
          (BuildContext context, AsyncSnapshot<PersistedData> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            key: ObjectKey(snapshot.data),
            theme: theme,
            home: MyHomePage(
              title: 'Network Viewer',
              data: snapshot.data,
            ),
          );
        } else
          return MaterialApp(
            key: ObjectKey(null),
            theme: theme,
            home: MyHomePage(title: 'Network Viewer'),
          );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.data}) : super(key: key);

  final String title;
  final PersistedData data;

  @override
  _MyHomePageState createState() => _MyHomePageState(data);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(PersistedData data) {
    List list = data == null ? [] : data['history'];
    items = List.generate(
      list?.length ?? 0,
          (index) => NetworkItem.fromJson(list[index]),
    );
  }

  List<NetworkItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TreeView(
        parentList: <Parent>[
          for (final item in items)
            Parent(
              parent: ListTile(
                title: Text(item.url),
                leading: Icon(Icons.http),
              ),
              childList: ChildList(
                children: [
                  Text(item.responseBody),
                ],
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startWebFilePicker,
        tooltip: 'Load file',
        child: Icon(Icons.folder_open),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  startWebFilePicker() async {
    html.InputElement fileInput = html.FileUploadInputElement();
    fileInput
      ..accept = ".json"
      ..multiple = false
      ..draggable = true
      ..onChange.listen((e) async {
        final reader = new html.FileReader();
        reader
          ..readAsText(fileInput.files.first)
          ..onLoadEnd.first.then((value) {
            final List foo = jsonDecode(reader.result);
            widget.data['history'] = foo;
            final List<NetworkItem> bar =
            foo.map((element) => NetworkItem.fromJson(element)).toList();
            setState(() {
              items = bar;
            });
          });
      })
      ..click();
  }
}

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
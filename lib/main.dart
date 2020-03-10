import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:networkviewer/NetworkItem.dart';
import 'package:networkviewer/network_list_item.dart';
import 'package:networkviewer/webstorage.dart';
import 'package:state_persistence/state_persistence.dart';

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
              data: snapshot.data,
            ),
          );
        } else
          return MaterialApp(
            key: ObjectKey(null),
            theme: theme,
            home: MyHomePage(),
          );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.data}) : super(key: key);
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
  final listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final haveData = items.length > 0;

    return Scaffold(
      body: haveData
          ? ListView.builder(
              key: listKey,
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  NetworkItemWidget(item: items[index]),
            )
          : Center(
              child: Text('Nothing loaded'),
            ),
      floatingActionButtonLocation: haveData
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: haveData ? resetData : startWebFilePicker,
        tooltip: haveData ? 'Clear data' : 'Load file',
        child: Icon(haveData ? Icons.clear_all : Icons.folder_open),
      ),
    );
  }

  resetData() {
    setState(() {
      widget.data.clear();
      items = [];
    });
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

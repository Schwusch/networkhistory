import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:networkviewer/NetworkItem.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedList(
        initialItemCount: items.length,
        itemBuilder: (context, index, animation) => Card(
          child: ListTile(
            title: Text(items[index].url),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            body: SingleChildScrollView(
                              child: Center(
                                child:
                                    SelectableText(items[index].responseBody),
                              ),
                            ),
                          )));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startWebFilePicker,
        tooltip: 'Load file',
        child: Icon(Icons.folder_open),
      ),
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

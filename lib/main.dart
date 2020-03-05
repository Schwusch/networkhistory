import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:networkviewer/NetworkItem.dart';
import 'package:tree_view/tree_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Viewer',
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.yellow),
      home: MyHomePage(title: 'Network Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NetworkItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TreeView(
        parentList: <Parent>[
          for (final item in items)
            Parent(parent: ListTile(
              title: Text(item.url),
              leading: Icon(Icons.http),
            ), childList: ChildList(
              children: [
                Text(item.responseBody)
              ]
            ))
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
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = ".json";
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      final file = files.first;
      final reader = new html.FileReader();
      reader.readAsText(file);
      reader.onLoadEnd.first.then((value) {
        final List foo = jsonDecode(reader.result);
        final List<NetworkItem> bar =
            foo.map((element) => NetworkItem.fromJson(element)).toList();
        setState(() {
          items = bar;
        });
      });
    });
    uploadInput.click();
  }
}

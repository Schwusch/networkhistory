import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:networkviewer/NetworkItem.dart';

class ReplayWidget extends StatefulWidget {
  final NetworkItem item;

  ReplayWidget({Key key, NetworkItem item})
      // Lazy way of deep copying
      : item = NetworkItem.fromJson(item.toJson()),
        super(key: key);

  @override
  _ReplayWidgetState createState() => _ReplayWidgetState(item);
}

class _ReplayWidgetState extends State<ReplayWidget> {
  final NetworkItem item;
  Client client = Client();
  TextEditingController headerController;
  TextEditingController bodyController;
  TextEditingController urlController;

  _ReplayWidgetState(this.item) {
    headerController = TextEditingController(text: item.requestHeaders);
    bodyController = TextEditingController(text: item.requestBody);
    urlController = TextEditingController(text: item.url.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.mail),
                hintText: 'Url',
                labelText: 'Url:',
              ),
              controller: urlController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.face),
                hintText: 'Headers',
                labelText: 'Headers:',
              ),
              controller: headerController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            if (item.method.toLowerCase() != 'get')
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.pregnant_woman),
                  hintText: 'Body',
                  labelText: 'Body:',
                ),
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              )
          ],
        ),
      ),
    );
  }
}

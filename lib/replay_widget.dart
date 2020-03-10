import 'dart:convert';

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
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  TextEditingController headerController;
  TextEditingController bodyController;
  TextEditingController urlController;
  String responseBody;
  String responseHeaders;
  int responseCode;

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
              ),
            if (responseCode != null)
              Text(
                'Response Code: $responseCode',
                style: Theme.of(context).textTheme.headline5,
              ),
            if (responseHeaders != null) ...[
              Text(
                'Response headers:',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(responseHeaders)
            ],
            if (responseBody != null) ...[
              Text(
                'Response body:',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(responseBody)
            ]
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: runRequest,
      ),
    );
  }

  runRequest() async {
    final request = Request(item.method, Uri.parse(urlController.text));
    request.body = bodyController.text;

    headerController.text
        .split('\n')
        .where((e) => e.isNotEmpty)
        .map((e) => e.split(' : '))
        .forEach((h) => request.headers[h.first] = h.last);
    final rs = await client.send(request);
    final body = await rs.stream.bytesToString();

    setState(() {
      try {
        responseBody = encoder.convert(jsonDecode(body));
      } catch (e) {
        responseBody = body;
      }

      responseHeaders =
          rs.headers.entries.map((e) => '${e.key} : ${e.value}').join('\n');
      responseCode = rs.statusCode;
    });
  }
}

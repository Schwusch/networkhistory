import 'package:flutter/material.dart';
import 'package:networkviewer/NetworkItem.dart';
import 'package:networkviewer/util.dart';

class NetworkItemDetailWidget extends StatefulWidget {
  const NetworkItemDetailWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final NetworkItem item;

  @override
  _NetworkItemDetailWidgetState createState() =>
      _NetworkItemDetailWidgetState();
}

class _NetworkItemDetailWidgetState extends State<NetworkItemDetailWidget>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = [
    Tab(
      text: 'REQUEST',
      icon: Icon(Icons.file_upload),
    ),
    Tab(
      text: 'RESPONSE',
      icon: Icon(Icons.file_download),
    )
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: SelectableText(item.url.path),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DetailPageWidget(
            body: item.requestBody,
            headers: item.requestHeaders,
            uri: item.url,
          ),
          DetailPageWidget(
            body: item.responseBody,
            headers: item.responseHeaders,
            uri: item.url,
          )
        ],
      ),
    );
  }

  void copyText(BuildContext context, String text, String message) {
    copyToClipboardHack(text);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

class DetailPageWidget extends StatelessWidget {
  final String headers;
  final String body;
  final Uri uri;

  const DetailPageWidget({Key key, this.headers, this.body, this.uri})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (headers.isNotEmpty) ...[
              Text('Headers', style: Theme.of(context).textTheme.headline5),
              SelectableText(headers)
            ],
            if (uri.queryParameters.isNotEmpty) ...[
              Text('Parameters', style: Theme.of(context).textTheme.headline5),
              SelectableText(uri.queryParameters.entries
                  .map((entry) => '${entry.key}: ${entry.value}')
                  .join('\n'))
            ],
            if (body.isNotEmpty) ...[
              Text('Body', style: Theme.of(context).textTheme.headline5),
              SelectableText(body)
            ]
          ],
        ),
      ),
    );
  }
}

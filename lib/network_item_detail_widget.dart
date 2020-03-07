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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.item.url}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DetailPageWidget(
            body: widget.item.requestBody,
            headers: widget.item.requestHeaders,
          ),
          DetailPageWidget(
            body: widget.item.responseBody,
            headers: widget.item.responseHeaders,
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

  const DetailPageWidget({Key key, this.headers, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Headers', style: Theme.of(context).textTheme.headline5),
            Text(headers),
            Text('Body', style: Theme.of(context).textTheme.headline5),
            Text(body)
          ],
        ),
      ),
    );
  }
}

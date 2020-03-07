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
      text: 'RESPONSE',
      icon: Icon(Icons.file_download),
    ),
    Tab(
      text: 'REQUEST',
      icon: Icon(Icons.file_upload),
    ),
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
      body: NestedScrollView(
        headerSliverBuilder: (context, value) => [
          SliverAppBar(
            floating: true,
            title: SelectableText('${item.url.path}  ${item.responseCode}'),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _SliverAppBarDelegate(TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
              tabs: tabs,
            )),
          )
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            DetailPageWidget(
              body: item.responseBody,
              headers: item.responseHeaders,
            ),
            DetailPageWidget(
              body: item.requestBody,
              headers: item.requestHeaders,
              uri: item.url,
            ),
          ],
        ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      Container(
        color: Theme.of(context).bottomAppBarColor,
        child: _tabBar,
      );

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class DetailPageWidget extends StatelessWidget {
  final String headers;
  final String body;
  final Uri uri;

  const DetailPageWidget({Key key, this.headers, this.body, this.uri})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (headers.isNotEmpty) ...[
                Text('Headers', style: Theme.of(context).textTheme.headline5),
                SelectableText(headers)
              ],
              if (uri?.queryParameters?.isNotEmpty == true) ...[
                Text('Parameters',
                    style: Theme.of(context).textTheme.headline5),
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

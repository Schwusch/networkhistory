import 'package:flutter/material.dart';
import 'package:networkviewer/NetworkItem.dart';
import 'package:networkviewer/network_item_detail_widget.dart';
import 'package:networkviewer/util.dart';

class NetworkItemWidget extends StatelessWidget {
  const NetworkItemWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final NetworkItem item;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onLongPress: () => copyText(context, item.url),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.method),
              Text(
                '${item.responseCode}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          title: Text(
            item.url,
            style: TextStyle(color: item.responseCode.httpColor),
          ),
          subtitle: Text("Time: ${item.time} ms"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NetworkItemDetailWidget(item: item),
              ),
            );
          },
        ),
      );

  void copyText(BuildContext context, String text) {
    copyToClipboardHack(text);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('URL copied!'),
      ),
    );
  }
}

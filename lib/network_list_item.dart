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
          onLongPress: () => copyText(context, item.url.toString()),
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
          title: SelectableText(
            item.url.authority,
            style: TextStyle(color: item.responseCode.httpColor),
          ),
          subtitle: SelectableText("${item.url.path}\nTime: ${item.time} ms"),
          isThreeLine: true,
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

import 'dart:html';

import 'package:flutter/material.dart';

extension HttpCodeToColor on int {
  Color get httpColor {
    if (this >= 200 && this < 300) return Colors.green;
    if (this >= 400 && this < 500) return Colors.orange;
    if (this >= 500 && this < 600) return Colors.redAccent;

    return Colors.blueGrey;
  }
}

bool copyToClipboardHack(String text) {
  final textarea = new TextAreaElement();
  document.body.append(textarea);
  textarea.style
    ..border = '0'
    ..margin = '0'
    ..padding = '0'
    ..opacity = '0'
    ..position = 'absolute';

  textarea
    ..readOnly = true
    ..value = text
    ..select();

  final result = document.execCommand('copy');
  textarea.remove();
  return result;
}

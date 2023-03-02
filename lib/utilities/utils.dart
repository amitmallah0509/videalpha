import 'package:flutter/material.dart';

class Utils {
  static final Utils _to = Utils._internal();

  factory Utils() {
    return _to;
  }

  Utils._internal() {
    //inital
  }

  static Utils get to => _to;

  showToast(BuildContext? context, String? msg) {
    if (msg == null || msg == '' || context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        elevation: 30,
      ),
    );
  }
}

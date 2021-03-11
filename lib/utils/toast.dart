import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void flutterToast(String message, BuildContext context) {
  Toast.show(
    message,
    context,
    gravity: Toast.CENTER,
  );
}
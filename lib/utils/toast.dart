import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

// 메시지를 출력해서 보여주는 기능
void flutterToast(String message, BuildContext context) {
  Toast.show(
    message,
    context,
    gravity: Toast.CENTER,
  );
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void errorAlert(message) {
  dynamic text = message;

  if (text is Map) {
    if (text.containsKey('errors') && text['errors'] is Map) {
      text = text['errors'].values.map((value) {
        if (value is List) {
          return value.join('\n');
        }
        return value;
      }).join('\n');
    }
  }

  Get.snackbar(
    '',
    '',
    titleText: const SizedBox(),
    messageText: Row(
      children: [
        const Icon(
          Icons.error,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text.toString()),
        ),
      ],
    ),
    isDismissible: true,
    duration: const Duration(seconds: 3),
    backgroundColor: const Color(0xffE4E4E4),
    borderRadius: 10,
  );
}

void successAlert(String message) {
  Get.snackbar(
    '',
    '',
    titleText: const SizedBox(),
    messageText: Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xff1AB147),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message.toString()),
        ),
      ],
    ),
    isDismissible: true,
    duration: const Duration(seconds: 3),
    backgroundColor: const Color(0xffE4E4E4),
    borderRadius: 10,
  );
}

void warningAlert(String message) {
  Get.snackbar(
    '',
    '',
    titleText: const SizedBox(),
    messageText: Row(
      children: [
        const Icon(
          Icons.warning,
          color: Color(0xfff5a25d),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message.toString()),
        ),
      ],
    ),
    isDismissible: true,
    duration: const Duration(seconds: 3),
    backgroundColor: const Color(0xffE4E4E4),
    borderRadius: 10,
  );
}

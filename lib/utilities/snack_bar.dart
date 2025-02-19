import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSnackBar(BuildContext context, message,
    {required bool err,
    EdgeInsets? edge,
    bool? info,
    bool? isCancellable,
    Function? onClick,
    int? seconds,
    int? type}) {
  if (info != null && info) {
    toastification.show(
        context: context,
        title: const Text("Info"),
        description: Text("$message"),
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(
          seconds: 4,
        ),
        type: ToastificationType.info);
  } else if (err) {
    toastification.show(
      context: context,
      title: const Text("Error"),
      description: Text("$message"),
      style: ToastificationStyle.minimal,
      type: ToastificationType.error,
      autoCloseDuration: const Duration(
        seconds: 4,
      ),
    );
  } else {
    toastification.show(
      context: context,
      title: const Text("Success"),
      description: Text("$message"),
      style: ToastificationStyle.minimal,
      type: ToastificationType.success,
      autoCloseDuration: const Duration(
        seconds: 4,
      ),
    );
  }
}

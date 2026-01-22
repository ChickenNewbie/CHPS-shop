import 'package:flutter/material.dart';

class ConfirmDialog{
  static Future<bool> show({
    required BuildContext context,
    Widget? title,
    required Widget content,
    String? confirmButtonText,
    String? cancelButtonText,
    IconData? confirmIcon,
    IconData? cancelIcon
  }){
    return showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: [
          ElevatedButton.icon(
            onPressed: () =>  Navigator.of(context).pop(false), 
            icon: Icon(cancelIcon ?? Icons.cancel_outlined),
            label: Text(cancelButtonText ?? "Cancel")
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true), 
            icon: Icon( confirmIcon ?? Icons.check_circle_outline),
            label: Text(confirmButtonText ?? "Ok")
          ),
        ],
      )
    ).then((value) => value ?? false);
  }
}
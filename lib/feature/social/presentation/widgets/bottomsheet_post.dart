import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/config/theme.dart';

class BottomSheetPost {
  static void show(context, VoidCallback onTap, String title) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: t16R,
              ),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SnackbarType { informative, success, error, warning }

class CommonSnackbar {
  static show(BuildContext context,
      {required SnackbarType type, required String message}) {
    getColor() {
      MaterialColor color;
      switch (type) {
        case SnackbarType.success:
          color = Colors.green;
          break;
        case SnackbarType.informative:
          color = Colors.lightBlue;
          break;
        case SnackbarType.error:
          color = Colors.red;
          break;
        case SnackbarType.warning:
          color = Colors.orange;
          break;
        default:
          color = Colors.green;
      }
      return color;
    }

    getIcon() {
      IconData icon;
      switch (type) {
        case SnackbarType.success:
          icon = Icons.sentiment_very_satisfied;
          break;
        case SnackbarType.informative:
          icon = Icons.sentiment_neutral;
          break;
        case SnackbarType.error:
          icon = Icons.sentiment_very_dissatisfied;
          break;
        case SnackbarType.warning:
          icon = Icons.sentiment_dissatisfied;
          break;
        default:
          icon = Icons.sentiment_very_satisfied;
      }
      return icon;
    }

    //custom snackbar
    customSnackbar(String message) => Material(
          child: Container(
            height: 64,
            decoration: BoxDecoration(
                color: getColor(), borderRadius: BorderRadius.circular(8.0)),
            child: Stack(
              children: [
                SizedBox(
                    width: 264,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            message,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: t16M.copyWith(color: Colors.white),
                          ),
                        ))),
                Positioned(
                  right: 0,
                  child: Transform.rotate(
                      angle: 120,
                      child:
                          Icon(getIcon(), size: 88, color: AppColors.ink[0])),
                ),
              ],
            ),
          ),
        );
    //show snackbar
    showTopSnackBar(context, customSnackbar(message),
        displayDuration: const Duration(milliseconds: 1000));
  }
}

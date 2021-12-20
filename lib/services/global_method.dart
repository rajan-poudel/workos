import 'package:flutter/material.dart';
import 'package:workos/constants/constants.dart';

class GlobalMethod {
  static void showErrorDialog(
      {required String error, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              Text(
                "Error occured ",
                style: TextStyle(color: Colors.pink.shade800),
              ),
            ],
          ),
          elevation: 10,
          content: Text(
            " $error",
            style: TextStyle(
              color: Constants.darkBlue,
              fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

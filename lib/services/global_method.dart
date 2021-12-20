import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants/constants.dart';

import '../user_state.dart';

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

  static void logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
              ),
              Text(
                "Sign Out",
                style: TextStyle(color: Colors.pink.shade800),
              ),
            ],
          ),
          elevation: 10,
          content: const Text(
            "Do You wanna Sign Out?",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserState(),
                  ),
                );
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

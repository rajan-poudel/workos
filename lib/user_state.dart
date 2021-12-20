import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos/screens/auth/login.dart';
import 'package:workos/screens/tasks_screen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.data == null) {
            return const Login();
          } else if (userSnapshot.hasData) {
            return const TasksScreen();
          } else if (userSnapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("an Error occured"),
              ),
            );
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        });
  }
}

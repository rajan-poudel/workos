import 'package:flutter/material.dart';
import 'package:workos/screens/auth/login.dart';
import 'package:workos/screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter workos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFEDE7DC),
          primarySwatch: Colors.blue,
        ),
        home: TasksScreen());
  }
}

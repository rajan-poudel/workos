import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/inner_screen/profile.dart';
import 'package:workos/inner_screen/upload_task.dart';
import 'package:workos/screens/all_workers.dart';
import 'package:workos/screens/tasks_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.cyan,
            ),
            child: Column(
              children: [
                Flexible(
                  child: Image.network(
                      "https://image.flaticon.com/icons/png/128/390/390973.png"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Text(
                    "Work OS",
                    style: TextStyle(
                        color: Constants.darkBlue,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          _listTiles(
            label: 'All tasks',
            fct: () {
              _navigateToAllTaskScreen(context);
            },
            icon: Icons.task_outlined,
          ),
          _listTiles(
            label: 'My account',
            fct: () {
              _navigateProfileScreen(context);
            },
            icon: Icons.settings_outlined,
          ),
          _listTiles(
            label: 'Registered Workers',
            fct: () {
              _navigateAllWorkersScreen(context);
            },
            icon: Icons.workspaces_outline,
          ),
          _listTiles(
            label: 'Add Task',
            fct: () {
              _navigateToAddTaskScreen(context);
            },
            icon: Icons.add_task,
          ),
          const Divider(
            thickness: 2,
          ),
          _listTiles(
            label: 'Logout',
            fct: () {
              _logout(context);
            },
            icon: Icons.logout_outlined,
          ),
        ],
      ),
    );
  }

  Widget _listTiles(
      {required String label, required Function fct, required IconData icon}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Constants.darkBlue,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 20,
        ),
      ),
      onTap: () {
        fct();
      },
    );
  }

  void _navigateToAllTaskScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasksScreen(),
      ),
    );
  }

  void _navigateProfileScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  void _navigateAllWorkersScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllWorkersScreen(),
      ),
    );
  }

  void _navigateToAddTaskScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadTask(),
      ),
    );
  }

  void _logout(context) {
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

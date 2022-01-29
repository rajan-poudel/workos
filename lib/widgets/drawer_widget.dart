import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/inner_screen/profile.dart';
import 'package:workos/inner_screen/upload_task.dart';
import 'package:workos/screens/all_workers.dart';
import 'package:workos/screens/tasks_screen.dart';
import 'package:workos/services/global_method.dart';

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
                  // child: Image.network(
                  //     "https://image.flaticon.com/icons/png/128/390/390973.png"),
                  child: Image.asset(
                    "assets/images/task.jpg",
                    fit: BoxFit.fill,
                  ),
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
              GlobalMethod.logout(context);
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
        builder: (context) => const TasksScreen(),
      ),
    );
  }

  void _navigateProfileScreen(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userId: uid,
        ),
      ),
    );
  }

  void _navigateAllWorkersScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AllWorkersScreen(),
      ),
    );
  }

  void _navigateToAddTaskScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadTask(),
      ),
    );
  }
}

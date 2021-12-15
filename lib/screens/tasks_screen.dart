import 'package:flutter/material.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/task_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<String> taskCategoryList = [
    'Business',
    'Programming',
    'Information Technology',
    'Human resources',
    'Marketing',
    'Design',
    'Accounting'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        // leading: Builder(builder: (ctx) {
        //   return IconButton(
        //     icon: Icon(
        //       Icons.menu,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       Scaffold.of(ctx).openDrawer();
        //     },
        //   );
        // }),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Tasks",
          style: TextStyle(color: Colors.pink),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showTaskCategoriesDialog(size: size);
              },
              icon: Icon(
                Icons.filter_list_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return TaskWidget();
      }),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Task category',
            style: TextStyle(color: Colors.pink.shade800),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
                itemCount: taskCategoryList.length,
                shrinkWrap:
                    true, //yesle chai content anusar wrap garxa dherai khali thau xodna didaina
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.red.shade200,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            taskCategoryList[index],
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Cancel filter'),
            ),
          ],
        );
      },
    );
  }
}

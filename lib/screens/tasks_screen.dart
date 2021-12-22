import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/task_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskWidget(
                      taskTitle: snapshot.data!.docs[index]['taskTitle'],
                      taskDescription: snapshot.data!.docs[index]
                          ['taskDescription'],
                      taskId: snapshot.data!.docs[index]['taskId'],
                      uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                      isDone: snapshot.data!.docs[index]['isDone'],
                    );
                  });
            } else {
              Center(
                child: Text(
                  "There is no Tasks",
                  style: TextStyle(fontSize: 30),
                ),
              );
            }
          }
          return Center(
              child: Text(
            "Something went Wrong",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ));
        },
      ),
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
                itemCount: Constants.taskCategoryList.length,
                shrinkWrap:
                    true, //yesle chai content anusar wrap garxa dherai khali thau xodna didaina
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print(
                          "taskCategoryList[index],${Constants.taskCategoryList[index]}");
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.red.shade200,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Constants.taskCategoryList[index],
                            style: TextStyle(
                              color: Constants.darkBlue,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
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

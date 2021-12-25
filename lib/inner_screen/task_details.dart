import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/services/global_method.dart';
import 'package:workos/widgets/comments_widget.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String uploadedBY;
  final String taskId;

  const TaskDetailsScreen({required this.uploadedBY, required this.taskId});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  var _textStyle = TextStyle(
    color: Constants.darkBlue,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  var _titleStyle = TextStyle(
      fontWeight: FontWeight.bold, color: Constants.darkBlue, fontSize: 20);

  TextEditingController _commentController = TextEditingController();

  bool _isCommenting = false;

  String? authorName;
  String? authorPosition;
  String? userImage;
  String? taskCategory;
  String? taskDescription;
  String? taskTitle;
  bool? _isDone;
  Timestamp? postedDateTimestamp;
  Timestamp? deadlineDateTimestamp;
  String? postedDate;
  String? deadLineDate;
  bool isDeadlineAvailable = false;

  @override
  void initState() {
    super.initState();
    getTaskData();
  }

  void getTaskData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBY)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        authorPosition = userDoc.get('positionCompany');
        userImage = userDoc.get('userImage');
      });
    }

    final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();

    if (taskDatabase == null) {
      return;
    } else {
      setState(() {
        _isDone = taskDatabase.get('isDone');
        taskTitle = taskDatabase.get('taskTitle');
        taskCategory = taskDatabase.get("taskCategory");
        taskDescription = taskDatabase.get('taskDescription');
        postedDateTimestamp = taskDatabase.get('createdAt');
        deadlineDateTimestamp = taskDatabase.get('deadlineDateTimestamp');
        deadLineDate = taskDatabase.get('deadlineDate');
        var postDate = postedDateTimestamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });
      var date = deadlineDateTimestamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Back",
            style: TextStyle(
                color: Constants.darkBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(
              taskTitle == null ? '' : taskTitle!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Constants.darkBlue,
                  fontSize: 30),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Uploaded by",
                            style: TextStyle(
                                color: Constants.darkBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic),
                          ),
                          const Spacer(),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.pink),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  userImage == null
                                      ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                      : userImage!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(authorName == null ? '' : authorName!,
                                    style: _textStyle),
                                Text(
                                  authorPosition == null ? '' : authorPosition!,
                                  style: _textStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Divider(
                      //   thickness: 1,
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),

                      _dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Uploaded on: ", style: _titleStyle),
                          // Spacer(),
                          Text(postedDate == null ? '' : postedDate!,
                              style: _textStyle),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("DeadLine date: ", style: _titleStyle),
                          // Spacer(),
                          Text(
                            deadLineDate == null ? '' : deadLineDate!,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          isDeadlineAvailable
                              ? "Still have a time "
                              : "Deadline passed",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: isDeadlineAvailable
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 15),
                        ),
                      ),
                      _dividerWidget(),
                      Text("Done State: ", style: _titleStyle),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              User? user = _auth.currentUser;
                              var _uid = user!.uid;
                              if (_uid == widget.uploadedBY) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.taskId)
                                      .update({'isDone': true});
                                } catch (error) {
                                  GlobalMethod.showErrorDialog(
                                      error: "Action cannot be performed",
                                      context: context);
                                }
                              } else {
                                GlobalMethod.showErrorDialog(
                                    error: "you can't perform this action",
                                    context: context);
                              }
                              getTaskData();
                            },
                            child: Text(
                              "Done ",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                                color: Constants.darkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: _isDone == true ? 1 : 0,
                            child: const Icon(
                              Icons.check_box_rounded,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () {
                              User? user = _auth.currentUser;
                              var _uid = user!.uid;
                              if (_uid == widget.uploadedBY) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.taskId)
                                      .update({'isDone': false});
                                } catch (error) {
                                  GlobalMethod.showErrorDialog(
                                      error: "Action cannot be performed",
                                      context: context);
                                }
                              } else {
                                GlobalMethod.showErrorDialog(
                                    error: "you can't perform this action",
                                    context: context);
                              }
                              getTaskData();
                            },
                            child: Text(" Not Done ",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Constants.darkBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                          Opacity(
                            opacity: _isDone == false ? 1 : 0,
                            child: const Icon(
                              Icons.check_box_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      _dividerWidget(),
                      Text("Task description: ", style: _titleStyle),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(taskDescription == null ? '' : taskDescription!,
                          style: _textStyle),
                      const SizedBox(
                        height: 10,
                      ),

                      AnimatedSwitcher(
                        duration: const Duration(
                          microseconds: 500,
                        ),
                        child: _isCommenting
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentController,
                                      maxLength: 200,
                                      keyboardType: TextInputType.text,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.pink),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Constants.darkBlue,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: MaterialButton(
                                          color: Colors.pink.shade700,
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onPressed: () async {
                                            if (_commentController
                                                .text.isEmpty) {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      "please enter comment first",
                                                  context: context);
                                            } else {
                                              var _generatedId = Uuid().v4();
                                              await FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(widget.taskId)
                                                  .update({
                                                'taskComments':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'userId': widget.uploadedBY,
                                                    'commentId': _generatedId,
                                                    'name': authorName,
                                                    'userImage': userImage,
                                                    'commentBody':
                                                        _commentController.text,
                                                    'time': Timestamp.now(),
                                                  }
                                                ])
                                              });
                                              await Fluttertoast.showToast(
                                                msg:
                                                    "your comment has been added",
                                                toastLength: Toast.LENGTH_SHORT,
                                                // gravity: ToastGravity.CENTER,
                                                // timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey,
                                                // textColor: Colors.white,
                                                fontSize: 18.0,
                                              );
                                              _commentController.clear();
                                            }
                                            setState(() {});
                                          },
                                          child: const Text(
                                            "Post",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isCommenting = !_isCommenting;
                                          });
                                        },
                                        child: const Text("Cancel"),
                                      )
                                    ],
                                  ))
                                ],
                              )
                            : Center(
                                child: MaterialButton(
                                  color: Colors.pink.shade700,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  onPressed: () {
                                    setState(() {
                                      _isCommenting = !_isCommenting;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "Add a comment",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      //comment Section

                      FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(widget.taskId)
                              .get(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              if (snapshot.data == null) {
                                return const Center(
                                  child: Text("No Comments"),
                                );
                              }
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                  commentId: snapshot.data!['taskComments']
                                      [index]['commentId'],
                                  commenterId: snapshot.data!['taskComments']
                                      [index]['userId'],
                                  commenterName: snapshot.data!['taskComments']
                                      [index]['name'],
                                  commenterImage: snapshot.data!['taskComments']
                                      [index]['userImage'],
                                  commentBody: snapshot.data!['taskComments']
                                      [index]['commentBody'],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 1,
                                );
                              },
                              itemCount: snapshot.data!['taskComments'].length,
                            );
                          })
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

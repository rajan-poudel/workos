import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/screens/tasks_screen.dart';
import 'package:workos/services/global_method.dart';
import 'package:workos/widgets/drawer_widget.dart';

class UploadTask extends StatefulWidget {
  const UploadTask({Key? key}) : super(key: key);

  @override
  _UploadTaskState createState() => _UploadTaskState();
}

class _UploadTaskState extends State<UploadTask> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _taskCategoryContoller =
      TextEditingController(text: "Choose category");
  TextEditingController _taskTitleContoller = TextEditingController(text: "");
  TextEditingController _taskDescriptionContoller =
      TextEditingController(text: "");
  TextEditingController _deadlineContoller =
      TextEditingController(text: "Pick up a date");

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? _deadlineTimestamp;

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _taskCategoryContoller.dispose();
    _taskTitleContoller.dispose();
    _taskDescriptionContoller.dispose();
    _deadlineContoller.dispose();
  }

  void _UploadTask() async {
    var taskId = Uuid().v4();
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_taskCategoryContoller.text == "Choose category" &&
          _deadlineContoller.text == "Pick up a date") {
        GlobalMethod.showErrorDialog(
            error: "Please fill everything", context: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection("tasks").doc(taskId).set({
          'taskId': taskId,
          'uploadedBy': _uid,
          'taskTitle': _taskTitleContoller.text,
          'taskDescription': _taskDescriptionContoller.text,
          'deadlineDate': _deadlineContoller.text,
          'deadlineDateTimestamp': _deadlineTimestamp,
          'taskCategory': _taskCategoryContoller.text,
          'taskComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        await Fluttertoast.showToast(
          msg: "Task uploaded",
          toastLength: Toast.LENGTH_LONG,
          // gravity: ToastGravity.CENTER,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          // textColor: Colors.white,
          fontSize: 18.0,
        );
        _taskTitleContoller.clear();
        _taskDescriptionContoller.clear();
        setState(() {
          _taskCategoryContoller.text = "Choose category";
          _deadlineContoller.text = "Choose category";
        });
      } catch (error) {
        throw "error";
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("it is not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.darkBlue),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "All Field are Required",
                      style: TextStyle(
                          color: Constants.darkBlue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //task Category
                        _textTitle(label: "Task category *"),
                        _textFormField(
                          valuKey: "TaskCategory",
                          controller: _taskCategoryContoller,
                          enabled: false, //keyboard aaudaina
                          fct: () {
                            _showTaskCategoriesDialog(size: size);
                          },
                          maxLength: 100,
                        ),
                        //Task title
                        _textTitle(label: "Task title*"),
                        _textFormField(
                          valuKey: "TaskTitle",
                          controller: _taskTitleContoller,
                          enabled: true,
                          fct: () {},
                          maxLength: 100,
                        ),
                        //Task description
                        _textTitle(label: "Task description*"),
                        _textFormField(
                          valuKey: "TaskDescription",
                          controller: _taskDescriptionContoller,
                          enabled: true,
                          fct: () {},
                          maxLength: 1000,
                        ),
                        //Deadline date
                        _textTitle(label: "Deadline date*"),
                        _textFormField(
                          valuKey: "Deadline",
                          controller: _deadlineContoller,
                          enabled: false,
                          fct: () {
                            _pickDateDialog();
                          },
                          maxLength: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : MaterialButton(
                            color: Colors.pink.shade700,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            onPressed: _UploadTask,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Upload",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        Duration(days: 0),
      ),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _deadlineContoller.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';

        _deadlineTimestamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  Widget _textFormField(
      {required String valuKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is missing";
            }
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valuKey),
          style: TextStyle(
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          maxLines: valuKey == "TaskDescription" ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFEDE7DC),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pink),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                'Choose the task Category',
                style: TextStyle(color: Colors.pink.shade800),
              ),
              Icon(Icons.arrow_downward_sharp)
            ],
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
                      setState(() {
                        _taskCategoryContoller.text =
                            Constants.taskCategoryList[index];
                      });
                      Navigator.pop(context);
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
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _textTitle({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: TextStyle(
            color: Colors.pink[800], fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

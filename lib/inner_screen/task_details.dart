import 'package:flutter/material.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/widgets/comments_widget.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
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
            SizedBox(
              height: 15,
            ),
            Text(
              "Task  Title",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Constants.darkBlue,
                  fontSize: 30),
            ),
            SizedBox(
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
                          Spacer(),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.pink),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Uploader Name", style: _textStyle),
                              Text(
                                "Uploader job",
                                style: _textStyle,
                              ),
                            ],
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
                          Text("date:1234567 ", style: _textStyle),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("DeadLine date: ", style: _titleStyle),
                          // Spacer(),
                          Text(
                            "date:1234567 ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          "Still have a time ",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.green,
                              fontSize: 15),
                        ),
                      ),
                      _dividerWidget(),
                      Text("Done State: ", style: _titleStyle),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
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
                            opacity: 1,
                            child: Icon(
                              Icons.check_box_rounded,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(" Not Done ",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Constants.darkBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                          Opacity(
                            opacity: 0,
                            child: Icon(
                              Icons.check_box_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      _dividerWidget(),
                      Text("Task description: ", style: _titleStyle),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Description: ", style: _textStyle),
                      SizedBox(
                        height: 10,
                      ),

                      AnimatedSwitcher(
                        duration: Duration(
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
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
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
                                          onPressed: () {},
                                          child: Text(
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
                                          child: Text("Cancel"))
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                      SizedBox(
                        height: 40,
                      ),
                      //comment Section
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CommentWidget();
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              thickness: 1,
                            );
                          },
                          itemCount: 15)
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
      children: [
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/services/global_method.dart';

import 'package:workos/widgets/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool _isLoading = false;
  String name = '';
  String phoneNumber = '';
  String email = '';
  String imageUrl = '';
  String job = '';
  String joinedAt = '';
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get();
      if (userDoc == null) {
        // GlobalMethod.showErrorDialog(error: "Fetching Error", context: context)
        return;
      } else {
        setState(() {
          name = userDoc.get("name");
          email = userDoc.get("email");
          phoneNumber = userDoc.get("phoneNumber");
          job = userDoc.get("positionCompany");
          imageUrl = userDoc.get("userImage");
          Timestamp joinedAtTimestamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimestamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.all(30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '$job since at $joinedAt',
                              style: TextStyle(
                                color: Constants.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(thickness: 1),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Contact Info",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Expanded(
                                child:
                                    userInfo(title: "Email", content: email)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: userInfo(
                                title: "Phone Number", content: phoneNumber),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _isSameUser
                              ? Container()
                              : const Divider(
                                  thickness: 1,
                                ),
                          const SizedBox(
                            height: 15,
                          ),
                          _isSameUser
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    contactBy(
                                      color: Colors.green,
                                      fct: () {
                                        _openWhatsAppChat();
                                      },
                                      icon: FontAwesome.whatsapp,
                                    ),
                                    contactBy(
                                      color: Colors.red,
                                      fct: () {
                                        _mailTo();
                                      },
                                      icon: Icons.mail_outline,
                                    ),
                                    contactBy(
                                      color: Colors.purple,
                                      fct: () {
                                        _callPhoneNumber();
                                      },
                                      icon: Icons.call,
                                    )
                                  ],
                                ),
                          const SizedBox(
                            height: 15,
                          ),
                          !_isSameUser
                              ? Container()
                              : const Divider(
                                  thickness: 1,
                                ),
                          const SizedBox(
                            height: 15,
                          ),
                          !_isSameUser
                              ? Container()
                              : Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: MaterialButton(
                                      color: Colors.pink.shade700,
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      onPressed: () {
                                        GlobalMethod.logout(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.logout,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Text(
                                                "Logout",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.width * 0.26,
                        width: size.width * 0.26,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 8,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              // 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png',
                              imageUrl == null
                                  ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                  : imageUrl,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/$phoneNumber?text=hello';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("error");
      throw "Error Occur";
    }
  }

  void _mailTo() async {
    var mailUrl = 'mailto:$email';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print("error");
      throw "Error Occur";
    }
  }

  void _callPhoneNumber() async {
    var phoneUrl = 'tel:$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw "error occured";
    }
  }

  Widget contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          onPressed: () {
            fct();
          },
          icon: Icon(
            icon,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(
              // decoration: TextDecoration.underline,
              color: Constants.darkBlue,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

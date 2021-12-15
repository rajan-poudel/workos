import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _fullNameTextController =
      TextEditingController(text: "");
  late TextEditingController _emailTextController =
      TextEditingController(text: "");
  late TextEditingController _passTextContoller =
      TextEditingController(text: "");
  late TextEditingController _positionCPTextContoller =
      TextEditingController(text: "");

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _positionCPFocusNode = FocusNode();

  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameTextController.dispose();
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextContoller.dispose();
    _positionCPTextContoller.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void _submitFormOnSignUp() {
    final isValid = _signUpFormKey.currentState!.validate();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) => Image.asset(
              "assets/images/wallpaper.jpg",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text(
                  "SignUp",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already have an account',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      // SizedBox(width: 10,), not allowed
                      const TextSpan(text: "   "),
                      TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue.shade300,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      //fullname
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.name,
                        controller: _fullNameTextController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is missing";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Full Name ',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //email
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please enter a valid email address";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //password
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_positionCPFocusNode),
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passTextContoller,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return "Email and password invalid";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          hintText: 'Enter your Password',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      //position
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _submitFormOnSignUp,
                        focusNode: _passFocusNode,
                        keyboardType: TextInputType.name,
                        controller: _positionCPTextContoller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is missing";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Position in the company',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                MaterialButton(
                    color: Colors.pink.shade700,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    onPressed: _submitFormOnSignUp,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "SignUp",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.person_add,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

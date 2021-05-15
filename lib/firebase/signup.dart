import 'dart:io';

import 'package:flat_mate/firebase/authorization/authService.dart';
import 'package:flat_mate/firebase/signin.dart';
import 'package:flat_mate/helper/loading.dart';
import 'package:flat_mate/main.dart';
import 'package:flat_mate/widget/googleButton.dart';
import 'package:flat_mate/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flat_mate/shared/ourTheme.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController _nameController=new TextEditingController();
  File _image;


  signUp2() async {
    if(_image==null){
      setState(() {
        isLoading=false;
      });
      imageDialog();
      return;
    }
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final pass = passwordEditingController.text.toString().trim();
      final email = emailEditingController.text.toString().trim();
      final name = _nameController.text.toString().trim();
      final username =usernameEditingController.text.toString().trim();
      var result = await _auth.registerUser(email: email,
          name: name,username: username,
          pass: pass,image: _image);
      if (result!=null) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  static const colorizeColors = [
    const Color(0xFF5A60B7),
    const Color(0xff2A75BC),
    const Color(0xFF26c485),
    const Color(0xFF868ACB)
  ];

  AuthService2 _auth = AuthService2();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: appBarMain(context),
      body: isLoading
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    width: double.infinity,
                    child: AnimatedTextKit(
                      // repeatForever: true,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'ConnexHer',
                          speed: Duration(seconds: 1),
                          textStyle: TextStyle(
                              fontSize: 40, color: OurTheme().mPurple),
                          colors: colorizeColors,
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap:() {
                            chooseFile();
                          },
                          child:Container(
                            height: 150,
                            width: 150,
                            child: CircleAvatar(
                              backgroundColor: Colors.black12,
                              backgroundImage:  _image==null ?AssetImage('assets/logo.png'):
                              FileImage(_image),
                            ),
                          ),
                        ),
                        TextFormField(
                            controller: _nameController,
                          validator: (val) {
                            return val.isEmpty || val.length < 3
                                ? "Enter Full Name"
                                : null;
                          },
                            decoration: textFieldInputDecoration("Full Name"),
                          ),

                        TextFormField(
                          style: simpleTextStyle(),
                          controller: usernameEditingController,
                          validator: (val) {
                            return val.isEmpty || val.length < 3
                                ? "Enter Username 3+ characters"
                                : null;
                          },
                          decoration: textFieldInputDecoration("username"),
                        ),
                        TextFormField(
                          controller: emailEditingController,
                          style: simpleTextStyle(),
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Enter correct email";
                          },
                          decoration: textFieldInputDecoration("email"),
                        ),
                        TextFormField(
                          obscureText: true,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("password"),
                          controller: passwordEditingController,
                          validator: (val) {
                            return val.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () async => await signUp2(),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: OurTheme().mPurple,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: isLoading
                      ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                        "Sign Up",
                        style: biggerTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GoogleButton(),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: simpleTextStyle(),
                      ),
                      InkWell(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Text(
                          "Sign In now",
                          style: TextStyle(
                              color: OurTheme().mPurple,
                              fontFamily: 'PopM',
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
    );
  }
  Future chooseFile() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  void imageDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 190,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30,right: 30),
                          child: Text('Select Image',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30,right: 25,top: 15),
                          child: Text(
                            "Image is not selected for avatar.",
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey,thickness: 0,height: 0,),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('Try Again',style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

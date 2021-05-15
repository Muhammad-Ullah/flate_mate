import 'package:flat_mate/firebase/authorization/authService.dart';
import 'package:flat_mate/firebase/forgot_password.dart';
import 'package:flat_mate/firebase/signup.dart';
import 'package:flat_mate/helper/loading.dart';
import 'package:flat_mate/shared/ourTheme.dart';
import 'package:flat_mate/widget/googleButton.dart';
import 'package:flat_mate/widget/widget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  final AuthService2 _auth = AuthService2();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  static const colorizeColors = [
    const Color(0xFF5A60B7),
    const Color(0xff2A75BC),
    const Color(0xFF26c485),
    const Color(0xFF868ACB)
  ];


  Future signIn() async {
    // works only and only if the validators return null
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      String result = await _auth.signinWithEmail(
          emailEditingController.text, passwordEditingController.text);
      if (result == "success") {
        // setState(() {
        //   // error =
        //   //     "Couldn't Sign with this Email & Password";
        //   isLoading = false;
        // });
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //  Commented By Ashley
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
                child: Text(
                      'Flat Mate',
                      style: TextStyle(
                          fontSize: 40, color: OurTheme().mPurple),

                    ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)
                            ? null
                            : "Please Enter Correct Email";
                      },
                      controller: emailEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("email"),
                      onChanged: (val) {
                        setState(
                              () {
                            email = val;
                          },
                        );
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val.length > 6
                            ? null
                            : "Enter Password 6+ characters";
                      },
                      style: simpleTextStyle(),
                      controller: passwordEditingController,
                      decoration: textFieldInputDecoration("password"),
                      onChanged: (value) {
                        setState(
                              () {
                            password = value;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                        // PageTransition(
                        //   type: PageTransitionType.leftToRight,
                        //   child: ForgotPassword(),
                        // ),
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          "Forgot Password?",
                          style: simpleTextStyle(),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () async => await signIn(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: OurTheme().mPurple,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign In",
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
                    "Don't have account? ",
                    style: simpleTextStyle(),
                  ),
                  InkWell(
                    onTap: () {
                       widget.toggleView();

                    },
                    child: Text(
                      "Register Now",
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
      ),
    );
  }
}

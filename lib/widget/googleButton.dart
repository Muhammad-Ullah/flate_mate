import 'package:flat_mate/shared/ourTheme.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: OurTheme().mPurple.withOpacity(0.18),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 25,
            width: 25,
            child: Image(
              image: AssetImage("assets/google_logo.png"),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            "Sign Up with Google",
            style: TextStyle(
              fontSize: 17,
              color: OurTheme().black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

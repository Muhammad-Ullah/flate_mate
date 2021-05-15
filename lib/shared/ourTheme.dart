import 'package:flutter/material.dart';

class OurTheme {
  Color mPurple = Color(0xFFf62459);
  Color pinkShade = Color(0xFFf62459).withAlpha(120);
  Color pinkShade2 = Color(0xFFf62459).withOpacity(0.8);

  Color purpleShade = Color(0xFF5A60B7).withAlpha(150);
  Color purple = Color(0xFF5A60B7);

  Color lPurple = Color(0xFF868ACB);
  Color black = Color(0xFF001011);
  Color green = Color(0xFF26c485);
  Color ourGrey = Color(0xFF5D5D5D);
  Color secGrey = Color(0xFF919191);

  ThemeData buildTheme() {
    return ThemeData(
      primaryColor: mPurple,
      appBarTheme: AppBarTheme(
          color: mPurple, backgroundColor: mPurple, foregroundColor: mPurple),
      scaffoldBackgroundColor: Colors.grey[200],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'PopR',
      accentColor: green,
    );
  }
}

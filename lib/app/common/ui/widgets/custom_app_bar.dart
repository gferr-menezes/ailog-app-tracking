import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Key? key, double elevation = 2, String? getCurrentRoute})
      : super(
          key: key,
          backgroundColor: Colors.white,
          elevation: elevation,
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        );
}

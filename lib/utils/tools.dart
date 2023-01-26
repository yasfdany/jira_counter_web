import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tools {
  static void onViewCreated(VoidCallback onViewCreated) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onViewCreated());
  }

  static void changeStatusbarIconColor({
    bool darkIcon = true,
    Color statusBarColor = Colors.transparent,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: darkIcon ? Brightness.dark : Brightness.light,
      ),
    );
  }
}

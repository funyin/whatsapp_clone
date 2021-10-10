import 'package:flutter/material.dart';

class R {
  static var colors = _Colors();
  static var strings = _Strings();
  static var dimens = _Dimens();
}

class _Colors {
  Color green = Color(0xff07bc4c);
  Color teal = Color(0xff009788);
  Color iconColor = Color(0xff919191);
  Color background = Color(0xffededed);
  Color senderColor = Color(0xffdcf8c7);
  double headerHeight = 58;
}

class _Strings {}

class _Dimens {
  Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  double screenHeight(BuildContext context) => screenSize(context).height;

  double screenWidth(BuildContext context) => screenSize(context).width;

  bool isMobile(BuildContext context) =>
      screenWidth(context).toInt() <= breakPoints.keys.first;

  bool isTabLet(BuildContext context) =>
      screenWidth(context).toInt() <= breakPoints.keys.elementAt(1);

  bool isLapTop(BuildContext context) =>
      screenWidth(context).toInt() <= breakPoints.keys.elementAt(2);

  bool isDeskTop(BuildContext context) =>
      screenWidth(context).toInt() <= breakPoints.keys.elementAt(3);

  double sectionSpace(BuildContext context) => isMobile(context)
      ? 90
      : isTabLet(context)
          ? 120
          : 220;

  ///Map<Width,Height>
  Map<int, int> breakPoints = {
    411: 731, //Mobile
    768: 1024, //TabLet
    1366: 768, //Laptop
    1920: 1080, //Desktop or High res Laptop
  };
}

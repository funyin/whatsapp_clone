import 'package:flutter/material.dart';

class R {
  static var images = _Images();
  static var colors = _Colors();
  static var vectors = _Vectors();
  static var strings = _Strings();
  static var dimens = _Dimens();
}

class _Images {
  var folderMain = "main";
  var subFolderImages = "/images";

  String myPortrait() => "$folderMain$subFolderImages/myPortait.png";

  String myPortraitCropped() =>
      "$folderMain$subFolderImages/myPortraitCropped.png";
  var uiClone1 = "";
}

class _Colors {
  var primary = Color(0xff052c42);
  var primaryLight = Color(0xff2eaef8);
  var secondary = Color(0xfff8782e);
}

class _Vectors {
  String icGitHub = "vectors/ic_github.svg";
  String icLinkedIn = "vectors/ic_linkedin.svg";
  String icStackOverflow = "vectors/ic_stackoverflow.svg";
  String icTwitter = "vectors/ic_twitter.svg";
  String icMenu = "vectors/ic_menu.svg";
  String icAndroid = "vectors/ic_android.svg";
  String icWordPress = "vectors/ic_wordpress.svg";
  String icFlutter = "vectors/ic_flutter.svg";
  String icFirebase = "vectors/ic_firebase.svg";
  String icPingPong = "vectors/ic_ping_pong.svg";
  String icUnity = "vectors/ic_unity.svg";
  String icFeatured = "vectors/ic_featured.svg";
  String icCalendar = "vectors/ic_calendar.svg";
  String icUser = "vectors/ic_user.svg";
  String icCode = "vectors/ic_code.svg";
}

class _Strings {
  String FIRE_STORAGE_BUCKET = "gs://funyinkash-portfolio.appspot.com/";
}

class _Dimens {
  double navBarHeight(BuildContext context) {
    if (isTabLet(context))
      return 80;
    else
      return 100;
  }

  double gutterWidth(BuildContext context) {
    if (isMobile(context))
      return 14.0;
    else if (isTabLet(context))
      return 26.0;
    else if (isLapTop(context))
      return 60.0;
    else
      return 80;
  }

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

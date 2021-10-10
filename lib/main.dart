import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:whatsapp_clone/presentation/routes/app_router.dart';
import 'package:whatsapp_clone/resources/R.dart';

var faker = Faker();

void main() async {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WhatsApp Web Clone - funyinKash",
      theme: AppTheme.light,
      routes: AppRouter.routes,
    );
  }
}

class AppTheme {
  static ThemeData get light {
    return ThemeData.light().copyWith(
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black26,
            selectionColor: R.colors.teal.withAlpha(120)),
        inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Color(0xffa3a3a3),
                fontSize: 14,
                fontWeight: FontWeight.w100)),
        scaffoldBackgroundColor: R.colors.background,
        textTheme: GoogleFonts.openSansTextTheme());
  }
}

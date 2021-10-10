import 'package:flutter/material.dart';
import 'package:whatsapp_clone/presentation/screens/main/whats_app_clone.dart';
import 'package:whatsapp_clone/presentation/screens/splash/splash_screen.dart';

class AppRouter {
  static const splash = "/";
  static const main = "/main";

  static get routes => <String, Widget Function(BuildContext)>{
        splash: (context) => SplashScreen(),
        main: (context) => WhatsAppClone()
      };
}

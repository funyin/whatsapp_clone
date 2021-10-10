import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp_clone/generated/assets.dart';
import 'package:whatsapp_clone/presentation/routes/app_router.dart';
import 'package:whatsapp_clone/resources/R.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () async {
      progress.value = 0.2;
      await Future.delayed(Duration(seconds: 2));
      progress.value = 0.6;
      await Future.delayed(Duration(seconds: 1));
      progress.value = 1;
      Navigator.pushNamed(context, AppRouter.main);
    });
  }

  var progress = ValueNotifier(0.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          highlightColor: Color(0xffbfbfbf),
          baseColor: R.colors.iconColor.withOpacity(0.3),
          child: SvgPicture.asset(
            Assets.vectorsLogo,
            height: 50,
            width: 50,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: SizedBox(
            width: 420,
            height: 3,
            child: ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, child) => LinearProgressIndicator(
                backgroundColor: R.colors.iconColor.withOpacity(0.3),
                value: value,
                valueColor: AlwaysStoppedAnimation(R.colors.green),
              ),
            ),
          ),
        ),
        Center(child: Text("WhatsApp")),
        SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock,
              size: 12,
              color: R.colors.iconColor,
            ),
            Text(
              " End-to-end encrypted",
              style: TextStyle(color: Colors.black45, fontSize: 14),
            )
          ],
        )
      ],
    ));
  }
}

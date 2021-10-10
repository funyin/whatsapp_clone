import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_clone/bloc/bloc.dart';
import 'package:whatsapp_clone/generated/assets.dart';
import 'package:whatsapp_clone/presentation/widgets/chat_detail.dart';
import 'package:whatsapp_clone/presentation/widgets/chat_main.dart';
import 'package:whatsapp_clone/presentation/widgets/chat_master.dart';
import 'package:whatsapp_clone/resources/R.dart';
import 'package:whatsapp_clone/server/mock_server.dart';
import 'package:whatsapp_clone/state.dart';
import 'package:whatsapp_clone/utils/project_vectors.dart';

///main entry point
class WhatsAppClone extends StatelessWidget {
  late BuildContext mContext;

  WhatsAppClone({Key? key}) : super(key: key);

  var resizeAnimDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    mContext = context;

    ///dictates if the main chat area has  padding around
    var frame = MediaQuery.of(context).size.width > 1300;
    return Scaffold(
      body: BlocProvider<WhatsAppCloneCubit>(
          create: (context) => WhatsAppCloneCubit(
              WhatsAppCloneState(randomChats: MockServer.randomChats)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Color(0xffdadbd5),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: R.colors.teal,
                  height: R.dimens.screenHeight(context) / 6.32,
                ),
              ),

              ///Smaller displays are unsupported for whatsapp web
              if (MediaQuery.of(context).size.width < 680)
                smallFormFactorMessage()
              else
                FractionallySizedBox(
                  widthFactor: frame ? 0.91 : 1,
                  heightFactor: frame ? 0.95 : 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: R.colors.background,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2))
                        ]),
                    child: BlocBuilder<WhatsAppCloneCubit, WhatsAppCloneState>(
                      buildWhen: (previous, current) =>
                          previous.activeDetail != current.activeDetail,
                      builder: (context, state) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                                flex: 3,
                                child: AnimatedContainer(
                                    duration: resizeAnimDuration,
                                    child: ChatMaster())),
                            VerticalDivider(width: 0.8, thickness: 0.5),
                            Flexible(
                                flex: state.activeDetail != null ? 8 : 7,
                                child: BlocBuilder<WhatsAppCloneCubit,
                                        WhatsAppCloneState>(
                                    buildWhen: (previous, current) =>
                                        previous.selectedChatId !=
                                            current.selectedChatId ||
                                        previous.activeDetail !=
                                            current.activeDetail,
                                    builder: (context, state) {
                                      if (state.selectedChatId ==
                                          WhatsAppCloneState.NO_CHAT_ID)
                                        return initialState();
                                      else
                                        return currentChatState(state);
                                    }))
                          ],
                        );
                      },
                    ),
                  ),
                )
            ],
          )),
    );
  }

  Center smallFormFactorMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "This project is currently only available for large screen devices, check it on a larger screen with at least 680px width",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),
      ),
    );
  }

  LayoutBuilder currentChatState(WhatsAppCloneState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var sideBarWidth =
            state.activeDetail != null ? constraints.maxWidth / 2.493 : 0.0;
        var mainContentWidth = constraints.maxWidth - sideBarWidth;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: resizeAnimDuration,
              curve: Curves.decelerate,
              width: mainContentWidth,
              child: ChatMain(
                  selectedChat: state.randomChats!.firstWhere(
                      (element) => element.chatId == state.selectedChatId)),
            ),
            AnimatedContainer(
              duration: resizeAnimDuration,
              curve: Curves.decelerate,
              width: sideBarWidth,
              child: ChatDetail(),
            )
          ],
        );
      },
    );
  }

  Widget initialState() {
    var tapGestureRecognizer = TapGestureRecognizer();
    tapGestureRecognizer.onTap = () {
      launch("https://funyinkash.com");
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      decoration: BoxDecoration(
          color: Color(0xfff8f9fb),
          border: Border(bottom: BorderSide(width: 6, color: R.colors.green))),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.imagesInitialState,
            width: 355,
            height: 355,
          ),
          Padding(
            padding: EdgeInsets.only(top: 28, bottom: 16),
            child: Text("Keep your phone connected",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 36,
                    color: Color(0xff525252),
                    fontWeight: FontWeight.w300)),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 430),
            child: Text(
              "WhatsApp connects to your phone to sync messages. To reduce data usage, connect your phone to Wi-Fi.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 14,
                  height: 1.7),
            ),
          ),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 430),
              child: Divider(height: 72, thickness: 0.6)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.string(ProjectVectors.laptopIcon,
                  height: 14, width: 17),
              SizedBox(width: 5),
              RichText(
                  text: TextSpan(
                      text: "WhatsApp clone by ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w200),
                      children: [
                    TextSpan(
                        text: "FunyinKash",
                        recognizer: tapGestureRecognizer,
                        style: TextStyle(
                          color: R.colors.green,
                        ))
                  ])),
            ],
          )
        ],
      ),
    );
  }
}

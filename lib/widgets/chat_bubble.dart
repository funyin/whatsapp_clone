import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:whatsapp_clone/models/item_chat_model.dart';
import 'package:whatsapp_clone/server/mock_server.dart';
import 'package:whatsapp_clone/utils/project_utils.dart';
import 'package:whatsapp_clone/utils/project_vectors.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final ChatType? chatType;
  final ChatMessageModel? nextMessage;

  ChatBubble({Key? key, required this.message, this.chatType, this.nextMessage})
      : super(key: key);
  final hovering = ValueNotifier(false);
  late MessageSender messageSender = message.sender!;
  late bool iSent = messageSender == MockServer.signedInUser;

  @override
  Widget build(BuildContext context) {
    var headerStyle = TextStyle(
        fontSize: 12.8, color: Colors.black26, fontWeight: FontWeight.w200);
    var bottomMargin =
        nextMessage == null || nextMessage!.sender == messageSender
            ? 2.0
            : 10.0;
    return LayoutBuilder(
      builder: (context, constraints) => MouseRegion(
        onEnter: (_) => hovering.value = true,
        onExit: (_) => hovering.value = false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          textDirection: iSent ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Transform(
              transform: Matrix4.rotationY(iSent ? pi : 0)
                ..translate(iSent ? -8 : 0),
              child: SvgPicture.string(
                ProjectVectors.chatBubbleChip,
                color: iSent ? ProjectUtils.senderColor : Colors.white,
                matchTextDirection: true,
                width: 8,
                height: 13,
              ),
            ),
            Flexible(
                child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    bottom: bottomMargin,
                  ),
                  decoration: BoxDecoration(
                      color: iSent ? ProjectUtils.senderColor : Colors.white,
                      borderRadius: BorderRadius.circular(8).copyWith(
                          topLeft: Radius.circular(iSent ? 8 : 0),
                          topRight: Radius.circular(iSent ? 0 : 8))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: iSent
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (chatType == ChatType.public &&
                          messageSender != MockServer.signedInUser)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            if (!messageSender.savedContact!)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "${messageSender.mobile}",
                                  style: headerStyle.copyWith(
                                      color: messageSender.color),
                                ),
                              ),
                            Text(
                              "${(!messageSender.savedContact! ? "~ " : "") + messageSender.name!}",
                              style: headerStyle.copyWith(
                                  color: messageSender.savedContact!
                                      ? messageSender.color
                                      : null),
                            ),
                          ]),
                        ),
                      Flexible(
                        child: Text(
                          message.message!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 1),
                      Opacity(opacity: 0, child: time())
                    ],
                  ),
                ),
                Positioned(
                  bottom: bottomMargin + 2,
                  right: 10,
                  child: time(),
                )
              ],
            )),
            SizedBox(width: constraints.maxWidth / 2.83)
          ],
        ),
      ),
    );
  }

  Text time() {
    return Text(intl.DateFormat.jm().format(message.date!),
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w200, color: Colors.black26));
  }

  ValueListenableBuilder<bool> bubbleActions() {
    return ValueListenableBuilder<bool>(
      valueListenable: hovering,
      builder: (context, hovering, child) => AnimatedPositioned(
          right: hovering ? 0 : -30,
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                (iSent ? ProjectUtils.senderColor : Colors.white)
                    .withOpacity(0.4),
                (iSent ? ProjectUtils.senderColor : Colors.white),
                (iSent ? ProjectUtils.senderColor : Colors.white),
              ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ProjectUtils.iconColor,
              ),
            ),
          ),
          duration: Duration(milliseconds: 200)),
    );
  }
}

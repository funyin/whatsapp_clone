import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/models/item_chat_model.dart';
import 'package:whatsapp_clone/resources/R.dart';

class ProjectUtils {
  //Project Utils

  static String messageSenderStatusToString(MessageSenderStatus status) {
    switch (status) {
      case MessageSenderStatus.offline:
        return "offline";
      case MessageSenderStatus.online:
        return "online";
      case MessageSenderStatus.typing:
        return "typing";
      case MessageSenderStatus.recording:
        return "recording";
    }
  }

  static ClipOval buildAvatar(
      {required ItemChatModel chat, required double size}) {
    var isPrivate = chat.chatType == ChatType.private;
    var respondent = chat.chatData.participants!.first;
    var chatImageUrl = isPrivate ? respondent.imageUrl : chat.chatData.imageURl;
    return ClipOval(
        child: chatImageUrl == null
            ? SvgPicture.network(
                isPrivate ? respondent.noDpSvg : chat.chatData.noGroupDpSvg,
                fit: BoxFit.cover,
                height: size,
                width: size)
            : Image.network(chatImageUrl,
                fit: BoxFit.cover, height: size, width: size));
  }

  static Widget buildAction(String svg,
      {VoidCallback? onTap,
      double? size = 24,
      Key? key,
      double padding = 12,
      Color? color}) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SvgPicture.string(
          svg,
          height: size,
          width: size,
          color: color ?? R.colors.iconColor,
        ),
      ),
    );
  }

  static String formatChatDate(DateTime dateTime) {
    var messageDate = dateTime;
    var currentDate = DateTime.now();
    var thisMonth = messageDate.year == currentDate.year &&
        messageDate.month == currentDate.month;
    var lastWeek = thisMonth && messageDate.day - currentDate.day < 7;
    var yesterday = thisMonth && messageDate.day == currentDate.day - 1;
    var today = thisMonth && messageDate.day == currentDate.day;

    if (today)
      return DateFormat.jm().format(messageDate);
    else if (yesterday)
      return "yesterday";
    else if (lastWeek)
      return DateFormat.EEEE().format(messageDate);
    else
      return DateFormat.yMd().format(messageDate);
  }

  static String audioMediaImage =
      "https://firebasestorage.googleapis.com/v0/b/funyinkash-portfolio.appspot.com/o/portfolio%2FwhatsAppClone%2Fimages%2FaudioImage.png?alt=media&token=a68e7f03-0c6f-4968-9b2c-162410097101";
  static String docMediaImage =
      "https://firebasestorage.googleapis.com/v0/b/funyinkash-portfolio.appspot.com/o/portfolio%2FwhatsAppClone%2Fimages%2FdocImage.png?alt=media&token=028cbfc2-4ec3-4b6b-a4e3-42a4b30f484d";
}

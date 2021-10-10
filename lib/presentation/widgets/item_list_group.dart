import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/bloc/bloc.dart';
import 'package:whatsapp_clone/models/item_chat_model.dart';
import 'package:whatsapp_clone/utils/project_utils.dart';

class ItemListGroup extends StatelessWidget {
  final ItemChatModel chat;
  late final hovering = ValueNotifier(false);
  late var isPrivate = chat.chatType == ChatType.private;
  late var respondent = chat.chatData.participants!.first;

  ItemListGroup({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) => hovering.value = value,
      onTap: () {
        BlocProvider.of<WhatsAppCloneCubit>(context).selectChat(chat.chatId);
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: hovering,
          builder: (context, hovering, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 10),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              height: 72,
              child: Row(
                children: [
                  ProjectUtils.buildAvatar(chat: chat, size: 48),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPrivate ? respondent.name! : chat.chatData.topic!,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w100),
                        ),
                        SizedBox(height: 9),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                chat.chatData.participants!
                                    .map((e) =>
                                        e.savedContact! ? e.name : e.mobile)
                                    .join(", "),
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 14,
                                    color: Colors.black38),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ...[
                              SizedBox(width: 4),
                              AnimatedCrossFade(
                                duration: Duration(milliseconds: 100),
                                firstChild: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xff919191)),
                                secondChild: SizedBox(width: 0, height: 24),
                                crossFadeState: hovering
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                              )
                            ]
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

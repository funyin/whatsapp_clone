import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/bloc/bloc.dart';
import 'package:whatsapp_clone/models/item_chat_model.dart';
import 'package:whatsapp_clone/state.dart';
import 'package:whatsapp_clone/utils/project_utils.dart';

class ItemListChats extends StatelessWidget {
  final ItemChatModel chat;
  late final hovering = ValueNotifier(false);
  late var isPrivate = chat.chatType == ChatType.private;
  late var respondent = chat.chatData.participants!.first;

  ItemListChats({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WhatsAppCloneCubit, WhatsAppCloneState>(
      listener: (context, state) {},
      buildWhen: (previous, current) =>
          current.selectedChatId! == chat.chatId ||
          previous.selectedChatId == chat.chatId,
      builder: (context, state) => InkWell(
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
                color: state.selectedChatId == chat.chatId
                    ? Color(0xffebebeb)
                    : (hovering ? Color(0xfff5f5f5) : Colors.transparent),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  isPrivate
                                      ? respondent.name!
                                      : chat.chatData.topic!,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                ProjectUtils.formatChatDate(
                                    chat.messages.last.date!),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black38),
                              )
                            ],
                          ),
                          SizedBox(height: 9),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  chat.messages.last.message!,
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
                                if (chat.numOfNewMessage % 2 == 0 &&
                                    chat.numOfNewMessage != 0)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff06d755)),
                                    child: Text(
                                      chat.numOfNewMessage.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ),
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
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/bloc/bloc.dart';
import 'package:whatsapp_clone/models/item_chat_model.dart';
import 'package:whatsapp_clone/presentation/widgets/chat_bottomsheet.dart';
import 'package:whatsapp_clone/presentation/widgets/chat_bubble.dart';
import 'package:whatsapp_clone/resources/R.dart';
import 'package:whatsapp_clone/server/mock_server.dart';
import 'package:whatsapp_clone/state.dart';
import 'package:whatsapp_clone/utils/project_utils.dart';
import 'package:whatsapp_clone/utils/project_vectors.dart';

class ChatMain extends StatelessWidget {
  final ItemChatModel selectedChat;

  ChatMain({Key? key, required this.selectedChat}) : super(key: key) {
    Timer(Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  var scrollController = ScrollController();
  late final messageController =
      TextEditingController(text: selectedChat.draft);
  final typing = ValueNotifier(false);
  late var isPrivate = selectedChat.chatType == ChatType.private;
  late var title = isPrivate
      ? selectedChat.chatData.participants!.first.name!
      : selectedChat.chatData.topic!;

  /// Determines what the sheet would show
  /// 0 Emoji
  /// 1 GIF
  /// 2 History
  final bottomSheetState = ValueNotifier(-1);
  late WhatsAppCloneCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit = BlocProvider.of<WhatsAppCloneCubit>(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Color(0xffe5ddd5),
            child: Opacity(
              opacity: 0.06,
              child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/funyinkash-portfolio.appspot.com/o/portfolio%2FwhatsAppClone%2"
                "Fimages%2FchatBack.png?alt=media&token=f16e7c3f-639d-4a57-bafc-2b1b3843d28c",
                repeat: ImageRepeat.repeat,
                scale: 1.2,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            child: BlocConsumer<WhatsAppCloneCubit, WhatsAppCloneState>(
              listener: (context, state) {
                Timer(Duration(milliseconds: 60), () {
                  scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                });
              },
              listenWhen: buildCheck,
              bloc: BlocProvider.of<WhatsAppCloneCubit>(context),
              buildWhen: buildCheck,
              builder: (context, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  chatHeader(context),
                  Expanded(child: chatBody(context)),
                  messageBuilder(context)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatBody(BuildContext context) {
    var animDuration = Duration(milliseconds: 300);
    var bottomSheetHeight = 320.0;
    return LayoutBuilder(
      builder: (context, constraints) => ValueListenableBuilder<int>(
        valueListenable: bottomSheetState,
        builder: (context, value, child) {
          var showing = value != -1;
          return Stack(
            children: [
              AnimatedPositioned(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                bottom: showing ? bottomSheetHeight : 0,
                duration: animDuration,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth / 12.23,
                          vertical: 20)
                      .copyWith(top: 10),
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    var message = selectedChat.messages[index];
                    return ChatBubble(
                        message: message,
                        chatType: selectedChat.chatType,
                        nextMessage: message == selectedChat.messages.last
                            ? null
                            : selectedChat.messages[index + 1]);
                  },
                  itemCount: selectedChat.messages.length,
                ),
              ),
              AnimatedPositioned(
                  height: bottomSheetHeight,
                  bottom: showing ? 0 : -bottomSheetHeight,
                  width: constraints.maxWidth,
                  child: ChatBottomsheet(
                    onEmojiSelected: (emoji) {
                      messageController.text = messageController.text + emoji;
                      selectedChat.draft = messageController.text;
                    },
                  ),
                  duration: animDuration)
            ],
          );
        },
      ),
    );
  }

  bool buildCheck(WhatsAppCloneState previous, WhatsAppCloneState current) {
    // var test = (element) => element.chatId == selectedChat.chatId;
    // return previous.randomChats!
    //         .firstWhere((element) => element.chatId == selectedChat.chatId)
    //         .messages !=
    //     current.randomChats!
    //         .firstWhere((element) => element.chatId == selectedChat.chatId)
    //         .messages;
    return previous.randomChats != current.randomChats;
  }

  Material chatHeader(BuildContext context) {
    return Material(
      color: R.colors.background,
      child: Container(
        height: R.colors.headerHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              BlocProvider.of<WhatsAppCloneCubit>(context)
                  .setActiveDetail(ActiveDetail.chatInfo);
            },
            child: Row(
              children: [
                ProjectUtils.buildAvatar(chat: selectedChat, size: 40),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Text(
                          title,
                          style: TextStyle(fontSize: 16),
                        )),
                        if (!isPrivate)
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: BlocBuilder<WhatsAppCloneCubit,
                                  WhatsAppCloneState>(
                                // buildWhen: (previous, current) => ,
                                builder: (context, state) {
                                  var participants =
                                      BlocProvider.of<WhatsAppCloneCubit>(
                                              context)
                                          .selectedChat()
                                          .chatData
                                          .participants;
                                  var respondentTyping = participants!.any(
                                      (element) =>
                                          element.status ==
                                          MessageSenderStatus.typing);
                                  var typingAuthorIdentifier =
                                      participants.firstWhere(
                                    (element) =>
                                        element.status ==
                                        MessageSenderStatus.typing,
                                    orElse: () => MessageSender(),
                                  );
                                  return Text(
                                    respondentTyping
                                        ? "${typingAuthorIdentifier.savedContact! ? typingAuthorIdentifier.name : typingAuthorIdentifier.mobile} is typing..."
                                        : selectedChat.chatData.participants!
                                            .map((e) => e.name)
                                            .join(", "),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w200,
                                        color: respondentTyping
                                            ? R.colors.teal
                                            : Colors.black54),
                                  );
                                },
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<WhatsAppCloneCubit>(context)
                        .setActiveDetail(ActiveDetail.search);
                  },
                  splashRadius: 24,
                  icon: Icon(Icons.search),
                  color: R.colors.iconColor,
                ),
                ProjectUtils.buildAction(ProjectVectors.overflowMenu),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container messageBuilder(BuildContext context) {
    var edgeInsets = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
    return Container(
      color: R.colors.background,
      child: Padding(
        padding: edgeInsets,
        child: ValueListenableBuilder<int>(
          valueListenable: bottomSheetState,
          builder: (context, value, child) {
            var showing = value != -1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 52,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (showing)
                            ProjectUtils.buildAction(ProjectVectors.close,
                                size: 16, onTap: () {
                              bottomSheetState.value = -1;
                            }, key: ValueKey(0)),
                          ProjectUtils.buildAction(ProjectVectors.emoji,
                              onTap: () {
                            bottomSheetState.value = 0;
                          },
                              key: ValueKey(1),
                              color: value == 0 ? R.colors.teal : null),
                          if (showing)
                            ProjectUtils.buildAction(ProjectVectors.gif,
                                size: 18, onTap: () {
                              bottomSheetState.value = 1;
                            },
                                key: ValueKey(2),
                                color: value == 1 ? R.colors.teal : null),
                          if (showing)
                            ProjectUtils.buildAction(ProjectVectors.paste,
                                size: 20, onTap: () {
                              bottomSheetState.value = 2;
                            },
                                key: ValueKey(3),
                                color: value == 2 ? R.colors.teal : null),
                          ProjectUtils.buildAction(ProjectVectors.paperClip,
                              size: 18, key: ValueKey(4))
                        ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: edgeInsets,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      maxLines: 5,
                      minLines: 1,
                      controller: messageController,
                      onSubmitted: (value) => sendMessage(context),
                      onChanged: (value) {
                        typing.value = value.isNotEmpty;
                        selectedChat.draft = value;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          isDense: true,
                          hintText: " Type a message"),
                    ),
                  ),
                ),
                SizedBox(
                    height: 52,
                    width: 60,
                    child: Center(
                      child: ValueListenableBuilder<bool>(
                          valueListenable: typing,
                          builder: (context, typing, child) => AnimatedSwitcher(
                              duration: Duration(milliseconds: 60),
                              child: ProjectUtils.buildAction(
                                typing
                                    ? ProjectVectors.sendIcon
                                    : ProjectVectors.mic,
                                onTap: () => sendMessage(context),
                                key: ValueKey(typing),
                              ))),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> sendMessage(BuildContext context) async {
    var text = messageController.text;
    if (text.isNotEmpty) {
      final message = ChatMessageModel(
          date: DateTime.now(), message: text, sender: MockServer.signedInUser);
      await cubit.addMessage(message, selectedChat.chatId);
      messageController.clear();
      typing.value = false;
      await cubit.awaitResponse(selectedChat.chatId);
    }
  }
}

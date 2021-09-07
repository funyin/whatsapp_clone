import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/item_chat_model.dart';

class MockServer {
  static List<ItemChatModel> get randomChats {
    var list = List.generate(30, (index) {
      var chatType = Random().nextBool() ? ChatType.private : ChatType.public;
      var isPrivate = chatType == ChatType.private;
      var randomMessages = _randomMessages();
      return ItemChatModel(
          chatData: ChatData(
              created: faker.date.dateTime(),
              imageURl: Random().nextBool()
                  ? faker.image.image(width: 200, height: 200)
                  : null,
              description: faker.lorem.sentences(Random().nextInt(2)).join(" "),
              topic: faker.lorem.words(3).join(" "),
              admins: List.generate(
                  Random().nextInt(3) + 1, (index) => _randomUser),
              chatMedia: List.generate(Random().nextInt(5), (index) {
                var mediaType = ChatMediaType.values[Random().nextInt(3)];
                return ChatMedia(
                    data: mediaType == ChatMediaType.image
                        ? faker.image.image()
                        : faker.internet.httpsUrl(),
                    mediaType: mediaType);
              }),

              ///If its private make the list have 2 participants 2 and the signed in user as the second user
              participants: List.generate(
                  isPrivate ? 2 : (Random().nextInt(10) + 1),
                  (index) =>
                      isPrivate && index == 2 ? signedInUser : _randomUser)),
          chatId: "$index",
          chatType: chatType,
          messages: randomMessages,
          numOfNewMessage: randomMessages
              .where((element) => element.sender != signedInUser)
              .length);
    });

    list.sort((chat1, chat2) =>
        chat1.messages.last.date!.compareTo(chat2.messages.last.date!));
    return list.reversed.toList();
  }

  static List<ChatMessageModel> _randomMessages() {
    return List.generate(Random().nextInt(20) + 1, (index) {
      var dateTime = DateTime.now();
      var month = Random().nextInt(dateTime.month) + 1;
      return ChatMessageModel(
          date: DateTime(
              dateTime.year,
              month,
              Random().nextInt(month != dateTime.month ? 30 : dateTime.day),
              Random().nextInt(23),
              Random().nextInt(59)),
          message: faker.lorem.sentences(Random().nextInt(2) + 1).join(),
          sender: Random().nextBool() ? _randomUser : signedInUser);
    });
  }

  static String get _mobileNumber => faker.phoneNumber.random.fromPattern([
        '080########',
        '090########',
        '081########',
        '070########',
      ]);

  static MessageSender get _randomUser => MessageSender(
      imageUrl: Random().nextBool()
          ? faker.image.image(
              width: 200,
              height: 200,
              keywords: ["person", "woman", "man", "boy", ",girl"])
          : null,
      about: faker.lorem.sentence(),
      mobile: _mobileNumber,
      status: MessageSenderStatus.offline,
      savedContact: Random().nextBool(),
      color: _userColors[Random().nextInt(_userColors.length - 1)],
      name: faker.person.name());

  static var _userColors = <Color>[
    Colors.green,
    Colors.deepOrange,
    Colors.brown,
    Colors.purple,
    Colors.blue,
    Colors.cyanAccent
  ];

  static MessageSender signedInUser = MessageSender(
      imageUrl: signInUserImageUrl,
      savedContact: true,
      about: "Hey there, I'm a developer",
      mobile: "07035892924",
      color: _userColors[1],
      name: "Funyinoluwa Kashimawo");

  static String signInUserImageUrl =
      "https://avatars.githubusercontent.com/u/38915569?v=4";

  static Future<ChatMessageModel> generateResponse(
      ItemChatModel selectedChat) async {
    var private = selectedChat.chatType == ChatType.private;
    var groupMembers = selectedChat.chatData.participants!
        .where((element) => element != signedInUser);
    var respondent = private
        ? selectedChat.chatData.participants!.first
        : groupMembers.elementAt(Random().nextInt(groupMembers.length - 1));
    respondent.status = MessageSenderStatus.typing;
    participantStatusController.add({selectedChat.chatId: respondent});
    await Future.delayed(Duration(seconds: Random().nextInt(4) + 2));
    respondent.status = MessageSenderStatus.offline;
    participantStatusController.add({selectedChat.chatId: respondent});
    if (private)
      return ChatMessageModel(
          sender: selectedChat.chatData.participants!.first,
          date: DateTime.now(),
          message: faker.lorem.sentences(Random().nextBool() ? 1 : 2).join());
    else
      return ChatMessageModel(
          sender: respondent,
          date: DateTime.now(),
          message: faker.lorem.sentences(Random().nextBool() ? 1 : 2).join());
  }

  static StreamController<Map<String, MessageSender>>
      get participantStatusController => StreamController();
}

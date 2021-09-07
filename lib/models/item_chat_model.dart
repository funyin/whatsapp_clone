import 'package:flutter/material.dart';

class ItemChatModel {
  final List<ChatMessageModel> messages;
  final ChatType chatType;
  final ChatData chatData;
  final String chatId;
  String draft;
  late int numOfNewMessage;

  ItemChatModel(
      {required this.messages,
      this.numOfNewMessage = 0,
      required this.chatType,
      required this.chatData,
      required this.chatId,
      this.draft = ""}) {}
}

class ChatMessageModel {
  final MessageSender? sender;
  final String? message;
  final DateTime? date;

  ChatMessageModel({this.sender, this.message, this.date});
}

class MessageSender {
  final String? name;
  final String? mobile;
  final String? about;
  final String? imageUrl;
  final Color? color;
  final bool? savedContact;
  MessageSenderStatus? status;
  final noDpSvg =
      "https://firebasestorage.googleapis.com/v0/b/funyinkash-portfolio.appspot.com/o/portfolio%2FwhatsAppClone%2Fimages%2FwhatsAppNoDp.svg?alt=media&token=d0c8c9dc-6041-4e13-9eb1-ad18b8cce1a9";

  MessageSender(
      {this.name,
      this.mobile,
      this.imageUrl,
      this.about,
      this.color,
      this.savedContact,
      this.status});
}

enum MessageSenderStatus { offline, online, typing, recording }
enum ChatType { public, private }

class ChatData {
  final String? topic;
  final String? description;
  final String? imageURl;
  final List<MessageSender>? admins;

  ///for private chats the respondent is the first element while the signed in user is the second
  final List<MessageSender>? participants;
  final DateTime? created;
  final List<ChatMedia>? chatMedia;
  final noGroupDpSvg =
      "https://firebasestorage.googleapis.com/v0/b/funyinkash-portfolio.appspot.com/o/portfolio%2FwhatsAppClone%2Fimages%2FnoGroupDpSvg.svg?alt=media&token=265c0ff0-4a77-4f3c-8884-82adfafd7226";

  ChatData({
    this.topic,
    this.imageURl,
    this.admins,
    this.participants,
    this.description,
    this.created,
    this.chatMedia,
  });
}

class ChatMedia {
  final ChatMediaType? mediaType;
  final String? data;

  ChatMedia({this.mediaType, this.data});
}

enum ChatMediaType { image, audio, doc, link }

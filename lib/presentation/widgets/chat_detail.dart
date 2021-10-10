import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/bloc/bloc.dart';
import 'package:whatsapp_clone/models/item_chat_model.dart';
import 'package:whatsapp_clone/presentation/widgets/item_list_group.dart';
import 'package:whatsapp_clone/presentation/widgets/search_text_field.dart';
import 'package:whatsapp_clone/resources/R.dart';
import 'package:whatsapp_clone/state.dart';
import 'package:whatsapp_clone/utils/project_utils.dart';

class ChatDetail extends StatelessWidget {
  ChatDetail({
    Key? key,
  }) : super(key: key);
  WhatsAppCloneState? _state;
  ItemChatModel? selectedChat;
  late BuildContext mContext;
  late var cubit = BlocProvider.of<WhatsAppCloneCubit>(mContext);

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return BlocBuilder<WhatsAppCloneCubit, WhatsAppCloneState>(
      bloc: cubit,
      builder: (context, state) {
        _state = state;
        selectedChat = cubit.selectedChat();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            detailHeader(context),
            if (state.activeDetail == ActiveDetail.chatInfo)
              buildInfo(context)
            else
              buildSearch()
          ],
        );
      },
    );
  }

  Widget buildSearch() {
    var private = selectedChat!.chatType == ChatType.private;
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchTextField(hint: "Search..."),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 72, vertical: 50),
                child: Text(
                    "Search for messages ${private ? "with" : "within"} ${private ? selectedChat!.chatData.participants!.first.name : selectedChat!.chatData.topic}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildInfo(BuildContext context) {
    var public = selectedChat!.chatType == ChatType.public;
    var respondent = selectedChat!.chatData.participants!.first;
    var chatMedia = selectedChat!.chatData.chatMedia!;
    var actionTextStyle = TextStyle(color: Colors.black, fontSize: 17);
    var groupsInCommon = cubit.groupsInCommon();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 22),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ProjectUtils.buildAvatar(
                          chat: selectedChat!, size: 200),
                    ),
                  ),
                  SizedBox(height: 26),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            public
                                ? selectedChat!.chatData.topic!
                                : respondent.name!,
                            style: TextStyle(fontSize: 19, color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        public
                            ? "Created ${DateFormat.yMMMd().format(selectedChat!.chatData.created!)} ${DateFormat.jm().format(selectedChat!.chatData.created!)}"
                            : ProjectUtils.messageSenderStatusToString(
                                respondent.status!),
                        style: TextStyle(fontSize: 14, color: Colors.black26),
                      )
                    ],
                  )
                ],
              ),
            ),
            spacer(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: sectionTitle("Media, Links and Docs"),
                      ),
                      buildChevron()
                    ],
                  ),
                  SizedBox(height: 22),
                  if (chatMedia.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var media = chatMedia.elementAt(index);
                            return buildMediaImage(media);
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 6),
                          itemCount: chatMedia.length),
                    )
                  else
                    Text(
                      "No Media, Links and Docs",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black26),
                    ),
                ],
              ),
            ),
            spacer(),
            Container(
              color: Colors.white,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                  title: Text(
                    "Mute Notifications",
                    style: actionTextStyle,
                  ),
                  dense: true,
                  trailing: Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                divider(indent: 30),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                  title: Text("Starred Notifications", style: actionTextStyle),
                  dense: true,
                  trailing: buildChevron(),
                ),
                divider(indent: 30),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                  title: Text("Disappearing Messages", style: actionTextStyle),
                  subtitle: Text("Off"),
                  dense: true,
                  trailing: buildChevron(),
                ),
              ]),
            ),
            spacer(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("About and phone number"),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      respondent.about!,
                      style: actionTextStyle,
                    ),
                  ),
                  divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(respondent.mobile!, style: actionTextStyle),
                  ),
                ],
              ),
            ),
            if (groupsInCommon.length > 0) ...[
              spacer(),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(child: sectionTitle("Groups in common")),
                          sectionTitle(groupsInCommon.length.toString())
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                          groupsInCommon.length,
                          (index) => ItemListGroup(
                                chat: groupsInCommon[index],
                              )),
                    )
                  ],
                ),
              ),
            ],
            spacer(),
            buildAction("Block", iconsData: Icons.block, onTap: () {}),
            spacer(),
            buildAction("Report", iconsData: Icons.thumb_down, onTap: () {}),
            spacer(),
            buildAction("Delete", iconsData: Icons.delete, onTap: () {}),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  Widget buildAction(String text, {IconData? iconsData, VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            children: [
              Icon(
                iconsData,
                color: Colors.red,
              ),
              SizedBox(width: 30),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Divider divider({double? indent}) => Divider(height: 1, indent: indent);

  Widget buildMediaImage(ChatMedia media) {
    var audio = media.mediaType == ChatMediaType.audio;
    return media.mediaType != ChatMediaType.doc
        ? Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.network(audio ? ProjectUtils.audioMediaImage : media.data!,
                  width: 100, fit: BoxFit.cover, height: 100),
              if (audio)
                Padding(
                  padding: EdgeInsets.only(left: 6, bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.headphones, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "${Random().nextInt(6)}:${Random().nextInt(59)}",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      )
                    ],
                  ),
                )
            ],
          )
        : Image.network(ProjectUtils.docMediaImage, width: 100, height: 100);
  }

  Text sectionTitle(String title) {
    return Text(
      title,
      maxLines: 1,
      style: TextStyle(color: R.colors.teal, fontSize: 14),
    );
  }

  Icon buildChevron() => Icon(Icons.chevron_right);

  SizedBox spacer() => SizedBox(height: 10);

  Container detailHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: R.colors.headerHeight,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: R.colors.iconColor,
              ),
              onPressed: () {
                BlocProvider.of<WhatsAppCloneCubit>(context)
                    .setActiveDetail(null);
              },
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(_state!.activeDetail == ActiveDetail.search
                  ? "Search Message"
                  : (selectedChat!.chatType == ChatType.public
                      ? "Group Info"
                      : "Contact Info")),
            ))
          ],
        ));
  }
}

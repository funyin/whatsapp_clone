import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/bloc/bloc.dart';
import 'package:whatsapp_clone/presentation/widgets/item_list_chats.dart';
import 'package:whatsapp_clone/presentation/widgets/search_text_field.dart';
import 'package:whatsapp_clone/resources/R.dart';
import 'package:whatsapp_clone/server/mock_server.dart';
import 'package:whatsapp_clone/state.dart';
import 'package:whatsapp_clone/utils/project_utils.dart';
import 'package:whatsapp_clone/utils/project_vectors.dart';

class ChatMaster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhatsAppCloneCubit, WhatsAppCloneState>(
        buildWhen: (previous, current) =>
            previous.randomChats != current.randomChats,
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: R.colors.headerHeight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          NetworkImage(MockServer.signInUserImageUrl),
                    ),
                    Spacer(),
                    ...[
                      ProjectUtils.buildAction(ProjectVectors.statusIcon,
                          padding: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ProjectUtils.buildAction(
                            ProjectVectors.messageIcon,
                            padding: 10),
                      ),
                      ProjectUtils.buildAction(ProjectVectors.overflowMenu,
                          padding: 10, onTap: () {}),
                    ]
                  ],
                ),
              ),
              SearchTextField(hint: "Search or start a new chat"),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    radius: Radius.zero,
                    child: ListView.separated(
                      primary: false,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ItemListChats(chat: state.randomChats![index]),
                      ),
                      itemCount: state.randomChats!.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        indent: 76,
                        height: 0.8,
                        endIndent: 10,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}

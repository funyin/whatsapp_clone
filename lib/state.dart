import 'package:whatsapp_clone/models/item_chat_model.dart';

class WhatsAppCloneState {
  final String? selectedChatId;
  static const NO_CHAT_ID = "-1";
  List<ItemChatModel>? randomChats;
  final ActiveDetail? activeDetail;

  WhatsAppCloneState(
      {this.selectedChatId = NO_CHAT_ID, this.randomChats, this.activeDetail});
}

enum ActiveDetail { chatInfo, search, chatMedia }

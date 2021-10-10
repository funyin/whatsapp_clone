import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/presentation/widgets/searchHeaderDelegate.dart';
import 'package:whatsapp_clone/resources/R.dart';
import 'package:whatsapp_clone/utils/project_emojis.dart';

class ChatBottomsheet extends StatefulWidget {
  final Function(String) onEmojiSelected;

  const ChatBottomsheet({Key? key, required this.onEmojiSelected})
      : super(key: key);

  @override
  _ChatBottomsheetState createState() => _ChatBottomsheetState();
}

class _ChatBottomsheetState extends State<ChatBottomsheet>
    with SingleTickerProviderStateMixin {
  var bottomSheetTabs = <IconData>[
    Icons.access_time_outlined,
    Icons.pets,
    Icons.toys_outlined,
    Icons.emoji_food_beverage_outlined,
    Icons.sports_soccer,
    Icons.directions_car,
    Icons.emoji_objects_outlined,
    Icons.tag,
    Icons.flag_outlined
  ];
  var searchController = TextEditingController();
  late var tabController =
      TabController(length: bottomSheetTabs.length, vsync: this);
  var scrollController = ScrollController();
  final searching = ValueNotifier("");
  var searchEmojis = [];
  late var emojiMap = <String, Iterable<Emoji>>{
    "Recent": [],
    "Smileys & People": Emoji.byGroup(EmojiGroup.smileysEmotion),
    "Animals & Nature": Emoji.byGroup(EmojiGroup.animalsNature),
    "Food & Drink": Emoji.byGroup(EmojiGroup.foodDrink),
    "Activity": Emoji.byGroup(EmojiGroup.activities),
    "Travel & Places": Emoji.byGroup(EmojiGroup.travelPlaces),
    "Objects": Emoji.byGroup(EmojiGroup.objects),
    "Symbols": Emoji.byGroup(EmojiGroup.symbols),
    "Flags": Emoji.byGroup(EmojiGroup.flags)
  };
  var showEmoji = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: R.colors.background,
      child: ValueListenableBuilder<bool>(
        valueListenable: showEmoji,
        builder: (context, value, child) => value
            ? Column(
                children: [
                  TabBar(
                    tabs: List.generate(
                        bottomSheetTabs.length,
                        (index) => Container(
                            width: 80,
                            height: 40,
                            alignment: Alignment.center,
                            child: Icon(bottomSheetTabs[index],
                                color: R.colors.iconColor))),
                    controller: tabController,
                    indicatorColor: R.colors.teal,
                  ),
                  Expanded(
                      child: NotificationListener(
                    onNotification: (notification) {
                      // var position = scrollController.position;
                      // var fixedScrollMetrics = FixedScrollMetrics(
                      //     minScrollExtent: position
                      //         .minScrollExtent,
                      //     maxScrollExtent: position
                      //         .maxScrollExtent,
                      //     pixels: position.pixels,
                      //     viewportDimension: position
                      //         .viewportDimension,
                      //     axisDirection: position
                      //         .axisDirection);
                      // if (notification ==
                      //     SmileysEmojisSection(context: context,
                      //         metrics: fixedScrollMetrics))
                      //   print()
                      return true;
                    },
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverPersistentHeader(
                          delegate: SearchHeaderDelegate(
                              onChanged: (value) {
                                searching.value = value;
                                searchEmojis = Emoji.all()
                                    .where((element) => element.keywords!.any(
                                        (element) => element.contains(value)))
                                    .map((e) => e.char)
                                    .toList();
                              },
                              controller: searchController),
                          floating: true,
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                          Align(
                              alignment: Alignment.centerRight,
                              child: buildSwitchTile(value))
                        ])),
                        SliverList(
                            delegate: SliverChildListDelegate([
                          ValueListenableBuilder<String>(
                            valueListenable: searching,
                            builder: (context, value, child) {
                              return Padding(
                                padding: EdgeInsets.all(12),
                                child: value.isNotEmpty
                                    ? Wrap(
                                        children: List.generate(
                                            searchEmojis.length,
                                            (index) =>
                                                itemEmoji(searchEmojis[index])),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: emojiMap.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var key =
                                              emojiMap.keys.elementAt(index);
                                          var emojiSectionMap = emojiMap[key]!;
                                          return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                sectionTitle(key),
                                                Wrap(
                                                  children: List.generate(
                                                      emojiSectionMap.length,
                                                      (index) => itemEmoji(
                                                          emojiSectionMap
                                                              .elementAt(index)
                                                              .char!)),
                                                ),
                                                SizedBox(height: 20)
                                              ]);
                                        },
                                      ),
                              );
                            },
                          )
                        ])),
                      ],
                    ),
                  ))
                ],
              )
            : emojiInitialState(value),
      ),
    );
  }

  Column emojiInitialState(bool value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Emojis were removed because they had a bad effect on performance",
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        SizedBox(height: 20),
        buildSwitchTile(value)
      ],
    );
  }

  SizedBox buildSwitchTile(bool value) {
    return SizedBox(
        width: 200,
        child: Material(
          color: Colors.transparent,
          child: SwitchListTile(
              title: Text(
                value ? "Hide Emojis" : "Show Emojis",
                style: TextStyle(fontSize: 14),
              ),
              value: value,
              onChanged: (_) => showEmoji.value = _),
        ));
  }

  InkWell itemEmoji(String emoji) {
    return InkWell(
      onTap: () {
        widget.onEmojiSelected.call(emoji);
        var element = Emoji(char: emoji);
        if (!searchEmojis.contains(element)) searchEmojis.add(element);
      },
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Text(
          emoji,
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: TextStyle(
              fontSize: 14,
              color: Colors.black26,
              fontWeight: FontWeight.w200)),
    );
  }
}

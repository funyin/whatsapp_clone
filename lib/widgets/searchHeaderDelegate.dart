import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp_clone/utils/project_utils.dart';

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(String)? onChanged;
  final TextEditingController? controller;

  SearchHeaderDelegate({this.onChanged, this.controller});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: ProjectUtils.contentBackColor,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search Emoji",
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            filled: true,
            fillColor: Color(0xffe6e6e6),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

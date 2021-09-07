import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String hint;
  const SearchTextField({
    Key? key,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff6f6f6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        height: 35,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(17)),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Color(0xff9b9b9b),
              size: 19,
            ),
            SizedBox(width: 32),
            Expanded(
              child: TextField(
                style: TextStyle(color: Color(0xff4a4a4a), fontSize: 15),
                decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: EdgeInsets.only(bottom: 12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wisely/classes/book.dart';
import 'package:wisely/components/book.dart';
import 'package:wisely/components/interText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class month_list extends StatefulWidget {
  final String datename;
  final Function callBackSetState;
  const month_list({
    super.key,
    required this.datename,
    required this.callBackSetState,
  });

  @override
  State<month_list> createState() => _month_listState();
}

class _month_listState extends State<month_list> {
  var books = [];
  var booksButton = [];

  Future<void> loadBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();

    books.clear();
    booksButton.clear();

    for (var e in keys) {
      if (jsonDecode(prefs.getString(e) ?? "{'date': 0}")["date"] ==
          widget.datename) {
        books.add(jsonDecode(prefs.getString(e) ?? "{'date': 0}"));
      }
    }

    for (var i = 0; i < books.length; i++) {
      booksButton.add(
        Book(
          id: keys.toList()[i],
          callBackSetState: widget.callBackSetState,
          bookClass: books[i],
        ),
      );
    }
  }

  @override
  void initState() {
    loadBooks().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant month_list oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadBooks().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SizedBox(
            width: screenWidth - 50,
            child: InterText(
              text: widget.datename,
              weight: FontWeight.w200,
              color: const Color(0xffD9D9D9),
              size: 15,
              align: TextAlign.left,
            ),
          ),
        ),
        ...booksButton.map((Book) => Book).toList()
      ],
    );
  }
}

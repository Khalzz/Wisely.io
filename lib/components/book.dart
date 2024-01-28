import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisely/components/interText.dart';
import 'package:wisely/pages/bookpage.dart';

class Book extends StatefulWidget {
  final Function callBackSetState;
  final Map<String, dynamic> bookClass;
  final String id;

  const Book({
    super.key,
    required this.id,
    required this.callBackSetState,
    required this.bookClass,
  });

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  Future<void> deleteBook(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(id);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant Book oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: screenWidth - 50,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Color(0xffD9D9D9),
            alignment: Alignment.centerLeft,
            foregroundColor: Color(0xff304454),
          ),
          onLongPress: () {
            showCupertinoModalPopup(
              barrierColor: Color.fromARGB(100 as int, 0, 0, 0),
              context: context,
              builder: (BuildContext context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: screenWidth * 0.6,
                    height: 40,
                    // add blur to this
                    margin: EdgeInsets.only(bottom: 30),
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFB4934),
                            foregroundColor: Color(0xffD9D9D9)),
                        child: const InterText(
                          text: "Delete",
                          weight: FontWeight.w200,
                          color: Color(0xffD9D9D9),
                          size: 15,
                          align: TextAlign.center,
                        ),
                        onPressed: () async {
                          deleteBook(widget.id)
                              .then((value) => widget.callBackSetState());
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookPage(
                        book: widget.bookClass,
                        id: widget.id,
                      )),
            );
          },
          child: Text(widget.bookClass["name"]),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisely/classes/book.dart';
import 'package:wisely/components/interText.dart';

class Value extends StatefulWidget {
  final Map<String, dynamic> expense;
  final String id;
  final Function callBackSetState;

  const Value(
      {super.key,
      required this.expense,
      required this.callBackSetState,
      required this.id});

  @override
  State<Value> createState() => _ValueState();
}

class _ValueState extends State<Value> {
  NumberFormat f = new NumberFormat("#,##0", "es_CL");

  void deleteValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var emptyBook =
        jsonEncode(BookClass(name: "", budget: null, date: "", expenses: []));
    var book = jsonDecode(prefs.getString(widget.id) ?? emptyBook);

    for (var i = 0; i < book['expenses'].length; i++) {
      if (book['expenses'][i]['id'] == widget.expense['id']) {
        book['expenses'].removeAt(i);
      }
    }

    prefs.setString(widget.id, jsonEncode(book));
    widget.callBackSetState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var value = '';

    if (widget.expense["isCollect"]) {
      value = "+${f.format(widget.expense['value'])}";
    } else {
      value = "-${f.format(widget.expense['value'])}";
    }

    return Container(
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              shadowColor: Colors.transparent,
              backgroundColor: Color(0xffCFCFCF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
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
                            deleteValue();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            onPressed: () {},
            child: Row(
              children: [
                Expanded(
                  child: InterText(
                    text: widget.expense['expenseName'],
                    weight: FontWeight.w300,
                    color: Color(0xff304454),
                    size: 15,
                    align: TextAlign.left,
                  ),
                ),
                InterText(
                    text: value,
                    weight: FontWeight.w300,
                    color: widget.expense["isCollect"]
                        ? Color(0xff16B313)
                        : Color(0xffB3134D),
                    size: 15,
                    align: TextAlign.right)
              ],
            )));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisely/classes/book.dart';
import 'package:wisely/components/interText.dart';
import 'package:wisely/components/value.dart';
import 'package:intl/intl.dart';

class Collect extends StatefulWidget {
  final Function callBackSetState;

  final Map<String, dynamic> book;
  final String id;

  const Collect(
      {super.key,
      required this.book,
      required this.id,
      required this.callBackSetState});

  @override
  State<Collect> createState() => _CollectState();
}

class _CollectState extends State<Collect> {
  List<Widget> expenses = [];
  num minusValue = 0;

  void loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var emptyBook =
        jsonEncode(BookClass(name: "", budget: null, date: "", expenses: []));
    var book = jsonDecode(prefs.getString(widget.id) ?? emptyBook);

    expenses = [];
    book['expenses'].forEach((element) {
      if (element['isCollect']) {
        expenses.add(Container(
            child: Value(
          expense: element,
          callBackSetState: widget.callBackSetState,
          id: widget.id,
        )));
      }
    });
    expenses.add(Container(height: 30));
    setState(() {});
  }

  void getExpensesValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var emptyBook =
        jsonEncode(BookClass(name: "", budget: null, date: "", expenses: []));
    var book = jsonDecode(prefs.getString(widget.id) ?? emptyBook);

    minusValue = 0;
    book['expenses'].forEach((element) {
      if (element['isCollect']) {
        minusValue += element['value'];
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    getExpensesValue();
    loadExpenses();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Collect oldWidget) {
    getExpensesValue();
    loadExpenses();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    NumberFormat f = new NumberFormat("#,##0", "es_CL");

    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 15),
            width: screenWidth * 0.5,
            height: screenHeight * 0.10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffD9D9D9),
                foregroundColor: Color(0xff304454),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {},
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InterText(
                        text: '${f.format(0 + minusValue)}\$',
                        weight: FontWeight.w200,
                        color:
                            (int.parse(widget.book["budget"]) + minusValue) > 0
                                ? Color(0xff2166ED)
                                : Color(0xffB3134D),
                        size: 18,
                        align: TextAlign.center),
                  ],
                ),
              ),
            )),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 25),
            decoration: const BoxDecoration(
              color: Color(0xffD9D9D9),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              boxShadow: [
                // to make elevation
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
                // to make the coloured border
              ],
            ),
            width: screenWidth * 0.8,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: InterText(
                    text: 'Collections',
                    weight: FontWeight.w700,
                    color: Color(0xff304454),
                    size: 15,
                    align: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: expenses,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

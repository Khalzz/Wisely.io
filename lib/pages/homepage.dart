import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wisely/classes/book.dart';
import 'package:wisely/components/interText.dart';
import 'package:wisely/components/month_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var finalDates = [];

  Future<void> loadDates() async {
    finalDates = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();
    var dates = [];
    var emptyBook =
        jsonEncode(BookClass(name: "", budget: null, date: "", expenses: []));
    keys.forEach((keyElement) {
      dates.add(jsonDecode(prefs.getString(keyElement) ?? emptyBook)['date']);
    });

    dates.sort((a, b) {
      List<String> partsA = a.split('-');
      List<String> partsB = b.split('-');

      int yearA = int.parse(partsA[1]);
      int monthA = int.parse(partsA[0]);

      int yearB = int.parse(partsB[1]);
      int monthB = int.parse(partsB[0]);

      // First, compare years in descending order
      int yearComparison = yearB.compareTo(yearA);
      if (yearComparison != 0) {
        return yearComparison;
      } else {
        // If years are the same, compare months in descending order
        return monthB.compareTo(monthA);
      }
    });
    dates.toSet().toList().forEach((dateElement) {
      finalDates.add(month_list(
        datename: dateElement,
        callBackSetState: callBackSetState,
      ));
    });

    setState(() {});
  }

  void callBackSetState() {
    loadDates();
  }

  @override
  void initState() {
    loadDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff304454),
        onPressed: () {
          showDialog(
            barrierColor: Color.fromARGB(100 as int, 0, 0, 0),
            context: context,
            builder: (BuildContext context) {
              return AddBook(
                callBackSetState: callBackSetState,
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Color(0xffD9D9D9),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffB8134F), Color(0xff42071C)],
                ),
              ),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                    child: Center(
                      child: InterText(
                        text: 'Hi Rodrigo!',
                        weight: FontWeight.w300,
                        color: Color(0xffD9D9D9),
                        size: 20,
                        align: TextAlign.center,
                      ),
                    ),
                  ),
                  ...finalDates.map((monthList) => monthList).toList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddBook extends StatefulWidget {
  final Function callBackSetState;
  const AddBook({super.key, required this.callBackSetState});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  bool canAdd = false;
  String endText = "";

  Future<int> getNextId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int higherId = 0;
    prefs.getKeys().forEach((element) {
      if (int.parse(element) > higherId) {
        higherId = int.parse(element);
      }
    });
    return higherId;
  }

  Future<void> saveBook(text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var date = DateTime.now();
    var fixedDate =
        "${date.month.toString().length == 2 ? date.month : "0${date.month}"} - ${date.year}";
    var book =
        BookClass(name: text, budget: null, date: fixedDate, expenses: []);
    var thisId = (await getNextId() + 1);
    await prefs.setString(thisId.toString(), jsonEncode(book));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Column(
        children: [
          AlertDialog(
            insetPadding: EdgeInsets.only(top: screenHeight / 2.5, bottom: 20),
            contentPadding: const EdgeInsets.all(5),
            backgroundColor: const Color(0xffD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              height: 40,
              width: screenWidth - 80,
              alignment: Alignment.center,
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    endText = text;
                    canAdd = text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Book',
                  contentPadding: const EdgeInsets.only(left: 10),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff304454),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xff304454),
                ),
                cursorColor: const Color(0xff304454),
              ),
            ),
          ),
          Container(
            width: 100,
            margin: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              onPressed: canAdd
                  ? () async {
                      saveBook(endText)
                          .then((value) => widget.callBackSetState());
                      Navigator.of(context).pop(true);
                    }
                  : null,
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xffD9D9D9)),
              child: const Text('Add'),
            ),
          ),
          Container(
            width: 100,
            child: OutlinedButton(
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xffD9D9D9)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
    // Dialog with Input
  }
}

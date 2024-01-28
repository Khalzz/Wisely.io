import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wisely/classes/expense.dart';
import 'package:wisely/components/collection.dart';
import 'package:wisely/components/expenses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookPage extends StatefulWidget {
  final Map<String, dynamic> book;
  final String id;
  const BookPage({super.key, required this.book, required this.id});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  void callBackSetState() {
    setState(() {});
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> widgetOptions = <Widget>[
      Budget(
        book: widget.book,
        id: widget.id,
        callBackSetState: callBackSetState,
      ),
      Collect(
        book: widget.book,
        id: widget.id,
        callBackSetState: callBackSetState,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: widget.book['budget'] == null
          ? null
          : BottomNavigationBar(
              backgroundColor: Color(0xff304454),
              selectedItemColor: Color(0xffD9D9D9),
              unselectedItemColor: Color.fromARGB(50, 217, 217, 217),
              selectedIconTheme: IconThemeData(opacity: 1),
              unselectedIconTheme: IconThemeData(opacity: 0.4),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.outbox,
                    color: Color(0xffD9D9D9),
                  ),
                  label: 'Budget',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.inbox,
                    color: Color(0xffD9D9D9),
                  ),
                  label: 'Collect',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.book['name'],
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xffB8134F),
        foregroundColor: Color(0xffD9D9D9),
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.book['budget'] == null
          ? null
          : FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xff689D6A),
              onPressed: () {
                showDialog(
                  barrierColor: Color.fromARGB(100 as int, 0, 0, 0),
                  context: context,
                  builder: (BuildContext context) {
                    return AddValue(
                      book: widget.book,
                      id: widget.id,
                      callBackSetState: callBackSetState,
                      pageIndex: _selectedIndex,
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
              width: screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffB8134F), Color(0xff42071C)],
                ),
              ),
              child: widget.book['budget'] == null
                  ? Center(
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          child: Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              barrierColor: Color.fromARGB(100 as int, 0, 0, 0),
                              context: context,
                              builder: (BuildContext context) {
                                return AddBudget(
                                  book: widget.book,
                                  id: widget.id,
                                  callBackSetState: callBackSetState,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                  : widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}

class AddBudget extends StatefulWidget {
  final Function callBackSetState;
  final Map<String, dynamic> book;
  final String id;
  const AddBudget(
      {super.key,
      required this.book,
      required this.id,
      required this.callBackSetState});

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  bool canAdd = false;
  String endText = "";

  Future<void> addBudget(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.book['budget'] = value;
    prefs.setString(widget.id, jsonEncode(widget.book));
    setState(() {});
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
            content: Column(
              children: [
                Container(
                  height: 40,
                  width: screenWidth - 80,
                  alignment: Alignment.center,
                  child: TextField(
                    maxLength: 15,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (text) {
                      setState(() {
                        endText = text;
                        canAdd = text.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Budget',
                      counterText: '',
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
                Container(
                  width: 140,
                  margin: const EdgeInsets.only(top: 10),
                  child: OutlinedButton(
                    onPressed: canAdd
                        ? () async {
                            addBudget(endText)
                                .then((value) => widget.callBackSetState());
                            Navigator.of(context).pop(true);
                          }
                        : null,
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff304454)),
                    child: const Text('Add budget'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 100,
                  child: OutlinedButton(
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff304454)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // Dialog with Input
  }
}

class AddValue extends StatefulWidget {
  final Function callBackSetState;
  final Map<String, dynamic> book;
  final String id;
  final int pageIndex;
  const AddValue(
      {super.key,
      required this.book,
      required this.id,
      required this.callBackSetState,
      required this.pageIndex});

  @override
  State<AddValue> createState() => _AddValueState();
}

class _AddValueState extends State<AddValue> {
  bool canAdd = false;
  bool canAdd1 = false;
  String endValue = "";
  String endTag = "";
  NumberFormat f = new NumberFormat("#,##0", "es_CL");

  Future<int> getNextId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bookJson = prefs.getString(widget.id) ??
        '{"name": "", "budget": 0, "expenses": [], "date": ""}';
    Map<String, dynamic> book = jsonDecode(bookJson);
    List<dynamic> expenses = book['expenses'];
    int higherId = 0;

    expenses.forEach((element) {
      if (element["id"] > higherId) {
        higherId = element["id"];
      }
    });

    return higherId;
  }

  Future<void> setValue(tag, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bookJson = prefs.getString(widget.id) ??
        '{"name": "", "budget": 0, "expenses": [], "date": ""}';

    // Decode the JSON string to a Map
    Map<String, dynamic> book = jsonDecode(bookJson);
    List<dynamic> expenses = book['expenses'];

    var expense = Expense(
        id: await getNextId() + 1,
        expenseName: tag,
        value: int.parse(value),
        isCollect: (widget.pageIndex == 0 ? false : true));
    expenses.add(expense);
    prefs.setString(widget.id, jsonEncode(book));
    setState(() {});
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
            content: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 40,
                  width: screenWidth - 80,
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        endTag = text;
                        canAdd = text.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tag',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff304454),
                      ),
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
                Container(
                  height: 40,
                  width: screenWidth - 80,
                  alignment: Alignment.center,
                  child: TextField(
                    maxLength: 15,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (text) {
                      setState(() {
                        endValue = text;
                        canAdd1 = text.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Value',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff304454)),
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
                Container(
                  width: 140,
                  margin: const EdgeInsets.only(top: 10),
                  child: OutlinedButton(
                    onPressed: canAdd && canAdd1
                        ? () async {
                            setValue(endTag, endValue)
                                .then((value) => widget.callBackSetState());

                            Navigator.of(context).pop(true);
                          }
                        : null,
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff304454)),
                    child: const Text('Add value'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 100,
                  child: OutlinedButton(
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff304454)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // Dialog with Input
  }
}

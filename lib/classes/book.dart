import 'package:wisely/classes/expense.dart';

class BookClass {
  String name;
  double? budget;
  List<Expense> expenses;
  String date;

  BookClass({
    required this.name,
    required this.budget,
    required this.expenses,
    required this.date,
  });

  // for the jsonEncode and decode we need this function in our objects
  Map<String, dynamic> toJson() =>
      {'name': name, 'budget': budget, 'date': date, 'expenses': expenses};
}

class Expense {
  int id;
  String expenseName;
  int value;
  bool isCollect;

  Expense(
      {required this.id,
      required this.expenseName,
      required this.value,
      required this.isCollect});

  Map<String, dynamic> toJson() => {
        'id': id,
        'expenseName': expenseName,
        'value': value,
        'isCollect': isCollect,
      };
}

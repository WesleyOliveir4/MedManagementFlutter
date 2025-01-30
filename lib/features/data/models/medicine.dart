import 'dart:convert';

class Medicine {
  String name;
  int pillsInBox;
  int timesPerDay;
  DateTime startDate;

  Medicine({
    required this.name,
    required this.pillsInBox,
    required this.timesPerDay,
    required this.startDate,
  });

  int get remainingDays => (pillsInBox / timesPerDay).floor();

  Map<String, dynamic> toJson() => {
    'name': name,
    'pillsInBox': pillsInBox,
    'timesPerDay': timesPerDay,
    'startDate': startDate.toIso8601String(),
  };

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      pillsInBox: json['pillsInBox'],
      timesPerDay: json['timesPerDay'],
      startDate: DateTime.parse(json['startDate']),
    );
  }

  static List<Medicine> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((e) => Medicine.fromJson(e)).toList();
  }

  static String toJsonList(List<Medicine> medicines) {
    return json.encode(medicines.map((e) => e.toJson()).toList());
  }
}
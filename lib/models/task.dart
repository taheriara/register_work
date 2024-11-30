class Task {
  final String category;
  final String type;
  final String? details;
  final String regDate;
  final bool follow;
  final String? endDate;
  final String? year;
  final String? month;
  final String? day;

  Task({
    required this.category,
    required this.type,
    this.details,
    required this.regDate,
    required this.follow,
    this.endDate,
    this.year,
    this.month,
    this.day,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        category: json['category'],
        type: json['type'],
        details: json['details'],
        regDate: json['regDate'],
        follow: json['follow'] != 0 ? true : false,
        endDate: json['endDate'],
        year: json['year'],
        month: json['month'],
        day: json['day'],
      );

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'type': type,
      'details': details,
      'regDate': regDate,
      'follow': follow ? 1 : 0,
      'endDate': endDate,
      'year': year,
      'month': month,
      'day': day,
    };
  }
}

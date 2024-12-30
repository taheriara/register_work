class Report {
  final String category;
  final String type;
  final int qty;

  Report({
    required this.category,
    required this.type,
    required this.qty,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        category: json['category'],
        type: json['type'],
        qty: json['qty'],
      );

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'type': type,
      'qty': qty,
    };
  }
}

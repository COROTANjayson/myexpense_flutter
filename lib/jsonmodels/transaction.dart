class Transaction {
  final String message;
  final Map info;

  Transaction({this.message, this.info});
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(message: json['message'], info: json['recipe']);
  }
}

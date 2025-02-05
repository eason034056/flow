// import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkRecord {
  final String id;
  final String userId;
  final int amount;
  final DateTime timestamp;
  final String type;
  final String source;

  DrinkRecord({
    required this.id,
    required this.userId,
    required this.amount,
    required this.timestamp,
    required this.type,
    required this.source,
  });

  factory DrinkRecord.fromJson(Map<String, dynamic> json) {
    return DrinkRecord(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'source': source,
    };
  }

  DrinkRecord copyWith({
    String? id,
    String? userId,
    String? type,
    String? source,
    int? amount,
    DateTime? timestamp,
  }) {
    return DrinkRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      source: source ?? this.source,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

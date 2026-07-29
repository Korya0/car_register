import 'package:flutter/foundation.dart';

@immutable
class CarNumberModel {

  CarNumberModel({required this.number, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  factory CarNumberModel.fromJson(Map<String, dynamic> json) {
    return CarNumberModel(
      number: json['number'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
  final String number;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {'number': number, 'createdAt': createdAt.toIso8601String()};
  }

  CarNumberModel copyWith({String? number, DateTime? createdAt}) {
    return CarNumberModel(
      number: number ?? this.number,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CarNumberModel && other.number == number;
  }

  @override
  int get hashCode => number.hashCode;
}

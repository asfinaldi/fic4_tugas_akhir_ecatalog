// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateModel {
  final String title;
  final int price;
  UpdateModel({
    required this.title,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'price': price,
    };
  }

  factory UpdateModel.fromMap(Map<String, dynamic> map) {
    return UpdateModel(
      title: map['title'] ?? '',
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateModel.fromJson(String source) => UpdateModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

// To parse this JSON data, do
//
//     final slider = sliderFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class MySlider {
  MySlider({
    required this.id,
    required this.title,
    required this.image,
    required this.product_id
  });

  int id;
  String title;
  String image;
  int product_id;

  factory MySlider.fromJson(String str) => MySlider.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MySlider.fromMap(Map<String, dynamic> json) => MySlider(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    product_id: json["product_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "product_id": product_id,
  };
}

// To parse this JSON data, do
//
//     final detailsMealResponse = detailsMealResponseFromJson(jsonString);

import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'details_meal_response.g.dart';

DetailsMealResponse detailsMealResponseFromJson(String str) =>
    DetailsMealResponse.fromJson(json.decode(str));

String detailsMealResponseToJson(DetailsMealResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class DetailsMealResponse {
  @JsonKey(name: "meals")
  List<DetailsMealDto>? meals;

  DetailsMealResponse({this.meals});

  factory DetailsMealResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailsMealResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsMealResponseToJson(this);
}

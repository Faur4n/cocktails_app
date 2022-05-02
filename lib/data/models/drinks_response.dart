import 'package:freezed_annotation/freezed_annotation.dart';
import 'drink.dart';

part 'drinks_response.freezed.dart';
part 'drinks_response.g.dart';

@freezed
class DrinksResponse with _$DrinksResponse {
  const factory DrinksResponse([@Default([]) List<Drink> drinks]) =
      _DrinksResponse;

  factory DrinksResponse.fromJson(Map<String, dynamic> json) =>
      _$DrinksResponseFromJson(json);
}


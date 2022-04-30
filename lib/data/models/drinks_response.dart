import 'package:freezed_annotation/freezed_annotation.dart';

part 'drinks_response.freezed.dart';
part 'drinks_response.g.dart';

@freezed
class DrinksResponse with _$DrinksResponse {
  const factory DrinksResponse([@Default([]) List<Drink> drinks]) =
      _DrinksResponse;

  factory DrinksResponse.fromJson(Map<String, dynamic> json) =>
      _$DrinksResponseFromJson(json);
}

@freezed
class Drink with _$Drink {
  const factory Drink(
      @JsonKey(name: 'idDrink') String id,
      @JsonKey(name: 'strDrink') String name,
      @JsonKey(name: 'strCategory') String category,
      @JsonKey(name: 'strDrinkThumb') String thumb,
      @JsonKey(name: 'strInstructions') String instruction,
      @JsonKey(name: 'strGlass') String glass,
    ) = _Drink;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
}
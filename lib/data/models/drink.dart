import 'package:freezed_annotation/freezed_annotation.dart';

part 'drink.freezed.dart';

part 'drink.g.dart';

@freezed
class Drink with _$Drink {
  const factory Drink(
      @JsonKey(name: 'idDrink') final String id,
      @JsonKey(name: 'strDrink') final String name,
      @JsonKey(name: 'strCategory') final String category,
      @JsonKey(name: 'strDrinkThumb') final String thumb,
      @JsonKey(name: 'strInstructions') final String instruction,
      @JsonKey(name: 'strGlass') final String glass,
      @JsonKey(name: 'strIngredient1') final String? ingredient1,
      @JsonKey(name: 'strIngredient2') final String? ingredient2,
      @JsonKey(name: 'strIngredient3') final String? ingredient3,
      @JsonKey(name: 'strIngredient4') final String? ingredient4,
      @JsonKey(name: 'strIngredient5') final String? ingredient5,
      {@JsonKey(name: 'is_favorite') @Default(false) bool isFavorite}) = _Drink;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
}

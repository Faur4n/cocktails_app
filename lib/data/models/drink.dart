import 'package:freezed_annotation/freezed_annotation.dart';

part 'drink.freezed.dart';

part 'drink.g.dart';

@freezed
class Drink with _$Drink {
  const factory Drink(
      @JsonKey(name: 'idDrink') String id,
      @JsonKey(name: 'strDrink') String name,
      @JsonKey(name: 'strCategory') String category,
      @JsonKey(name: 'strDrinkThumb') String thumb,
      @JsonKey(name: 'strInstructions') String instruction,
      @JsonKey(name: 'strGlass') String glass,
      {@JsonKey(name: 'is_favorite') @Default(false) bool isFavorite}) = _Drink;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
}

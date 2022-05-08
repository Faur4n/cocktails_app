import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_response.freezed.dart';
part 'filter_response.g.dart';

@freezed
class FilterResponse with _$FilterResponse {
  const factory FilterResponse([@Default([]) List<FilteredDrink> drinks]) = _FilterResponse;

  factory FilterResponse.fromJson(Map<String, dynamic> json) =>
      _$FilterResponseFromJson(json);
}

@freezed
class FilteredDrink with _$FilteredDrink {
  const factory FilteredDrink(
      @JsonKey(name: 'idDrink') String id,
      @JsonKey(name: 'strDrink') String name,
      @JsonKey(name: 'strDrinkThumb') String thumb,
  ) = _FilteredDrink;

  factory FilteredDrink.fromJson(Map<String, dynamic> json) =>
      _$FilteredDrinkFromJson(json);
}


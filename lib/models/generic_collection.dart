import 'package:json_annotation/json_annotation.dart';

import 'profile.dart';

part 'generic_collection.g.dart';

@JsonSerializable()
class GenericCollection<T> {
  int count;

  @JsonKey(nullable: true)
  String previous;

  @JsonKey(nullable: true)
  String next;

  @JsonKey(name: 'results')
  @_Converter()
  List<T> items;

  GenericCollection({this.count, this.previous, this.next, this.items});

  factory GenericCollection.fromJson(Map<String, dynamic> json) => _$GenericCollectionFromJson<T>(json);

  Map<String, dynamic> toJson() => _$GenericCollectionToJson(this);
}

class _Converter<T> implements JsonConverter<T, Object> {
  const _Converter();

  @override
  T fromJson(Object json) {
    if (json is Map<String, dynamic>) {
      if (T == User) {
        return User.fromJson(json) as T;
      }
      if (T == Profile) {
        return Profile.fromJson(json) as T;
      }
    }

    return json as T;
  }

  @override
  Object toJson(T object) {
    return object;
  }
}

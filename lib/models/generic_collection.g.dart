// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericCollection<T> _$GenericCollectionFromJson<T>(Map<String, dynamic> json) {
  return GenericCollection<T>(
    count: json['count'] as int,
    previous: json['previous'] as String,
    next: json['next'] as String,
    items: (json['results'] as List)?.map(_Converter<T>().fromJson)?.toList(),
  );
}

Map<String, dynamic> _$GenericCollectionToJson<T>(
        GenericCollection<T> instance) =>
    <String, dynamic>{
      'count': instance.count,
      'previous': instance.previous,
      'next': instance.next,
      'results': instance.items?.map(_Converter<T>().toJson)?.toList(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

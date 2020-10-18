import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class User {
  User();

  int id;
  String username;

  @JsonKey(name: 'first_name')
  String firstName;
  @JsonKey(name: 'last_name')
  String lastName;

  bool get hasName => firstName?.isNotEmpty == true || lastName?.isNotEmpty == true;

  String get fullName => hasName ? '$lastName $firstName' : username ?? '';

  String get initials => hasName ? '${_getInitial(lastName)} ${_getInitial(firstName)}' : _getInitial(username);

  String _getInitial(String value) {
    if (value == null || value.isEmpty) return '';
    return '${value[0].toUpperCase()}.';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(nullable: false)
class Profile extends User {
  Profile();

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'reference_owner.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferenceOwner {
  final String id;
  final String firstName;
  final String lastName;
  final bool derbigum;

  const ReferenceOwner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.derbigum,
  });

  factory ReferenceOwner.fromJson(Map<String, dynamic> json) =>
      _$ReferenceOwnerFromJson(json);

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => _$ReferenceOwnerToJson(this);
}

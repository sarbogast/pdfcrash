import 'package:json_annotation/json_annotation.dart';

part 'reference_authorization.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferenceAuthorization {
  final String? url;
  final String? filename;
  final String? storagePath;

  ReferenceAuthorization({
    this.url,
    this.filename,
    this.storagePath,
  });

  factory ReferenceAuthorization.fromJson(Map<String, dynamic> json) =>
      _$ReferenceAuthorizationFromJson(json);

  Map<String, dynamic> toJson() => _$ReferenceAuthorizationToJson(this);

  bool get isEmpty => url == null && filename == null && storagePath == null;
}

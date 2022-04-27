import 'package:json_annotation/json_annotation.dart';

import '../enums/language_code.dart';

part 'reference_picture.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferencePicture {
  final String url;
  final String? storagePath;
  final String? webUrl;
  final String? webStoragePath;
  final Map<LanguageCode, String>? alt;
  final Map<LanguageCode, String>? legend;
  final bool excluded;

  ReferencePicture({
    required this.url,
    this.alt,
    this.legend,
    this.storagePath,
    this.webUrl,
    this.webStoragePath,
    this.excluded = false,
  });

  factory ReferencePicture.fromJson(Map<String, dynamic> json) =>
      _$ReferencePictureFromJson(json);

  Map<String, dynamic> toJson() => _$ReferencePictureToJson(this);
}

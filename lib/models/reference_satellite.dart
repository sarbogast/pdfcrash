import 'package:json_annotation/json_annotation.dart';

part 'reference_satellite.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferenceSatellite {
  final String url;
  final String storagePath;

  ReferenceSatellite({
    required this.url,
    required this.storagePath,
  });

  factory ReferenceSatellite.fromJson(Map<String, dynamic> json) =>
      _$ReferenceSatelliteFromJson(json);

  Map<String, dynamic> toJson() => _$ReferenceSatelliteToJson(this);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../exceptions/exceptions.dart';

import '../enums/building_type.dart';
import '../enums/language_code.dart';
import '../enums/product.dart';
import '../enums/share_channel.dart';
import '../enums/share_destination.dart';
import '../enums/solution_type.dart';
import '../enums/user_locale.dart';
import 'geo_location.dart';
import 'reference_authorization.dart';
import 'reference_picture.dart';
import 'reference_satellite.dart';
import 'reference_owner.dart';

import 'json_helpers.dart';

part 'reference.g.dart';

@JsonSerializable(explicitToJson: true)
class Reference {
  final String id;
  @JsonKey(
    fromJson: nullableDateTimeFromTimestamp,
    toJson: nullableDateTimeToTimestamp,
    required: true,
  )
  final DateTime? dateCreated;
  final Map<LanguageCode, String> projectName; //
  final String customerName; //
  final String? companyName;
  @JsonKey(
    fromJson: geoLocationFromGeoPoint,
    toJson: geoLocationToGeoPoint,
    required: true,
  )
  final GeoLocation location;
  final int surface; //
  final BuildingType? buildingType; //
  final bool newBuilding; //
  final int year; //
  final int month; //
  final String address;
  final String countryCode;
  final String city;
  final String country;
  final String projectDate;
  ReferenceSatellite? satellite;
  @JsonKey(defaultValue: [])
  final List<ReferencePicture> pictures;
  final UserLocale locale;
  @JsonKey(defaultValue: {})
  final Map<String, List<String>> tags;
  final ReferenceOwner owner;
  final Map<LanguageCode, String>? description;
  final String? prescriber;
  final ReferenceAuthorization? authorization;
  final ShareDestination? share;
  @JsonKey(defaultValue: [])
  final List<SolutionType> solutionTypes;
  final Map<String, String>?
      shareGroups; //keys are group ids, values are group names
  @JsonKey(defaultValue: [])
  final List<ShareChannel> channels;
  @JsonKey(defaultValue: [])
  final List<Product> products;

  Reference({
    required this.id,
    required this.dateCreated,
    required this.projectName,
    required this.customerName,
    required this.companyName,
    required this.location,
    required this.surface,
    required this.buildingType,
    required this.newBuilding,
    required this.year,
    required this.month,
    required this.address,
    required this.countryCode,
    required this.city,
    required this.country,
    required this.projectDate,
    required this.satellite,
    required this.pictures,
    required this.locale,
    required this.tags,
    required this.owner,
    required this.description,
    required this.prescriber,
    required this.authorization,
    required this.share,
    required this.solutionTypes,
    required this.shareGroups,
    required this.channels,
    required this.products,
  });

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);

  bool get isPrivate => shareGroups == null || shareGroups!.isEmpty;

  bool get isPhotoSharingAuthorized =>
      authorization != null && authorization!.url != null;

  Map<String, dynamic> toJson() => _$ReferenceToJson(this);

  factory Reference.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (!documentSnapshot.exists) throw DocumentDoesNotExistException();
    final json = documentSnapshot.data()!;
    Reference reference = Reference.fromJson({
      "id": documentSnapshot.id,
      ...json,
    });
    return reference;
  }

  ReferencePicture? get mainPicture => pictures.isNotEmpty
      ? pictures.first
      : (satellite != null
          ? ReferencePicture(url: satellite!.url, legend: {}, alt: {})
          : null);

  LanguageCode get language =>
      LanguageCode.values.byName(locale.name.split('_').first);

  String get translatedProjectName => getTranslatedProjectName(language);

  String getTranslatedProjectName(LanguageCode? language) {
    if (language == null) {
      return projectName[LanguageCode.en] ?? projectName.values.first;
    } else {
      return projectName[language] ??
          projectName[LanguageCode.en] ??
          projectName.values.first;
    }
  }

  String? get translatedDescription => getTranslatedDescription(language);

  String? getTranslatedDescription(LanguageCode? language) {
    if (description == null || description!.isEmpty) return null;
    if (language == null) {
      return description![LanguageCode.en] ?? description!.values.first;
    } else {
      return description![language] ??
          description![LanguageCode.en] ??
          description!.values.first;
    }
  }

  DateTime get date => DateTime(year, month, 15, 12, 0, 0);
}

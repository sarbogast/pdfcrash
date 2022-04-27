// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reference _$ReferenceFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['dateCreated', 'location'],
  );
  return Reference(
    id: json['id'] as String,
    dateCreated:
        nullableDateTimeFromTimestamp(json['dateCreated'] as Timestamp?),
    projectName: (json['projectName'] as Map<String, dynamic>).map(
      (k, e) => MapEntry($enumDecode(_$LanguageCodeEnumMap, k), e as String),
    ),
    customerName: json['customerName'] as String,
    companyName: json['companyName'] as String?,
    location: geoLocationFromGeoPoint(json['location'] as GeoPoint),
    surface: json['surface'] as int,
    buildingType:
        $enumDecodeNullable(_$BuildingTypeEnumMap, json['buildingType']),
    newBuilding: json['newBuilding'] as bool,
    year: json['year'] as int,
    month: json['month'] as int,
    address: json['address'] as String,
    countryCode: json['countryCode'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    projectDate: json['projectDate'] as String,
    satellite: json['satellite'] == null
        ? null
        : ReferenceSatellite.fromJson(
            json['satellite'] as Map<String, dynamic>),
    pictures: (json['pictures'] as List<dynamic>?)
            ?.map((e) => ReferencePicture.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    locale: $enumDecode(_$UserLocaleEnumMap, json['locale']),
    tags: (json['tags'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(
              k, (e as List<dynamic>).map((e) => e as String).toList()),
        ) ??
        {},
    owner: ReferenceOwner.fromJson(json['owner'] as Map<String, dynamic>),
    description: (json['description'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry($enumDecode(_$LanguageCodeEnumMap, k), e as String),
    ),
    prescriber: json['prescriber'] as String?,
    authorization: json['authorization'] == null
        ? null
        : ReferenceAuthorization.fromJson(
            json['authorization'] as Map<String, dynamic>),
    share: $enumDecodeNullable(_$ShareDestinationEnumMap, json['share']),
    solutionTypes: (json['solutionTypes'] as List<dynamic>?)
            ?.map((e) => $enumDecode(_$SolutionTypeEnumMap, e))
            .toList() ??
        [],
    shareGroups: (json['shareGroups'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    channels: (json['channels'] as List<dynamic>?)
            ?.map((e) => $enumDecode(_$ShareChannelEnumMap, e))
            .toList() ??
        [],
    products: (json['products'] as List<dynamic>?)
            ?.map((e) => $enumDecode(_$ProductEnumMap, e))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$ReferenceToJson(Reference instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': nullableDateTimeToTimestamp(instance.dateCreated),
      'projectName': instance.projectName
          .map((k, e) => MapEntry(_$LanguageCodeEnumMap[k], e)),
      'customerName': instance.customerName,
      'companyName': instance.companyName,
      'location': geoLocationToGeoPoint(instance.location),
      'surface': instance.surface,
      'buildingType': _$BuildingTypeEnumMap[instance.buildingType],
      'newBuilding': instance.newBuilding,
      'year': instance.year,
      'month': instance.month,
      'address': instance.address,
      'countryCode': instance.countryCode,
      'city': instance.city,
      'country': instance.country,
      'projectDate': instance.projectDate,
      'satellite': instance.satellite?.toJson(),
      'pictures': instance.pictures.map((e) => e.toJson()).toList(),
      'locale': _$UserLocaleEnumMap[instance.locale],
      'tags': instance.tags,
      'owner': instance.owner.toJson(),
      'description': instance.description
          ?.map((k, e) => MapEntry(_$LanguageCodeEnumMap[k], e)),
      'prescriber': instance.prescriber,
      'authorization': instance.authorization?.toJson(),
      'share': _$ShareDestinationEnumMap[instance.share],
      'solutionTypes':
          instance.solutionTypes.map((e) => _$SolutionTypeEnumMap[e]).toList(),
      'shareGroups': instance.shareGroups,
      'channels':
          instance.channels.map((e) => _$ShareChannelEnumMap[e]).toList(),
      'products': instance.products.map((e) => _$ProductEnumMap[e]).toList(),
    };

const _$LanguageCodeEnumMap = {
  LanguageCode.fr: 'fr',
  LanguageCode.en: 'en',
  LanguageCode.it: 'it',
  LanguageCode.de: 'de',
  LanguageCode.nl: 'nl',
  LanguageCode.da: 'da',
  LanguageCode.sv: 'sv',
  LanguageCode.no: 'no',
};

const _$BuildingTypeEnumMap = {
  BuildingType.Agricultural: 'Agricultural',
  BuildingType.Commercial: 'Commercial',
  BuildingType.Residential: 'Residential',
  BuildingType.Medical: 'Medical',
  BuildingType.Educational: 'Educational',
  BuildingType.Government: 'Government',
  BuildingType.Industrial: 'Industrial',
  BuildingType.Military: 'Military',
  BuildingType.Parking: 'Parking',
  BuildingType.Religious: 'Religious',
  BuildingType.Transport: 'Transport',
  BuildingType.PowerProvider: 'PowerProvider',
  BuildingType.WarehouseAndLogistics: 'WarehouseAndLogistics',
  BuildingType.Office: 'Office',
  BuildingType.Other: 'Other',
};

const _$UserLocaleEnumMap = {
  UserLocale.fr_FR: 'fr_FR',
  UserLocale.fr_BE: 'fr_BE',
  UserLocale.it_IT: 'it_IT',
  UserLocale.da_DK: 'da_DK',
  UserLocale.sv_SE: 'sv_SE',
  UserLocale.no_NO: 'no_NO',
  UserLocale.nl_NL: 'nl_NL',
  UserLocale.fr_CH: 'fr_CH',
  UserLocale.de_DE: 'de_DE',
  UserLocale.en_GB: 'en_GB',
  UserLocale.nl_BE: 'nl_BE',
  UserLocale.en_ZA: 'en_ZA',
};

const _$ShareDestinationEnumMap = {
  ShareDestination.all: 'all',
  ShareDestination.none: 'none',
};

const _$SolutionTypeEnumMap = {
  SolutionType.ClassicFlatRoofs: 'ClassicFlatRoofs',
  SolutionType.ReflectiveRoofs: 'ReflectiveRoofs',
  SolutionType.WaterCollection: 'WaterCollection',
  SolutionType.GreenRoofs: 'GreenRoofs',
  SolutionType.RoofTerracesAndBalconies: 'RoofTerracesAndBalconies',
  SolutionType.AestheticalRoofs: 'AestheticalRoofs',
  SolutionType.Co2AbsorbantRoofs: 'Co2AbsorbantRoofs',
  SolutionType.ParkingRoofs: 'ParkingRoofs',
  SolutionType.BridgesAndWorksOfArt: 'BridgesAndWorksOfArt',
  SolutionType.LiquidProducts: 'LiquidProducts',
  SolutionType.SyntheticRoofs: 'SyntheticRoofs',
};

const _$ShareChannelEnumMap = {
  ShareChannel.international: 'international',
  ShareChannel.sweden: 'sweden',
  ShareChannel.norway: 'norway',
  ShareChannel.netherlands: 'netherlands',
  ShareChannel.belgium: 'belgium',
  ShareChannel.france: 'france',
  ShareChannel.italy: 'italy',
  ShareChannel.dsbelgium: 'dsbelgium',
};

const _$ProductEnumMap = {
  Product.derbibriteNt: 'derbibriteNt',
  Product.derbicolorFr: 'derbicolorFr',
  Product.derbicolorFrOlivine: 'derbicolorFrOlivine',
  Product.derbicolorWsl: 'derbicolorWsl',
  Product.derbicolorWslOlivine: 'derbicolorWslOlivine',
  Product.derbicolorPatch: 'derbicolorPatch',
  Product.derbigumAquatop: 'derbigumAquatop',
  Product.derbigumGcFr: 'derbigumGcFr',
  Product.derbigumGcAr: 'derbigumGcAr',
  Product.derbigumNt: 'derbigumNt',
  Product.derbigumSpAr: 'derbigumSpAr',
  Product.derbigumSpFr: 'derbigumSpFr',
  Product.derbipure: 'derbipure',
  Product.derbitwinNt: 'derbitwinNt',
  Product.residek5000: 'residek5000',
  Product.residek5000P: 'residek5000P',
  Product.residekTopSlsFr: 'residekTopSlsFr',
  Product.unigumMineral: 'unigumMineral',
  Product.unigumMineralFr: 'unigumMineralFr',
  Product.unigumUg: 'unigumUg',
  Product.vaeplanV12: 'vaeplanV12',
  Product.vaeplanV15: 'vaeplanV15',
  Product.vaeplanVFr12: 'vaeplanVFr12',
  Product.vaeplanVFr15: 'vaeplanVFr15',
  Product.vaeplanVFr16: 'vaeplanVFr16',
  Product.vaeplanVs: 'vaeplanVs',
  Product.vaeplanVs12: 'vaeplanVs12',
  Product.vaeplanVs15: 'vaeplanVs15',
};

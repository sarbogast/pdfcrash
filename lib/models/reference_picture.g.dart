// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferencePicture _$ReferencePictureFromJson(Map<String, dynamic> json) =>
    ReferencePicture(
      url: json['url'] as String,
      alt: (json['alt'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$LanguageCodeEnumMap, k), e as String),
      ),
      legend: (json['legend'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$LanguageCodeEnumMap, k), e as String),
      ),
      storagePath: json['storagePath'] as String?,
      webUrl: json['webUrl'] as String?,
      webStoragePath: json['webStoragePath'] as String?,
      excluded: json['excluded'] as bool? ?? false,
    );

Map<String, dynamic> _$ReferencePictureToJson(ReferencePicture instance) =>
    <String, dynamic>{
      'url': instance.url,
      'storagePath': instance.storagePath,
      'webUrl': instance.webUrl,
      'webStoragePath': instance.webStoragePath,
      'alt': instance.alt?.map((k, e) => MapEntry(_$LanguageCodeEnumMap[k], e)),
      'legend':
          instance.legend?.map((k, e) => MapEntry(_$LanguageCodeEnumMap[k], e)),
      'excluded': instance.excluded,
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

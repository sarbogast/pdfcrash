// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceAuthorization _$ReferenceAuthorizationFromJson(
        Map<String, dynamic> json) =>
    ReferenceAuthorization(
      url: json['url'] as String?,
      filename: json['filename'] as String?,
      storagePath: json['storagePath'] as String?,
    );

Map<String, dynamic> _$ReferenceAuthorizationToJson(
        ReferenceAuthorization instance) =>
    <String, dynamic>{
      'url': instance.url,
      'filename': instance.filename,
      'storagePath': instance.storagePath,
    };

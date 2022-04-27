// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

enum BuildingType {
  Agricultural,
  Commercial,
  Residential,
  Medical,
  Educational,
  Government,
  Industrial,
  Military,
  Parking,
  Religious,
  Transport,
  PowerProvider,
  WarehouseAndLogistics,
  Office,
  Other
}

extension BuildingTypeHelper on BuildingType {
  String i18n(BuildContext context) {
    switch (this) {
      case BuildingType.Agricultural:
        return 'Agricultural';
      case BuildingType.Commercial:
        return 'Commercial';
      case BuildingType.Residential:
        return 'Residential';
      case BuildingType.Medical:
        return 'Medical';
      case BuildingType.Educational:
        return 'Educational';
      case BuildingType.Government:
        return 'Government';
      case BuildingType.Industrial:
        return 'Industrial';
      case BuildingType.Military:
        return 'Military';
      case BuildingType.Parking:
        return 'Parking';
      case BuildingType.Religious:
        return 'Religious';
      case BuildingType.Transport:
        return 'Transport';
      case BuildingType.PowerProvider:
        return 'Power provider';
      case BuildingType.WarehouseAndLogistics:
        return 'Warehouse and logistics';
      case BuildingType.Office:
        return 'Office';
      case BuildingType.Other:
        return 'Other';
      default:
        return '';
    }
  }
}

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum SolutionType {
  ClassicFlatRoofs,
  ReflectiveRoofs,
  WaterCollection,
  GreenRoofs,
  RoofTerracesAndBalconies,
  AestheticalRoofs,
  Co2AbsorbantRoofs,
  ParkingRoofs,
  BridgesAndWorksOfArt,
  LiquidProducts,
  SyntheticRoofs,
}

extension SolutionTypeHelper on SolutionType {
  String i18n(BuildContext context) {
    switch (this) {
      case SolutionType.ClassicFlatRoofs:
        return 'Classic flat roofs';
      case SolutionType.ReflectiveRoofs:
        return 'Reflective roofs';
      case SolutionType.WaterCollection:
        return 'Water collection';
      case SolutionType.GreenRoofs:
        return 'Green roofs';
      case SolutionType.RoofTerracesAndBalconies:
        return 'Terraces and balconies';
      case SolutionType.AestheticalRoofs:
        return 'Aesthetical roofs';
      case SolutionType.Co2AbsorbantRoofs:
        return 'C02 absorbant roofs';
      case SolutionType.ParkingRoofs:
        return 'Parking roofs';
      case SolutionType.BridgesAndWorksOfArt:
        return 'Bridges and works of art';
      case SolutionType.LiquidProducts:
        return 'Liquid products';
      case SolutionType.SyntheticRoofs:
        return 'Synthetic roofs';
      default:
        return '';
    }
  }
}

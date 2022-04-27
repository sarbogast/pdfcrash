import 'package:flutter/material.dart';

enum Product {
  derbibriteNt,
  derbicolorFr,
  derbicolorFrOlivine,
  derbicolorWsl,
  derbicolorWslOlivine,
  derbicolorPatch,
  derbigumAquatop,
  derbigumGcFr,
  derbigumGcAr,
  derbigumNt,
  derbigumSpAr,
  derbigumSpFr,
  derbipure,
  derbitwinNt,
  residek5000,
  residek5000P,
  residekTopSlsFr,
  unigumMineral,
  unigumMineralFr,
  unigumUg,
  vaeplanV12,
  vaeplanV15,
  vaeplanVFr12,
  vaeplanVFr15,
  vaeplanVFr16,
  vaeplanVs,
  vaeplanVs12,
  vaeplanVs15,
}

extension ProductHelper on Product {
  String i18n(BuildContext context) {
    switch (this) {
      case Product.derbibriteNt:
        return "DERBIBRITE NT";
      case Product.derbicolorFr:
        return "DERBICOLOR FR";
      case Product.derbicolorFrOlivine:
        return "DERBICOLOR FR Olivine";
      case Product.derbicolorWsl:
        return "DERBICOLOR WSL";
      case Product.derbicolorWslOlivine:
        return "DERBICOLOR WSL Olivine";
      case Product.derbicolorPatch:
        return "DERBICOLOR Patch";
      case Product.derbigumAquatop:
        return "DERBIGUM AQUATOP";
      case Product.derbigumGcFr:
        return "DERBIGUM GC FR";
      case Product.derbigumGcAr:
        return "DERBIGUM GC AR";
      case Product.derbigumNt:
        return "DERBIGUM NT";
      case Product.derbigumSpAr:
        return "DERBIGUM SP AR";
      case Product.derbigumSpFr:
        return "DERBIGUM SP FR";
      case Product.derbipure:
        return "DERBIPURE";
      case Product.derbitwinNt:
        return "DERBITWIN NT";
      case Product.residek5000:
        return "RESIDEK 5000";
      case Product.residek5000P:
        return "RESIDEK 5000P";
      case Product.residekTopSlsFr:
        return "RESIDEK TOP SLS FR";
      case Product.unigumMineral:
        return "UNIGUM MINERAL";
      case Product.unigumMineralFr:
        return "UNIGUM MINERAL FR";
      case Product.unigumUg:
        return "UNIGUM UG";
      case Product.vaeplanV12:
        return "VAEPLAN V 1.2";
      case Product.vaeplanV15:
        return "VAEPLAN V 1.5";
      case Product.vaeplanVFr12:
        return "VAEPLAN V FR 1.2";
      case Product.vaeplanVFr15:
        return "VAEPLAN V FR 1.5";
      case Product.vaeplanVFr16:
        return "VAEPLAN V FR 1.6";
      case Product.vaeplanVs:
        return "VAEPLAN VS";
      case Product.vaeplanVs12:
        return "VAEPLAN VS 1.2";
      case Product.vaeplanVs15:
        return "VAEPLAN VS 1.5";
      default:
        return "";
    }
  }
}

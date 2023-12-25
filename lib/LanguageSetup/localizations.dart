import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/LanguageSetup/constant.dart'
    show languages;

class MyLocalizations {
  final Map<String, Map<String, String>> localizedValues;
  MyLocalizations(this.locale, this.localizedValues);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  String word(String key, String value) {
    return localizedValues[locale.languageCode][key] != null
        ? localizedValues[locale.languageCode][key]
        : value;
  }

  // String get district {
  //   return localizedValues[locale.languageCode]['district'];
  // }

  // String get village {
  //   return localizedValues[locale.languageCode]['village'];
  // }

  // String get tehsil {
  //   return localizedValues[locale.languageCode]['tehsil'];
  // }

  // String get landKhasraNo {
  //   return localizedValues[locale.languageCode]['landKhasraNo'];
  // }

  // String get cropType {
  //   return localizedValues[locale.languageCode]['cropType'];
  // }

  // String get crop {
  //   return localizedValues[locale.languageCode]['crop'];
  // }

  // String get fieldSize {
  //   return localizedValues[locale.languageCode]['fieldSize'];
  // }

  // String get acre {
  //   return localizedValues[locale.languageCode]['acre'];
  // }

  // String get hectare {
  //   return localizedValues[locale.languageCode]['hectare'];
  // }

  // String get fieldArea {
  //   return localizedValues[locale.languageCode]['fieldArea'];
  // }

  // String get soilType {
  //   return localizedValues[locale.languageCode]['soilType'];
  // }

  // String get landType {
  //   return localizedValues[locale.languageCode]['landType'];
  // }

  // String get farmingName {
  //   return localizedValues[locale.languageCode]['farmingName'];
  // }

  // String get soilReport {
  //   return localizedValues[locale.languageCode]['soilReport'];
  // }

  // String get yes {
  //   return localizedValues[locale.languageCode]['yes'];
  // }

  // String get no {
  //   return localizedValues[locale.languageCode]['no'];
  // }

  // String get bioFertilizers {
  //   return localizedValues[locale.languageCode]['bioFertilizers'];
  // }

  // String get nitrogenous {
  //   return localizedValues[locale.languageCode]['nitrogenous'];
  // }

  // String get complex {
  //   return localizedValues[locale.languageCode]['complex'];
  // }

  // String get phosphatic {
  //   return localizedValues[locale.languageCode]['phosphatic'];
  // }

  // String get potassic {
  //   return localizedValues[locale.languageCode]['potassic'];
  // }

  // String get organicManure {
  //   return localizedValues[locale.languageCode]['organicManure'];
  // }

  // String get patanjaliManure {
  //   return localizedValues[locale.languageCode]['patanjaliManure'];
  // }

  // String get compost {
  //   return localizedValues[locale.languageCode]['compost'];
  // }

  // String get oilCake {
  //   return localizedValues[locale.languageCode]['oilCake'];
  // }

  // String get testReportOfPbriKit {
  //   return localizedValues[locale.languageCode]['testReportByDhartiKaDoctor'];
  // }

  // String get testReportByExternalLaboratory {
  //   return localizedValues[locale.languageCode]
  //       ['testReportByExternalLaboratory'];
  // }

  // String get nColorChart {
  //   return localizedValues[locale.languageCode]['nColorChart'];
  // }

  // String get pColorChart {
  //   return localizedValues[locale.languageCode]['pColorChart'];
  // }

  // String get kColorChart {
  //   return localizedValues[locale.languageCode]['kColorChart'];
  // }

  // String get organicCarbon {
  //   return localizedValues[locale.languageCode]['organicCarbon'];
  // }

  // String get pH {
  //   return localizedValues[locale.languageCode]['pH'];
  // }

  // String get chooseColor {
  //   return localizedValues[locale.languageCode]['chooseColor'];
  // }

  // String get custom {
  //   return localizedValues[locale.languageCode]['custom'];
  // }

  // String get next {
  //   return localizedValues[locale.languageCode]['next'];
  // }

  // String get lastCropType {
  //   return localizedValues[locale.languageCode]['lastCropType'];
  // }

  // String get lastCrop {
  //   return localizedValues[locale.languageCode]['lastCrop'];
  // }

  // String get lastYield {
  //   return localizedValues[locale.languageCode]['lastYield'];
  // }

  // greetTo(name) {
  //   return localizedValues[locale.languageCode]['greetTo']
  //       .replaceAll('{{name}}', name);
  // }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  Map<String, Map<String, String>> localizedValues;

  MyLocalizationsDelegate(this.localizedValues);

  @override
  bool isSupported(Locale locale) => languages.contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(
        MyLocalizations(locale, localizedValues));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}

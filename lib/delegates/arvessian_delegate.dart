import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArvessianDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'av';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

class ArvessianCupertinoDelegate 
    extends LocalizationsDelegate<CupertinoLocalizations> {
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'av';

  @override
  Future<CupertinoLocalizations> load(Locale locale) => 
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

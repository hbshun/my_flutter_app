import 'dart:ui';

import 'package:flutter/material.dart';
import './locales/base.dart';
import './locales/en.dart';
import './locales/zh.dart';

///自定义多语言实现
class HGLocalizations {
  final Locale locale;

  HGLocalizations(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  ///HGStringEn和HGStringZh都继承了HGStringBase
  static Map<String, HGStringBase> _localizedValues = {
    'en': new HGStringEn(),
    'zh': new HGStringZh(),
  };

  HGStringBase get currentLocalized {
    if(_localizedValues.containsKey(locale.languageCode)) {
      return _localizedValues[locale.languageCode];
    }
    return _localizedValues["en"];
  }

  ///通过 Localizations 加载当前的 HGLocalizations
  ///获取对应的 HGStringBase
  static HGLocalizations of(BuildContext context) {
    return Localizations.of(context, HGLocalizations);
  }
}

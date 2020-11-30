import 'package:flutter/material.dart';

Locale localeFromString(String str) {
  final locale = str.split('_');
  switch (locale.length) {
    case 2:
      return Locale(locale.first, locale.last);
    case 3:
      return Locale.fromSubtags(languageCode: locale.first, scriptCode: locale[1], countryCode: locale.last);
    default:
      return Locale(locale.first);
  }
}

String localeToString(Locale locale, {String separator = '_'}) {
  return locale.toString().split('_').join(separator);
}

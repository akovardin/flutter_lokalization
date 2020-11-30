import 'dart:io';

import 'package:flutter/material.dart';

import 'loader.dart';
import 'locale.dart';

extension Translate on String {
  static final loader = Loader();

  static Future<void> load({
    String url,
    String dir,
    List<Locale> supported,
    Locale def,
    bool code = true,
  }) async {
    if (def == null) {
      def = Locale('en');
    }

    if (supported == null) {
      supported = [];
    }

    final locale = localeFromString(Platform.localeName);

    var current = def;

    if (code) {
      supported.forEach((element) {
        if (element.languageCode == locale.languageCode) {
          current = locale;
        }
      });
    } else {
      if (supported.contains(locale)) {
        current = locale;
      }
    }

    Translate.loader.load(
      url: url,
      locale: current,
      dir: dir,
    );
  }

  String tr() {
    return loader.get(this);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Translate {
  String key;
  String translation;

  Translate({this.key, this.translation});

  factory Translate.fromJson(json) {
    return Translate(key: json['key'], translation: json['translation']);
  }
}

class LanguageResponse {
  List<Translate> translations;
  int updated;

  LanguageResponse({this.translations, this.updated});

  factory LanguageResponse.fromJson(dynamic json) {
    return LanguageResponse(
      translations: (json['translations'] ?? []).map((e) => Translate.fromJson(e)).toList().cast<Translate>(),
      updated: json['updated'],
    );
  }
}

class Loader {
  var translate = Map<String, String>();

  load({
    String url,
    Locale locale,
    String dir = 'assets/localizations/',
  }) async {
    log('easy localization loader: load url ${url}?lang=${locale.languageCode}');

    try {
      final http.Response response = await http.get('${url}?lang=${locale.languageCode}');
      if (response.statusCode == 200) {
        translate = parse(json.decode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      log('error on load localization from url: ${e.toString()}');

      var f = '$dir/${locale.languageCode}.json';
      log('easy localization loader: load file $f');
      translate = parse(json.decode(await rootBundle.loadString(f)));
    }
  }

  Map<String, String> parse(dynamic body) {
    var data = LanguageResponse.fromJson(body);
    log(data.toString());

    return Map<String, String>.fromIterable(data.translations,
        key: (item) => item.key, value: (item) => item.translation);
  }

  String get(String key) {
    return translate[key];
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';

class JsonService {
  static final JsonService _instance = JsonService._internal();
  factory JsonService() => _instance;
  JsonService._internal();

  Map<String, dynamic>? _data;

  Future<void> loadJson() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    _data = json.decode(jsonString);
  }

  String get(String key) {
    return _data?[key] ?? 'Key not found';
  }
}

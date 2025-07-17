import 'package:get_storage/get_storage.dart';

class TLocalStorage {
  static final TLocalStorage _instances = TLocalStorage._internal();

  factory TLocalStorage() {
    return _instances;
  }

  TLocalStorage._internal();

  final _storage = GetStorage();


  Future<void> saveDate<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  T? readData<T>(String key) {
    return _storage.read(key);
  }

  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }
}
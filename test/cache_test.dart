import 'package:bloc_firebase_login/core/utils/cache_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheClient', () {
    test('Se puede escribir y leer valores para una key dada.', () {
      final cache = CacheUtil();
      const key = '__key__';
      const value = '__value__';
      expect(cache.read(key: key), isNull);
      cache.write(key: key, value: value);
      expect(cache.read(key: key), equals(value));
    });
  });
}

import 'package:car_register_app/core/services/local/shared_pref_local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPref sharedPref;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPref = SharedPref();
    await sharedPref.instantiatePreferences();
  });

  group('SharedPref', () {
    test('is a singleton', () {
      final instance1 = SharedPref();
      final instance2 = SharedPref();
      expect(identical(instance1, instance2), isTrue);
    });

    test('instantiatePreferences initializes the preferences', () {
      final prefs = sharedPref.getString('any_key');
      expect(prefs, isNull);
    });

    group('String operations', () {
      test('setString and getString store and retrieve values', () async {
        await sharedPref.setString('key1', 'hello');
        final value = sharedPref.getString('key1');
        expect(value, equals('hello'));
      });

      test('getString returns null for missing key', () {
        final value = sharedPref.getString('nonexistent');
        expect(value, isNull);
      });

      test('setString overwrites existing value', () async {
        await sharedPref.setString('key1', 'first');
        await sharedPref.setString('key1', 'second');
        final value = sharedPref.getString('key1');
        expect(value, equals('second'));
      });
    });
  });
}

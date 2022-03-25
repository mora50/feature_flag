import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';

class CustomFirebaseRemoteConfig {
  late FirebaseRemoteConfig _firebaseRemoteConfig;

  CustomFirebaseRemoteConfig._internal();

  static final CustomFirebaseRemoteConfig _singleton =
      CustomFirebaseRemoteConfig._internal();

  factory CustomFirebaseRemoteConfig() => _singleton;

  Future<void> initialize() async {
    _firebaseRemoteConfig = FirebaseRemoteConfig.instance;

    await _firebaseRemoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
  }

  Future<void> forceFetch() async {
    try {
      await _firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: Duration.zero),
      );
      await _firebaseRemoteConfig.fetchAndActivate();
    } on PlatformException catch (e) {
      throw (e.toString());
    } catch (e) {
      throw ('Erro ao se conectar no firebase remote config');
    }
  }

  getValueOrDefault({required String key, required dynamic defaultValue}) {
    switch (defaultValue.runtimeType) {
      case bool:
        var _value = _firebaseRemoteConfig.getBool(key);
        return _value != false ? _value : defaultValue;
      default:
        return Exception('Implementation not found');
    }
  }
}

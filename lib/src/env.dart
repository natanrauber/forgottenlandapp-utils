import 'dart:io';

import 'package:dotenv/dotenv.dart' as dart_dotenv;
import 'package:flutter_dotenv/flutter_dotenv.dart' as flutter_dotenv;

enum EnvVar {
  databaseKey,
  databaseUrl,
  pathEtl,
  pathForgottenLandApi,
  pathTibiaArchive,
  pathTibiaArchiveApi,
  pathTibiaDataApi,
  pathTibiaDataApiSelfHosted,
}

class Env {
  final Map<String, String?> _map = <String, String?>{};

  String? operator [](EnvVar key) => _map[key.name];

  Future<void> load({
    // web only
    String? fileName,
    List<EnvVar>? required,
  }) async {
    try {
      if (_isWeb()) {
        final flutter_dotenv.DotEnv env = flutter_dotenv.DotEnv();
        await env.load(fileName: fileName ?? "assets/.env");
        _map.addAll(env.env);
      } else {
        _map.addAll(Platform.environment);
        final dart_dotenv.DotEnv env = dart_dotenv.DotEnv();
        env.load();
        // ignore: invalid_use_of_visible_for_testing_member
        _map.addAll(env.map);
      }
    } catch (_) {}

    if (required != null && required.isNotEmpty) {
      for (EnvVar v in required) {
        if (_map[v.name] == null || _map[v.name] == '') throw 'Missing required environment variable: $v';
      }
    }
  }

  bool _isWeb() {
    try {
      // dart:io Platform is not supported on web → will throw
      Platform.environment;
      return false;
    } catch (_) {
      return true;
    }
  }

  Map<String, String?> get map => _map;

  void log() {
    print('Environment variables:');
    String setEvs = '\tSet:';
    String notSetEvs = '\tNot set:';

    for (final String key in _map.keys) {
      if (_map[key] != null && _map[key] != '') {
        setEvs = '$setEvs $key;';
      } else {
        notSetEvs = '$notSetEvs $key;';
      }
    }

    print(setEvs);
    print(notSetEvs);
  }
}

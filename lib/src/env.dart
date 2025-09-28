import 'dart:io';

import 'package:dotenv/dotenv.dart' as dart_dotenv;
import 'package:flutter_dotenv/flutter_dotenv.dart' as flutter_dotenv;

import 'extensions/extensions.dart';

const Map<String, String?> _variables = <String, String?>{
  'DATABASE_KEY': String.fromEnvironment('DATABASE_KEY'),
  'DATABASE_URL': String.fromEnvironment('DATABASE_URL'),
  'PATH_ETL': String.fromEnvironment('PATH_ETL'),
  'PATH_FORGOTTENLAND_API': String.fromEnvironment('PATH_FORGOTTENLAND_API'),
  'PATH_TIBIAARCHIVE_API': String.fromEnvironment('PATH_TIBIAARCHIVE_API'),
  'PATH_TIBIAARCHIVE': String.fromEnvironment('PATH_TIBIAARCHIVE'),
  'PATH_TIBIADATA_API_SELFHOSTED': String.fromEnvironment('PATH_TIBIADATA_API_SELFHOSTED'),
  'PATH_TIBIADATA_API': String.fromEnvironment('PATH_TIBIADATA_API'),
};

class Env {
  final Map<String, String?> _map = <String, String?>{};
  late final String? databaseKey;
  late final String? databaseUrl;
  late final String? pathEtl;
  late final String? pathForgottenLandApi;
  late final String? pathTibiaArchive;
  late final String? pathTibiaArchiveApi;
  late final String? pathTibiaDataApi;
  late final String? pathTibiaDataApiSelfHosted;

  Future<void> load({
    // web only
    String? fileName,
    List<String>? required,
  }) async {
    _map.addAll(_variables);
    _map.clean();

    try {
      if (_isWeb()) {
        final flutter_dotenv.DotEnv env = flutter_dotenv.DotEnv();
        await env.load(fileName: fileName ?? "assets/.env");
        _map.addAll(env.env);
      } else {
        final dart_dotenv.DotEnv env = dart_dotenv.DotEnv();
        env.load();
        // ignore: invalid_use_of_visible_for_testing_member
        _map.addAll(env.map);
      }
    } catch (_) {}

    if (required != null && required.isNotEmpty) {
      for (String v in required) {
        if (_map[v] == null || _map[v] == '') throw 'Missing required environment variable: $v';
      }
    }

    databaseKey = _map['DATABASE_KEY'];
    databaseUrl = _map['DATABASE_URL'];
    pathEtl = _map['PATH_ETL'];
    pathForgottenLandApi = _map['PATH_FORGOTTENLAND_API'];
    pathTibiaArchive = _map['PATH_TIBIAARCHIVE'];
    pathTibiaArchiveApi = _map['PATH_TIBIAARCHIVE_API'];
    pathTibiaDataApi = _map['PATH_TIBIADATA_API'];
    pathTibiaDataApiSelfHosted = _map['PATH_TIBIADATA_API_SELFHOSTED'];
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

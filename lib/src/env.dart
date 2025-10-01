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

  Env({
    required Map<String, String> env,
    required List<EnvVar> required,
  }) {
    _map.addAll(env);

    if (required.isNotEmpty) {
      for (EnvVar v in required) {
        if (_map[v.name] == null || _map[v.name] == '') throw 'Missing required environment variable: $v';
      }
    }
  }
}

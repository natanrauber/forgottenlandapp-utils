import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../utils.dart';

Map<String, Object> _responseHeader({Map<String, Object>? add}) {
  final Map<String, Object> defaultHeader = <String, Object>{
    "Content-Type": "application/json",
  };
  Map<String, Object> map = <String, Object>{};
  map.addEntries(defaultHeader.entries);
  if (add != null) map.addEntries(add.entries);
  return map;
}

String _responseBody({Map<String, dynamic>? add}) {
  final Map<String, dynamic> defaultBody = <String, dynamic>{
    "server_time": DT.germany.timeStamp(),
    "tibia_time": DT.tibia.timeStamp(),
  };
  Map<String, dynamic> map = <String, dynamic>{};
  map.addEntries(defaultBody.entries);
  if (add != null) map.addEntries(add.entries);
  return jsonEncode(map.clean());
}

class ApiResponse extends Response {
  ApiResponse.success({dynamic data})
      : super(
          200,
          headers: _responseHeader(),
          body: _responseBody(
            add: <String, dynamic>{
              "response": 'Success',
              "data": data,
            },
          ),
        );

  ApiResponse.accepted()
      : super(
          202,
          headers: _responseHeader(),
          body: _responseBody(add: <String, dynamic>{"response": 'Accepted'}),
        );

  // Temporarily changed status code from 204 to 200 due to a bug:
  // upstream connect error or disconnect/reset before headers. reset reason: protocol error
  ApiResponse.noContent()
      : super(
          200,
          headers: _responseHeader(),
          body: _responseBody(add: <String, dynamic>{"response": 'No Content'}),
        );

  ApiResponse.notFound()
      : super(
          404,
          headers: _responseHeader(),
          body: _responseBody(add: <String, dynamic>{"response": 'Not Found'}),
        );

  ApiResponse.notAcceptable()
      : super(
          406,
          headers: _responseHeader(),
          body: _responseBody(add: <String, dynamic>{"response": 'Not Acceptable'}),
        );

  ApiResponse.conflict()
      : super(
          409,
          headers: _responseHeader(),
          body: _responseBody(add: <String, dynamic>{"response": 'Conflict'}),
        );

  ApiResponse.error(dynamic e)
      : super(
          500,
          headers: _responseHeader(),
          body: _responseBody(add: <String, dynamic>{"response": e.toString()}),
        );
}

import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../config.dart';
import '../factory.dart';
import 'api_mock.dart';

part 'weiguan.g.dart';

@JsonSerializable()
@immutable
class ApiResponse {
  static const int codeResponseError = -2;
  static const int codeRequestError = -1;
  static const int codeOk = 0;

  final int code;
  final String message;
  final Map<String, dynamic>? data;

  const ApiResponse(
      {this.code = ApiResponse.codeOk, this.message = '', this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

class Service {
  final _client = Dio();
  final _logger = Factory().getLogger("service");

  Service(PersistCookieJar cookieJar) {
    _client.options.baseUrl = Config.apiBaseUrl;
    _client.interceptors.add(CookieManager(cookieJar));
  }

  Future<ApiResponse> request(
    String method,
    String path, {
    dynamic data,
  }) async {
    _client.options.method = method;
    if (Config.isLogApi) {
      _logger.fine('request: $method $path');
    }

    var response = Response(requestOptions: RequestOptions(path: path));
    if (Config.isMockApi) {
      assert(mockApis[path] != null, 'api $path not mocked');
      response.statusCode = HttpStatus.ok;
      response.data = await mockApis[path]!(method, data);
    } else {
      try {
        response = await _client.request(
          path,
          data: data,
          options: _client.options as Options,
          onSendProgress: (progress, total) {
            // ignore: avoid_print
            print("当前进度是 $progress 总进度是 $total");
          },
        );
      } catch (e) {
        return ApiResponse(
            code: ApiResponse.codeRequestError,
            message: 'DioError: ${e.runtimeType} ${e.toString()}');
      }
    }

    if (Config.isLogApi) {
      _logger.fine('response: ${response.statusCode} ${response.data}');
    }

    if (response.statusCode == HttpStatus.ok) {
      return ApiResponse.fromJson(response.data);
    } else {
      return ApiResponse(
        code: ApiResponse.codeResponseError,
        message: response.statusCode.toString(),
      );
    }
  }

  //get
  Future<ApiResponse> get(String path, {Map<String, dynamic>? data}) async {
    return request('GET', path, data: data);
  }

  // post
  Future<ApiResponse> post(String path, {dynamic data}) async {
    return request('POST', path, data: data);
  }

  // postform
  Future<ApiResponse> postForm(String path, {required FormData data}) async {
    return request('POST', path, data: data);
  }
}

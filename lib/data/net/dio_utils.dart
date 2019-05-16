import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DioUtils {
  static final DioUtils _singleton = DioUtils._init();
  static Dio _dio;

  /// 是否是debug模式.
  static bool _isDebug = true;

  /// 打开debug模式.
  static void openDebug() {
    _isDebug = true;
  }

  DioUtils._init() {
    BaseOptions options = new BaseOptions(
      baseUrl: "http://api.zhuishushenqi.com",
      connectTimeout: 1000 * 10,
      receiveTimeout: 1000 * 20,
    );
    _dio = Dio(options);
  }

  factory DioUtils() {
    return _singleton;
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// String 返回 json data .
  Future<Map> request<T>(
    String path, {
    String method = Method.get,
    queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    Response response = await _dio.request(
      path,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    _printHttpLog(response);
    if (response.statusCode == 200) {
      try {
        if (response.data is Map) {
          if (response.data["ok"] != null &&
              !response.data["ok"] &&
              response.data["msg"] != null &&
              response.data["code"] != null) {
            Fluttertoast.showToast(msg: response.data["msg"], fontSize: 14.0);
            return new Future.error(new DioError(
              response: response,
              message: response.data["msg"],
              type: DioErrorType.RESPONSE,
            ));
          }
          // 由于小说接口返回的格式不固定不规范，所以直接返回，这里一般返回BaseResp.
          return response.data;
        } else {
          if (response.data is List) {
            Map<String, dynamic> _dataMap = Map();
            _dataMap["data"] = response.data;
            return _dataMap;
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "网络连接不可用，请稍后重试", fontSize: 14.0);
        return new Future.error(new DioError(
          response: response,
          message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }
    Fluttertoast.showToast(msg: "网络连接不可用，请稍后重试", fontSize: 14.0);
    return new Future.error(new DioError(
      response: response,
      message: "statusCode: ${response.statusCode}, service error",
      type: DioErrorType.RESPONSE,
    ));
  }

  /// check Options.
  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  /// print Http Log.
  void _printHttpLog(Response response) {
    if (!_isDebug) {
      return;
    }
    try {
      print("----------------Http Log Start----------------" +
          "\n[statusCode]:   " +
          response.statusCode.toString() +
          "\n[request   ]:   " +
          _getOptionsStr(response.request));
      _printDataStr("reqdata ", response.request.data);
      _printDataStr("queryParameters ", response.request.queryParameters);
      _printDataStr("response", response.data);
      print("----------------Http Log Stop----------------");
    } catch (ex) {
      print("Http Log" + " error......");
    }
  }

  /// get Options Str.
  String _getOptionsStr(RequestOptions request) {
    return "method: " +
        request.method +
        "  baseUrl: " +
        request.baseUrl +
        "  path: " +
        request.path;
  }

  /// print Data Str.
  void _printDataStr(String tag, Object value) {
    String da = value.toString();
    while (da.isNotEmpty) {
      if (da.length > 512) {
        print("[$tag  ]:   " + da.substring(0, 512));
        da = da.substring(512, da.length);
      } else {
        print("[$tag  ]:   " + da);
        da = "";
      }
    }
  }
}

/// <BaseRespR<T> 返回 status code msg data Response.
class BaseRespR<T> {
  String status;
  int code;
  String msg;
  T data;
  Response response;

  BaseRespR(this.status, this.code, this.msg, this.data, this.response);

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"status\":\"$status\"");
    sb.write(",\"code\":$code");
    sb.write(",\"msg\":\"$msg\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
}

abstract class DioCallback<T> {
  void onSuccess(T t);

  void onError(DioError error);
}

/// 请求方法.
class Method {
  static const String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

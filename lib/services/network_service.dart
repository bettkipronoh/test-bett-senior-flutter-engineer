import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../exceptions/api_exception.dart';

class NetworkService {
  late Dio _dio;

  NetworkService() {
    setUpDio();
  }
  Future setUpDio() async {
    _dio = Dio(BaseOptions(
      sendTimeout: const Duration(seconds: 60), // 60 seconds
      receiveTimeout: const Duration(seconds: 60), //
      receiveDataWhenStatusError: true,
    ));
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          return handler.next(request);
        },
        onError: (err, handler) async {
          handler.next(err);
        },
      ),
    );
  }

  Future<Response> getRequest(String path,
      {Map<String, dynamic>? data, Map<String, dynamic>? headers}) async {
    Response response;

    bool isConnected = await checkIfConnectedToInternet();

    if (isConnected) {
      try {
        if (headers == null) {
          _dio.options.headers['Accept'] = 'application/json';
          _dio.options.headers['Content-Type'] = 'application/json';
        } else {
          _dio.options.headers = headers;
        }
        response = await _dio.get(path, queryParameters: data);
        return _returnResponse(response);
      } on DioException catch (e) {
        if (e.response != null) {
          return _returnResponse(e.response!);
        } else {
          throw FetchDataException(e.message);
        }
      } on Exception catch (e) {
        throw throw FetchDataException(e.toString());
      }
      // ignore: dead_code
    } else {
      throw FetchDataException("Not connected to internet");
    }
  }

  Future<Response> postRequest(String path, var data,
      {Map<String, dynamic>? headers}) async {
    bool isConnected = await checkIfConnectedToInternet();
    if (isConnected) {
      try {
        if (headers == null) {
          _dio.options.headers['Accept'] = 'application/json';
          _dio.options.headers['Content-Type'] = 'application/json';
        } else {
          _dio.options.headers = headers;
        }
        Response response = await _dio.post(
          path,
          data: data,
        );
        return _returnResponse(response);
      } on DioException catch (e) {
        if (e.response != null) {
          return _returnResponse(e.response!);
        } else {
          throw FetchDataException(e.message);
        }
      }
      // ignore: dead_code
    } else {
      throw FetchDataException("Not connected to internet");
    }
  }

  Future<Response> downloadFile(String fileUrl, String savePath) async {
    Dio dio = Dio();
    try {
      Response response = await dio.download(fileUrl, savePath);
      return _returnResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return _returnResponse(e.response!);
      } else {
        throw FetchDataException(e.message);
      }
    }
  }

  //Custom Response to capture all possible scenarios
  dynamic _returnResponse(Response? response) {
    if (response == null) throw BadRequestException("No results!");
    log("STATUS::${response.statusCode} Full Response:${jsonEncode(response.data)}");
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
        return response;
      case 400:
      case 401:
      case 404:
        if (response.data['message'] == null) {
          throw BadRequestException("Not found");
        } else {
          throw BadRequestException(response.data['message']);
        }
      case 412:
      case 415:
        throw BadRequestException(response.data['message']);
      case 422:
        throw BadRequestException(response.data['message']);

      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<bool> checkIfConnectedToInternet() async {
    bool isConnected = true;
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     isConnected = true;
    //   }
    // } on SocketException catch (_) {
    //   isConnected = false;
    // }
    return isConnected;
  }
}

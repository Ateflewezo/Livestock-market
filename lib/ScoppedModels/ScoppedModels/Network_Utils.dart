import "package:dio/dio.dart";

class NetworkUtil {
// next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();
  Dio dio = Dio();
  factory NetworkUtil() => _instance;
  Future<Response> get(String url, {Map headers}) async {
    var response;
    try {
      dio.options.baseUrl = "https://souq-mawashi.com/api/";
      response = await dio.get(url,
          options: Options(
              headers: {"content-type": "application/json; charset=utf-8"}));
    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
        print("RESS" + e.response.toString());
      } else {
        // print("LAAAAAA " + e.stackTrace.toString());
      }
// return handleResponse(e.response);
    }
    return handleResponse(response);
  }

  Future<Response> post(String url,
      {Map headers, FormData body, encoding}) async {
    print("---------============> $body");
    var response;
    dio.options.baseUrl = "https://souq-mawashi.com/api/";

    try {
      print("=========================oooo");
      response = await dio.post(url,
          data: body,
          options: Options(headers: {
            "content-type": "application/json; charset=utf-8",
          }, requestEncoder: encoding));
      print("==================> $response");
    } on DioError catch (e) {
      if (e.response != null) {
        print("Status Code" + e.response.statusCode.toString());
        response = e.response;
        print("RESS" + e.response.toString());
      } else {
        // print("LAAAAAA " + e.stackTrace.toString());
      }
      return handleResponse(e.response);
    }

    return handleResponse(response);
  }

  Future<Response> delete(String url, {Map headers}) {
    return dio
        .delete(
      url,
      options: Options(headers: headers),
    )
        .then((Response response) {
      return handleResponse(response);
    });
  }

  Future<Response> put(String url, {Map headers, body, encoding}) {
    return dio
        .put(url,
            data: body,
            options: Options(headers: headers, requestEncoder: encoding))
        .then((Response response) {
      return handleResponse(response);
    });
  }

  Response handleResponse(Response response) {
    final int statusCode = response.statusCode;
    print("RESPONSE : " + response.toString());
// if (statusCode == 401) {
// throw new Exception("Unauthorized");
// }
// else if (statusCode != 200) {
// throw new Exception("Error while fetching data");
// }

    if (statusCode >= 200 && statusCode < 300) {
      return response;
    } else {
      return response;
    }
  }
}

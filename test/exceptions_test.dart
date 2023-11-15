import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';
import 'package:elisha/src/config/exceptions.dart';

void main() {
  group('Exceptions', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
    });

    test('fromDioError - DioErrorType.cancel', () async {
      dioAdapter.onGet('/test', (server) => server.reply(500, 'Internal server error'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.cancel,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(exceptions.toString(), 'Request to API server was cancelled');
    });

    test('fromDioError - DioErrorType.connectTimeout', () async {
      dioAdapter.onGet('/test', (server) => server.reply(500, 'Internal server error'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.connectTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(exceptions.toString(), 'Connection timeout with API server');
    });

    test('fromDioError - DioErrorType.receiveTimeout', () async {
      dioAdapter.onGet('/test', (server) => server.reply(500, 'Internal server error'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.receiveTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(exceptions.toString(), 'Receive timeout in connection with API server');
    });

    test('fromDioError - DioErrorType.response 404', () async {
      dioAdapter.onGet('/test', (server) => server.reply(404, 'The requested resource was not found'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      expect(exceptions.toString(), 'The requested resource was not found');
    });

    test('fromDioError - DioErrorType.response 500', () async {
      dioAdapter.onGet('/test', (server) => server.reply(500, 'Internal server error'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      expect(exceptions.toString(), 'Internal server error');
    });

    test('fromDioError - DioErrorType.response 429', () async {
      dioAdapter.onGet('/test', (server) => server.reply(429, 'Request limit reached'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 429,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      expect(exceptions.toString(), 'Request limit reached');
    });

    test('fromDioError - DioErrorType.response 400', () async {
      dioAdapter.onGet('/test', (server) => server.reply(400, 'Bad request'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      expect(exceptions.toString(), 'Bad request');
    });

    test('fromDioError - DioErrorType.sendTimeout', () async {
      dioAdapter.onGet('/test', (server) => server.reply(500, 'Internal server error'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.sendTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(exceptions.toString(), 'Send timeout in connection with API server');
    });

    test('fromDioError - DioErrorType.other', () async {
      dioAdapter.onGet('/test', (server) => server.reply(500, 'Internal server error'));

      final exceptions = Exceptions.fromDioError(DioError(
        type: DioErrorType.other,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(exceptions.toString(), 'Error retrieving data');
    });
  });
}

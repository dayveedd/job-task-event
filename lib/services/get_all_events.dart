import 'package:dio/dio.dart';

class EventRepository {
  final Dio dio;

  const EventRepository(this.dio);

  Future<List<dynamic>> getAllEvents() async {
    try {
      final response = await dio.get(
        '/v1/bf8a6694-6c2a-4730-8e88-ddbd464c9080',
      );
      print(response);
      return response.data;
    } on DioException catch (e) {
      print(e.error);
      print(e.response);
      return e.response!.data;
    }
  }
}

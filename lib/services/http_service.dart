import 'package:http/http.dart' as http;
import 'package:mission_chef_app/interfaces/request_service_interface.dart';

class HttpService implements IRequestService {
  final client = http.Client();

  @override
  Future get({required String url}) async {
    return await client.get(Uri.parse(url));
  }
}

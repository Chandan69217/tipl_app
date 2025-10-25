import 'package:http/http.dart';

void printAPIResponse(Response response){
  print('Response code: ${response.statusCode}, Body: ${response.body}');
}
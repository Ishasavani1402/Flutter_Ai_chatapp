import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
 static final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  static final Api_Key = "AIzaSyB3lhbHtTkhtSK-_NJG6Wt7Y8X1oXCYfQE";

  static final  headerdata = {
      "Content-Type": "application/json",
      "X-goog-api-key": Api_Key,
    };

 static Future<String> get_api_data(String message)async{
   final bodydata = {
     "contents": [
       {
         "parts": [
           {"text": message},
         ],
       },
     ],
   };
   try{
     final response = await http.post(Uri.parse(url), headers: headerdata ,
         body: jsonEncode(bodydata));
     print("Api Response :${response.statusCode} : ${response.body}");
     if(response.statusCode == 200){
       final jsondata = jsonDecode(response.body);
       return jsondata['candidates'][0]['content']['parts'][0]['text'];
     }else{
       return "failed to fetch data from api with status code : ${response.statusCode}";
     }
   }catch(e){
     return "failed to fetch data from api : ${e.toString()}";
   }

  }
}
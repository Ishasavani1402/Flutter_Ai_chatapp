import 'dart:convert';
import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  static final Api_Key = "AIzaSyB3lhbHtTkhtSK-_NJG6Wt7Y8X1oXCYfQE";

  static final headerdata = {
    "Content-Type": "application/json",
    "X-goog-api-key": Api_Key,
  };

  static Future<String> get_api_data(ChatMessage message) async {
    List<Map<String, dynamic>> parts = [];

    if (message.text.isNotEmpty) {
      parts.add({"text": message.text});
    } else {
      parts.add({"text": "describe this image"});
    }

    if (message.medias != null && message.medias!.isNotEmpty) {
      final media = message.medias![0];
      if (media.type == MediaType.image) {
        try {
          final file = File(media.url);
          final byte = await file.readAsBytes();
          final base64image = base64Encode(byte);
          String mimtype = 'image/jpeg';
          if (media.fileName.toLowerCase().endsWith('.png')) {
            mimtype = 'image/png';
          } // add more mime types as needed
          parts.add({
            "inline_data": {"mime_type": mimtype, "data": base64image},
          });
        } catch (e) {
          return "failed to read image file : ${e.toString()}";
        }
      }
    }
    final bodydata = {
      "contents": [
        {"parts": parts},
      ],
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headerdata,
        body: jsonEncode(bodydata),
      );
      print("Api Response :${response.statusCode} : ${response.body}");
      if (response.statusCode == 200) {
        final jsondata = jsonDecode(response.body);
        return jsondata['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "failed to fetch data from api with status code : ${response.statusCode}";
      }
    } catch (e) {
      return "failed to fetch data from api : ${e.toString()}";
    }
  }
}

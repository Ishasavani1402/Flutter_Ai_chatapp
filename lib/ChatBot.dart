import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  ChatUser myself = ChatUser(
    // user jo message type kar raha hai...
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );
  ChatUser bot = ChatUser(id: '2', firstName: 'Gemini');

  List<ChatMessage> allmessage = [];
  List<ChatUser> _typing = [];

  final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  static final Api_Key = "AIzaSyB3lhbHtTkhtSK-_NJG6Wt7Y8X1oXCYfQE";

  final headersdata = {
    "Content-Type": "application/json",
    "X-goog-api-key": Api_Key,
  };

  getdata(ChatMessage m) async {
    _typing.add(bot);
    allmessage.insert(0, m);
    setState(() {});
    final bodydata = {
      "contents": [
        {
          "parts": [
            {"text": m.text},
          ],
        },
      ],
    };
     await http
        .post(Uri.parse(url), headers: headersdata, body: jsonEncode(bodydata))
        .then((response) {
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            print(
              "Show Response Data : ${responseData['candidates'][0]['content']['parts'][0]['text']}",
            );

            ChatMessage m1 = ChatMessage(
              text:
                  responseData['candidates'][0]['content']['parts'][0]['text'],
              user: bot,
              createdAt: DateTime.now(),
            );

            allmessage.insert(0, m1);

          }
        })
        .catchError((e) {
          print("Error for getting data from Gemini : ${e.toString()}");
        });

     _typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBot", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: DashChat(
        typingUsers: _typing,
        currentUser: myself,
        onSend: (ChatMessage m) {
          getdata(m);
        },
        messages: allmessage,
        inputOptions: InputOptions(
          alwaysShowSend: true,
          cursorStyle: CursorStyle(color: Colors.black),
        ),
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.black,
          avatarBuilder: (ChatUser user , Function? icon , Function? ontap){
            return Image.asset('assets/gamini.png', height: 40, width: 40);
          },
        ),
      ),
    );
  }
}

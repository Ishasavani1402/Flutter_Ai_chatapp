import 'package:chatapp/ApiService/Api_Service.dart';
import 'package:chatapp/UserAuth/Login.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Added for DateFormat

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  ChatUser myself = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );
  ChatUser bot = ChatUser(id: '2', firstName: 'Gemini');

  List<ChatMessage> allMessages = [];
  List<ChatUser> _typing = [];
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker

  void getData(ChatMessage m) async {
    _typing.add(bot);
    allMessages.insert(0, m);
    setState(() {});
    try {
      final responseData = await ApiService.get_api_data(m);
      ChatMessage m1 = ChatMessage(
        user: bot,
        text: responseData,
        createdAt: DateTime.now(),
      );
      allMessages.insert(0, m1);
    } catch (e) {
      print(e.toString());
    }
    _typing.remove(bot);
    setState(() {});
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Create a ChatMessage with the image
      ChatMessage imageMessage = ChatMessage(
        user: myself,
        createdAt: DateTime.now(),
        medias: [
          ChatMedia(
            url: image.path,
            type: MediaType.image,
            fileName: image.name,
          ),
        ],
      );
      getData(imageMessage);
    }
  }

  // void copytoclipbord(String text) {
  //   Clipboard.setData(ClipboardData(text: text));
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  // }

  Future<void> logout()async{
    await FirebaseAuth.instance.signOut().
    then((val)=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen())));
  }
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold,
              color: Color(0xFF142B1A))),
          content: Text('Are you sure you want to log out?', style: GoogleFonts.poppins(
              color: Color(0xFF142B1A)
          )),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: GoogleFonts.poppins(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Yes', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(onPressed: _showLogoutDialog,   icon:  Icon(FontAwesomeIcons.rightFromBracket,color: Colors.white,),)
        ],
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "ChatBot",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black54,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: DashChat(
          typingUsers: _typing,
          currentUser: myself,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: allMessages,
          inputOptions: InputOptions(
            alwaysShowSend: false,
            cursorStyle: const CursorStyle(color: Colors.blueAccent),
            inputDecoration: InputDecoration(
              hintText: "Type a message...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 2,
                ),
              ),
            ),
            // leading: [
            //   IconButton(
            //     icon: const Icon(Icons.image, color: Colors.blueAccent),
            //     onPressed: _pickImage, // Add image picker button
            //   ),
            // ],
            trailing: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.blueAccent),
                onPressed: _pickImage, // Add image picker button
              ),
            ],
            sendButtonBuilder:
                (Function send) => IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => send(),
                ),
          ),
          messageOptions: MessageOptions(
            currentUserContainerColor: Colors.blueAccent,
            containerColor: Colors.grey.shade200,
            textColor: Colors.black87,
            currentUserTextColor: Colors.white,
            messagePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            borderRadius: 20,
            showTime: true,
            timeTextColor: Colors.grey.shade600,
            // onLongPressMessage: (ChatMessage message) {
            //   copytoclipbord(message.text);
            // },
            messageTextBuilder: (
              ChatMessage message,
              ChatMessage? previousmsg,
              ChatMessage? nextmsg,
            ) {
              return SelectableText(
                message.text,
                style: TextStyle(
                  color:
                      message.user.id == myself.id
                          ? Colors.white
                          : Colors.black87,
                  fontSize: 16,
                ),
                toolbarOptions: const ToolbarOptions(
                  copy: true,
                  selectAll: true,
                  paste: true,
                  cut: true
                ),
                onSelectionChanged: (
                  TextSelection selection,
                  SelectionChangedCause? cause,
                ) {
                  if (cause == SelectionChangedCause.longPress) {
                    // copytoclipbord(message.text);
                  }
                },
              );
            },
            avatarBuilder: (
              ChatUser user,
              Function? onPress,
              Function? onLongPress,
            ) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: const AssetImage("assets/gamini.png"),
                  backgroundColor: Colors.grey.shade300,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                ),
              );
            },
          ),
          messageListOptions: MessageListOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            showDateSeparator: true,
            dateSeparatorFormat: DateFormat(
              'MMM d, yyyy',
            ), // Using intl package
          ),
        ),
      ),
    );
  }
}

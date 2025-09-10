import 'package:chatapp/ApiService/Api_Service.dart';
import 'package:chatapp/UserAuth/Login.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../FirestoreService.dart';
import '../theme_provider.dart';

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
  ChatUser bot = ChatUser(
    id: '2',
    firstName: 'Gemini',
  );

  List<ChatMessage> allMessages = [];
  List<ChatUser> _typing = [];
  final ImagePicker _picker = ImagePicker();

  void getData(ChatMessage m) async {
    _typing.add(bot);
    // allMessages.insert(0, m);
    allMessages.add(m);
    setState(() {});
    try {
      final responseData = await ApiService.get_api_data(m);
      ChatMessage m1 = ChatMessage(
        user: bot,
        text: responseData,
        createdAt: DateTime.now(),
      );
      // allMessages.insert(0, m1);
      allMessages.add(m1);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirestoreService.saveMessage(user.uid, m, m1);
      }
    } catch (e) {
      print(e.toString());
    }
    _typing.remove(bot);
    setState(() {});
  }


  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
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

  Future<void> logout() async {
    try{
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut().then(
            (val) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
      );
    }on FirebaseAuthException catch(e){
      print("Error for logout : ${e.message}");
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: GoogleFonts.poppins(
                  color: Theme.of(context).textButtonTheme.style!.foregroundColor!.resolve({}),
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    final bool islogin = FirebaseAuth.instance.currentUser!=null;// check if user is logged in or not
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkTheme
                  ? FontAwesomeIcons.sun
                  : FontAwesomeIcons.moon,
              color: Colors.white,
            ),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            onPressed: islogin ? _showLogoutDialog : () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: Icon(
              islogin
                  ? FontAwesomeIcons.rightFromBracket
                  : FontAwesomeIcons.rightToBracket,
              color: Colors.white,
            ),
            tooltip: islogin ? 'Logout' : 'Login',
          ),
        ],
        title: Text(
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
      body: StreamBuilder<List<ChatMessage>>(
      stream: user != null ? FirestoreService.getMessages(user.uid) : Stream.value([]),
          builder: (context , snapshot){
            if(snapshot.hasData){
              allMessages = snapshot.data!;
            }
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
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
                  cursorStyle: CursorStyle(color: Theme.of(context).primaryColor),
                  inputDecoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  trailing: [
                    IconButton(
                      icon: Icon(Icons.image, color: Theme.of(context).brightness == Brightness.dark ?
                      Colors.white :
                      Theme.of(context).primaryColor),
                      onPressed: _pickImage,
                    ),
                  ],
                  sendButtonBuilder: (Function send) => IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).brightness == Brightness.dark ?
                    Colors.white :
                    Theme.of(context).primaryColor),
                    onPressed: () => send(),
                  ),
                ),
                messageOptions: MessageOptions(
                  currentUserContainerColor: Theme.of(context).brightness ==
                      Brightness.light ? Colors.blueAccent : Colors.grey.shade700,
                  containerColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  textColor: Theme.of(context).textTheme.bodyMedium!.color!,
                  currentUserTextColor: Colors.white,
                  messagePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  borderRadius: 20,
                  showTime: true,
                  timeTextColor: Colors.grey.shade600,
                  messageTextBuilder: (
                      ChatMessage message,
                      ChatMessage? previousmsg,
                      ChatMessage? nextmsg,
                      ){
                    return SelectableText(
                      message.text,
                      style: TextStyle(
                        color: message.user.id == myself.id
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: 16,
                      ),
                      toolbarOptions: const ToolbarOptions(
                        copy: true,
                        selectAll: true,
                        paste: true,
                        cut: true,
                      ),
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
                        // radius: 20,
                        backgroundImage: AssetImage("assets/gemini.png"),
                        backgroundColor: Colors.grey.shade300,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color:
                            Theme.of(context).brightness == Brightness.dark ?
                            Colors.grey.shade700 :
                            Colors.deepPurple, width: 2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                messageListOptions: MessageListOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  showDateSeparator: true,
                  dateSeparatorFormat: DateFormat('MMM d, yyyy'),
                ),
              ),
            );
          })
    );
  }
}


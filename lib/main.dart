import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:for_firebase/helper/authenticate.dart';
import 'package:for_firebase/helper/helper_fuctions.dart';
import 'package:for_firebase/views/chat_room_screen.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MyApp();
      },
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState(){
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null ?  userIsLoggedIn ? ChatRoom() : Authenticate()
          : Container(
            child: Center(
              child: Authenticate(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:for_firebase/helper/authenticate.dart';
import 'package:for_firebase/helper/constants.dart';
import 'package:for_firebase/helper/helper_fuctions.dart';
import 'package:for_firebase/services/auth.dart';
import 'package:for_firebase/services/database.dart';
import 'package:for_firebase/views/conversation_screen.dart';
import 'package:for_firebase/views/search.dart';
import 'package:for_firebase/widget/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                return ChatRoomsTile(
                  snapshot.data.docs[index].get("chatroomId")
                      .toString().replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                    snapshot.data.docs[index].get("chatroomId")
                );
              }) : Container();
        },
    );
  }

  @override

  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: logo(),
        actions: [
          GestureDetector(
            onTap: (){
             authMethods.signOut();
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()
             ));
            },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.exit_to_app))
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1)}"),
            ),
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),),
          ],
        ),
      ),
    );
  }
}


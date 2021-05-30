import 'package:flutter/material.dart';
import 'package:for_firebase/helper/constants.dart';
import 'package:for_firebase/services/database.dart';
import 'package:for_firebase/widget/widget.dart';

class ConversationScreen extends StatefulWidget {
  String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream chatMessagesStream;

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return MessageTile(snapshot.data.docs[index].get("message"),
              snapshot.data.docs[index].get("sendBy") == Constants.myName);
            }) : Container();
      },
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,String> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch.toString(),
      };
      databaseMethods.addConversationMessages(widget.chatRoomId,messageMap);
      messageController.text = "";
    }
  }

  @override

  void initState(){
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child:
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(color: Colors.white,),
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color(0x0FFFFFFF),
                                  ]),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.send, size: 25, color: Colors.white,)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              Color(0xff007EF4),
              Color(0xff2A75BC)
            ]
              :   [
                Color(0x1AFFFFFF),
                Color(0x1AFFFFFF)
              ],
          ),
        borderRadius: isSendByMe ?
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
            ) :
        BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
        )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17
        ),),
      ),
    );
  }
}


import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.message_outlined,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Chatting App',
            style: TextStyle(
              fontSize: 20,
            ),
          )
        ],
      ),
    ),
  );
}

Container logo() {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.message_outlined,
          size: 30,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'Chatting App',
          style: TextStyle(
            fontSize: 20,
          ),
        )
      ],
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

class ButtonContainer extends StatelessWidget {
  String buttonText;
  Color buttonColor;
  Color textColor;

  ButtonContainer({this.buttonText, this.buttonColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(30)),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
          fontSize: 17,
        ),
      ),
    );
  }
}

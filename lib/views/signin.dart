import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_firebase/helper/helper_fuctions.dart';
import 'package:for_firebase/services/auth.dart';
import 'package:for_firebase/services/database.dart';
import 'package:for_firebase/widget/widget.dart';
import 'chat_room_screen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() async{
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      await authMethods
          .singInWithEmailPassword(
             emailTextEditingController.text, passwordTextEditingController.text)
          .then((val) async {
            if(val != null) {
              HelperFunctions.saveUserEmailSharedPreference(
                  emailTextEditingController.text);

              databaseMethods.getUserByUserEmail(emailTextEditingController.text)
                  .then((val){
                snapshotUserInfo = val;
                HelperFunctions
                    .saveUserNameSharedPreference(snapshotUserInfo.docs[0].get('name'));
              });
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()));
            }else {
              setState(() {
                isLoading = false;
              });
            }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val) ? null : "Enter correct email";
                        },
                      controller: emailTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('email'),
                    ),
                      TextFormField(
                        validator: (val){
                          return val.length > 6 ? null : "Please provide password 6+ character.";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        obscureText: true,
                        decoration: textFieldInputDecoration('password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forget Password?", style: simpleTextStyle(),),
                  ),
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: ButtonContainer(buttonText: "Sign In", buttonColor: Colors.blueAccent, textColor: Colors.white,),
                ),
                SizedBox(height: 16,),
                ButtonContainer(buttonText: "Sign In with Google", buttonColor: Colors.white, textColor: Colors.black87,),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register now",
                          style:
                          TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

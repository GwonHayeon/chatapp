import 'package:flutter/material.dart';
import 'package:for_firebase/helper/helper_fuctions.dart';
import 'package:for_firebase/services/auth.dart';
import 'package:for_firebase/services/database.dart';
import 'package:for_firebase/views/chat_room_screen.dart';
import 'package:for_firebase/widget/widget.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  signMeUp(){

    if(formKey.currentState.validate()){

      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
           // print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
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
                          return val.isEmpty || val.length < 4 ?  "Please Provide UserName" : null;
                        },
                      controller: userNameTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('username'),
                    ),
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
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: (){
                    signMeUp();
                  },
                  child:ButtonContainer(buttonText: "Sign Up", buttonColor: Colors.blueAccent, textColor: Colors.white,)
                ),
                SizedBox(height: 16,),
                ButtonContainer(buttonText: "Sign Up with Google", buttonColor: Colors.white, textColor: Colors.black87,),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Sign now",
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

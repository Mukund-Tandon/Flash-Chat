import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
final _firestore = FirebaseFirestore.instance;
User logged_in_user;
class ChatScreen extends StatefulWidget {
 static String id ='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final text_controller = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String message_text;
  @override
  void initState() {
    super.initState();
    getuser();
  }
  void getuser()
  async{
    try{
      final user = await _auth.currentUser;
      if(user !=Null)
      {
        logged_in_user = user;
        print(logged_in_user.email);
      }
    }
    catch(e)
    {
      print(e);
    }


  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                  //Implement logout functionality
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              message_stream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: text_controller,
                        onChanged: (value) {
                          message_text = value;
                          //Do something with the user input.
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        text_controller.clear();
                        _firestore.collection('message').add({
                          'text': message_text,
                          'sender': logged_in_user.email,
                          'time': FieldValue.serverTimestamp(),
                        });
                        print(message_text);
                        //Implement send functionality.
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class message_stream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:   _firestore.collection('message').orderBy('time', descending: false).snapshots(),
        builder: (context ,snapshot) {
          if(snapshot.hasData)
          {
            final messages = snapshot.data.docs.reversed;
            List<message_bubble> message_wigets_list = [];
            for(var message in messages)
            {
              final messageText = message.get('text');
              final message_sender = message.get('sender');
              final current_user = logged_in_user.email;
              final message_wiget = message_bubble(sender: message_sender,message: messageText,isme: current_user==message_sender,);
              message_wigets_list.add(message_wiget);
            }
            return Container(
              child: Expanded(
                flex: 3,
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
                  children: message_wigets_list,
                ),
              ),
            );
          }
          else
            {
              return Container(
              );
            }
        });
  }
}

class message_bubble extends StatelessWidget {
  message_bubble({this.sender,this.message,this.isme});
  final String sender;
  final String message;
  final bool isme;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isme? CrossAxisAlignment.end :CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(
            color: Colors.black45,
            fontSize: 12.0,
          ),),
          Material(
            elevation: 5.0,
            borderRadius: isme? BorderRadius.only(bottomRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),topLeft: Radius.circular(30.0)):BorderRadius.only(bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0),topRight: Radius.circular(30.0)),
            color: isme==false? Colors.lightBlueAccent : Colors.greenAccent,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(message,
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
          )
        ],
      ),
    );
  }
}

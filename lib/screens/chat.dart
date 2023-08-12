import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatter/components/chatBubble.dart';
import 'package:flutter_chatter/components/myTextField.dart';
import 'package:flutter_chatter/model/message.dart';

class ChatPage extends StatefulWidget {

  final String receiverUserEmail;
  final String receiverUserId;

  const ChatPage({ Key? key, required this.receiverUserEmail, required this.receiverUserId }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  // firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final messageController = TextEditingController();

  void sendMessage() async {
    if(messageController.text.isNotEmpty){
      await firestoreSendMessage( widget.receiverUserId, messageController.text);
      messageController.clear();
    }
  }

  Future<void> firestoreSendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId, 
      senderEmail: currentUserEmail, 
      receiverId: receiverId, 
      message: message, 
      timestamp: timestamp
    );

    // create chatroom
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _fireStore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.toMap());

  }

  Stream<QuerySnapshot> getMessages(String firstUserId, String secondUserId){

    // get chatroom id
    List<String> ids = [firstUserId, secondUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _fireStore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: _messageList()
          ),
          _messageInput(),
        ],
      )
    );
  }

  Widget _messageList(){
    return StreamBuilder(
      stream: getMessages(_firebaseAuth.currentUser!.uid, widget.receiverUserId),
      builder:(context, snapshot) {
        if(snapshot.hasError){
          return Text("Технические неполадки...");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return(Center(
            child: CircularProgressIndicator(),
            )
          );
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((el) => _messageItem(el)).toList(),
          ),
        );
      },
    );
  }

  Widget _messageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Alignment _alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

    return Container(
      alignment: _alignment,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
          children: <Widget>[
            Text(data['senderEmail']),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  Widget _messageInput(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MyTextField(
              textController: messageController, 
              hintText: 'Type message here...', 
              obscureText: false
            )
          ),
          IconButton(
            onPressed: sendMessage, 
            icon: Icon(Icons.keyboard_arrow_right, size: 40,))
        ],
      ),
    );
  }
}
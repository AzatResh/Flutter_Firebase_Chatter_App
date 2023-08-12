import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatter/screens/chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signOut() async{
    await _firebaseAuth.signOut();
    if(mounted){
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        actions: [
          IconButton(onPressed: signOut, 
          icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Users", 
              style: TextStyle(fontSize: 24),),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _userList(),
            ) 
          )
        ],
      ),
    );
  }

  // список пользователей
  Widget _userList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder:(context, snapshot) {
        if(snapshot.hasError){
          return const Text("Error");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ) 
          );
        }

        return(
          ListView(
            children: snapshot.data!.docs
              .map<Widget>((el) => _userItem(el))
              .toList()
          )
        );
      },
    );
  }

  Widget _userItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if(_firebaseAuth.currentUser!.uid != data['uid']){
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: ListTile(
          title: Text(data['email']),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5),
          ), 
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder:(context) => ChatPage(
                  receiverUserEmail: data['email'],
                  receiverUserId: data['uid'],
                ),
              )
            );
          } 
        ),
      );
    }
    else{
      return Container();
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable{
  String? id;
  final String? name;
  final String? email;
  String? password;
  bool? isEmailVerified;

  UserModel({this.id, this.name, this.email, this.password, this.isEmailVerified});

  UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc)
    : id = doc.id,
    name = doc.data()!['name']?? '',
    email = doc.data()!['email']?? '';

  Map<String, dynamic> toMap(){
    return({
      'uid': id,
      'name': name,
      'email': email
    });
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    bool? isEmailVerified,
  }){
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      password: password ?? this.password,
    );
  }
  @override
  List<Object> get props =>
      [];
}
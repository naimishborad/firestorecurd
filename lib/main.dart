import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    TextEditingController namecontroller = new TextEditingController();
    TextEditingController agecontroller = new TextEditingController();
    TextEditingController phonecontroller = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Curd Firestore",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),  
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: "Enter Your Name"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: agecontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: "Enter Your Age"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: phonecontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: "Enter Your Phone"
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      elevation: 0,
                      onPrimary: Colors.black,
                      fixedSize: Size(100, 20)
                    ),
                    onPressed: (){
                      final name = namecontroller.text;
                      final age = agecontroller.text;
                      final phone = phonecontroller.text;
                      create(name, age, phone);
                    }, child: Text("Add")),
                    ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      elevation: 0,
                      onPrimary: Colors.black,
                      fixedSize: Size(100, 20)
                    ),
                    onPressed: (){
                      final name = namecontroller.text;
                      final age = agecontroller.text;
                      final phone = phonecontroller.text;
                      final docUser = FirebaseFirestore.instance.collection('user').doc('my-doc');
                      docUser.update(
                        {
                          'name': name,
                          'age':age,
                          'phone':phone
                        }
                      );
                    }, child: Text("Update")),
                    
                    ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      elevation: 0,
                      onPrimary: Colors.black,
                      fixedSize: Size(100, 20)
                    ),
                    onPressed: (){
                      final name = namecontroller.text;
                      final age = agecontroller.text;
                      final phone = phonecontroller.text;
                      final docUser = FirebaseFirestore.instance.collection('user').doc('spN3yjV0LqUFPYKRwsoU');
                      docUser.delete();
                    }, child: Text("Delete")),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
    
  }
}

Stream<List<User>>readUser()=>FirebaseFirestore.instance.collection('user').snapshots().map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Future create(String name,String age,String phone)async{
    final docUser = FirebaseFirestore.instance.collection('user').doc();
    final user = User(name: name, age: age, phone: phone);
    final json = user.toJson();
    await docUser.set(json);
  }

Widget buildUser(User user){
    return ListTile(
      leading: CircleAvatar(child: Text('${user.age}'),),
      title: Text(user.name),
      subtitle: Text(user.phone),
    );
  }
class User {
  String name;
  String age;
  String phone;
  User({
    required this.name,
    required this.age,
    required this.phone,
  });

  Map<String,dynamic> toJson() =>{
    'name':name,
    'age':age,
    'phone':phone
  };
  static User fromJson(Map<String,dynamic> json)=>User(name: json['name'], age: json['age'], phone: json['phone']);
}

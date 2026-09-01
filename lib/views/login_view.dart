
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vativanotes/firebase_options.dart';
import 'dart:developer' as devtools show log;
class LoginView extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {
      //final keyword I promise I will give this variable a value later… before anyone tries to use it.
  //final means:“I will give this variable a value only once… and after that, nobody can change it.”

  late final TextEditingController  _email;
  late final TextEditingController  _password;

  @override
  void initState() {
    // initState() is like the moment a new toy robot comes out of the box.
    // You put the batteries in, turn it on, and set it up — and you only do this once when it’s brand new
    
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    
    // dispose() is like when you’re finished playing with your toy robot.
    // You take the batteries out, turn it off, and put it safely back in the box so it doesn’t waste energy or get broken.
    // You only do this once — when the toy is going away.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // #the Scaffold is the owner of the white content here
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
                                children: [
                                  TextField(
                                    controller: _email,
                                    obscureText: false,
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Email'
                                    ),
                                  ),
                                  TextField(
                                    controller: _password,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Password',
                                      
                              
                                    ),
                                  ),
                                  TextButton(onPressed:  ()async{
                                    //So we have to get the TextField variables from the TextField Buttons
                                    //but we have no access to them so we must use a text editing controller
                                    
                                    final email = _email.text;
                                    final password = _password.text;
                                    try {
                                      final UserCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: email, 
                                      password: password);
                                      // print(UserCredential);
                                      devtools.log(UserCredential.toString());
                                      Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false,);
                                    }
                                    //on is like saying
                                    //“Only if the problem is this special kind of problem… then do this!”  
                                    //It’s a way to pick exactly which kind of “uh-oh” you want to catch.
                                    on FirebaseAuthException catch(e){
                                        if(e.code == 'user-not-found'){
                                          // print("User not found");
                                          devtools.log(e.code.toString());
                                        }
                                        else if(e.code == 'wrong-password'){
                                          // print("Wrong Password");
                                          devtools.log(e.code.toString());
                                        }
                                    }
                                    
                                    
                                  }, child: const Text('Login')),
                                  TextButton(onPressed: (){
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/register/'
                                    ,(route) => false,);
                                  }, child: const Text('Not registered yet? Register here:'),)
                                ],
                              ),
    );
  }

  
}
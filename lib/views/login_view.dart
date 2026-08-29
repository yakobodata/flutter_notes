
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vativanotes/firebase_options.dart';

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
    @override
  Widget build(BuildContext context) {
    // #the Scaffold is the owner of the white content here
    return Scaffold(
      // AppBar is the heading
      appBar: AppBar(
        title: const Text('Register'),
      ),
      // We Wrap our Body in the center
      //  We Use Flutter Builder to do a future before
      // So before we build a column , we are going to build a firebase initialization
      // because we dnot want to keep on initalizing a firbase
      body: FutureBuilder(
        future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder: (context, asyncSnapshot) {
          // So Connection State tells us what is the state of our Future 
          switch (asyncSnapshot.connectionState){
            case ConnectionState.done:
              return Column(
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
                                    print(UserCredential);
                                  }
                                  //on is like saying
                                  //“Only if the problem is this special kind of problem… then do this!”  
                                  //It’s a way to pick exactly which kind of “uh-oh” you want to catch.
                                  on FirebaseAuthException catch(e){
                                      if(e.code == 'user-not-found'){
                                        print("User not found");
                                      }
                                      else if(e.code == 'wrong-password'){
                                        print("Wrong Password");
                                      }
                                  }
                                  
                                  
                                }, child: const Text('Login')),
                              ],
                            );
              default:
              return const Text('Loading');
          }
          
        }
      ),
    );
  }

  
}
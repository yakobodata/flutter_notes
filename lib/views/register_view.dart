import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vativanotes/constants/routes.dart';
import 'package:vativanotes/firebase_options.dart';
import 'package:vativanotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const new({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
      body: Scaffold(
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
                                      try{
                                        final UserCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: email, 
                                        password: password);
                                        // print(UserCredential);
                                        final user = FirebaseAuth.instance.currentUser;
                                        await user?.sendEmailVerification(); 
                                        Navigator.of(context).pushNamed(VerifyEmailRoute);
                                      }on FirebaseAuthException catch(e){
                                        if (e.code == 'weak-password'){
                                          await showErrorDialog(context, 'Weak password',);
                                        }
                                        else if (e.code == 'email-already-in-use'){
                                          await showErrorDialog(context, 'Email already in use',);
                                        }
                                        else if (e.code == 'invalid-email'){
                                          await showErrorDialog(context, 'Invalid email');
                                        }
                                        else {
                                          await showErrorDialog(
                                            context,
                                            'Error ${e.code}',);
                                        }
                                      } catch (e){
                                        // Catch any other exception even if its not in Firebase
                                        await showErrorDialog(context, e.toString());
                                      }
                                      
                                    }, 
                                    child: const Text('Register'),
                                    ),
                                    TextButton(onPressed: (){
                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                      loginRoute
                                    ,(route) => false,);
                                    }, child: const Text('Already registered? Login here'),)
                                  ],
                                ),
      ),
    );
  }
}
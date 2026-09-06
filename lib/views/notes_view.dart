// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vativanotes/constants/routes.dart';
import 'package:vativanotes/enums/menu_action.dart';
import 'package:vativanotes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const new({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value){
                case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                // devtools.log(shouldLogout.toString());
                if (shouldLogout){
                  await AuthService.firebase().logOut();
                  // await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,(_) => false,
                    );
                }
              }
            },
            itemBuilder: (context){
              return const [
                PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out'),
                )
              ];        
            },)
        ],
      ),
      body: Text("Hello World"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(context: context,builder: (context){
    return AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to sign out'),
      actions: [
        TextButton(onPressed: (){Navigator.of(context).pop(false);},child: const Text('Cancel')),
        TextButton(onPressed: (){Navigator.of(context).pop(true);},child: const Text('Log out'))
      ],
    );
  },
  ).then((value) => value ?? false);
}

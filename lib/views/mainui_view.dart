import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/enums/menu_action.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value)  {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout){
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, 
                      (_)=> false,
                      );
                  }
              }

          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child:  Text('Log out'),
              ),

            ];
            
          },
          )

        ],
      ),
      body: const Text("Happy Learning.")
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,  
    builder: (context){
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text('Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            }, child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            }, child: const Text('Log out'),
          ),
        ],
      );

    },
  ).then((value) => value ?? false);
}
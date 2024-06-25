import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/enums/menu_action.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/services/crud/mainui_service.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final MainService _mainsService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _mainsService = MainService();
    _mainsService.open();
    super.initState();
  }

  @override
  void dispose() {
    _mainsService.close();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Chat"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(newChatRoute);
          }, 
          icon: const Icon(Icons.add)
          ),
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
      body: FutureBuilder(
        future: _mainsService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _mainsService.allMain, 
                builder: (context, snapshot) {
                  switch(snapshot.connectionState){                    
                    case ConnectionState.waiting:
                      return const Text('Waiting for chat history.');
                    default:
                    return const CircularProgressIndicator();
                  }

                },);
            default:
              return const CircularProgressIndicator();
          }
        },
      )
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
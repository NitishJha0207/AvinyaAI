import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/enums/menu_action.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/services/crud/mainui_service.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:path/path.dart';

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
        shadowColor: Colors.blue[50],
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text("Learning content", style: TextStyle(),),
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
      
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        //gridDelegate: null,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const UpscContent(),
            
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),

          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.deepOrange[100],
            child: const Card(
              borderOnForeground: true,
              ),            
          ),


     ],
     
    ),
           
    
      // Or any other location
    );
  }
}

class UpscContent extends StatefulWidget {
  const UpscContent({super.key});

  @override
  State<UpscContent> createState() => _UpscContentState();
}

class _UpscContentState extends State<UpscContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ListTile(
          leading: Icon(Icons.book),
          title: Text("UPSC"),
          subtitle: Text("data"),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Start learning'),
                  onPressed: () {Navigator.of(context).pushNamed(newChatRoute);},
                ),
                
                const SizedBox(width: 8),
              ],
            ),
      ]
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
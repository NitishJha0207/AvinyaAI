import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/enums/menu_action.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/services/crud/mainui_service.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:path/path.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final MainService _mainsService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  final List<String> topics =[
    'Mathematics',
    'Science',
    'History',
    'Programming',
  ];

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(255, 13, 14, 15),
        backgroundColor:const Color.fromARGB(255, 122, 243, 243),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/app_logo.png'), // Replace with your logo
        ),
        title: const Text(
          "Avinya.AI", 
          style: TextStyle( 
            fontWeight: FontWeight.bold,       
          ),        
        ),
        
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
        padding: const EdgeInsets.all(40),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 1, 
        //gridDelegate: null,
        children: [
          Column(
            children: [
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () { 
                          Navigator.of(context).pushNamed(newMathematicsChatRoute);
                          
                         }, 
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                        ),
                        child: const Text('Mathematics'),
                        )
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () { 
                          Navigator.of(context).pushNamed(newChatRoute);
                        }, 
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                        ),
                        child: const Text('History'),
                        )
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () { 
                          Navigator.of(context).pushNamed(newChatRoute);
                        }, 
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                        ),
                        child: const Text('Physics'),
                        )
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () { 
                          Navigator.of(context).pushNamed(newChatRoute);
                        }, 
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                        ),
                        child: const Text('Or, Ask me anythin!'),
                        )
                    ),
                  ],
                ),
              ),

            ],
          ),
          

     ],
     
    ),

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,     
    
      // Or any other location
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
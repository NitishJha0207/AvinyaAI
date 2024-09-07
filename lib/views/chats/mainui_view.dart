import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/enums/menu_action.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/services/crud/mainui_service.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter/widgets.dart';
//import 'package:path/path.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  XFile? _image;
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

  Future<void> _getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if(image != null){
      _image = image;
    }
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

          
          // PopupMenuButton<MenuAction>(
          //   onSelected: (value) async {
          //     switch (value)  {
          //       case MenuAction.logout:
          //         final shouldLogout = await showLogOutDialog(context);
          //         if (shouldLogout){
          //           await AuthService.firebase().logOut();
          //           Navigator.of(context).pushNamedAndRemoveUntil(
          //             loginRoute, 
          //             (_)=> false,
          //             );
          //         }
          //       }

          //     },
          //     itemBuilder: (context) {
          //       return const [
          //         PopupMenuItem<MenuAction>(
          //         value: MenuAction.logout,
          //         child:  Text('Log out'),
          //         ),

          //       ];
                
          //     },
          //   )

        ],
      ),
      
      body: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(newMathematicsChatRoute);
                 }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                    fontSize: 20,

                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Mathematics'),
                ),
            ),
            const SizedBox(
              height: 10,
              ),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(historyChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                    fontSize: 20,

                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('History'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(physicsChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                    fontSize: 20,
              
                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Physics'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(chemistryChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,
              
                )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Chemistry'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(englishLiteratureChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,
              
                )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('English Language Literature'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(geographyChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,
              
                )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Geography'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(hindiChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,
              
                )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Hindi'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(biologyChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,
              
                )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Biology'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(socialScienseChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,
              
                )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Social Science'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(englishCommunicationChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,
              
                )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('English Communication'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(economicsChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,

                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Economics'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(businessStudiesChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,

                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Business Studies'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(accountancyChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,

                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Accountancy'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(computerScienceChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,

                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Computer Science'),
                ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: TextButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed(newChatRoute);
                }, 
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 20,

                  )),
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 122, 243, 243)),
                ),
                child: const Text('Or, Ask me anything !'),
                ),
            ),
            ] 
          ),
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
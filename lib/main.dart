import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/views/chats/Accountancy/accountancy_chat_view.dart';
import 'package:aiguru/views/chats/Biology/biology_chat_view.dart';
import 'package:aiguru/views/chats/BusinessStudies/business_studies_chat_view.dart';
import 'package:aiguru/views/chats/ComputerScience/computer_science_chat_view.dart';
import 'package:aiguru/views/chats/Economics/economics_chat_view.dart';
import 'package:aiguru/views/chats/EnglishCommunication/english_communication_chat_view.dart';
import 'package:aiguru/views/chats/EnglishLanguageLiterature/english_language_literature_chat_view.dart';
import 'package:aiguru/views/chats/Geography/geography_chat_view.dart';
import 'package:aiguru/views/chats/Hindi/hindi_chat_view.dart';
import 'package:aiguru/views/chats/SocialScience/social_science_chat_view.dart';
import 'package:aiguru/views/chats/chatfromcamera.dart';
import 'package:aiguru/views/chats/chatmessage.dart';
import 'package:aiguru/views/chats/chemistry/chemistry_chat_view.dart';
import 'package:aiguru/views/chats/history/history_chat_view.dart';
import 'package:aiguru/views/chats/mathematics/mathematics_chat_view.dart';
import 'package:aiguru/views/chats/mathematics/mathematics_prompt.dart';
import 'package:aiguru/views/chats/new_chat_view.dart';
import 'package:aiguru/views/chats/physics/physics_chat_view.dart';
import 'package:aiguru/views/google_signin_view.dart';
import 'package:aiguru/views/login_view.dart';
import 'package:aiguru/views/chats/mainui_view.dart';
import 'package:aiguru/views/register_view.dart';
import 'package:aiguru/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart';



void main() async {
  
  //load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Avinya AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage (),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context)=> const RegisterView(),
        mainuiRoute: (context)=> const MainView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newChatRoute: (context) => const NewChatView(title: "Avinya",),
        chatMessageRoute: (context) => const ChatWidget(),
        googleSignInRoute: (context) => const SignInDemo(),
        mathematicsChatRoute: (context)=> const MathematicsPrompt(),
        newMathematicsChatRoute: (context)=> const MathematicsChatView(title: 'Avinya-Mathematics'),
        chatFromCamera: (context)=> const Chatfromcamera(),
        physicsChatRoute: (context)=> const PhysicsChatView(title: 'Avinya-Physics'),
        historyChatRoute: (context) => const HistoryChatView(title:'Avinya-History'),
        chemistryChatRoute: (context)=> const ChemistryChatView(title: 'Avinya-Chemistry'),
        socialScienseChatRoute: (context)=> const SocialScienceChatView(title: 'Avinya-SocialScience'),
        accountancyChatRoute: (context) => const AccountancyChatView(title: "Avinya-Accounts"),
        biologyChatRoute: (context)=> const BiologyChatView(title: "Avinya-Biology"),
        businessStudiesChatRoute: (context) => const BusinessStudiesChatView(title: "Avinya-Business Studies"),
        computerScienceChatRoute: (context) => const ComputerScienceChatView(title: "Avinya-Computer Science"),
        economicsChatRoute: (context) => const EconomicsChatView(title: "Avinya-Economics"),
        englishCommunicationChatRoute: (context) => const EnglishCommunicationChatView(title: "Avinya-English Communication"),
        englishLiteratureChatRoute: (context) => const EnglishLanguageLiteratureChatView(title: "Avinya-English Literature"),
        geographyChatRoute: (context) => const GeographyChatView(title: "Avinya-Geography"),
        hindiChatRoute: (context) => const HindiChatView(title: "Avinya-Hindi"),
        
      }
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return const MainView();
    // FutureBuilder(
    //     future: AuthService.firebase().initialze(),
    //     builder: (context, snapshot) {
    //       switch(snapshot.connectionState){
    //         case ConnectionState.done:
    //            final user = AuthService.firebase().currentUser;
    //            if (user != null) {
    //             if (user.isEmailVerified){
    //               return const MainView();
    //             } else {
    //               return const VerifyEmailView();
    //             } 
    //            } else {
    //             return const MainView();
    //            }
    //         default: 
    //           return const CircularProgressIndicator();
    //       }
          
    //     },
    //   );
  }    
}












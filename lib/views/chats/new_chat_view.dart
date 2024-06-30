import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/services/crud/mainui_service.dart';
import 'package:flutter/material.dart';

class NewChatView extends StatefulWidget {
  const NewChatView({super.key});

  @override
  State<NewChatView> createState() => _NewChatViewState();
}

class _NewChatViewState extends State<NewChatView> {

  DatabaseMain? _chat;
  late final MainService _chatsService;
  late final TextEditingController _textController;

  @override
  void initState(){
    _chatsService = MainService();
    _textController = TextEditingController();

    super.initState();
  }

  void _textControllerListener() async {
    final chat = _chat;
    if (chat == null) {
      return;
    }
    final text = _textController.text;
    await _chatsService.updateMain(
      main: chat, 
      text: text,
    );
  }

  void _setupTextControllerListener (){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener); 
  }


  Future<DatabaseMain> createNewChat() async {
    final existingChat = _chat;
    if (existingChat != null) {
      return existingChat;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _chatsService.getUser(email: email);
    return await _chatsService.createMain(owner: owner);
  }

  void _deleteChatIfTextIsEmpty(){
    final chat = _chat;
    if (_textController.text.isEmpty && chat != null) {
      _chatsService.deleteMain(id: chat.id);
    }
  }

  void _saveChatIfTextNotEmpty() async {
    final chat = _chat;
    final text = _textController.text;
    if(chat != null && text.isNotEmpty) {
      await _chatsService.updateMain(
        main: chat,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteChatIfTextIsEmpty();
    _saveChatIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: FutureBuilder(
        future: createNewChat() ,
        builder: (context, snapshot) {
          
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _chat =snapshot.data;            
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Ask me anything!",
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
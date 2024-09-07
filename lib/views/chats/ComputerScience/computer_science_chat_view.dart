import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/services/crud/mainui_service.dart';
import 'package:aiguru/views/chats/ComputerScience/computer_science_prompt.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; 
import 'package:firebase_vertexai/firebase_vertexai.dart';

class ComputerScienceChatView extends StatefulWidget {
  const ComputerScienceChatView({super.key, required this.title});
  final String title;

  @override
  State<ComputerScienceChatView> createState() => _ComputerScienceChatViewState();
}

class GeminiClient {
  GeminiClient({
    required this.model,
  });

  final GenerativeModel model;

  Future generateContentFromText({
    required String prompt,
  }) async {
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text;
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final XFile? image; // Add this property for the image

  ChatMessage({required this.text, required this.isUser, this.image});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: message.isUser ? Alignment.bottomRight : Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.image != null) 
                Image.file(File(message.image!.path), height: 200.0),
              Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComputerScienceChatViewState extends State<ComputerScienceChatView> {

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


  List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  // API Key Setup (Replace with your actual API key)
  //final _apiKey = Platform.environment['GEMINI_API_KEY']; 

  
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, image: _selectedImage));
    });
    _textController.clear();
    _selectedImage = null;

    final aiResponse = await _getAIResponse(text, _selectedImage);

    setState(() {
      _messages.add(ChatMessage(text: aiResponse, isUser: false));
    });
  }

  Future<String> _getAIResponse(String text, XFile? image) async {
    try {
      final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
      // API Key Validation
      //if (_apiKey == null) {
      // return "Error: API Key not found. Please set the 'API_KEY' environment variable.";
      //}

      //final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      

      // Build the prompt
      if (image != null) {
        final imageBytes = await image.readAsBytes();
        // Create a Content object for the image
        final imageContent = Content.data('image/jpeg', imageBytes);
        // Generate response with the image
        final response = await model.generateContent([imageContent]);
        return response.text!;
      } else if (text.isNotEmpty) {
        // Create a Content object for the text
        final textContent = Content.text(text);
        // Generate response with the text
        final response = await model.generateContent([textContent]);
        return response.text!;
      } else {
        return "Please provide text or an image."; // Handle empty input
      }
    } catch (e) {
      // Error handling for API call
      return "Error generating response. Please try again.";
    }
  }

  Future<void> _selectImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        backgroundColor: const Color.fromARGB(255, 122, 243, 243),
        title: Text(
          widget.title,
          style: const TextStyle( 
            fontWeight: FontWeight.bold,       
          ),
        ),
        centerTitle: true,
      ),
      body: const ComputerSciencePrompt(),
    ); 
  }
}
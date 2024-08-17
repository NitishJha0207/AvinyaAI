import 'dart:convert';
import 'dart:io';
import 'package:aiguru/services/auth/auth_service.dart';
//import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Chatfromcamera extends StatefulWidget {
  const Chatfromcamera({super.key});

  @override
  State<Chatfromcamera> createState() => _ChatfromcameraState();
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
        @override
        (int, int)? get data => (2, 3);

        @override
        String get name => '2x3 (customized)';
}

class _ChatfromcameraState extends State<Chatfromcamera> {
  XFile? _image;
  String customPrompt ="";
  late final GenerativeModel _model;
  late final GenerativeModel _functionCallModel;
  //late final GenerativeModel _functionCallModel;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  _openCamera(){
    if(_image == null) {
      _getImageFromCamera(); 
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  


  Future<void> _getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if(image != null){
      ImageCropper cropper = ImageCropper();
      final croppedImage = await cropper.cropImage(
        sourcePath: image.path,
        uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ],
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
        ],
      ),
      WebUiSettings(
        context: context,
      ),
      ],
        
     );

    
    setState(() {
      _image = croppedImage != null ? XFile(croppedImage.path): null;
    });
    }
  }

  Future<void> sendImage(XFile? imagefile) async{
    if(imagefile == null) return;
    String base64Image = base64Encode(File(imagefile.path).readAsBytesSync());
    String apiKey = "AIzaSyAz3K7iQrhGtybkFQ103dreu_vXWDnpjhQ";
    String requestBody = json.encode(
      {
            "contents": [
              {
                "role": "user",
                "parts": [
                      {
                        "text": "Solve this math function and write step-by-step details and the reason behind that step"
                      },
            {
          //     "image": { // This is an example, you might need to adapt it
          //   "content": "base64EncodedImageString",
          //   "mimeType": "image/jpeg"
          // }
              "fileData": {
                "content": "base64EncodedImageString",
                "mimeType": "image/jpeg"
              }
            },
            {
              "text": "input: Solve this math function and write step-by-step details and the reason behind that step"
            },
            {
              "text": "output: "
            },
            {
              "text": "input: Solve this math function and write step-by-step details and the reason behind that step"
            },
            {
              "text": "output: "
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 1,
        "topK": 64,
        "topP": 0.95,
        "maxOutputTokens": 8192,
        "responseMimeType": "text/plain"
      }
      }
    );

    http.Response response = await http.post(
      Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: requestBody,
    );
    if (response.statusCode == 200){
      print("Image sent successfully");
      
    }
    else{
      print("request failed");
    }
    print(response.body);


  



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a picture"),
      ),
      body: Stack(
        children: [
          _image == null ? const Text("No Image is selected!"): Image.file(File(_image!.path)),
        ],

        
        ),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          _image == null ? _openCamera(): sendImage(_image);        } ,
        tooltip: _image==null ? "Pick Image" : "Send Image",
        child:  Icon(_image == null ? Icons.camera_alt_rounded : Icons.send),
    ),
  );
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}



import 'package:aiguru/services/auth/auth_service.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:google_generative_ai/google_generative_ai.dart';

//const String _apiKey = String.fromEnvironment('API_KEY');


class ChatWidget extends StatefulWidget {
  const ChatWidget({
    //required this.apiKey,
    super.key,
  });

  //final String apiKey;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  //late final GenAI model;
  //late final NewChat _chat;
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

  @override
  void initState() {
    super.initState();
    //final model = AuthService.firebase().genAiModel();
    //_chat = model as ChatSession;

    initFirebase().then((value) {
      _model = FirebaseVertexAI.instance.generativeModel(
        //model: 'gemini-1.5-flash-preview-0514',
        model: 'gemini-1.5-pro',
      );
      _functionCallModel = FirebaseVertexAI.instance.generativeModel(
        //model: 'gemini-1.5-flash-preview-0514',
        model: 'gemini-1.5-pro',
        tools: [
          Tool(functionDeclarations: [exchangeRateTool]),
        ],
      );
      _chat = _model.startChat();
    });
  }

  Future<Map<String, Object?>> findExchangeRate(
    Map<String, Object?> arguments,
  ) async =>
      // This hypothetical API returns a JSON such as:
      // {"base":"USD","date":"2024-04-17","rates":{"SEK": 0.091}}
      {
        'date': arguments['currencyDate'],
        'base': arguments['currencyFrom'],
        'rates': <String, Object?>{arguments['currencyTo']! as String: 0.091},
      };

  
  final exchangeRateTool = FunctionDeclaration(
    'findExchangeRate',
    'Returns the exchange rate between currencies on given date.',
    Schema(
      SchemaType.object,
      properties: {
        'currencyDate': Schema(
          SchemaType.string,
          description: 'A date in YYYY-MM-DD format or '
              'the exact value "latest" if a time period is not specified.',
        ),
        'currencyFrom': Schema(
          SchemaType.string,
          description: 'The currency code of the currency to convert from, '
              'such as "USD".',
        ),
        'currencyTo': Schema(
          SchemaType.string,
          description: 'The currency code of the currency to convert to, '
              'such as "USD".',
        ),
      },
    ),
  );

  Future<void> initFirebase() async {
    await AuthService.firebase().initialze();
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

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'write your query.',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        borderSide: const BorderSide(color: Colors.grey), // Customize border color
        //borderRadius: const BorderRadius.all(
        //  Radius.circular(14),
        //),
        
        //borderSide: BorderSide(
        //  color: Theme.of(context).colorScheme.secondary,
        //),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: Color.fromARGB(255, 122, 243, 243), width: 4.0), // Visual feedback
        //borderRadius: const BorderRadius.all(
        //  Radius.circular(14),
        //),
        //borderSide: BorderSide(
        // color: Theme.of(context).colorScheme.secondary,
        //),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      final content = _generatedContent[idx];
                      return MessageWidget(
                        text: content.text,
                        image: content.image,
                        isFromUser: content.fromUser,
                      );
                    },
                    itemCount: _generatedContent.length,
                  )                
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: textFieldDecoration,
                    controller: _textController,
                    onSubmitted: _sendChatMessage,
                  ),
                ),
                const SizedBox.square(dimension: 5), 
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      await _sendChatMessage(_textController.text);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 6, 211, 211),
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendStorageUriPrompt(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      final content = [
        Content.multi([
          TextPart(message),
          FileData(
            'image/jpeg',
            'gs://vertex-ai-example-ef5a2.appspot.com/foodpic.jpg',
          ),
        ]),
      ];
      _generatedContent.add((image: null, text: message, fromUser: true));

      var response = await _model.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendImagePrompt(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      ByteData catBytes = await rootBundle.load('assets/images/cat.jpg');
      ByteData sconeBytes = await rootBundle.load('assets/images/scones.jpg');
      final content = [
        Content.multi([
          TextPart(message),
          // The only accepted mime types are image/*.
          DataPart('image/jpeg', catBytes.buffer.asUint8List()),
          DataPart('image/jpeg', sconeBytes.buffer.asUint8List()),
        ])
      ];
      _generatedContent.add((
        image: Image.asset("assets/images/cat.jpg"),
        text: message,
        fromUser: true
      ));
      _generatedContent.add((
        image: Image.asset("assets/images/scones.jpg"),
        text: null,
        fromUser: true
      ));

      var response = await _model.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  

  Future<void> _testCountToken() async {
    setState(() {
      _loading = true;
    });

    const prompt = 'tell a short story';
    var response = await _model.countTokens([Content.text(prompt)]);
    print(
      'token: ${response.totalTokens}, billable characters: ${response.totalBillableCharacters}',
    );

    setState(() {
      _loading = false;
    });
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

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  final Image? image;
  final String? text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                decoration: BoxDecoration(
                  color: isFromUser
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(children: [
                  if (text case final text?) MarkdownBody(data: text),
                  if (image case final image?) image,
                ]))),
      ],
    );
  }
}
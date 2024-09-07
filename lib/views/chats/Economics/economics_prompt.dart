import 'package:aiguru/services/auth/auth_service.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class EconomicsPrompt extends StatefulWidget {
  const EconomicsPrompt({super.key});

  @override
  State<EconomicsPrompt> createState() => _EconomicsPromptState();
}

class _EconomicsPromptState extends State<EconomicsPrompt> {

  late final GenerativeModel _model;
  late final GenerativeModel _functionCallModel;
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
        model: 'gemini-1.5-flash',
      );
      _functionCallModel = FirebaseVertexAI.instance.generativeModel(
        //model: 'gemini-1.5-flash-preview-0514',
        model: 'gemini-1.5-flash',
        tools: [
          Tool(functionDeclarations: [economicsControlTool]),
        ],
      );
      _chat = _model.startChat();
    });
  }

  Future<Map<String, Object?>> learnEconomics(
    Map<String, Object?> arguments,
  ) async =>
      
    // This mock API returns the requested lighting values
    {
      'topic': arguments['topic'],
      'numberOfWords': arguments['numberOfWords'],
    };


  
  final economicsControlTool = FunctionDeclaration(
    'learnEconomics',
    'Generate answers for the topic and in specified number of words.',
    Schema(SchemaType.object, properties: {
      'topic': Schema(SchemaType.string,
          description: 'Topic from Economics.'),
      'numberOfWords': Schema(SchemaType.integer,
          description: 'Number of words can be in the range of 0-300 words.'),
    }, requiredProperties: [
      'topic',
      'numberOfWords'
    ]
    )
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
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: Color.fromARGB(255, 122, 243, 243), width: 4.0), // Visual feedback        
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
                    onSubmitted: _testFunctionCalling,
                  ),
                ),
                const SizedBox.square(dimension: 5), 
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      await _testFunctionCalling(_textController.text);
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

  

Future<void> _testFunctionCalling(String message) async {
    setState(() {
      _loading = true;
    });
    final chat = _functionCallModel.startChat();
    const prompt = 'You are an expert Economics teacher. Please ask user about what user is interested to learn, how much user knows about the topic and based on the user response generate a learning plan to complete the topic also provide number of days it would be take complete the learning along with hours and then start teaching concepts step by step.';

    // Send the message to the generative model.
     var response = await chat.sendMessage(Content.text(prompt));
     final text= response.text;
     _generatedContent.add((image: null, text: text, fromUser: false));

    void showError(String message) {
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon:const Icon(
                Icons.add_alert,
                color: Color.fromARGB(255, 6, 211, 211),
                ),
              title: const Text(
                'Oops!',
                ),
              content: SingleChildScrollView(
                child: SelectableText(message),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                  ),
                )
              ],
            );
          },
        );
    }    

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await Future.delayed(const Duration(milliseconds: 1000), (){
        return _chat.sendMessage(
        Content.text(message),
      );
      });
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        showError('You may want to enter a text.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      showError("There seems to be an issue with your network, Please try again. If the issue persist then please wait for a minute and try again.");
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

    final functionCalls = response.functionCalls.toList();
    // When the model response with a function call, invoke the function.
    if (functionCalls.isNotEmpty) {
     final functionCall = functionCalls.first;
     final result = switch (functionCall.name) {
        // Forward arguments to the hypothetical API.
       'learnEconomics' => await learnEconomics(functionCall.args),
        // Throw an exception if the model attempted to call a function that was
        // not declared.
         _ => throw UnimplementedError(
            'Function not implemented: ${functionCall.name}',
          )
      };
      // Send the response to the model so that it can use the result to generate
      // text for the user.
     response =  await Future.delayed(const Duration(milliseconds: 5000), () {
      return chat.sendMessage(Content.functionResponse(functionCall.name, result));
     });
    }

    // When the model responds with non-null text content, print it.
    if (response.text case final text?) {
      _generatedContent.add((image: null, text: text, fromUser: false));
      setState(() {
        _loading = false;
      });
    }
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
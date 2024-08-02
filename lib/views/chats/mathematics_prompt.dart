import 'package:aiguru/services/auth/auth_service.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
 
 
 class MathematicsPrompt extends StatefulWidget {
  const MathematicsPrompt({super.key});

  @override
  State<MathematicsPrompt> createState() => _MathematicsPromptState();
}

class _MathematicsPromptState extends State<MathematicsPrompt> {

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
      contentPadding: const EdgeInsets.all(25),
      hintText: 'write your query.',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              vertical: 25,
              horizontal: 15,
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
                const SizedBox.square(dimension: 15), 
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      await _testFunctionCalling(_textController.text);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
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
    const prompt = 'You are a Mathematics teacher based in India. You are expert in Mathematics. Ask users which graded they belong to and then prepare a learning path for the user based on the provided grade.';

    // Send the message to the generative model.
    // var response = await chat.sendMessage(Content.text(prompt));
    // final text= response.text;
    // _generatedContent.add((image: null, text: text, fromUser: false));

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

    //final functionCalls = response.functionCalls.toList();
    // When the model response with a function call, invoke the function.
    //if (functionCalls.isNotEmpty) {
     // final functionCall = functionCalls.first;
     // final result = switch (functionCall.name) {
     //   // Forward arguments to the hypothetical API.
     //   'findExchangeRate' => await findExchangeRate(functionCall.args),
        // Throw an exception if the model attempted to call a function that was
        // not declared.
    //    _ => throw UnimplementedError(
    //        'Function not implemented: ${functionCall.name}',
    //      )
    //  };
      // Send the response to the model so that it can use the result to generate
      // text for the user.
     // response = await chat
     //     .sendMessage(Content.functionResponse(functionCall.name, result));
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
    // When the model responds with non-null text content, print it.
    //if (response.text case final text?) {
    //  _generatedContent.add((image: null, text: text, fromUser: false));
    //  setState(() {
    //    _loading = false;
    //  });
    //}

   





 
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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
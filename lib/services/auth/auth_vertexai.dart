import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

@immutable
class GenAI{
  final genAiModel = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
  
}

class NewChat{
  final startChat= FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash').startChat();
}


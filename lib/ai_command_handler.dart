// ai_command_handler.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AICommandHandler {
  static const String _apiKey = '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';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String> processCommand(String input) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content': '''Convert user commands to these exact actions:
              - take_photo: Capture image
              - open_gallery: Open image gallery
              - detect_currency: Currency detection mode
              - read_text: Text recognition mode
              - toggle_flash: Toggle flashlight
              - exit_app: Close application
              - unknown: Unrecognized command
              Respond ONLY with the action key'''
          },
          {'role': 'user', 'content': input}
        ]
      }),
    );

    return jsonDecode(response.body)['choices'][0]['message']['content'];
  }
}
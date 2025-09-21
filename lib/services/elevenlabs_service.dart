import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Service class for handling ElevenLabs speech-to-text API calls
class ElevenLabsService {
  static const String _apiBaseUrl = 'https://api.elevenlabs.io/v1';
  static const String _speechToTextEndpoint = '/speech-to-text';
  static const String _apiKeyStorageKey = 'elevenlabs_api_key';

  static const _secureStorage = FlutterSecureStorage();

  /// Initialize the service with API key stored securely
  static Future<void> initializeApiKey() async {
    // Store the API key securely on first run
    const apiKey = 'sk_e81e4e7999d54b0d611fcf4aab8e95e9e93f59ddac7bcf1d';
    await _secureStorage.write(key: _apiKeyStorageKey, value: apiKey);
  }

  /// Get the stored API key
  static Future<String?> _getApiKey() async {
    return await _secureStorage.read(key: _apiKeyStorageKey);
  }

  /// Convert speech to text using ElevenLabs API
  static Future<SpeechToTextResult> speechToText(String audioFilePath) async {
    try {
      final apiKey = await _getApiKey();
      if (apiKey == null) {
        throw Exception('API key not found. Please initialize the service.');
      }

      final file = File(audioFilePath);
      if (!file.existsSync()) {
        throw Exception('Audio file not found at path: $audioFilePath');
      }

      // Create multipart request
      final uri = Uri.parse('$_apiBaseUrl$_speechToTextEndpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'xi-api-key': apiKey,
        'Accept': 'application/json',
      });

      // Add audio file
      final audioBytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'audio',
        audioBytes,
        filename: 'audio.${_getFileExtension(audioFilePath)}',
      );
      request.files.add(multipartFile);

      // Add additional parameters if needed
      request.fields['model_id'] =
          'whisper-1'; // or other model as per ElevenLabs docs

      debugPrint('Sending request to ElevenLabs API...');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('ElevenLabs API Response Status: ${response.statusCode}');
      debugPrint('ElevenLabs API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return SpeechToTextResult.success(responseData['text'] ?? '');
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['detail'] ?? 'Unknown error occurred';
        return SpeechToTextResult.error('API Error: $errorMessage');
      }
    } catch (e) {
      debugPrint('Error in speechToText: $e');
      return SpeechToTextResult.error('Failed to transcribe audio: $e');
    }
  }

  /// Get file extension from path
  static String _getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  /// Delete the stored API key (for security/logout purposes)
  static Future<void> clearApiKey() async {
    await _secureStorage.delete(key: _apiKeyStorageKey);
  }
}

/// Result class for speech-to-text operations
class SpeechToTextResult {
  final bool isSuccess;
  final String? text;
  final String? error;

  const SpeechToTextResult._({required this.isSuccess, this.text, this.error});

  factory SpeechToTextResult.success(String text) {
    return SpeechToTextResult._(isSuccess: true, text: text);
  }

  factory SpeechToTextResult.error(String error) {
    return SpeechToTextResult._(isSuccess: false, error: error);
  }
}

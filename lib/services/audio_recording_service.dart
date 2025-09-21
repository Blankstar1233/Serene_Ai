import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for handling audio recording functionality
class AudioRecordingService {
  static FlutterSoundRecorder? _recorder;
  static String? _currentRecordingPath;

  /// Check and request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // Open app settings for user to manually grant permission
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Initialize the recorder
  static Future<void> _initRecorder() async {
    if (_recorder == null) {
      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();
    }
  }

  /// Start recording audio
  static Future<bool> startRecording() async {
    try {
      // Check permission first
      final hasPermission = await requestMicrophonePermission();
      if (!hasPermission) {
        if (kDebugMode) {
          print('Microphone permission not granted');
        }
        return false;
      }

      // Initialize recorder
      await _initRecorder();

      // Get temporary directory for recording
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = path.join(
        tempDir.path,
        'recording_$timestamp.aac',
      );

      // Start recording
      await _recorder!.startRecorder(
        toFile: _currentRecordingPath!,
        codec: Codec.aacADTS,
        sampleRate: 16000,
        bitRate: 128000,
      );

      if (kDebugMode) {
        print('Recording started: $_currentRecordingPath');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error starting recording: $e');
      }
      return false;
    }
  }

  /// Stop recording and return the file path
  static Future<String?> stopRecording() async {
    try {
      if (_recorder == null) {
        if (kDebugMode) {
          print('Recorder not initialized');
        }
        return null;
      }

      final recordingPath = await _recorder!.stopRecorder();
      if (kDebugMode) {
        print('Recording stopped: $recordingPath');
      }

      // Verify file exists and has content
      if (recordingPath != null) {
        final file = File(recordingPath);
        if (file.existsSync() && await file.length() > 0) {
          return recordingPath;
        }
      }

      return _currentRecordingPath;
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping recording: $e');
      }
      return null;
    }
  }

  /// Check if currently recording
  static Future<bool> isRecording() async {
    return _recorder?.isRecording ?? false;
  }

  /// Cancel current recording
  static Future<void> cancelRecording() async {
    try {
      if (_recorder != null) {
        await _recorder!.stopRecorder();
      }

      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (file.existsSync()) {
          await file.delete();
        }
      }
      _currentRecordingPath = null;
      if (kDebugMode) {
        print('Recording cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling recording: $e');
      }
    }
  }

  /// Clean up temporary recording files
  static Future<void> cleanupRecording(String? filePath) async {
    if (filePath != null) {
      try {
        final file = File(filePath);
        if (file.existsSync()) {
          await file.delete();
          if (kDebugMode) {
            print('Cleaned up recording file: $filePath');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error cleaning up recording file: $e');
        }
      }
    }
  }

  /// Dispose of the recorder
  static Future<void> dispose() async {
    if (_recorder != null) {
      await _recorder!.closeRecorder();
      _recorder = null;
    }
  }
}

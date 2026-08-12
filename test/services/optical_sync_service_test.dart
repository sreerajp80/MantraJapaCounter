import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:mantra_japa_counter/models/optical_sync_frame.dart';
import 'package:mantra_japa_counter/services/optical_sync_service.dart';

void main() {
  group('OpticalSyncFrame Tests', () {
    test('CRC32 checksum produces deterministic non-zero values', () {
      final crc1 = OpticalSyncFrame.computeCrc32('test-payload');
      final crc2 = OpticalSyncFrame.computeCrc32('test-payload');
      final crc3 = OpticalSyncFrame.computeCrc32('different-payload');

      expect(crc1, equals(crc2));
      expect(crc1, isNot(equals(crc3)));
      expect(crc1, greaterThan(0));
    });

    test('Frame serialization and parsing round-trip', () {
      final frame = OpticalSyncFrame.create(
        sessionId: 'sess1234',
        frameIndex: 0,
        totalOriginalChunks: 3,
        totalPayloadLength: 500,
        chunkIndices: [0],
        dataBytes: utf8.encode('Hello Optical World'),
      );

      final rawText = frame.serialize();
      expect(rawText.startsWith('AIRQR|LT1|'), isTrue);

      final parsedFrame = OpticalSyncFrame.parse(rawText);
      expect(parsedFrame, isNotNull);
      expect(parsedFrame!.sessionId, equals('sess1234'));
      expect(parsedFrame.frameIndex, equals(0));
      expect(parsedFrame.totalOriginalChunks, equals(3));
      expect(parsedFrame.isSystematic, isTrue);
      expect(utf8.decode(parsedFrame.dataBytes), equals('Hello Optical World'));
    });

    test('Corrupted CRC checksum causes frame parsing failure', () {
      final frame = OpticalSyncFrame.create(
        sessionId: 'sess1234',
        frameIndex: 0,
        totalOriginalChunks: 3,
        totalPayloadLength: 500,
        chunkIndices: [0],
        dataBytes: utf8.encode('Hello Optical World'),
      );

      final rawText = frame.serialize();
      // Tamper with serialized CRC32 value
      final corruptedText = rawText.replaceAll('"c":${frame.crc32}', '"c":9999999');

      final parsedFrame = OpticalSyncFrame.parse(corruptedText);
      expect(parsedFrame, isNull);
    });
  });

  group('OpticalSyncService & Decoder Tests', () {
    final sampleJson = jsonEncode({
      'counters': [
        {
          'id': 'cnt-1',
          'name': 'Om Namah Shivaya',
          'initialCount': 0,
          'incrementStep': 1,
          'lifetimeGoal': 100000,
          'dailyGoal': 108,
          'status': 'ACTIVE',
        },
        {
          'id': 'cnt-2',
          'name': 'Gayatri Mantra',
          'initialCount': 108,
          'incrementStep': 1,
          'lifetimeGoal': 50000,
          'dailyGoal': 216,
          'status': 'ACTIVE',
        }
      ],
      'sessions': [
        {
          'id': 'sess-1',
          'counterId': 'cnt-1',
          'date': '2026-08-12',
          'count': 108,
          'durationSeconds': 900,
        }
      ]
    });

    test('Encodes payload into systematic and parity frames', () {
      final frames = OpticalSyncService.generateFrames(
        sampleJson,
        sessionId: 'test-session',
        maxFramesToGenerate: 30,
      );

      expect(frames.isNotEmpty, isTrue);
      expect(frames.first.isSystematic, isTrue);
      expect(frames.first.sessionId, equals('test-session'));
    });

    test('Decodes payload cleanly from 100% systematic frames', () {
      final frames = OpticalSyncService.generateFrames(
        sampleJson,
        sessionId: 'test-session',
        maxFramesToGenerate: 30,
      );

      final decoder = OpticalSyncDecoder();
      OpticalSyncReceiveProgress? progress;

      for (final frame in frames) {
        if (frame.isSystematic) {
          progress = decoder.processFrame(frame);
        }
      }

      expect(progress, isNotNull);
      expect(progress!.isComplete, isTrue);
      expect(progress.completionPercentage, equals(1.0));
      expect(progress.decodedJsonPayload, equals(sampleJson));
    });

    test('Reconstructs payload under 50% systematic frame drops using LT parity frames', () {
      final frames = OpticalSyncService.generateFrames(
        sampleJson,
        sessionId: 'test-session',
        maxFramesToGenerate: 60,
      );

      final decoder = OpticalSyncDecoder();
      OpticalSyncReceiveProgress? progress;

      // Simulate dropping odd systematic frames, feeding parity frames instead
      for (int i = 0; i < frames.length; i++) {
        final frame = frames[i];
        if (frame.isSystematic && frame.frameIndex % 2 != 0) {
          // Drop odd systematic frame
          continue;
        }

        progress = decoder.processFrame(frame);
        if (progress.isComplete) break;
      }

      expect(progress, isNotNull);
      expect(progress!.isComplete, isTrue);
      expect(progress.decodedJsonPayload, equals(sampleJson));
    });

    test('Rejects frames with mismatched session ID', () {
      final frames1 = OpticalSyncService.generateFrames(
        sampleJson,
        sessionId: 'session-A',
        maxFramesToGenerate: 10,
      );
      final frames2 = OpticalSyncService.generateFrames(
        sampleJson,
        sessionId: 'session-B',
        maxFramesToGenerate: 10,
      );

      final decoder = OpticalSyncDecoder();
      decoder.processFrame(frames1.first);

      final progressAfterMismatch = decoder.processFrame(frames2.first);
      expect(progressAfterMismatch.sessionId, equals('session-A'));
      expect(progressAfterMismatch.reconstructedChunksCount, equals(1));
    });
  });
}

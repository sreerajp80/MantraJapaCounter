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
      final corruptedText = rawText.replaceAll(
        '"c":${frame.crc32}',
        '"c":9999999',
      );

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
        },
      ],
      'sessions': [
        {
          'id': 'sess-1',
          'counterId': 'cnt-1',
          'date': '2026-08-12',
          'count': 108,
          'durationSeconds': 900,
        },
      ],
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

    test('Chunks are small enough for an easy-to-read QR code', () {
      final frames = OpticalSyncService.generateFrames(
        sampleJson * 5,
        sessionId: 'test-session',
        maxFramesToGenerate: 40,
      );

      expect(OpticalSyncService.chunkSize, equals(120));
      for (final frame in frames) {
        expect(frame.dataBytes.length, lessThanOrEqualTo(120));
        // Keeps each code at a low QR version (about 57×57 squares or less).
        expect(frame.serialize().length, lessThan(260));
      }
    });

    test(
      'Round-trips a multi-chunk payload through QR text, parity frames first',
      () {
        // Not a multiple of the chunk size, so the last chunk is short.
        final payload = sampleJson * 4;
        expect(payload.length % OpticalSyncService.chunkSize, isNot(0));

        final frames = OpticalSyncService.generateFrames(
          payload,
          sessionId: 'test-session',
          maxFramesToGenerate: 120,
        );

        // Feed parity frames before systematic ones, as QR text, the way a
        // receiver that joins mid-stream would see them.
        final ordered = [
          ...frames.where((f) => !f.isSystematic),
          ...frames.where((f) => f.isSystematic),
        ];

        final decoder = OpticalSyncDecoder();
        OpticalSyncReceiveProgress? progress;
        for (final frame in ordered) {
          final parsed = OpticalSyncFrame.parse(frame.serialize());
          expect(parsed, isNotNull);
          progress = decoder.processFrame(parsed!);
          if (progress.isComplete) break;
        }

        expect(progress!.isComplete, isTrue);
        expect(progress.decodedJsonPayload, equals(payload));
      },
    );

    test('frameAt returns the same frame for the same index', () {
      final a = OpticalSyncEncoder(sampleJson * 3, sessionId: 'sess-x');
      final b = OpticalSyncEncoder(sampleJson * 3, sessionId: 'sess-x');
      for (final i in [0, 1, a.totalOriginalChunks, 500, 123456]) {
        expect(a.frameAt(i).serialize(), equals(b.frameAt(i).serialize()));
      }
    });

    test('Stream keeps sending plain chunks and new mixes', () {
      final encoder = OpticalSyncEncoder(sampleJson * 3, sessionId: 'sess-x');
      final n = encoder.totalOriginalChunks;
      expect(n, greaterThan(3));

      // First N frames are the plain chunks in order.
      for (int i = 0; i < n; i++) {
        expect(encoder.frameAt(i).chunkIndices, equals([i]));
      }

      // After that, every third frame is a plain chunk; all chunks come back.
      final plainLater = <int>{};
      final mixes = <String>{};
      for (int i = n; i < n + 3 * n; i++) {
        final frame = encoder.frameAt(i);
        if ((i - n) % 3 == 0) {
          expect(frame.isSystematic, isTrue);
          plainLater.add(frame.chunkIndices.single);
        } else {
          expect(frame.chunkIndices.length, inInclusiveRange(2, 4));
          mixes.add(frame.chunkIndices.join(','));
        }
      }
      expect(plainLater.length, equals(n));
      expect(mixes.length, greaterThan(1));
    });

    test('Frame numbers wrap instead of growing without end', () {
      final encoder = OpticalSyncEncoder(sampleJson, sessionId: 'sess-x');
      final frame = encoder.frameAt(OpticalSyncEncoder.maxFrameIndex + 2);
      expect(frame.frameIndex, equals(2));
    });

    test('Receiver joining mid-stream and missing half the frames rebuilds '
        'the payload', () {
      final payload = sampleJson * 4;
      final encoder = OpticalSyncEncoder(payload, sessionId: 'sess-mid');
      final decoder = OpticalSyncDecoder();
      OpticalSyncReceiveProgress? progress;

      for (int i = 500; i < 500 + 40 * encoder.totalOriginalChunks; i++) {
        if (i.isOdd) continue; // camera missed this frame
        final parsed = OpticalSyncFrame.parse(encoder.frameAt(i).serialize());
        progress = decoder.processFrame(parsed!);
        if (progress.isComplete) break;
      }

      expect(progress!.isComplete, isTrue);
      expect(progress.decodedJsonPayload, equals(payload));
    });

    test('framesReceived counts each frame once', () {
      final encoder = OpticalSyncEncoder(sampleJson * 3, sessionId: 'sess-x');
      final decoder = OpticalSyncDecoder();
      decoder.processFrame(encoder.frameAt(0));
      decoder.processFrame(encoder.frameAt(0));
      final progress = decoder.processFrame(encoder.frameAt(1));
      expect(progress.framesReceived, equals(2));
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

import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AESEncryptor {
  // Encrypt data in Flutter (Dart)
  static String encryptData(String plaintext) {
    final encryptionKey = dotenv.env['ENCRYPTION_KEY'] ?? 'ASDFGHJKLASDFGHJ';
    final key = Key(Uint8List.fromList(encryptionKey.codeUnits));
    final encrypter = Encrypter(AES(Key(Uint8List.fromList(key.bytes)),
        mode: AESMode.ecb, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(plaintext, iv: IV.fromLength(16));
    return base64.encode(encrypted.bytes);
  }
}

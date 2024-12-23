import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionDecryption {
  static String encryptMessage(String plainMessageText) {
    try {
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);

      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final encrypted = encrypter.encrypt(plainMessageText, iv: iv);

      String keyBase64 = base64.encode(key.bytes);
      String ivBase64 = base64.encode(iv.bytes);
      String encryptedMessageBase64 = encrypted.base64;

      return jsonEncode({
        'key': keyBase64,
        'iv': ivBase64,
        'message': encryptedMessageBase64,
      });
    } catch (e) {
      return '';
    }
  }

  static String decryptMessage(String encryptedData) {
    try {
      var data = jsonDecode(encryptedData);
      String keyBase64 = data['key'];
      String ivBase64 = data['iv'];
      String encryptedMessageBase64 = data['message'];

      final keyDecoded = encrypt.Key.fromBase64(keyBase64);
      final ivDecoded = encrypt.IV.fromBase64(ivBase64);

      final encryptedMessage =
          encrypt.Encrypted.fromBase64(encryptedMessageBase64);

      final encrypter =
          encrypt.Encrypter(encrypt.AES(keyDecoded, mode: encrypt.AESMode.cbc));

      final decryptedMessage =
          encrypter.decrypt(encryptedMessage, iv: ivDecoded);
      return decryptedMessage;
    } catch (e) {
      return '';
    }
  }
}

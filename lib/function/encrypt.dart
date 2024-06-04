import 'package:encrypt/encrypt.dart';

class EncryptData {
  static const _keyString = 'my 32 length key................';
  static final _key = Key.fromUtf8(_keyString);
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  // Encrypt AES
  static String encryptAES(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Encryption error: $e');
      return '';
    }
  }

  // Decrypt AES
  static String decryptAES(String encryptedText) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedText);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return '';
    }
  }
}

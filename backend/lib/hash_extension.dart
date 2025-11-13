import 'dart:convert';

import 'package:crypto/crypto.dart';

///adciona uma funcionalidade de hash
extension HashStringExtension on String {

  /// Returns the SHA256 hash of this [String]
  //essa funcao transforma as strings em uma palavra criptografada para armazenala em segurança
  String get hashValue {
    return sha256.convert(utf8.encode(this)).toString();
  }
}
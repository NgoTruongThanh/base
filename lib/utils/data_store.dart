import 'package:encrypt/encrypt.dart' as EncryptSys;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

class DataStore {
  final logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
    ), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  final EncryptSys.IV iv;
  final EncryptSys.Key key;
  final bool isEncryption;
  late final EncryptSys.Encrypter encrypter;
  DataStore({required this.key, required this.iv, required this.isEncryption}) {
    encrypter = EncryptSys.Encrypter(EncryptSys.AES(key));
  }

  Future<void> initStore() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? loadFromLocal(String key) {
    try {
      String? data = prefs.getString(key);
      if(data == null && data!.isEmpty) {
        return null;
      }
      if(isEncryption) {
        EncryptSys.Encrypted buffer = EncryptSys.Encrypted.fromBase64(data);
        String temp = encrypter.decrypt(buffer, iv: iv);
        return temp;
      } else {
        return data;
      }
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<bool> saveToLocal(String key, String data) async {
    try {
      String plainText = data;
      if (isEncryption) {
        EncryptSys.Encrypted dataEncrypted = encrypter.encrypt(plainText, iv: iv);
        return prefs.setString(key, dataEncrypted.base64);
      } else {
        return await prefs.setString(key, plainText);
      }
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  Future<bool> deleteLocal(String key) async {
    try {
      return await prefs.remove(key);
    } catch (e) {
      logger.e(e.toString());
      return false;
    }

  }
}
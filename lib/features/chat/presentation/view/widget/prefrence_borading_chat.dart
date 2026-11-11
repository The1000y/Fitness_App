import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PrefrenceBoradingChat {
  SharedPreferences sharedPrefrenceModule;
  PrefrenceBoradingChat(this.sharedPrefrenceModule);
  static const String keyBoardingChat = StorageKeys.kIntoChat;

  Future<void> setBoardingChat() async {
    await sharedPrefrenceModule.setBool(keyBoardingChat, true);
  }

  bool get getBoardingChat =>
      sharedPrefrenceModule.getBool(keyBoardingChat) ?? false;
}

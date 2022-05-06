import 'package:chaka_app/models/user.dart';
import 'package:get_storage/get_storage.dart';

mixin CacheManager {
  Future<void> saveDataLogin(Map<String, dynamic> dataLogin) async {
    final box = GetStorage();

    await box.write('dataLogin', dataLogin);
  }

  Future<User> getDataLogin() async {
    final box = GetStorage();
    if (box.read('dataLogin') != null) {
      final dataLogin = await box.read('dataLogin') as Map<String, dynamic>;

      return User(
        username: dataLogin['username'],
        password: dataLogin['password'],
      );
    }

    return User();
  }

  Future<void> removeDataLogin() async {
    final box = GetStorage();
    await box.remove('dataLogin');
  }

  /// Remember Me

  Future<void> saveRememberMe(Map<String, dynamic> data) async {
    final box = GetStorage();
    await box.write('dataRememberMe', data);
  }

  Future<Map<String, dynamic>?> getRememberMe() async {
    final box = GetStorage();
    if (box.read('dataRememberMe') != null) {
      return await box.read('dataRememberMe') as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> removeRememberMe() async {
    final box = GetStorage();
    // check dataRememberMe key and rm
    if (box.hasData('dataRememberMe')) {
      await box.remove('dataRememberMe');
    }
  }
}

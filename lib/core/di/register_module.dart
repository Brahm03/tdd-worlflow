import 'package:injectable/injectable.dart';
import 'package:task_app/core/storage/token_storage.dart';

// * tashqi / singleton classlarni getIt ga ro'yxatdan o'tkazadi
@module
abstract class RegisterModule {
  @lazySingleton
  TokenStorage get tokenStorage => TokenStorage.instance;
}

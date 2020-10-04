import 'package:cocoon/services/authentication_service.dart';
import 'package:cocoon/services/firestore_service.dart';
import 'package:get_it/get_it.dart';
import 'package:cocoon/services/navigation_service.dart';
import 'package:cocoon/services/dialog_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
}

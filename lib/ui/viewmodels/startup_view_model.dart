import 'package:cocoon/constants/route_names.dart';
import 'package:cocoon/locator.dart';
import 'package:cocoon/services/authentication_service.dart';
import 'package:cocoon/services/navigation_service.dart';
import 'package:cocoon/ui/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      _navigationService.clearAllAndNavigateTo(HomeViewRoute);
    } else {
      _navigationService.clearAllAndNavigateTo(LoginViewRoute);
    }
  }

  signOut(){
    _authenticationService.signOut();
  }
}

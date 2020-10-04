import 'package:cocoon/constants/route_names.dart';
import 'package:cocoon/locator.dart';
import 'package:cocoon/models/user.dart';
import 'package:cocoon/services/authentication_service.dart';
import 'package:cocoon/services/navigation_service.dart';
import 'package:cocoon/ui/shared/app_colors.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final NavigationService _navService = locator<NavigationService>();

  final AuthenticationService _authService = locator<AuthenticationService>();

  logOutAndNav() async{
    await _authService.signOut();
   await  _navService.clearAllAndNavigateTo(LoginViewRoute);
  }
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _user==null?Center(child: CircularProgressIndicator(),):
            ListTile(
              leading: Icon(Icons.person),
              title: Text(_user.fullName),
              subtitle: Text(_user.email),
              trailing: IconButton(icon: Icon(Icons.remove_circle, color: primaryColor,),
                  onPressed: (){
                setState(() {
                  Flushbar(
                    title:  "Signing You Out...",
                    message:  'SignOut Successful',
                    duration:  Duration(seconds: 2),
                  )..show(context).then((val)=>logOutAndNav());
                });
              }),
            ),
            /**
            Expanded(child:
                FutureBuilder(
                  //future: ,
                    builder: (context, snapshot){
                      if (snapshot.hasData) {
                        return Center(
                          child: Text(
                            snapshot.data,
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
            ),
            */
          ],
        ),
      ),
    );
  }
}

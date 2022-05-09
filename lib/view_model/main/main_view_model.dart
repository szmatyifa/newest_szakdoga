import 'package:barber_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class MainViewModel{

  void processLogin(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey);
  Future<LOGIN_STATE>  checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState);
}
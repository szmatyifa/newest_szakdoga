import 'package:barber_shop/model/user_model.dart';
import 'package:barber_shop/model/image_model.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeViewModel{
  Future<UserModel> displayUserProfile(BuildContext context, String phoneNumber);
  Future<List<ImageModel>> displayBanner();
  Future<List<ImageModel>> displayLookbook();

  bool isStaff(BuildContext context) ;
}

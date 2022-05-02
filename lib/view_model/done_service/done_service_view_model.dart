import 'package:barber_shop/model/booking_model.dart';
import 'package:barber_shop/model/service_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class DoneServiceViewModel{
  Future<BookingModel> displayDetailBooking(BuildContext context, int timeSlot);
  Future<List<ServiceModel>> displayServices(BuildContext context);
  void finishService(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey);
  double calculateTotalPrice(List<ServiceModel> serviceSelected);
  bool isDone(BuildContext context);
  bool isSelectedService(BuildContext context, ServiceModel serviceModel);
  void onSelectedchip(BuildContext context, bool isSelected, ServiceModel e);

}
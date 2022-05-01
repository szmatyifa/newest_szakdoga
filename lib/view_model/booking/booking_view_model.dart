import 'package:barber_shop/model/City_model.dart';
import 'package:barber_shop/model/barber_model.dart';
import 'package:barber_shop/model/salon_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BookingViewModel{
  //City
  Future<List<CityModel>> displayCities();
  void onSelectedCity(BuildContext context, CityModel cityModel);
  bool isCitySelected(BuildContext context, CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalonByCity(String cityName);
  void onSelectedSalon(BuildContext context, SalonModel salonModel);
  bool isSalonSelected(BuildContext context, SalonModel salonModel);

  //Barber
  Future<List<BarberModel>> displayBarberBySalon(SalonModel salonModel);
  void onSelectedBarber(BuildContext context, BarberModel barberModel);
  bool isBarberSelected(BuildContext context, BarberModel barberModel);

  //Timeslot
  Future<int> displayMaxAvailableTimeslot(DateTime dt);
  Future<List<int>> displayTimeSlotOfBarber(BarberModel barberModel, String date);
  bool isAvailableForTapTimeSlot(int maxTime,
      int index,
      List<int> listTimeSlot);
  void onSelectedTimeSlot(BuildContext context, int index);
  Color displayColorTimeSlot(BuildContext context,
      List<int> listTimeSlot,
      int index,
      int maxTimeSlot);

  void confirmBooking(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey);
}
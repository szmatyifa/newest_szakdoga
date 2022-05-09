import 'dart:ui';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:barber_shop/cloud_firestore/all_salon_ref.dart';
import 'package:barber_shop/model/City_model.dart';
import 'package:barber_shop/model/barber_model.dart';
import 'package:barber_shop/model/booking_model.dart';
import 'package:barber_shop/model/salon_model.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/string/strings.dart';
import 'package:barber_shop/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import 'booking_view_model.dart';

class BookingViewModelImp implements BookingViewModel{
  @override
  Future<List<CityModel>> displayCities() {
    return getCities();
  }

  @override
  bool isCitySelected(BuildContext context, CityModel cityModel) {
    return context.read(selectedCity).state.name == cityModel.name;
  }

  @override
  void onSelectedCity(BuildContext context, CityModel cityModel) {
    context.read(selectedCity).state = cityModel;
  }

  @override
  Future<List<SalonModel>> displaySalonByCity(String cityName) {
    return getSalonByCity(cityName);
  }

  @override
  bool isSalonSelected(BuildContext context, SalonModel salonModel) {
    return context.read(selectedSalon).state.docId == salonModel.docId;
  }

  @override
  void onSelectedSalon(BuildContext context, SalonModel salonModel) {
    context.read(selectedSalon).state = salonModel;
  }

  @override
  Future<List<BarberModel>> displayBarberBySalon(SalonModel salonModel) {
    return getBarberBySalon(salonModel);
  }

  @override
  bool isBarberSelected(BuildContext context, BarberModel barberModel) {
    return context.read(selectedBarber).state.docId == barberModel.docId;
  }

  @override
  void onSelectedBarber(BuildContext context, BarberModel barberModel) {
    context.read(selectedBarber).state = barberModel;
  }

  @override
  Color displayColorTimeSlot(BuildContext context, List<int> listTimeSlot, int index, int maxTimeSlot) {
    return listTimeSlot.contains(index)
        ? Colors.white10
        : maxTimeSlot > index
        ? Colors.white60
        : context.read(selectedTime).state ==
        TIME_SLOT.elementAt(index)
        ? Colors.white54
        : Colors.white;
  }

  @override
  Future<int> displayMaxAvailableTimeslot(DateTime dt) {
    return getMaxAvailableTimeSlot(dt);
  }

  @override
  Future<List<int>> displayTimeSlotOfBarber(BarberModel barberModel, String date) {
    return getTimeSlotOfBarber(barberModel, date);
  }

  @override
  bool isAvailableForTapTimeSlot(int maxTime, int index, List<int> listTimeSlot) {
    return (maxTime > index) || listTimeSlot.contains(index);
  }

  @override
  void onSelectedTimeSlot(BuildContext context, int index) {
    context.read(selectedTimeSlot).state = index;
    context.read(selectedTime).state = TIME_SLOT.elementAt(index);
  }

  @override
  void confirmBooking(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey) {

    var hour = context
        .read(selectedTime)
        .state.length <= 10 ? int.parse(context
        .read(selectedTime)
        .state
        .split(':')[0]
        .substring(0,1)) :
    int.parse(context
        .read(selectedTime)
        .state
        .split(':')[0]
        .substring(0,2));
    var minutes = context
        .read(selectedTime)
        .state.length <= 10 ? int.parse(context
        .read(selectedTime)
        .state
        .split(':')[1]
        .substring(0,1)) :
    int.parse(context
        .read(selectedTime)
        .state
        .split(':')[1]
        .substring(0,2));
    var timeStamp = DateTime(
      context.read(selectedDate).state.year,
      context.read(selectedDate).state.month,
      context.read(selectedDate).state.day,
      hour, //hour
      minutes,
    ).millisecondsSinceEpoch;
    //Create booking Model
    var bookingModel = BookingModel(
        barberId: context.read(selectedBarber).state.docId,
        barberName: context.read(selectedBarber).state.name,
        cityBook: context.read(selectedCity).state.name,
        customerId: FirebaseAuth.instance.currentUser.uid,
        customerName: context.read(userInformation).state.name,
        customerPhone: FirebaseAuth.instance.currentUser.phoneNumber,
        done: false,
        salonAddress:context.read(selectedSalon).state.address,
        salonId:context.read(selectedSalon).state.docId,
        salonName:context.read(selectedSalon).state.name,
        slot:context.read(selectedTimeSlot).state,
        timeStamp:timeStamp,
        time:'${context.read(selectedTime).state} - ${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}'
    );

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference barberBooking =
    context
        .read(selectedBarber)
        .state
        .reference
        .collection('${DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state)}')
        .doc(context.read(selectedTimeSlot).state.toString());

    DocumentReference userBooking = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .collection(
        'Booking_${FirebaseAuth.instance.currentUser.uid}')
        .doc(
        '${context.read(selectedBarber).state.docId}_${DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state)}');

    //Set for batch
    batch.set(barberBooking,bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value) {

      Navigator.of(context).pop();
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text('Booking was succesful'),
      ));
      //Reset value
      context.read(selectedDate).state = DateTime.now();
      context.read(selectedBarber).state = BarberModel();
      context.read(selectedCity).state = CityModel();
      context.read(selectedSalon).state = SalonModel();
      context.read(currentStep).state = 1;
      context.read(selectedTime).state = '';
      context.read(selectedTimeSlot).state = -1;


      //Create Event
      final event = Event(
          title: titleText,
          description: 'Barber appointment ${context.read(selectedTime).state} - '
              '${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}',
          location: '${context.read(selectedSalon).state.address}',
          startDate: DateTime(
              context.read(selectedDate).state.year,
              context.read(selectedDate).state.month,
              context.read(selectedDate).state.day,
              hour,
              minutes

          ),
          endDate: DateTime(
              context.read(selectedDate).state.year,
              context.read(selectedDate).state.month,
              context.read(selectedDate).state.day,
              hour,
              minutes+30

          ),
          iosParams: IOSParams(reminder: Duration(minutes: 30)),
          androidParams: AndroidParams(emailInvites: [])
      );
      Add2Calendar.addEvent2Cal(event).then((value) {});
    });


  }

}
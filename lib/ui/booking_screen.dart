
import 'package:barber_shop/cloud_firestore/all_salon_ref.dart';
import 'package:barber_shop/model/City_model.dart';
import 'package:barber_shop/model/barber_model.dart';
import 'package:barber_shop/model/salon_model.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/utils/utils.dart';
import 'package:barber_shop/view_model/booking/booking_view_model_imp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

import 'components/barber_list.dart';
import 'components/city_list.dart';
import 'components/confirm.dart';
import 'components/salon_list.dart';
import 'components/time_slot.dart';

class BookingScreen extends ConsumerWidget{
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final bookingViewModel = new BookingViewModelImp();
  @override
  Widget build(BuildContext context, watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var barberWatch = watch(selectedBarber).state;
    var dateWatch = watch(selectedDate).state;
    var timeWatch = watch(selectedTime).state;
    var timeSlotWatch = watch(selectedTimeSlot).state;


    return SafeArea(
        child: Scaffold(
          key:scaffoldKey,
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFFDF9EE),
          body: Column(
            children: [
              //Step
              NumberStepper(
                activeStep: step-1,
                direction: Axis.horizontal,
                enableNextPreviousButtons: false,
                enableStepTapping: false,
                numbers: [1,2,3,4,5],
                stepColor: Colors.black,
                activeStepColor: Colors.grey ,
                numberStyle: TextStyle(color: Colors.white),
              ),
              //Screen
              Expanded(
                flex: 10,
                child: step == 1
                    ? displayCityList(bookingViewModel)
                    : step == 2
                      ? displaySalon(bookingViewModel,cityWatch.name)
                      : step == 3
                        ? displayBarber(bookingViewModel,salonWatch)
                        : step == 4
                          ? displayTimeSlot(bookingViewModel,context, barberWatch)
                          : step == 5
                            ? displayConfirm(bookingViewModel,context,scaffoldKey)
                            : Container(),
              ),
              //Button
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(padding: const EdgeInsets.all(8), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                              onPressed: step == 1 ? null : ()=> context.read(currentStep).state--,
                              child: Text('Previous'),
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                            child: ElevatedButton(
                              onPressed:  (step == 1 &&
                                  context.read(selectedCity).state.name == null) ||
                                  (step == 2 &&
                                      context.read(selectedSalon).state.docId == null)  ||
                                  (step == 3 &&
                                      context.read(selectedBarber).state.docId == null) ||
                                  (step == 4 &&
                                      context.read(selectedTimeSlot).state == -1)//if city is not selected -> disable next button
                                  ? null :
                              step == 5
                                  ? null
                                  : ()=> context.read(currentStep).state++,
                              child: Text('Next'),
                            )),
                      ],
                    ),),
                  )
              )
            ],),
        ));
  }















}
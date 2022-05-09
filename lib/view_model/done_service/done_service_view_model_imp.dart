import 'package:barber_shop/cloud_firestore/all_salon_ref.dart';
import 'package:barber_shop/cloud_firestore/services_ref.dart';
import 'package:barber_shop/model/booking_model.dart';
import 'package:barber_shop/model/service_model.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/utils/utils.dart';
import 'package:barber_shop/view_model/done_service/done_service_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DoneServiceViewModelImp implements DoneServiceViewModel {
  @override
  double calculateTotalPrice(List<ServiceModel> serviceSelected) {
    return serviceSelected
        .map((item) => item.price)
        .fold(0,
            (value, element) => value + element);
  }

  @override
  Future<BookingModel> displayDetailBooking(BuildContext context,
      int timeSlot) {
    return getDetailBooking(context, timeSlot);
  }

  @override
  Future<List<ServiceModel>> displayServices(BuildContext context) {
    return getServices(context);
  }

  @override
  void finishService(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey) {
    var batch  = FirebaseFirestore.instance.batch();
    var barberBook = context.read(selectedBooking).state;

    var userBook = FirebaseFirestore.instance
        .collection('User')
        .doc('${barberBook.customerPhone}')
        .collection('Booking_${barberBook.customerId}')
        .doc('${barberBook.barberId}_${DateFormat('dd_MM_yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(barberBook.timeStamp))}');
    Map<String,dynamic> updateDone = new Map();
    updateDone['done'] = true;
    updateDone['services'] = convertServices(context.read(selectedServices).state);
    updateDone['totalPrice'] = context
        .read(selectedServices)
        .state
        .map((e)=>e.price)
        .fold(0, (previousValue, element)=>previousValue+element);

    batch.update(userBook,updateDone);
    batch.update(barberBook.reference, updateDone);

    batch.commit().then((value){
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content:Text('Process success'))).closed
          .then((v)=> Navigator.of(context).pop());
    });
  }


  @override
  bool isDone(BuildContext context) {
    return context.read(selectedBooking).state.done;
  }

  @override
  bool isSelectedService(BuildContext context, ServiceModel serviceModel) {
    return context
        .read(selectedServices)
        .state
        .contains(serviceModel);
  }

  @override
  void onSelectedchip(BuildContext context, bool isSelected, ServiceModel e) {
    var list = context
        .read(selectedServices)
        .state;
    if (isSelected) {
      list.add(e);
      context
          .read(selectedServices)
          .state = list;
    }
    else {
      list.remove(e);
      context
          .read(selectedServices)
          .state = list;
    }
  }
}
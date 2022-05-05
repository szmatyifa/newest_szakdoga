import 'package:barber_shop/model/booking_model.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/view_model/barber_booking_history/barber_booking_history_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BarberBookingHistoryViewModelImp implements BarberBookingHistoryViewModel{
  @override
  Future<List<BookingModel>> getBarberBookingHistory(
      BuildContext context, DateTime dateTime) async{
    var listBooking = List<BookingModel>.empty(growable: true);
    var barberDocument = FirebaseFirestore.instance
    .collection('AllSalon')
    .doc('${context.read(selectedCity).state.name}')
    .collection('Branch')
    .doc('${context.read(selectedSalon).state.docId}')
    .collection('Barber')
    .doc('${FirebaseAuth.instance.currentUser.uid}')
    .collection(DateFormat('dd_MM_yyyy').format(dateTime));

    var snapshot = await barberDocument.get();
    snapshot.docs.forEach((element) {
      var barberBooking = BookingModel.fromJson(element.data());
      barberBooking.docId = element.id;
      barberBooking.reference = element.reference;
      listBooking.add(barberBooking);
    });
    return listBooking;
  }

}
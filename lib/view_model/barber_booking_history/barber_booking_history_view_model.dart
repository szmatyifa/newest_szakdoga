import 'package:barber_shop/model/booking_model.dart';
import 'package:flutter/material.dart';

abstract class BarberBookingHistoryViewModel{
  Future<List<BookingModel>> getBarberBookingHistory(
      BuildContext context, DateTime dateTime
      );
}
import 'package:barber_shop/model/booking_model.dart';
import 'package:flutter/cupertino.dart';

abstract class UserHistoryViewModel{
  Future<List<BookingModel>> displayUserHistory();
  void userCancelBooking(BuildContext context, BookingModel bookingModel);
}
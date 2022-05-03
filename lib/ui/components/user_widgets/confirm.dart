import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/string/strings.dart';
import 'package:barber_shop/view_model/booking/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

displayConfirm(
    BookingViewModel bookingViewModel,
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey
    ) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(child: Padding(padding: const EdgeInsets.all(24),
        child: Image.asset('assets/images/logo.png'),),),
      Expanded(child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(child: Padding(padding: const EdgeInsets.all(16),child:
        Column(
          children: [
            Text(thankServiceText.toUpperCase(),
              style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),),
            Text(bookingInformationText.toUpperCase(),
              style: GoogleFonts.robotoMono(),),
            Row(children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 20,),
              Text('${context.read(selectedTime).state} - ${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}'.toUpperCase(),
                style: GoogleFonts.robotoMono(),),
            ],),
            SizedBox(height:10, ),
            Row(children: [
              Icon(Icons.person),
              SizedBox(width: 20,),
              Text('${context.read(selectedBarber).state.name}'.toUpperCase(),
                style: GoogleFonts.robotoMono(),),
            ],),
            SizedBox(height:10, ),
            Divider(thickness: 1,),
            Row(children: [
              Icon(Icons.home),
              SizedBox(width: 20,),
              Text('${context.read(selectedSalon).state.name}'.toUpperCase(),
                style: GoogleFonts.robotoMono(),),
            ],),
            SizedBox(height:10, ),
            Row(children: [
              Icon(Icons.location_on),
              SizedBox(width: 20,),
              Text('${context.read(selectedSalon).state.address}'.toUpperCase(),
                style: GoogleFonts.robotoMono(),),
            ],),
            ElevatedButton(onPressed: ()=> bookingViewModel.confirmBooking(context,scaffoldKey), child: Text('Confirm'),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)),)
          ],
        ),),),
      ),)
    ],
  );
}

import 'package:barber_shop/model/booking_model.dart';
import 'package:barber_shop/state/staff_user_history_state.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/utils/utils.dart';
import 'package:barber_shop/view_model/barber_booking_history/barber_booking_history_view_model_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BarberHistoryScreen extends ConsumerWidget{
  final barberHistoryViewModel = BarberBookingHistoryViewModelImp();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var dateWatch = watch(barberHistorySelectedDate).state;
    return SafeArea(child: Scaffold(
      backgroundColor: Color(0xFFDFDFDF),
      appBar: AppBar(
        title: Text('Barber History'),
        backgroundColor: Color(0xFF383838),
      ),
      body: Column(children: [
        Container(
          color: Color(0xFF008577),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          '${DateFormat.MMMM().format(dateWatch)}',
                          style: GoogleFonts.robotoMono(color: Colors.white54),
                        ), //Month
                        Text(
                          '${dateWatch.day}',      //Day int
                          style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        Text('${DateFormat.EEEE().format(dateWatch)}',    //Day string
                          style: GoogleFonts.robotoMono(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(onTap: (){
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    onConfirm: (date)=> context.read(selectedDate).state = date); //you can pick date for the next 31 day
              },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.calendar_today, color:Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(child: FutureBuilder(
            future: barberHistoryViewModel.getBarberBookingHistory(context, dateWatch),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else{
                var userBookings = snapshot.data as List<BookingModel>;
                if(userBookings == null || userBookings.length == 0)
                  return Center(
                    child: Text('You have no booking in this date'),
                  );
                else
                  return FutureBuilder(
                      future: syncTime(),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting)
                          return Center(child:CircularProgressIndicator(),);
                        else{
                          var syncTime = snapshot.data as DateTime;

                          return ListView.builder(
                              itemCount: userBookings.length,
                              itemBuilder: (context, index){
                                return Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                              Column(children: [
                                                Text('Date', style: GoogleFonts.robotoMono(),),
                                                Text(DateFormat("dd/MM/yyyy").format(
                                                    DateTime.fromMicrosecondsSinceEpoch(userBookings[index].timeStamp)
                                                ), style: GoogleFonts.robotoMono(fontSize:22, fontWeight: FontWeight.bold),)
                                              ],),
                                              Column(children: [
                                                Text('Time', style: GoogleFonts.robotoMono(),),
                                                Text(TIME_SLOT.elementAt(userBookings[index].slot)
                                                  , style: GoogleFonts.robotoMono(fontSize:22, fontWeight: FontWeight.bold),)
                                              ],)
                                            ],),
                                            Divider(thickness: 1,),
                                            Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('${userBookings[index].salonName}',
                                                      style: GoogleFonts.robotoMono(fontSize: 20, fontWeight: FontWeight.bold),),
                                                    Text('${userBookings[index].barberName}',
                                                      style: GoogleFonts.robotoMono(),)
                                                  ],),
                                                Text('${userBookings[index].salonAddress}',
                                                  style: GoogleFonts.robotoMono(),)
                                              ],)
                                          ],
                                        ),),
                                    ],
                                  ),

                                );
                              });
                        }
                      });
              }
            }),)
      ],),
    ));
  }


}


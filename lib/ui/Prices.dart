import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:barber_shop/cloud_firestore/all_salon_ref.dart';
import 'package:barber_shop/cloud_firestore/user_ref.dart';
import 'package:barber_shop/model/City_model.dart';
import 'package:barber_shop/model/barber_model.dart';
import 'package:barber_shop/model/booking_model.dart';
import 'package:barber_shop/model/salon_model.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/utils/utils.dart';
import 'package:barber_shop/view_model/user_history/user_history_view_model_imp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:rflutter_alert/rflutter_alert.dart';

class Prices extends ConsumerWidget{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userHistoryViewModel = UserHistoryViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    var watchRefresh = watch(deleteFlagRefresh).state;
    return SafeArea(
        child: Scaffold(
          key:scaffoldKey,
          appBar: AppBar(
            title: Text('Prices'),
            backgroundColor: Color(0xFF383838),
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFFDF9EE),
          body:
          Center(
            child:
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FractionColumnWidth(0.65),
                1: FractionColumnWidth(0.25),
              },
              children: [
                buildRow(['Szolgáltatások', 'Árak',], isHeader: true),
                buildRow(['Razor cut', '19,5\$']),
                buildRow(['Beard trim', '16\$']),
                buildRow(['Shaving and Styling', '27\$']),
                buildRow(['Haircut', '18\$']),
                buildRow(['Shave', '24\$']),
                buildRow(['Haircut for children under 14', '14\$']),
                buildRow(['Head and neck massage', '25.5\$']),
                buildRow(['Service Option 1', '25\$']),
                buildRow(['Service Option 2', '17.5\$']),
                buildRow(['Service Option 3', '34\$']),
              ],
            ),
          ),
        )
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
    children: cells.map((cell) {
      final style = TextStyle(
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        fontSize: 18,
      );


      return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(child: Text(cell)),
      );
    }).toList(),
  );




}


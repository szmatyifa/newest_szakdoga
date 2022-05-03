import 'package:barber_shop/model/salon_model.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/string/strings.dart';
import 'package:barber_shop/view_model/staff_home/staff_home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

staffDisplaySalon(StaffHomeViewModel staffHomeViewModel, String name) {
  return FutureBuilder(
      future: staffHomeViewModel.displaySalonByCity(name),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else{
          var salons = snapshot.data as List<SalonModel>;
          if(salons == null || salons.length == 0)
            return Center(
              child: Text(cannotLoadSalonText),
            );
          else
            return ListView.builder(
                itemCount: salons.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: ()=> staffHomeViewModel.onSelectedSalon(context, salons[index]),
                    child: Card(
                      child: ListTile(
                        shape: staffHomeViewModel.isSalonSelected(context, salons[index])
                            ? RoundedRectangleBorder(side: BorderSide(color: Colors
                            .green,
                            width: 4),
                            borderRadius: BorderRadius.circular(5)) : null,
                        leading: Icon(
                          Icons.home_outlined,
                          color: Colors.black,
                        ),
                        trailing: context.read(selectedSalon).state.docId == salons[index].docId
                            ? Icon(Icons.check)
                            : null,
                        title: Text(
                          '${salons[index].name}',
                          style: GoogleFonts.robotoMono(),
                        ),
                        subtitle: Text(
                          '${salons[index].address}',
                          style: GoogleFonts.robotoMono(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  );
                });
        }
      }
  );
}

import 'package:barber_shop/screens/booking_screen.dart';
import 'package:barber_shop/state/state_management.dart';
import 'package:barber_shop/ui/barber_booking_history_screen.dart';
import 'package:barber_shop/ui/done_services_screen.dart';
import 'package:barber_shop/ui/home_screen.dart';
import 'package:barber_shop/ui/staff_home_screen.dart';
import 'package:barber_shop/ui/user_history_screen.dart';
import 'package:barber_shop/utils/utils.dart';
import 'package:barber_shop/view_model/main/main_view_model_imp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dcdg/dcdg.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase
  Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings){
        switch(settings.name)
        {
          case '/staffHome':
            return PageTransition(
                settings: settings,
                child: StaffHome(),
                type: PageTransitionType.fade);

          case '/doneService':
            return PageTransition(
                settings: settings,
                child: DoneService(),
                type: PageTransitionType.fade);

          case '/home':
            return PageTransition(
                settings: settings,
                child: HomePage(),
                type: PageTransitionType.fade);

          case '/history':
            return PageTransition(
                settings: settings,
                child: UserHistory(),
                type: PageTransitionType.fade);

          case '/booking':
            return PageTransition(
                settings: settings,
                child: BookingScreen(),
                type: PageTransitionType.fade);
          case '/bookingHistory':
            return PageTransition(
                settings: settings,
                child: BarberHistoryScreen(),
                type: PageTransitionType.fade);
          default: return null;
        }
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends ConsumerWidget {
  final scaffoldState = new GlobalKey<ScaffoldState>();

  final mainViewModel = MainViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return SafeArea(child: Scaffold(
      key: scaffoldState,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/my_bg.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: FutureBuilder(
                future: mainViewModel.checkLoginState(context,false,scaffoldState),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else{
                    var userState = snapshot.data as LOGIN_STATE;
                    if(userState == LOGIN_STATE.LOGGED )
                    {
                      return Container();
                    }
                    else { //if user never logged in before then return button
                      return ElevatedButton.icon(
                        onPressed: () => mainViewModel.processLogin(context,scaffoldState),
                        icon: Icon(Icons.phone,color:Colors.white),
                        label: Text('LOGIN WITH PHONE', style: TextStyle(color: Colors.white),),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                      );
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }




}

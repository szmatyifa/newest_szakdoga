

import 'package:barber_shop/main.dart';
import 'package:barber_shop/view_model/main/main_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

//class MockUser extends Mock implements User{
//  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
//}
class MockFirebaseUser extends Mock implements FirebaseAuth{}
class MockFirebaseAuth extends Mock implements FirebaseAuth{
  //@override
  //Stream<User> authStateChanges() {
  //  return Stream.fromIterable([
  //    MockUser(),
  //  ]);
  }
class MockAuthResult extends Mock implements UserCredential{}


void main(){
  test("anya", (){
    //final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
    //setUp((){});
    //tearDown((){});

    MockFirebaseAuth _auth =MockFirebaseAuth();
    BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
    

    group("anya", (){

      test("apa", () async{

      });
    });
  });
}


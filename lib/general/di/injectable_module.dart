import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';
import 'package:totalx_testpproject/firebase_options.dart';

@module 
abstract class FirabaseInjectableModule {
@preResolve 
Future<FirebaseServices> get firebaseServices=>FirebaseServices.init();

@lazySingleton
FirebaseFirestore get firebaseFirstore=>FirebaseFirestore.instance;
// @lazySingleton
// FirebaseStorage get firebasestorage=>FirebaseFirestore.instance;
@lazySingleton
FirebaseAuth get firebaseAuth=>FirebaseAuth.instance;

}





class FirebaseServices{

  static Future<FirebaseServices> init()async{
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
);
return FirebaseServices();
  }
}
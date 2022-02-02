import 'package:cloud_functions/cloud_functions.dart';

FirebaseFunctions functions = FirebaseFunctions.instance;

void invokeHello() {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('helloWorld');
  var ret = callable();
  print(ret.then((value) => print(value.data)));
}

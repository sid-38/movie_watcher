import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_watcher/models/idModel.dart';
import 'package:movie_watcher/roomCreater.dart';
import 'package:movie_watcher/videoPlayer.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: _initialization,
          builder: (ctxt, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Text("SomethingWentWrong");
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              FirebaseAuth auth = FirebaseAuth.instance;
              return Authenticator();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Text("Loading...");
          }),
    );
  }
}

class Authenticator extends StatefulWidget {
  const Authenticator({Key? key}) : super(key: key);

  @override
  _AuthenticatorState createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  User? _user;
  void signIn() {
    FirebaseAuth.instance.signInAnonymously();
  }

  @override
  void initState() {
    signIn();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _user = null;
        });
      } else {
        setState(() {
          _user = user;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_user == null) ? Text("Authentication Error!") : MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IdModel(),
      child: RoomCreater(),
    );
  }
}

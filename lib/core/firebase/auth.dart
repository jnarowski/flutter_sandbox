import 'package:firebase_auth/firebase_auth.dart';

typedef Auth = FirebaseAuth;
typedef AuthUser = User;
typedef AuthUserCredential = UserCredential;
typedef AuthUserException = FirebaseAuthException;

final auth = FirebaseAuth.instance;

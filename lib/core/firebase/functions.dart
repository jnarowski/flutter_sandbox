import 'package:cloud_functions/cloud_functions.dart';

final functions = FirebaseFunctions.instance;

final sendInviteEmail = functions.httpsCallable('sendInviteEmail');

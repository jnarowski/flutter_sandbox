import 'package:flutter_sandbox/features/account/account_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_provider.g.dart';

@riverpod
AccountService accountService(ref) {
  return AccountService();
}

import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthInnerInterface interface):super(const AuthStateUninitialized(isLoading: true)) {
    
  }
}
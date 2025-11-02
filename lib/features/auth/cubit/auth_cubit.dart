// lib/features/auth/cubit/auth_cubit.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/user_model.dart';
import 'package:lyceumai/core/services/sp_service.dart';
import 'package:lyceumai/core/services/fcm_token_service.dart';
import 'package:lyceumai/features/auth/repository/auth_remote_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final _spService = SpService();
  final _fcmTokenService = FcmTokenService();
  final _authRemoteRepository = AuthRemoteRepository();

  void getUserData() async {
    try {
      emit(AuthLoadingInitial());
      final userModel = await _authRemoteRepository.getUserData();
      if (userModel != null) {
        if (userModel.token.isNotEmpty) {
          await _spService.setToken(userModel.token);
          await _fcmTokenService.initFCM();
        }
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await _authRemoteRepository.signUp(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final userModel = await _authRemoteRepository.login(
        email: email,
        password: password,
      );
      if (userModel.token.isNotEmpty) {
        await _spService.setToken(userModel.token);
        await _fcmTokenService.initFCM();
      }
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logout() async {
    await _spService.clearToken();
    emit(AuthInitial());
  }
}

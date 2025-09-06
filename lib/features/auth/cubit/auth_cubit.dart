import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/models/user_model.dart';
import 'package:lyceumai/core/services/sp_service.dart';
import 'package:lyceumai/features/auth/repository/auth_remote_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoadingInitial());
      final userModel = await authRemoteRepository.getUserData();
      if (userModel != null) {
        if (userModel.token.isNotEmpty) {
          await spService.setToken(userModel.token);
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
      await authRemoteRepository.signUp(
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
      final userModel = await authRemoteRepository.login(
        email: email,
        password: password,
      );
      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

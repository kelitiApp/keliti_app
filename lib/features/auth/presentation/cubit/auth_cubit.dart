import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { idle, loading, success, failure }

class AuthState {
  const AuthState({this.status = AuthStatus.idle, this.errorMessage});

  final AuthStatus status;
  final String? errorMessage;

  AuthState copyWith({AuthStatus? status, String? errorMessage}) =>
      AuthState(status: status ?? this.status, errorMessage: errorMessage);
}

/// Mock authentication cubit — simulates network latency but has no real
/// backend wired in yet. Swap `_fakeRequest` for a real repository call
/// once an API/Firebase integration exists.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<bool> login({required String phone, required String password}) async {
    return _fakeRequest(() => phone.trim().isNotEmpty && password.trim().isNotEmpty);
  }

  Future<bool> createAccount({required String fullName, required String phone, required String password}) {
    return _fakeRequest(() => fullName.trim().isNotEmpty && phone.trim().isNotEmpty && password.length >= 6);
  }

  Future<bool> verifyOtp(String code) => _fakeRequest(() => code.length == 4);

  Future<bool> requestPasswordReset(String phone) => _fakeRequest(() => phone.trim().isNotEmpty);

  Future<bool> setNewPassword(String password, String confirm) =>
      _fakeRequest(() => password.length >= 6 && password == confirm);

  Future<bool> _fakeRequest(bool Function() validate) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(milliseconds: 700));
    final ok = validate();
    emit(state.copyWith(
      status: ok ? AuthStatus.success : AuthStatus.failure,
      errorMessage: ok ? null : 'يرجى التحقق من البيانات المدخلة',
    ));
    return ok;
  }

  void reset() => emit(const AuthState());
}

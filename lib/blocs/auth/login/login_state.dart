part of 'login_bloc.dart';

abstract class BaseLoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String? errorText;
  final ApiErrors? errors;

  const BaseLoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorText,
    this.errors,
  });

  BaseLoginState.loading() : this(isLoading: true);

  BaseLoginState.success() : this(isSuccess: true);

  BaseLoginState.error({String? errorText, ApiErrors? errors})
      : this(isFailure: true, errorText: errorText, errors: errors);

  @override
  List<Object?> get props => [isLoading, isSuccess, isFailure, errorText, errors];

  @override
  String toString() {
    return '${super.toString()} { isLoading: $isLoading, isSuccess: $isSuccess, isFailure: $isFailure, errorText: $errorText }';
  }
}

class SignInState extends BaseLoginState {
  SignInState() : super();

  SignInState.loading() : super.loading();

  SignInState.success() : super.success();

  SignInState.error({String? errorText, ApiErrors? errors}) : super.error(errorText: errorText, errors: errors);
}
